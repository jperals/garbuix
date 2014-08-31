public class Options {
  public boolean clear, delaunay, drawNodes, drawLine, lerp, inertia, path, stickyNodes, voronoi;
  public color backgroundColor;
  public float attraction, mass;
  private float minAttraction = -1;
  private float maxAttraction = 1;
  public PVector canvasStart, canvasEnd;
  public int exportFrameDelay, minExportFrameDelay = 1, maxExportFrameDelay = 300;
  public int lerpLevels;
  public int maxLerpLevels = 5;
  public int minNumberOfNodes = 500;
  public int maxNumberOfNodes = 1000;
  public int numberOfNodes;
  
  Options() {
    this(width, height);
  }

  Options(int w, int h) {
    backgroundColor = color(random(0, 127), random(0, 127), random(0, 127));
    clear = false;//random(1) < 0.5;
    delaunay = false;//random(1) < 0.5;
    drawNodes = false;//random(1) < 0.5;
    drawLine = false;//!drawNodes || random(1) < 0.5;
    minExportFrameDelay = 1;
    maxExportFrameDelay = 300;
    exportFrameDelay = 1;
    inertia = false;//random(1) < 0.5;
    lerp = true;//random(1) < 0.5;
    attraction = 0.005;//random(minAttraction, maxAttraction);
    mass = 100;
    canvasStart = new PVector(-w*0.25, -h*0.25);
    canvasEnd = new PVector(w*1.25, h*1.25);
    lerpLevels = 1;//lerp ? 1 : (int)random(maxLerpLevels);
    numberOfNodes = int(random(minNumberOfNodes, maxNumberOfNodes));
    path = true;
    stickyNodes = true;
    voronoi = false;//true;//random(1) < 0.5;
    println("Attraction: " + attraction);
    println("Draw nodes: " + drawNodes);
    println("Draw line: " + drawLine);
    println("Number of nodes: " + numberOfNodes);
  }
}

