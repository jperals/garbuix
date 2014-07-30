public class Edge {
  
  public Artifact a1, a2;
  public PVector p1, p2;
  
  public Edge() {
    a1=null;
    a2=null;
    p1=null;
    p2=null;
  }
  
  public Edge(PVector p1, PVector p2) {
    this.p1 = p1;
    this.p2 = p2;
  }
  
  public Edge(Artifact a1, Artifact a2) {
    this.a1 = a1;
    this.a2 = a2;
    this.p1 = a1.position;
    this.p2 = a2.position;
  }
  
}

