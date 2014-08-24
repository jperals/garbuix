import gifAnimation.*;
import java.util.Date;

public class Controller {
  ArrayList<Node> nodes;
  ArrayList<DelaunayTriangle> triangles;
  boolean resetRequested, exportingGif, exportingPng;
  DelaunayTriangulation delaunay;
  GifMaker gifMaker;
  MutationActions actions;
  Options options;
  PApplet parentApplet;
  PngSequenceMaker pngSequenceMaker;
  RemoteControlCommunication communication;
  Triangulate triangulate;
  Controller(PApplet applet) {
    resetRequested = false;
    exportingGif = false;
    delaunay = new DelaunayTriangulation();
    options = new Options();
    communication = new RemoteControlCommunication(this, options);
    nodes = new ArrayList<Node>();
    triangulate = new Triangulate();
    triangles = new ArrayList<DelaunayTriangle>();
    parentApplet = applet;
    createNodes();
    actions = new MutationActions(options);
  }
  private void createNodes() {
    for(int i = 0; i < options.numberOfNodes; i++) {
      Node node = new Node();
      node.attraction = options.attraction;
      node.inertia = options.inertia;
      node.mass = options.mass;
      nodes.add(node);
    }
  }
  public void draw() {
    if(options.clear) {
      pushStyle();
      noStroke();
      fill(options.backgroundColor);
      rect(0, 0, width, height); // The background() function doesn't seem to allow the use of alpha, so we draw a rectangle instead
      popStyle();
    }
    if(options.delaunay || options.voronoi) {
      triangles = triangulate.triangulate(nodes);
    }
    int nNodes = nodes.size();
    for(int i = 0; i < nNodes; i++) {
      Node artifact = nodes.get(i);
      if(options.voronoi ) {
        int nTriangles = triangles.size();
        for (int j = 0; j <nTriangles; j++) {
          DelaunayTriangle triangle = (DelaunayTriangle)triangles.get(j);
          if(triangle.n1 == artifact || triangle.n2 == artifact || triangle.n3 == artifact) {
            artifact.addTriangle(triangle);
          }
        }
        artifact.drawVoronoi(options.lerp, options.lerpLevels);
      }
    }
   if(options.delaunay) {
      delaunay.drawTriangles(triangles);
    }
    for(int i = 0; i < nNodes; i++) {
      Node node = nodes.get(i);
      Node closestNode = node.getClosestNode(nodes);
      if(options.drawNodes) {
        node.display();
      }
      if(options.drawLine && closestNode != null) {
        color lineColor = lerpColor(node.primaryColor, closestNode.primaryColor, 0.5);
        pushStyle();
        stroke(lineColor);
        line(node.position.x, node.position.y, closestNode.position.x, closestNode.position.y);
        popStyle();
      }
      node.update();
      node.position.x = constrain(node.position.x, options.canvasStart.x, options.canvasEnd.x);
      node.position.y = constrain(node.position.y, options.canvasStart.y, options.canvasEnd.y);
    }
  }
  public void triggerAction(char key) {
    switch(key) {
      case 'g':
        toggleGifExport();
        break;
      case 'p':
        togglePngExport();
        break;
      case 'r':
        requestReset();
        break;
      case 's':
        saveCurrentFrame();
        break;
      default:
        actions.invokeByKey(key);
    }
  }
  public void update() {
    if(resetRequested) {
      reset();
      resetRequested = false;
    }
    if(exportingGif && frameCount % options.exportFrameDelay == 0) {
      gifMaker.addFrame();
    }
    if(exportingPng && frameCount % options.exportFrameDelay == 0) {
      pngSequenceMaker.saveCurrentFrame();
    }
    int nNodes = nodes.size();
    if(nNodes < options.numberOfNodes) {
      nodes.add(new Point());
    }
    else if(nNodes > options.numberOfNodes) {
      int index = (int)random(nNodes);
      constrain(index, 0, nNodes - 1);
      nodes.remove(index);
    }
  }
  private String getFormattedDate() {
      Date date = new Date();
      String formattedDate = new java.text.SimpleDateFormat("yyyy-MM-dd.kk.mm.ss").format(date.getTime());
      return formattedDate;
  }
  public void reset() {
    nodes.clear();
    createNodes();
  }
  public void requestReset() {
    resetRequested = true;
  }
  public void saveCurrentFrame() {
    String formattedDate = getFormattedDate();
    saveFrame("screenshots/screenshot-" + formattedDate + "-######.png");
  }
  public void startPngExport() {
    exportingPng = true;
    if(pngSequenceMaker == null) {
      String formattedDate = getFormattedDate();   
      pngSequenceMaker = new PngSequenceMaker("screenshots/capture-" + formattedDate + "-######");
    }
  }
  public void finishPngExport() {
    exportingPng = false;
  }
  public void toggleGifExport() {
    exportingGif = !exportingGif;
    if(exportingGif) {
      if(gifMaker != null) {
        gifMaker.finish();
      }
      String formattedDate = getFormattedDate();
      gifMaker = new GifMaker(parentApplet, "screenshots/screenshot-" + formattedDate + "-" + frameCount + ".gif");
      gifMaker.setRepeat(0);
    }
  }
  public void togglePngExport() {
    exportingPng = !exportingPng;
    if(exportingPng) {
      startPngExport();
    }
  }
}
