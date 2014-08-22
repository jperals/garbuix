public class Options {
  public boolean clear, delaunay, drawNodes, drawLine, lerp, inertia, voronoi;
  public color backgroundColor;
  public float attraction, mass;
  private float minAttraction = -1;
  private float maxAttraction = -0.5;
  public PVector canvasStart, canvasEnd;
  public int exportFrameDelay, minExportFrameDelay = 1, maxExportFrameDelay = 300;
  public int lerpLevels;
  public int maxLerpLevels = 5;
  public int minNumberOfNodes = 100;
  public int maxNumberOfNodes = 600;
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
    attraction = random(minAttraction, maxAttraction);
    mass = 5000;
    canvasStart = new PVector(-w*1.25, -h*1.25);
    canvasEnd = new PVector(w*1.25, h*1.25);
    lerpLevels = 2;//lerp ? 1 : (int)random(maxLerpLevels);
    numberOfNodes = int(random(minNumberOfNodes, maxNumberOfNodes));
    voronoi = true;//random(1) < 0.5;
    println("Attraction: " + attraction);
    println("Draw nodes: " + drawNodes);
    println("Draw line: " + drawLine);
    println("Number of nodes: " + numberOfNodes);
  }
}
