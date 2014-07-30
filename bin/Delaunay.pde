public class DelaunayTriangulation {
  public void drawTriangles(ArrayList<DelaunayTriangle> triangles) {
    pushStyle();
    fill(0, 0, 0 ,0);
    int nTriangles = triangles.size();
    for (int i = 0; i < nTriangles; i++) {
      DelaunayTriangle t = (DelaunayTriangle)triangles.get(i);
      stroke(lerpColor(t.a1.baseColor, t.a2.baseColor, 0.5));
      line(t.p1.x, t.p1.y, t.p2.x, t.p2.y);
      stroke(lerpColor(t.a2.baseColor, t.a3.baseColor, 0.5));
      line(t.p2.x, t.p2.y, t.p3.x, t.p3.y);
      stroke(lerpColor(t.a3.baseColor, t.a1.baseColor, 0.5));
      line(t.p3.x, t.p3.y, t.p1.x, t.p1.y);
    }
    popStyle();
  }
}

