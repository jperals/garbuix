import gifAnimation.*;
import java.util.Date;

public class Controller {
  ArrayList<Artifact> artifacts;
  ArrayList<DelaunayTriangle> triangles;
  boolean resetRequested, exportingGif, exportingPng;
  DelaunayTriangulation delaunay;
  GifMaker gifMaker;
  Options options;
  PngSequenceMaker pngSequenceMaker;
  RemoteControlCommunication communication;
  Triangulate triangulate;
  Controller(PApplet applet) {
    resetRequested = false;
    exportingGif = false;
    delaunay = new DelaunayTriangulation();
    options = new Options();
    communication = new RemoteControlCommunication(this, options);
    artifacts = new ArrayList<Artifact>();
    triangulate = new Triangulate();
    triangles = new ArrayList<DelaunayTriangle>();
    createArtifacts();
  }
  private void createArtifacts() {
    for(int i = 0; i < options.numberOfArtifacts; i++) {
      Artifact artifact = new Point();
      artifacts.add(artifact);
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
      triangles = triangulate.triangulate(artifacts);
    }
    int nArtifacts = artifacts.size();
    for(int i = 0; i < nArtifacts; i++) {
      Artifact artifact = artifacts.get(i);
      if(options.voronoi ) {
        int nTriangles = triangles.size();
        for (int j = 0; j <nTriangles; j++) {
          DelaunayTriangle triangle = (DelaunayTriangle)triangles.get(j);
          if(triangle.a1 == artifact || triangle.a2 == artifact || triangle.a3 == artifact) {
            artifact.addTriangle(triangle);
          }
        }
        artifact.drawVoronoi(options.lerp, options.lerpLevels);
      }
    }
   if(options.delaunay) {
      delaunay.drawTriangles(triangles);
    }
    for(int i = 0; i < nArtifacts; i++) {
      Artifact artifact = artifacts.get(i);
      Artifact closestArtifact = artifact.getClosestArtifact(artifacts);
      if(options.drawArtifacts) {
        artifact.display();
      }
      if(options.drawLine && closestArtifact != null) {
        color lineColor = lerpColor(artifact.baseColor, closestArtifact.baseColor, 0.5);
        pushStyle();
        stroke(lineColor);
        line(artifact.position.x, artifact.position.y, closestArtifact.position.x, closestArtifact.position.y);
        popStyle();
      }
      artifact.update(options);
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
    int nArtifacts = artifacts.size();
    if(nArtifacts < options.numberOfArtifacts) {
      artifacts.add(new Point());
    }
    else if(nArtifacts > options.numberOfArtifacts) {
      int index = (int)random(nArtifacts);
      constrain(index, 0, nArtifacts - 1);
      artifacts.remove(index);
    }
  }
  private String getFormattedDate() {
      Date date = new Date();
      String formattedDate = new java.text.SimpleDateFormat("yyyy-MM-dd.kk.mm.ss").format(date.getTime());
      return formattedDate;
  }
  public void reset() {
    artifacts.clear();
    createArtifacts();
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
      Date date = new Date();
      String formattedDate = getFormattedDate();   
      pngSequenceMaker = new PngSequenceMaker("screenshots/capture-" + formattedDate + "-######");
    }
  }
  public void finishPngExport() {
    exportingPng = false;
  }
  public void toggleGifExport(PApplet applet) {
    exportingGif = !exportingGif;
    if(exportingGif) {
      if(gifMaker != null) {
        gifMaker.finish();
      }
      String formattedDate = getFormattedDate();
      gifMaker = new GifMaker(applet, "screenshots/screenshot-" + formattedDate + "-" + frameCount + ".gif");
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
