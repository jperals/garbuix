public class DelaunayTriangle {

  public Node n1, n2, n3;
  
  public PVector p1, p2, p3;
  
  public DelaunayTriangle() {
    p1=null;
    p2=null;
    p3=null; 
  }
  
  public DelaunayTriangle(PVector p1, PVector p2, PVector p3) {
    this.p1 = p1;
    this.p2 = p2;
    this.p3 = p3;
  }
  
  public DelaunayTriangle(Node n1, Node n2, Node n3) {
    this.n1 = n1;
    this.n2 = n2;
    this.n3 = n3;
    this.p1 = n1.position;
    this.p2 = n2.position;
    this.p3 = n3.position;
  }
  
  public boolean sharesVertex(DelaunayTriangle other) {
    return p1 == other.p1 || p1 == other.p2 || p1 == other.p3 ||
           p2 == other.p1 || p2 == other.p2 || p2 == other.p3 || 
           p3 == other.p1 || p3 == other.p2 || p3 == other.p3;
  }
  
}
