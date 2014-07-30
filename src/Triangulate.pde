/*
 * From Processing wiki, modified to accept our "Artifact" type instead of PVector
 * http://wiki.processing.org/w/Triangulation
 */
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.Iterator;

public class Triangulate {

  /*
    From P Bourke's C prototype - 

    qsort(p,nv,sizeof(XYZ),XYZCompare);
    
    int XYZCompare(void *v1,void *v2) {
      XYZ *p1,*p2;
      p1 = v1;
      p2 = v2;
      if (p1->x < p2->x)
        return(-1);
      else if (p1->x > p2->x)
        return(1);
      else
        return(0);
    }
  */
  private class XComparator implements Comparator<Artifact> {
    
    public int compare(Artifact p1, Artifact p2) {
      if (p1.position.x < p2.position.x) {
        return -1;
      }
      else if (p1.position.x > p2.position.x) {
        return 1;
      }
      else {
        return 0;
      }
    }
  }
  /*
    Return TRUE if a point (xp,yp) is inside the circumcircle made up
    of the points (x1,y1), (x2,y2), (x3,y3)
    The circumcircle centre is returned in (xc,yc) and the radius r
    NOTE: A point on the edge is inside the circumcircle
  */
  private boolean circumCircle(PVector p, DelaunayTriangle t, PVector circle) {

    float m1,m2,mx1,mx2,my1,my2;
    float dx,dy,rsqr,drsqr;
    
    /* Check for coincident points */
    if ( PApplet.abs(t.p1.y-t.p2.y) < PApplet.EPSILON && PApplet.abs(t.p2.y-t.p3.y) < PApplet.EPSILON ) {
      System.err.println("CircumCircle: Points are coincident.");
      return false;
    }

    if ( PApplet.abs(t.p2.y-t.p1.y) < PApplet.EPSILON ) {
      m2 = - (t.p3.x-t.p2.x) / (t.p3.y-t.p2.y);
      mx2 = (t.p2.x + t.p3.x) / 2.0f;
      my2 = (t.p2.y + t.p3.y) / 2.0f;
      circle.x = (t.p2.x + t.p1.x) / 2.0f;
      circle.y = m2 * (circle.x - mx2) + my2;
    }
    else if ( PApplet.abs(t.p3.y-t.p2.y) < PApplet.EPSILON ) {
      m1 = - (t.p2.x-t.p1.x) / (t.p2.y-t.p1.y);
      mx1 = (t.p1.x + t.p2.x) / 2.0f;
      my1 = (t.p1.y + t.p2.y) / 2.0f;
      circle.x = (t.p3.x + t.p2.x) / 2.0f;
      circle.y = m1 * (circle.x - mx1) + my1;  
    }
    else {
      m1 = - (t.p2.x-t.p1.x) / (t.p2.y-t.p1.y);
      m2 = - (t.p3.x-t.p2.x) / (t.p3.y-t.p2.y);
      mx1 = (t.p1.x + t.p2.x) / 2.0f;
      mx2 = (t.p2.x + t.p3.x) / 2.0f;
      my1 = (t.p1.y + t.p2.y) / 2.0f;
      my2 = (t.p2.y + t.p3.y) / 2.0f;
      circle.x = (m1 * mx1 - m2 * mx2 + my2 - my1) / (m1 - m2);
      circle.y = m1 * (circle.x - mx1) + my1;
    }
  
    dx = t.p2.x - circle.x;
    dy = t.p2.y - circle.y;
    rsqr = dx*dx + dy*dy;
    circle.z = PApplet.sqrt(rsqr);
    
    dx = p.x - circle.x;
    dy = p.y - circle.y;
    drsqr = dx*dx + dy*dy;
  
    return drsqr <= rsqr;
  }

  Triangulate() {
  }

  /*
    Triangulation subroutine
    Takes as input vertices (PVectors) in ArrayList pxyz
    Returned is a list of triangular faces in the ArrayList triangles 
    These triangles are arranged in a consistent clockwise order.
  */
  public ArrayList<DelaunayTriangle> triangulate( ArrayList<Artifact> artifacts ) {
  
    // sort vertex array in increasing x values
    Collections.sort(artifacts, new XComparator());
        
    /*
      Find the maximum and minimum vertex bounds.
      This is to allow calculation of the bounding triangle
    */
    float xmin = artifacts.get(0).position.x;
    float ymin = artifacts.get(0).position.y;
    float xmax = xmin;
    float ymax = ymin;
    
    Iterator<Artifact> pIter = artifacts.iterator();
    while (pIter.hasNext()) {
      PVector position = (PVector)pIter.next().position;
      if (position.x < xmin) xmin = position.x;
      if (position.x > xmax) xmax = position.x;
      if (position.y < ymin) ymin = position.y;
      if (position.y > ymax) ymax = position.y;
    }
    
    float dx = xmax - xmin;
    float dy = ymax - ymin;
    float dmax = (dx > dy) ? dx : dy;
    float xmid = (xmax + xmin) / 2.0f;
    float ymid = (ymax + ymin) / 2.0f;
  
    ArrayList<DelaunayTriangle> triangles = new ArrayList<DelaunayTriangle>(); // for the Triangles
    HashSet<DelaunayTriangle> complete = new HashSet<DelaunayTriangle>(); // for complete Triangles

    /*
      Set up the supertriangle
      This is a triangle which encompasses all the sample points.
      The supertriangle coordinates are added to the end of the
      vertex list. The supertriangle is the first triangle in
      the triangle list.
    */
    Artifact a1 = new Artifact( xmid - 2.0f * dmax, ymid - dmax);
    Artifact a2 = new Artifact( xmid, ymid + 2.0f * dmax);
    Artifact a3 = new Artifact( xmid + 2.0f * dmax, ymid - dmax);
    DelaunayTriangle superTriangle = new DelaunayTriangle(a1, a2, a3);
    triangles.add(superTriangle);
    
    /*
      Include each point one at a time into the existing mesh
    */
    ArrayList<Edge> edges = new ArrayList<Edge>();
    pIter = artifacts.iterator();
    while (pIter.hasNext()) {
    
      Artifact artifact = pIter.next();
      PVector p = artifact.position;
      
      edges.clear();
      
      /*
        Set up the edge buffer.
        If the point (xp,yp) lies inside the circumcircle then the
        three edges of that triangle are added to the edge buffer
        and that triangle is removed.
      */
      PVector circle = new PVector();
      
      for (int j = triangles.size()-1; j >= 0; j--) {
      
        DelaunayTriangle t = (DelaunayTriangle)triangles.get(j);
        if (complete.contains(t)) {
          continue;
        }
          
        boolean inside = circumCircle( p, t, circle );
        
        if (circle.x + circle.z < p.x) {
          complete.add(t);
        }
        if (inside) {
          edges.add(new Edge(t.a1, t.a2));
          edges.add(new Edge(t.a2, t.a3));
          edges.add(new Edge(t.a3, t.a1));
          triangles.remove(j);
          t = null;
        }
        /*if((t.p1.x == p.x && t.p1.y == p.y) || (t.p2.x == p.x && t.p2.y == p.y) || (t.p3.x == p.x && t.p3.y == p.y) {
          artifact.addTriangle(t);
        }*/
      }

      /*
        Tag multiple edges
        Note: if all triangles are specified anticlockwise then all
        interior edges are opposite pointing in direction.
      */
      for (int j=0; j<edges.size()-1; j++) {
        Edge e1 = (Edge)edges.get(j);
        for (int k=j+1; k<edges.size(); k++) {
          Edge e2 = (Edge)edges.get(k);
          if (e1.p1 == e2.p2 && e1.p2 == e2.p1) {
            e1.p1 = null;
            e1.p2 = null;
            e2.p1 = null;
            e2.p2 = null;
          }
          /* Shouldn't need the following, see note above */
          if (e1.p1 == e2.p1 && e1.p2 == e2.p2) {
            e1.p1 = null;
            e1.p2 = null;
            e2.p1 = null;
            e2.p2 = null;
          }
        }
      }
      
      /*
        Form new triangles for the current point
        Skipping over any tagged edges.
        All edges are arranged in clockwise order.
      */
      for (int j=0; j < edges.size(); j++) {
        Edge e = (Edge)edges.get(j);
        if (e.p1 == null || e.p2 == null) {
          continue;
        }
        //println(p);
        DelaunayTriangle triangle = new DelaunayTriangle(e.a1, e.a2, artifact);
        triangles.add(triangle);
        /*if(!triangle.sharesVertex(superTriangle)) {
          artifact.addTriangle(triangle);
        }*/
      }
      
    }
      
    /*
      Remove triangles with supertriangle vertices
    */
    for (int i = triangles.size()-1; i >= 0; i--) {
      DelaunayTriangle t = (DelaunayTriangle)triangles.get(i);
      if (t.sharesVertex(superTriangle)) {
        triangles.remove(i);
        //println("remove triangle");
        //t = null;
      }
    }

    return triangles;
  }
  
}

