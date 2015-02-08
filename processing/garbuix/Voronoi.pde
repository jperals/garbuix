public class Voronoi {
  PVector artifactPosition;
  Voronoi(PVector p) {
    artifactPosition = p;
  }
  public class slopeComparator implements Comparator<PVector> {
      public int compare(PVector p1, PVector p2) {
        PVector d1 = new PVector(p1.x, p1.y);
        PVector d2 = new PVector(p2.x, p2.y);
        float h1 = d1.heading();
        float h2 = d2.heading();
        if(h1 > h2) return 1;
        if(h1 < h2) return -1;
        return 0;
      }
  }
  public ArrayList<PVector> getCircumcenters(ArrayList<DelaunayTriangle> triangles) {
    ArrayList<PVector> points = new ArrayList<PVector>();
    int nTriangles = triangles.size();
    for(int i = 0; i < nTriangles; i++) {
      DelaunayTriangle t = triangles.get(i);
      if(t == null) {
        continue;
      }
      PVector origin1 = new PVector((t.p1.x + t.p2.x)/2 - artifactPosition.x, (t.p1.y + t.p2.y)/2 - artifactPosition.y);
      PVector samplePoint1 = new PVector(origin1.x + (origin1.y - (t.p1.y - artifactPosition.y)), origin1.y - (origin1.x - (t.p1.x - artifactPosition.x)));
      PVector origin2 = new PVector((t.p2.x + t.p3.x)/2 - artifactPosition.x, (t.p2.y + t.p3.y)/2 - artifactPosition.y);
      PVector samplePoint2 = new PVector(origin2.x + (origin2.y - (t.p2.y - artifactPosition.y)), origin2.y - (origin2.x - (t.p2.x - artifactPosition.x)));
      PVector circumcenter = lineIntersection(origin1.x, origin1.y, samplePoint1.x, samplePoint1.y, origin2.x, origin2.y, samplePoint2.x, samplePoint2.y);
      if(circumcenter != null) {
        points.add(new PVector(circumcenter.x, circumcenter.y));
      }
    }
    Collections.sort(points, new slopeComparator());
    return points;
  }
  
  /**
  @author Ryan Alexander 
  */
   
  // Infinite Line Intersection
   
  private PVector lineIntersection(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4)
  {
    float bx = x2 - x1;
    float by = y2 - y1;
    float dx = x4 - x3;
    float dy = y4 - y3; 
    float b_dot_d_perp = bx*dy - by*dx;
    if(b_dot_d_perp == 0) {
      return null;
    }
    float cx = x3-x1; 
    float cy = y3-y1;
    float t = (cx*dy - cy*dx) / b_dot_d_perp; 
   
    return new PVector(x1+t*bx, y1+t*by); 
  }
}
