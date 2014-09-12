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
    initializeOptions();
    communication = new RemoteControlCommunication(this, options);
    nodes = new ArrayList<Node>();
    triangulate = new Triangulate();
    triangles = new ArrayList<DelaunayTriangle>();
    parentApplet = applet;
    createNodes();
    actions = new MutationActions(options);
  }
  private void createNodes() {
    int nNodes = options.getAsInt("nodes");
    for(int i = 0; i < nNodes; i++) {
      Node node = new Node();
      node.attraction = options.getAsFloat("attraction");
      node.inertia = options.getAsBoolean("inertia");
      node.mass = options.getAsInt("mass");
      node.sticky = options.getAsBoolean("sticky");
      nodes.add(node);
    }
    for(int i = 0; i < nNodes; i++) {
      Node node = nodes.get(i);
      Node closestNode = node.getClosestNode(nodes);
    }
  }
  public void draw() {
    if(!options.getAsBoolean("trace")) {
      pushStyle();
      noStroke();
      fill(options.backgroundColor);
      rect(0, 0, width, height); // The background() function doesn't seem to allow the use of alpha, so we draw a rectangle instead
      popStyle();
    }
    if(options.getAsBoolean("delaunay") || options.getAsBoolean("voronoi")) {
      triangles = triangulate.triangulate(nodes);
    }
    int nNodes = nodes.size();
    for(int i = 0; i < nNodes; i++) {
      Node artifact = nodes.get(i);
      if(options.getAsBoolean("voronoi") ) {
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
    if(options.getAsBoolean("delaunay")) {
      delaunay.drawTriangles(triangles, options.getAsBoolean("fillTriangles"));
    }
    if(options.getAsBoolean("path")) {
      PickyPath path = new PickyPath(nodes);
      path.drawAsLines();
    }
    for(int i = 0; i < nNodes; i++) {
      Node node = nodes.get(i);
      Node closestNode = node.getClosestNode(nodes);
      if(options.getAsBoolean("points")) {
        node.drawPoint();
      }
      if(options.getAsBoolean("closest") && closestNode != null) {
        color lineColor = lerpColor(node.primaryColor, closestNode.primaryColor, 0.5);
        pushStyle();
        stroke(lineColor);
        line(node.position.x, node.position.y, closestNode.position.x, closestNode.position.y);
        popStyle();
      }
    }
  }
  public void propagateOption(String option) {
    println("propagate " + option);
    if(option.equals("attraction")) {
      float value = options.getAsFloat("attraction");
      println(value);
      int nNodes = nodes.size();
      for(int i = 0; i < nNodes; i++) {
        Node node = nodes.get(i);
        node.attraction = value;
      }
    }
    else if(option.equals("sticky")) {
      println("propagate stickiness");
      boolean value = options.getAsBoolean("sticky");
      println(value);
      int nNodes = nodes.size();
      for(int i = 0; i < nNodes; i++) {
        Node node = nodes.get(i);
        node.sticky = value;
      }
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
    if(nNodes < options.getAsInt("nodes")) {
      nodes.add(new Node());
    }
    else if(nNodes > options.getAsInt("nodes")) {
      int index = (int)random(nNodes);
      constrain(index, 0, nNodes - 1);
      nodes.remove(index);
      nNodes--;
    }
    for(int i = 0; i < nNodes; i++) {
      Node node = nodes.get(i);
      node.update();
      //node.position.x = constrain(node.position.x, options.canvasStart.x, options.canvasEnd.x);
      //node.position.y = constrain(node.position.y, options.canvasStart.y, options.canvasEnd.y);
      while(node.position.x < options.canvasStart.x) {
        node.position.x += options.canvasEnd.x - options.canvasStart.x;
      }
      while(node.position.x > options.canvasEnd.x) {
        node.position.x -= options.canvasEnd.x - options.canvasStart.x;
      }
      while(node.position.y < options.canvasStart.y) {
        node.position.y += options.canvasEnd.y - options.canvasStart.y;
      }
      while(node.position.y > options.canvasEnd.y) {
        node.position.y -= options.canvasEnd.y - options.canvasStart.y;
      }
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
  private void initializeOptions() {
    options.set("delaunay", false);
    options.set("fillTriangles", true);
    options.set("inertia", false);
    options.set("closest", false);
    options.set("path", false);
    options.set("points", false);
    options.set("sticky", false);
    options.set("trace", false);
    options.set("voronoi", false);
    options.set("attraction", 0.05);
    options.set("mass", 1000);
    options.set("nodes", 1000);
    options.set("polygons", 2);
    options.set("minNodes", 300);
    options.set("maxNodes", 2000);
 }
}
