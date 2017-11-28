class loops {
  public pts P,Q,R;
  Frame[] F ;
  public loops() {
  P = new pts(); 
  Q = new pts();
  R = new pts(); 
  P.declare(); Q.declare(); R.declare(); // P is a polyloop in 3D: declared in pts
  P.loadPts("data/pts");  Q.loadPts("data/pts2"); // loads saved models from file (comment out if they do not exist yet)
    F  = new Frame[P.nv];

  createLoop();
  }
  public loops(pts K) { 
  P = new pts(); 
  Q = new pts();
  R = new pts(); 
  P.declare(); Q.declare(); R.declare(); // P is a polyloop in 3D: declared in pts
  P.copyFrom(K); 
  Q.copyFrom(K); 
   F  = new Frame[P.nv];
  createLoop();
  }
  void createLoop() {
     R.copyFrom(P); 
    for(int i=0; i<level; i++) {
      Q.copyFrom(R); 
      Q.subdivideQuintic(R);
      }
  }
  void displaySubdivision() {
    //R.displaySubdivision();
    displaySubdivision3();
  }
   void displaySubdivision3() 
{
    float b = (float)Math.pow(4,level);
    float a = 500; //more subdivided, should have bigger b
    vec vecF = new vec(0,0,0);
    vec vecG = new vec(0,0,-1);
    pt newC = new pt(0,0,0);
    if (showCurve) {
      fill(yellow); 
      for (int j=0; j<P.nv; j++) caplet(P.G[j], 6, P.G[P.n(j)], 6);
    }
    boolean smooth =true;
    pt [] tmpB=new pt [P.nv];  
    pt[] B = new pt [P.nv];           // geometry table (vertices)
    Frame[] F = new Frame[P.nv];
   int k =1;
   for (int i=0; i<P.nv; i++)
    {
      //dual = refine, kill 
      int Bi = P.findKNext(k,i);
      int Di = P.findKPrev(k,i);
      pt pB = P.G[Bi], pC =P.G[i], pD = P.G[Di];

      vec v1 = V(pC,pD), v2 = V(pC,pB);
      vec acc = A(v1,v2);
      vecF = A(V(-b,acc), V(a,vecG)).normalize();
      vecF = V(100, vecF);
      newC = P(pC,vecF);
      if(smooth) {
      tmpB[i] = newC;
      } else {
        B[i] = newC;
        
      }
    }
    //System.out.println(_hk);
    if (smooth) {
     P.smoothB(B,tmpB); 
    }
    if (showPath) {
      fill(cyan); 
      for (int j=0; j<P.nv; j++) caplet(B[j], 6, B[P.n(j)], 6);
    } 
    if (showKeys) {
      fill(green); 
      for (int j=0; j<P.nv; j+=4) arrow(B[j], P.G[j], 3);
    }
    for(int i = 0; i < P.nv; i++) {
      F[i] = new Frame(B[i]); 
      float ang = angle(F[i].I, U(B[i], P.G[i])); 
      F[i].translateRotate(0, ang, 0);}
    if (animating) f=P.n(f);
      fill(red); 
      //arrow(B[f], G[f], 20);
      drawArrows(F[f].O, F[f].I, F[f].J, F[f].K);
      F[f].M = read_mesh ("my.ply");
      F[f].drawMesh(angle(F[f].I, U(B[f], P.G[f])));
 }
}