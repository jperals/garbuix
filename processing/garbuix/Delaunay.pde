public class DelaunayTriangulation {
  public void drawTriangles(ArrayList<DelaunayTriangle> triangles) {
    drawTriangles(triangles, false);
  }
  public void drawTriangles(ArrayList<DelaunayTriangle> triangles, boolean fillTriangles) {
    pushStyle();
    if(fillTriangles) {
      noStroke();
    }
    else {
      fill(0, 0, 0 ,0);
    }
    int nTriangles = triangles.size();
    for (int i = 0; i < nTriangles; i++) {
      DelaunayTriangle t = (DelaunayTriangle)triangles.get(i);
      if(fillTriangles) {
        color c1 = t.n1.primaryColor,
              c2 = t.n2.primaryColor,
              c3 = t.n2.primaryColor;
        float r = (red(c1) + red(c2) + red(c2))/3,
              g = (green(c1) + green(c2) + green(c3))/3,
              b = (blue(c1) + blue(c2) + blue(c3))/3,
              a = (alpha(c1) + alpha(c2) + alpha(c3))/3;
        fill(r, g, b, a);
        triangle(t.p1.x, t.p1.y, t.p2.x, t.p2.y, t.p3.x, t.p3.y);
      }
      else {
        stroke(lerpColor(t.n1.primaryColor, t.n2.primaryColor, 0.5));
        line(t.p1.x, t.p1.y, t.p2.x, t.p2.y);
        stroke(lerpColor(t.n2.primaryColor, t.n3.primaryColor, 0.5));
        line(t.p2.x, t.p2.y, t.p3.x, t.p3.y);
        stroke(lerpColor(t.n3.primaryColor, t.n1.primaryColor, 0.5));
        line(t.p3.x, t.p3.y, t.p1.x, t.p1.y);
      }
    }
    popStyle();
  }
}
