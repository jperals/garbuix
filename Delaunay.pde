public class DelaunayTriangulation {
  public void drawTriangles(ArrayList<DelaunayTriangle> triangles) {
    pushStyle();
    fill(0, 0, 0 ,0);
    int nTriangles = triangles.size();
    for (int i = 0; i < nTriangles; i++) {
      DelaunayTriangle t = (DelaunayTriangle)triangles.get(i);
      stroke(lerpColor(t.n1.primaryColor, t.n2.primaryColor, 0.5));
      line(t.p1.x, t.p1.y, t.p2.x, t.p2.y);
      stroke(lerpColor(t.n2.primaryColor, t.n3.primaryColor, 0.5));
      line(t.p2.x, t.p2.y, t.p3.x, t.p3.y);
      stroke(lerpColor(t.n3.primaryColor, t.n1.primaryColor, 0.5));
      line(t.p3.x, t.p3.y, t.p1.x, t.p1.y);
    }
    popStyle();
  }
}
