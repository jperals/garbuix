public class DelaunayTriangle {

  public Artifact a1, a2, a3;
  
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
  
  public DelaunayTriangle(Artifact a1, Artifact a2, Artifact a3) {
    this.a1 = a1;
    this.a2 = a2;
    this.a3 = a3;
    this.p1 = a1.position;
    this.p2 = a2.position;
    this.p3 = a3.position;
  }
  
  public boolean sharesVertex(DelaunayTriangle other) {
    return p1 == other.p1 || p1 == other.p2 || p1 == other.p3 ||
           p2 == other.p1 || p2 == other.p2 || p2 == other.p3 || 
           p3 == other.p1 || p3 == other.p2 || p3 == other.p3;
  }
  
}

