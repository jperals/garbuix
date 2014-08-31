/* 
   A "Picky path" is a collection of points picked by going always to the next nearest point,
   but without repeating any
 */

class PickyPath {
  public PVector[] points;
  public PickyPath(ArrayList<Node> nodes) {
    this(nodes, 0);
  }
  public PickyPath(ArrayList<Node> originalNodes, int first) {
    int nNodes = originalNodes.size(),
        nPickedNodes = 0;
    ArrayList<Node> nonPickedNodes = new ArrayList<Node>(),
                    pickedNodes = new ArrayList<Node>();
    
    points = new PVector[nNodes];
                    
    // First we need to make a copy of the original arraylist, otherwise we would modify it                
    for(int i = 0; i < nNodes; i++) {
      nonPickedNodes.add(originalNodes.get(i));
    }
    
    Node currentNode = originalNodes.get(first);
    while(nPickedNodes < nNodes) {
      Node closestNode = currentNode.getClosestNode(nonPickedNodes);
      while(pickedNodes.contains(closestNode)) {
        nonPickedNodes.remove(closestNode);
        closestNode = currentNode.getClosestNode(nonPickedNodes);
      }
      pickedNodes.add(closestNode);
      points[nPickedNodes] = closestNode.position;
      nPickedNodes++;
      currentNode = closestNode;
    }
  }
  public void drawAsCurve() {
    int nNodes = points.length;
    pushStyle();
    noFill();
    beginShape();
    for(int i = 0; i < nNodes; i++) {
      PVector point = points[i];
      curveVertex(point.x, point.y);
    }
    endShape();
    popStyle();
  }
  public void drawAsLines() {
    int nNodes = points.length;
    PVector currentNodePosition,
          nextNodePosition = points[0];
    for(int i = 0; i < nNodes - 1; i++) {
      currentNodePosition = nextNodePosition;
      nextNodePosition = points[i + 1];
      float distance = dist(currentNodePosition.x, currentNodePosition.y, nextNodePosition.x, nextNodePosition.y);
      float coefficient = 1 / max(distance*distance/300, 1);
  /*  stroke(255 * coefficient, 255 * coefficient, 255 * coefficient, 10);
      int strokeWidth = (int)(15 * coefficient);
        for(int j = 0; j < strokeWidth; j++) {
        strokeWeight(j);
        line(currentNodePosition.x, currentNodePosition.y, nextNodePosition.x, nextNodePosition.y);
      }*/
      //strokeWeight(coefficient);
      stroke(255, 255, 255, 100 * coefficient);
      line(currentNodePosition.x, currentNodePosition.y, nextNodePosition.x, nextNodePosition.y);
    }
  }
}
