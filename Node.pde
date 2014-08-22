public class Node {
  public PVector acceleration;
  public color primaryColor;
  public Node closestNode;
  public color secondaryColor;
  public float distanceToClosestNode;
  public PVector position;
  public PVector speed;
  ArrayList<DelaunayTriangle> triangles;
  Node() {
    this(randomX(), randomY());
  }
  Node(float x, float y) {
    acceleration = new PVector(0, 0);
    primaryColor = randomColor();
    closestNode = this;
    secondaryColor = primaryColor;
    distanceToClosestNode = -1;
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
    PVector difference = differenceTo(closestNode);
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
    float lerpAmount = 0.5/distanceToClosestNode;
    secondaryColor = lerpColor(secondaryColor, closestNode.secondaryColor, lerpAmount);
  }
  public PVector differenceTo(Node node) {
    return new PVector(node.position.x - position.x, node.position.y - position.y);
  }
  public float distanceTo(Node node) {
    return dist(position.x, position.y, node.position.x, node.position.y);
  }
  public Node getClosestNode(ArrayList<Node> nodes) {
    float minimumDistanceFound = -1;
    Node closestNodeFound = null;
    int numberOfNodes = nodes.size();
    for(int i = 0; i < numberOfNodes; i++) {
      Node node = nodes.get(i);
      float distance = distanceTo(node);
      if(node != this && (minimumDistanceFound == -1 || closestNodeFound == null || distance < minimumDistanceFound)) {
        minimumDistanceFound = distance;
        closestNodeFound = node;
      }
    }
    closestNode = closestNodeFound;
    distanceToClosestNode = minimumDistanceFound;
    return closestNodeFound;
  }
  public void drawVoronoi(boolean lerp, int lerpLevels) {
    Voronoi voronoi = new Voronoi(position);
    ArrayList<PVector> circumcenters = voronoi.getCircumcenters(triangles);
    int nCircumcenters = circumcenters.size();
    if(nCircumcenters > 2) {
      pushStyle();
      if(!lerp) {
        fill(secondaryColor);
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
          fill(lerpColor(primaryColor, secondaryColor, lerpAmount));
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

class Point extends Node {
  Point() {
    super();
  }
  public void display() {
    pushStyle();
    stroke(secondaryColor);
    point(position.x, position.y);
    popStyle();
  }
}
