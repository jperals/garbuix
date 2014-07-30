public class Artifact {
  public PVector acceleration;
  public color baseColor;
  public Artifact closestArtifact;
  public color displayColor;
  public float distanceToClosestArtifact;
  public PVector position;
  public PVector speed;
  private Options options;
  ArrayList<DelaunayTriangle> triangles;
  Artifact() {
    this(randomX(), randomY());
  }
  Artifact(float x, float y) {
    acceleration = new PVector(0, 0);
    baseColor = randomColor();
    closestArtifact = this;
    displayColor = baseColor;
    distanceToClosestArtifact = -1;
    this.options = options;
    position = new PVector(x, y);
    speed = new PVector(0, 0);
    triangles = new ArrayList<DelaunayTriangle>();
  }
  public void addTriangle(DelaunayTriangle t) {
    triangles.add(t);
  }
  public void display() {}
  public void update(Options options) {
    triangles.clear();
    PVector difference = differenceTo(closestArtifact);
    PVector movement = new PVector(difference.x * options.attraction / options.mass, difference.y * options.attraction / options.mass);
    if(options.inertia) {
      acceleration = movement;
      position.add(speed);
      speed.add(acceleration);
    }
    else {
      movement.mult(100);
      position.add(movement);
    }
    constrain(position.x, options.canvasStart.x, options.canvasEnd.x);
    constrain(position.y, options.canvasStart.y, options.canvasEnd.y);
    float lerpAmount = 0.5/distanceToClosestArtifact;
    displayColor = lerpColor(displayColor, closestArtifact.displayColor, lerpAmount);
  }
  public PVector differenceTo(Artifact artifact) {
    return new PVector(artifact.position.x - position.x, artifact.position.y - position.y);
  }
  public float distanceTo(Artifact artifact) {
    return dist(position.x, position.y, artifact.position.x, artifact.position.y);
  }
  public Artifact getClosestArtifact(ArrayList<Artifact> artifacts) {
    float minimumDistanceFound = -1;
    Artifact closestArtifactFound = null;
    int numberOfArtifacts = artifacts.size();
    for(int i = 0; i < numberOfArtifacts; i++) {
      Artifact artifact = artifacts.get(i);
      float distance = distanceTo(artifact);
      if(artifact != this && (minimumDistanceFound == -1 || closestArtifactFound == null || distance < minimumDistanceFound)) {
        minimumDistanceFound = distance;
        closestArtifactFound = artifact;
      }
    }
    closestArtifact = closestArtifactFound;
    distanceToClosestArtifact = minimumDistanceFound;
    return closestArtifactFound;
  }
  public void drawVoronoi(boolean lerp, int lerpLevels) {
    Voronoi voronoi = new Voronoi(position);
    ArrayList<PVector> circumcenters = voronoi.getCircumcenters(triangles);
    int nCircumcenters = circumcenters.size();
    if(nCircumcenters > 2) {
      pushStyle();
      if(!lerp) {
        fill(displayColor);
      }
      noStroke();
      pushMatrix();
      translate(position.x, position.y);
      PVector firstPoint = circumcenters.get(0);
      PVector lastPoint = firstPoint;
      for(int i = lerpLevels; i > 0; i--) {
        float lerpAmount = float(i)/lerpLevels;
        pushStyle();
        if(lerp) {
          fill(lerpColor(baseColor, displayColor, lerpAmount));
        }
        pushMatrix();
        scale(float(i)/lerpLevels);
        for(int j = 1; j < nCircumcenters; j++) {
          PVector point = circumcenters.get(j);
          triangle(0, 0, lastPoint.x, lastPoint.y, point.x, point.y);
          lastPoint = point;
        }
        triangle(0, 0, lastPoint.x, lastPoint.y, firstPoint.x, firstPoint.y);
        lastPoint = firstPoint;
        popMatrix();
        popStyle();
      }
      popMatrix();
      popStyle();
    }
  }
}

class Point extends Artifact {
  Point() {
    super();
  }
  public void display() {
    pushStyle();
    stroke(displayColor);
    point(position.x, position.y);
    popStyle();
  }
}

