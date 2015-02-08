public class Edge {
  
  public Node n1, n2;
  public PVector p1, p2;
  
  public Edge() {
    n1=null;
    n2=null;
    p1=null;
    p2=null;
  }
  
  public Edge(PVector p1, PVector p2) {
    this.p1 = p1;
    this.p2 = p2;
  }
  
  public Edge(Node n1, Node n2) {
    this.n1 = n1;
    this.n2 = n2;
    this.p1 = n1.position;
    this.p2 = n2.position;
  }
  
}
