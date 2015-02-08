public class Node {
  public boolean inertia,
                 sticky;
  public color primaryColor,
               secondaryColor;
  public float attraction,
               distanceToClosestNode,
               mass;
  public Node closestNode;
  public PVector acceleration,
                 position,
                 speed;
  public Options options;
  ArrayList<DelaunayTriangle> triangles;
  Node() {
    this(randomX(), randomY());
  }
  Node(float x, float y) {
    options = new Options();
    acceleration = new PVector(0, 0);
    primaryColor = randomColor();
    closestNode = null;
    secondaryColor = primaryColor;
    distanceToClosestNode = -1;
    position = new PVector(x, y);
    speed = new PVector(0, 0);
    triangles = new ArrayList<DelaunayTriangle>();
  }
  public void addTriangle(DelaunayTriangle t) {
    triangles.add(t);
  }
  public void drawPoint() {
    pushStyle();
    stroke(secondaryColor);
    point(position.x, position.y);
    popStyle();
  }
  public void update() {
    triangles.clear();
    updatePosition();
    updateColors();
  }
  public PVector differenceTo(Node node) {
    return new PVector(node.position.x - position.x, node.position.y - position.y);
  }
  public float distanceTo(Node node) {
    return dist(position.x, position.y, node.position.x, node.position.y);
  }
  public Node getClosestNode(ArrayList<Node> nodes) {
    if(!sticky || closestNode == null || !nodes.contains(closestNode)) {
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
    }
    return closestNode;
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
  private void updateColors() {
    if(options.getAsBoolean("lerpColor")) {
      float lerpAmount = 0.5/(distanceToClosestNode/10);
      color intermediateSecondaryColor = lerpColor(secondaryColor, closestNode.secondaryColor, lerpAmount);
      secondaryColor = intermediateSecondaryColor;
    }
  }
  private void updatePosition() {
    PVector difference = differenceTo(closestNode);
    PVector movement = new PVector(difference.x * attraction / mass, difference.y * attraction / mass);
    if(inertia) {
      acceleration = movement;
      position.add(speed);
      speed.add(acceleration);
    }
    else {
      movement.mult(100);
      position.add(movement);
    }
  }
}
