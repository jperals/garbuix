public class Options {
  public boolean clear, delaunay, drawArtifacts, drawLine, lerp, inertia, voronoi;
  public color backgroundColor;
  public float attraction, mass;
  private float minAttraction = -1;
  private float maxAttraction = 1;
  public PVector canvasStart, canvasEnd;
  public int exportFrameDelay, minExportFrameDelay = 1, maxExportFrameDelay = 300;
  public int lerpLevels;
  public int maxLerpLevels = 3;
  public int minNumberOfArtifacts = 10;
  public int maxNumberOfArtifacts = 400;
  public int numberOfArtifacts;
  
  Options() {
    this(width, height);
  }

  Options(int w, int h) {
    backgroundColor = randomColor();
    clear = random(1) < 0.5;
    delaunay = random(1) < 0.5;
    drawArtifacts = random(1) < 0.5;
    drawLine = !drawArtifacts || random(1) < 0.5;
    minExportFrameDelay = 1;
    maxExportFrameDelay = 300;
    exportFrameDelay = 1;
    inertia = random(1) < 0.5;
    lerp = random(1) < 0.5;
    attraction = random(minAttraction, maxAttraction);
    mass = 5000;
    canvasStart = new PVector(-w*1.25, -h*1.25);
    canvasEnd = new PVector(w*1.25, h*1.25);
    lerpLevels = lerp ? 1 : (int)random(maxLerpLevels);
    numberOfArtifacts = int(random(minNumberOfArtifacts, maxNumberOfArtifacts));
    voronoi = random(1) < 0.5;
    println("Attraction: " + attraction);
    println("Draw artifacts: " + drawArtifacts);
    println("Draw line: " + drawLine);
    println("Number of artifacts: " + numberOfArtifacts);
  }
}

