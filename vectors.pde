//**************************************
// 3D POINTS AND VECTOR CLASSES
// Written by Jarek Rossignac,  June 2006
//*************************************
  class pt 
  { 
  //float x=0,y=0; 
  float x,y,z; 
  // CREATE
  pt () {}
  pt (float px, float py) {x = px; y = py;};


  pt v() {vertex(x,y); return this;};  // used for drawing polygons between beginShape(); and endShape();
  
  pt (float px, float py, float pz) {x = px; y = py; z = pz;};
  pt make() {return(new pt(x,y,z));};
  void show(float r) { pushMatrix(); translate(x,y,z); sphere(r); popMatrix();}; 
  void showLineTo (pt P) {line(x,y,z,P.x,P.y,P.z); }; 
  void setTo(pt P) { x = P.x; y = P.y; z = P.z;}; 
  void setTo (float px, float py, float pz) {x = px; y = py; z = pz;}; 
  //void setTo (float px, float py) {x = px; y = py; }; 
  void setToMouse() { x = mouseX; y = mouseY; }; 
  void write() {println("("+x+","+y+","+z+")");};
  void addVec(vec V) {x += V.x; y += V.y; z += V.z;};
  void addScaledVec(float s, vec V) {x += s*V.x; y += s*V.y; z += s*V.z;};
  void moveTowards(float s, pt P) {x += s*(P.x-x); y += s*(P.y-y); z += s*(P.z-z);};
  void subVec(vec V) {x -= V.x; y -= V.y; z -= V.z;};
  void vert() {vertex(x,y,z);};
  void vertext(float u, float v) {vertex(x,y,z,u,v);};
  boolean isInWindow() {return(((x<0)||(x>width)||(y<0)||(y>height)));};
  void label(String s, vec D) {text(s, x+D.x, y+D.y, z+D.z);  };
  vec vecTo(pt P) {return(new vec(P.x-x,P.y-y,P.z-z)); };
  float disTo(pt P) {return(sqrt( sq(P.x-x)+sq(P.y-y)+sq(P.z-z) )); };
  vec vecToMid(pt P, pt Q) {return(new vec((P.x+Q.x)/2.0-x,(P.y+Q.y)/2.0-y,(P.z+Q.z)/2.0-z )); };
  vec vecToProp (pt B, pt D) {
      vec CB = this.vecTo(B); float LCB = CB.norm();
      vec CD = this.vecTo(D); float LCD = CD.norm();
      vec U = CB.make();
      vec V = CD.make(); V.sub(U); V.mul(LCB/(LCB+LCD));
      U.add(V);
      return(U);  
      };  
  void addPt(pt P) {x+=P.x; y+=P.y; z+=P.z;};
  void subPt(pt P) {x-=P.x; y-=P.y; z-=P.z; };
  void mul(float f) {x*=f; y*=f; z*=f;};
  void pers(float d) { y=d*y/(d+z); x=d*x/(d+z); z=d*z/(d+z); };
  void inverserPers(float d) { y=d*y/(d-z); x=d*x/(d-z); z=d*z/(d-z); };
  boolean coplanar (pt A, pt B, pt C) {return(abs(tetVol(this,A,B,C))<0.0001);};
  boolean cw (pt A, pt B, pt C) {return(tetVol(this,A,B,C)>0.0001);};

  } // end of pt class
 
// ===== point functions
pt P() {return new pt(); };                                                                          // point (x,y,z)
pt P(float x, float y, float z) {return new pt(x,y,z); };                                            // point (x,y,z)
pt P(float x, float y) {return new pt(x,y); };                                                       // make point (x,y)
pt P(pt A) {return new pt(A.x,A.y,A.z); };                                                           // copy of point P
pt P(pt A, float s, pt B) {return new pt(A.x+s*(B.x-A.x),A.y+s*(B.y-A.y),A.z+s*(B.z-A.z)); };        // A+sAB
pt L(pt A, float s, pt B) {return new pt(A.x+s*(B.x-A.x),A.y+s*(B.y-A.y),A.z+s*(B.z-A.z)); };        // A+sAB
pt P(pt A, pt B) {return P((A.x+B.x)/2.0,(A.y+B.y)/2.0,(A.z+B.z)/2.0); }                             // (A+B)/2
pt P(pt A, pt B, pt C) {return new pt((A.x+B.x+C.x)/3.0,(A.y+B.y+C.y)/3.0,(A.z+B.z+C.z)/3.0); };     // (A+B+C)/3
pt P(pt A, pt B, pt C, pt D) {return P(P(A,B),P(C,D)); };                                            // (A+B+C+D)/4
pt P(float s, pt A) {return new pt(s*A.x,s*A.y,s*A.z); };                                            // sA
pt A(pt A, pt B) {return new pt(A.x+B.x,A.y+B.y,A.z+B.z); };                                         // A+B
pt P(float a, pt A, float b, pt B) {return A(P(a,A),P(b,B));}                                        // aA+bB 
pt P(float a, pt A, float b, pt B, float c, pt C) {return A(P(a,A),P(b,B,c,C));}                     // aA+bB+cC 
pt P(float a, pt A, float b, pt B, float c, pt C, float d, pt D){return A(P(a,A,b,B),P(c,C,d,D));}   // aA+bB+cC+dD
pt P(pt P, vec V) {return new pt(P.x + V.x, P.y + V.y, P.z + V.z); }                                 // P+V
pt P(pt P, float s, vec V) {return new pt(P.x+s*V.x,P.y+s*V.y,P.z+s*V.z);}                           // P+sV
pt P(pt O, float x, vec I, float y, vec J) {return P(O.x+x*I.x+y*J.x,O.y+x*I.y+y*J.y,O.z+x*I.z+y*J.z);}  // O+xI+yJ
pt P(pt O, float x, vec I, float y, vec J, float z, vec K) {return P(O.x+x*I.x+y*J.x+z*K.x,O.y+x*I.y+y*J.y+z*K.y,O.z+x*I.z+y*J.z+z*K.z);}  // O+xI+yJ+kZ
pt L(pt A, pt B, float t) {return P(A.x+t*(B.x-A.x),A.y+t*(B.y-A.y));}
pt N(float a, pt A, float b, pt B, float t) {return P((b-t)/(b-a)*A.x+(t-a)/(b-a)*B.x,(b-t)/(b-a)*A.y+(t-a)/(b-a)*B.y, (b-t)/(b-a)*A.z+(t-a)/(b-a)*B.z);  } 
pt N(float a, pt A, float b, pt B, float c, pt C, float t) {pt P = N(a,A,b,B,t), Q = N(b,B,c,C,t); return N(a,P,c,Q,t);}
pt N(float a, pt A, float b, pt B, float c, pt C, float d, pt D, float t) {pt P = N(a,A,b,B,c,C,t), Q = N(b,B,c,C,d,D,t); return N(a,P,d,Q,t);}
void makePts(pt[] C) {for(int i=0; i<C.length; i++) C[i]=P();}

pt OnParabola(pt A, pt B, pt C, float t){return P(P(A,t,B),t,P(B,t,C)); } //(3)

 
class vec { 
  float x,y,z = 0;
  vec () {}; 
  vec (float px, float py, float pz) {x = px; y = py; z = pz;};
  vec (float px, float py) {x = px; y = py;};
  void setTo (float px, float py, float pz) {x = px; y = py; z = pz;}; 
  vec make() {return(new vec(x,y,z));};
  void setTo(vec V) { x = V.x; y = V.y; z = V.z;}; 
  void show (pt P) {line(P.x,P.y, P.z,P.x+x,P.y+y,P.z+z); }; 
  void add(vec V) {x += V.x; y += V.y; z += V.z;};
  void addScaled(float m, vec V) {x += m*V.x; y += m*V.y; z += m*V.z;};
  void sub(vec V) {x -= V.x; y -= V.y; z -= V.z;};
  void mul(float m) {x *= m; y *= m; z *= m;};
  void div(float m) {x /= m; y /= m; z /= m;};
  void write() {println("("+x+","+y+","+z+")");};
  float norm() {return(sqrt(sq(x)+sq(y)+sq(z)));}; 
  void makeUnit() {float n=this.norm(); if (n>0.0001) {this.div(n);};};
  void back() {x= -x; y= -y; z= -z;};
  boolean coplanar (vec V, vec W) {return(abs(mixed(this,V,W))<0.0001);};
  boolean cw (vec U, vec V, vec W) {return(mixed(this,V,W)>0.0001);};
  } ;
  
pt interpolate(pt A, float s, pt B) {return(new pt( (1-s)*A.x+s*B.x , (1-s)*A.y+s*B.y, (1-s)*A.z+s*B.z )); };

vec triNormalFromPts(pt A, pt B, pt C) {vec N = cross(A.vecTo(B),A.vecTo(C));  return(N); };
float tetVol (pt A, pt B, pt C, pt D) { return(dot(triNormalFromPts(A,B,C),A.vecTo(D))); };
vec midVec(vec U, vec V) {return(new vec((U.x+V.x)/2,(U.y+V.y)/2,(U.z+V.z)/2)); };
vec sum(vec U, vec V) {return(new vec(U.x+V.x,U.y+V.y,U.z+V.z)); };
vec dif(vec U, vec V) {return(new vec(U.x-V.x,U.y-V.y,U.z-V.z)); };
float dot(vec U, vec V) {return(U.x*V.x+U.y*V.y+U.z*V.z); };
vec cross(vec U, vec V) {return(new vec( U.y*V.z-U.z*V.y, U.z*V.x-U.x*V.z, U.x*V.y-U.y*V.x )); };
float mixed(vec U, vec V, vec W) {return(dot(cross(U,V),W)); };
pt midPt(pt A, pt B) {return(new pt((A.x+B.x)/2 , (A.y+B.y)/2, (A.z+B.z)/2 )); };
pt triCenterFromPts(pt A, pt B, pt C) {return(new pt((A.x+B.x+C.x)/3 , (A.y+B.y+C.y)/3, (A.z+B.z+C.z)/3 )); };
float tetVolume(pt E, pt A, pt B, pt C) {vec EA=E.vecTo(A); vec EB=E.vecTo(B); vec EC=E.vecTo(C); float v=mixed(EA,EB,EC); return(v/6); };
boolean rayHitTri(pt E, pt M, pt A, pt B, pt C) { boolean s, sA, sB, sC; 
  s=(tetVolume(E,A,B,C)>0);  sA=(tetVolume(E,M,B,C)>0); sB=(tetVolume(E,A,M,C)>0);  sC=(tetVolume(E,A,B,M)>0); 
  return( (s==sA) && (s==sB) && (s==sC) );};

float rayDistTriPlane(pt E, pt M, pt A, pt B, pt C) { 
   vec AE = A.vecTo(E); vec AC = A.vecTo(C); vec AB = A.vecTo(B); vec EM = E.vecTo(M); 
   float s = - mixed(AE,AC,AB) / mixed(EM,AC,AB);
   return(s); };
   
  
float angle(vec U, vec V) {float c=dot(U,V); float s=cross(U,V).norm(); float a=atan2(s,c); return(a);}; 

//float dot(vec U, vec V) {return U.x*V.x+U.y*V.y; }                                                     // dot(U,V): U*V (dot product U*V)
float det(vec U, vec V) {return dot(R(U),V); }    

//vec R(vec V) {return V(-V.y,V.x,V.z);} // rotated 90 degrees in XY plane

// =====  vector functions
vec V() {return new vec(); };                                                                          // make vector (x,y,z)
float det2(vec U, vec V) {return -U.y*V.x+U.x*V.y; };                                                // U:V det product of (x,y) components
float N(vec V) {return(sqrt(sq(V.x)+sq(V.y)+sq(V.z)));}; 
vec V(float x, float y, float z) {return new vec(x,y,z); };                                            // make vector (x,y,z)
vec V(vec V) {return new vec(V.x,V.y,V.z); };                                                          // make copy of vector V
vec A(vec A, vec B) {return new vec(A.x+B.x,A.y+B.y,A.z+B.z); };                                       // A+B
vec A(vec U, float s, vec V) {return V(U.x+s*V.x,U.y+s*V.y,U.z+s*V.z);};                               // U+sV
vec M(vec U, vec V) {return V(U.x-V.x,U.y-V.y,U.z-V.z);};                                              // U-V
vec M(vec V) {return V(-V.x,-V.y,-V.z);};                                                              // -V
float len(vec V) {return sqrt(V.x*V.x + V.y*V.y);}
//vec reverse() {return V(-V.x,-V.y,-V.z);};
vec V(vec A, vec B) {return new vec((A.x+B.x)/2.0,(A.y+B.y)/2.0,(A.z+B.z)/2.0); }                      // (A+B)/2
vec V(vec A, float s, vec B) {return new vec(A.x+s*(B.x-A.x),A.y+s*(B.y-A.y),A.z+s*(B.z-A.z)); };      // (1-s)A+sB
vec V(vec A, vec B, vec C) {return new vec((A.x+B.x+C.x)/3.0,(A.y+B.y+C.y)/3.0,(A.z+B.z+C.z)/3.0); };  // (A+B+C)/3
vec V(vec A, vec B, vec C, vec D) {return V(V(A,B),V(C,D)); };                                         // (A+B+C+D)/4
vec V(float s, vec A) {return new vec(s*A.x,s*A.y,s*A.z); };                                           // sA
vec V(float a, vec A, float b, vec B) {return A(V(a,A),V(b,B));}                                       // aA+bB 
vec V(float a, vec A, float b, vec B, float c, vec C) {return A(V(a,A,b,B),V(c,C));}                   // aA+bB+cC
vec V(pt P, pt Q) {return new vec(Q.x-P.x,Q.y-P.y,Q.z-P.z);};                                          // PQ
vec U(vec V) {float n = V.norm(); if (n<0.0000001) return V(0,0,0); else return V(1./n,V);};           // V/||V||
vec U(pt P, pt Q) {return U(V(P,Q));};                                                                 // PQ/||PQ||
vec U(float x, float y, float z) {return U(V(x,y,z)); };                                               // make vector (x,y,z)
vec N(vec U, vec V) {return V( U.y*V.z-U.z*V.y, U.z*V.x-U.x*V.z, U.x*V.y-U.y*V.x); };                  // UxV cross product (normal to both)
vec N(pt A, pt B, pt C) {return N(V(A,B),V(A,C)); };                                                   // normal to triangle (A,B,C), not normalized (proportional to area)
vec B(vec U, vec V) {return U(N(N(U,V),U)); }                                                          // normal to U in plane (U,V)
vec Normal(vec V) {                                                                                    // vector orthogonal to V
  if(abs(V.z)<=min(abs(V.x),abs(V.y))) return V(-V.y,V.x,0); 
  if(abs(V.x)<=min(abs(V.z),abs(V.y))) return V(0,-V.z,V.y);
  return V(V.z,0,-V.x);
  }
  
float d(vec U, vec V) {return U.x*V.x+U.y*V.y+U.z*V.z; };                                            //U*V dot product
float d(pt P, pt Q) {return sqrt(sq(Q.x-P.x)+sq(Q.y-P.y)+sq(Q.z-P.z)); };                            // ||AB|| distance

void v(pt P) {vertex(P.x,P.y,P.z);};                                           // vertex for shading or drawing (between BeginShape() ; and endShape();)
vec R(vec V) {return V(-V.y,V.x,V.z);} // rotated 90 degrees in XY plane
pt R(pt P, float a, vec I, vec J, pt G) {float x=d(V(G,P),I), y=d(V(G,P),J); float c=cos(a), s=sin(a); return P(P,x*c-x-y*s,I,x*s+y*c-y,J); }; // Rotated P by a around G in plane (I,J)
vec R(vec V, float a, vec I, vec J) {float x=d(V,I), y=d(V,J); float c=cos(a), s=sin(a); return A(V,V(x*c-x-y*s,I,x*s+y*c-y,J)); }; // Rotated V by a parallel to plane (I,J)
pt R(pt Q, float a) {float dx=Q.x, dy=Q.y, c=cos(a), s=sin(a); return P(c*dx+s*dy,-s*dx+c*dy,Q.z); };  // Q rotated by angle a around the origin
pt R(pt Q, float a, pt C) {float dx=Q.x-C.x, dy=Q.y-C.y, c=cos(a), s=sin(a); return P(C.x+c*dx-s*dy, C.y+s*dx+c*dy, Q.z); };  // Q rotated by angle a around point P
//pt R(pt Q, pt C, pt P, pt R)  // returns rotated version of Q by angle(CP,CR) parallel to plane (C,P,R)
   {
   //vec I0=U(C,P), I1=U(C,R), V=V(C,Q); 
   //float c=d(I0,I1), s=sqrt(1.-sq(c)); 
                                       //if(abs(s)<0.00001) return Q; // singular cAW
   //vec J0=V(1./s,I1,-c/s,I0);  
   //vec J1=V(-s,I0,c,J0);  
   //float x=d(V,I0), y=d(V,J0);
   //return P(Q,x,M(I1,I0),y,M(J1,J0)); 
   } 