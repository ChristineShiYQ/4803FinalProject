
class pts // class for manipulaitng and displaying pointclouds or polyloops in 3D 
{ 
  int maxnv = 16000;                 //  max number of vertices
  pt[] G = new pt [maxnv];           // geometry table (vertices)
  char[] L = new char [maxnv];             // labels of points
  vec [] LL = new vec[ maxnv];  // displacement vectors
  Boolean loop=true;          // used to indicate closed loop 3D control polygons
  int pv =0, // picked vertex index,
    iv=0, //  insertion vertex index
    dv = 0, // dancer support foot index
    nv = 0, // number of vertices currently used in P
    pp=1; // index of picked vertex

  pts() {
  }
  pts declare() 
  {
    for (int i=0; i<maxnv; i++) G[i]=P(); 
    for (int i=0; i<maxnv; i++) LL[i]=V(); 
    return this;
  }     // init all point objects
  pts empty() {
    nv=0; 
    pv=0; 
    return this;
  }                                 // resets P so that we can start adding points
  pts addPt(pt P, char c) { 
    G[nv].setTo(P); 
    pv=nv; 
    L[nv]=c; 
    nv++;  
    return this;
  }          // appends a new point at the end
  pts addPt(pt P) { 
    G[nv].setTo(P); 
    pv=nv; 
    L[nv]='f'; 
    nv++;  
    return this;
  }          // appends a new point at the end
  pts addPt(float x, float y) { 
    G[nv].x=x; 
    G[nv].y=y; 
    pv=nv; 
    nv++; 
    return this;
  } // same byt from coordinates
  pts copyFrom(pts Q) {
    empty(); 
    nv=Q.nv; 
    for (int v=0; v<nv; v++) G[v]=P(Q.G[v]); 
    return this;
  } // set THIS as a clone of Q

  pts resetOnCircle(int k, float r)  // sets THIS to a polyloop with k points on a circle of radius r around origin
  {
    empty(); // resert P
    pt C = P(); // center of circle
    for (int i=0; i<k; i++) addPt(R(P(C, V(0, -r, 0)), 2.*PI*i/k, C)); // points on z=0 plane
    pv=0; // picked vertex ID is set to 0
    return this;
  } 
  // ********* PICK AND PROJECTIONS *******  
  int SETppToIDofVertexWithClosestScreenProjectionTo(pt M)  // sets pp to the index of the vertex that projects closest to the mouse 
  {
    pp=0; 
    for (int i=1; i<nv; i++) if (d(M, ToScreen(G[i]))<=d(M, ToScreen(G[pp]))) pp=i; 
    return pp;
  }
  pts showPicked() {
    show(G[pv], 23); 
    return this;
  }
  pt closestProjectionOf(pt M)    // Returns 3D point that is the closest to the projection but also CHANGES iv !!!!
  {
    pt C = P(G[0]); 
    float d=d(M, C);       
    for (int i=1; i<nv; i++) if (d(M, G[i])<=d) {
      iv=i; 
      C=P(G[i]); 
      d=d(M, C);
    }  
    for (int i=nv-1, j=0; j<nv; i=j++) { 
      pt A = G[i], B = G[j];
      if (projectsBetween(M, A, B) && disToLine(M, A, B)<d) {
        d=disToLine(M, A, B); 
        iv=i; 
        C=projectionOnLine(M, A, B);
      }
    } 
    return C;
  }

  // ********* MOVE, INSERT, DELETE *******  
  pts insertPt(pt P) { // inserts new vertex after vertex with ID iv
    for (int v=nv-1; v>iv; v--) {
      G[v+1].setTo(G[v]);  
      L[v+1]=L[v];
    }
    iv++; 
    G[iv].setTo(P);
    L[iv]='f';
    nv++; // increments vertex count
    return this;
  }
  pts insertClosestProjection(pt M) {  
    pt P = closestProjectionOf(M); // also sets iv
    insertPt(P);
    return this;
  }
  pts deletePicked() 
  {
    for (int i=pv; i<nv; i++) 
    {
      G[i].setTo(G[i+1]); 
      L[i]=L[i+1];
    }
    pv=max(0, pv-1); 
    nv--;  
    return this;
  }
  pts setPt(pt P, int i) { 
    G[i].setTo(P); 
    return this;
  }

  pts drawBalls(float r) {
    for (int v=0; v<nv; v++) show(G[v], r); 
    return this;
  }
  pts showPicked(float r) {
    show(G[pv], r); 
    return this;
  }
  pts drawClosedCurve(float r) 
  {
    //fill(dgreen);
    //for (int v=0; v<nv; v++) show(G[v], r*3);    
    //fill(magenta);
    for (int v=0; v<nv-1; v++) stub(G[v], V(G[v], G[v+1]), r, r);  
    stub(G[nv-1], V(G[nv-1], G[0]), r, r);
    pushMatrix(); //translate(0,0,1); 
    scale(1, 1, 0.03);  
    //fill(grey);
    //for (int v=0; v<nv; v++) show(G[v], r*3);    
    //for (int v=0; v<nv-1; v++) stub(G[v], V(G[v], G[v+1]), r, r);  
    //stub(G[nv-1], V(G[nv-1], G[0]), r, r);
    popMatrix();
    return this;
  }
    pts drawClosedCurve(float r, Frame f) 
  {
    //fill(dgreen);
    //for (int v=0; v<nv; v++) show(G[v], r*3);    
    //fill(magenta);
    for (int v=0; v<nv-1; v++) {f.O = G[v]; drawArrows(f.O, f.I, f.J, f.K); stub(G[v], V(G[v], G[v+1]), r, r);}
    stub(G[nv-1], V(G[nv-1], G[0]), r, r);
    pushMatrix(); //translate(0,0,1); 
    scale(1, 1, 0.03);  
    //fill(grey);
    //for (int v=0; v<nv; v++) show(G[v], r*3);    
    //for (int v=0; v<nv-1; v++) stub(G[v], V(G[v], G[v+1]), r, r);  
    //stub(G[nv-1], V(G[nv-1], G[0]), r, r);
    popMatrix();
    return this;
  }
  pts set_pv_to_pp() {
    pv=pp; 
    return this;
  }
  pts movePicked(vec V) { 
    G[pv].add(V); 
    return this;
  }      // moves selected point (index p) by amount mouse moved recently
  pts setPickedTo(pt Q) { 
    G[pv].setTo(Q); 
    return this;
  }      // moves selected point (index p) by amount mouse moved recently
  pts moveAll(vec V) {
    for (int i=0; i<nv; i++) G[i].add(V); 
    return this;
  };   
  pt Picked() {
    return G[pv];
  } 
  pt Pt(int i) {
    if (0<=i && i<nv) return G[i]; 
    else return G[0];
  } 

  // ********* I/O FILE *******  
  void savePts(String fn) 
  {
    String [] inppts = new String [nv+1];
    int s=0;
    inppts[s++]=str(nv);
    for (int i=0; i<nv; i++) {
      inppts[s++]=str(G[i].x)+","+str(G[i].y)+","+str(G[i].z)+","+L[i];
    }
    saveStrings(fn, inppts);
  };

  void loadPts(String fn) 
  {
    println("loading: "+fn); 
    String [] ss = loadStrings(fn);
    String subpts;
    int s=0;   
    int comma, comma1, comma2;   
    float x, y;   
    int a, b, c;
    nv = int(ss[s++]); 
    print("nv="+nv);
    for (int k=0; k<nv; k++) 
    {
      int i=k+s; 
      //float [] xy = float(split(ss[i],",")); 
      String [] SS = split(ss[i], ","); 
      G[k].setTo(float(SS[0]), float(SS[1]), float(SS[2]));
      L[k]=SS[3].charAt(0);
    }
    pv=0;
  };

  // Dancer
  void setPicekdLabel(char c) {
    L[pp]=c;
  }



  void setFifo() 
  {
    _LookAtPt.reset(G[dv], 60);
  }              


  void next() {
    dv=n(dv);
  }
  int n(int v) {
    return (v+1)%nv;
  }
  int p(int v) {
    if (v==0) return nv-1; 
    else return v-1;
  }
  
    pts subdivideQuadraticSpline(pts Q) 
    {
    Q.empty();
    int k = 0;
    //while(k <=3) {
    for(int i=0; i<nv*2; i++)
      {
      //fill(pink);
        
        if (i%2==0) {Q.addPt(((P(G[p(i/2)]).mul(0.689)).add(P(G[i/2]).mul(8.-2.*0.689)).add(P(G[n(i/2)]).mul(0.689))).div(8.)); }
        else {Q.addPt((P(G[p((i-1)/2)]).mul(0.689-1.).add( P(G[(i-1)/2]).mul(9.-0.689)).add( P(G[n((i-1)/2)]).mul(9.-0.689)).add(P(G[n(n((i-1)/2))]).mul(0.689-1.))).div(16.));
        }
      }
    return this;
    } 
      pts subdivideQuintic(pts Q) 
    {
    Q.empty();
    int k = 0;
    //while(k <=3) {
    for(int i=0; i<nv*2; i++)
      {
      //fill(pink);
        
        if (i%2==0) {Q.addPt(((P(G[p(i/2)]).mul(1.5)).add(P(G[i/2]).mul(8.-2.*1.5)).add(P(G[n(i/2)]).mul(1.5))).div(8.)); }
        else {Q.addPt((P(G[p((i-1)/2)]).mul(1.5-1.).add( P(G[(i-1)/2]).mul(9.-1.5)).add( P(G[n((i-1)/2)]).mul(9.-1.5)).add(P(G[n(n((i-1)/2))]).mul(1.5-1.))).div(16.));
        }
      }
    return this;
    } 
pts subdivideFourPointInto(pts Q) 
  {
    Q.empty();
    pts tmp = new pts();
    tmp.declare();
    pts tmp2 = new pts();
    tmp2.declare();
    for (int i=0; i<nv; i++)
    {
      //refine  
      tmp.addPt(P(G[i])); 
      tmp.addPt(P(G[i], G[n(i)])); 
    }

    for (int i=0; i<tmp.nv; i++)
    {
      //dual = refine, kill 
      tmp2.addPt(P(tmp.G[i], tmp.G[tmp.n(i)])); 
    }
    tmp.empty();
    for (int i=0; i<tmp2.nv; i++)
    {
      //dual = refine, kill 
      tmp.addPt(P(tmp2.G[i], tmp2.G[tmp2.n(i)])); 
    }
   
   for (int i=0; i<tmp.nv; i++)
    {
      //dual = refine, kill 
      pt A = tmp.G[i], B = tmp.G[tmp.n(i)], C = tmp.G[tmp.n(tmp.n(i))];
      vec v1 = V(B,A), v2 = V(B,C);
      vec v = V(v1,v2);
      pt newB = P(B,M(v));
      Q.addPt(newB); 
    }
    return this;
  }  

void displaySubdivision() 
{
    float b = (float)Math.pow(4,level);
    float a = 500; //more subdivided, should have bigger b
    vec vecF = new vec(0,0,0);
    vec vecG = new vec(0,0,-1);
    pt newC = new pt(0,0,0);
    if (showCurve) {
      fill(yellow); 
      for (int j=0; j<nv; j++) caplet(G[j], 6, G[n(j)], 6);
    }
    boolean smooth =true;
    pt [] tmpB=new pt [nv];  
    pt[] B = new pt [nv];           // geometry table (vertices)
    Frame[] F = new Frame[nv];
   int k =1;
   for (int i=0; i<nv; i++)
    {
      //dual = refine, kill 
      int Bi = findKNext(k,i);
      int Di = findKPrev(k,i);
      pt pB = G[Bi], pC =G[i], pD = G[Di];

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
     smoothB(B,tmpB); 
    }
    if (showPath) {
      fill(cyan); 
      for (int j=0; j<nv; j++) caplet(B[j], 6, B[n(j)], 6);
    } 
    if (showKeys) {
      fill(green); 
      for (int j=0; j<nv; j+=4) arrow(B[j], G[j], 3);
    }
    for(int i = 0; i < nv; i++) {
      F[i] = new Frame(B[i]); 
      float ang = angle(F[i].I, U(B[i], G[i])); 
      F[i].translateRotate(0, ang, 0);}
    if (animating) f=n(f);
      fill(red); 
      //arrow(B[f], G[f], 20);
      drawArrows(F[f].O, F[f].I, F[f].J, F[f].K);
      F[f].M = myMesh;
      F[f].drawMesh(angle(F[f].I, U(B[f], G[f])));
 }
  int findKPrev(int k, int j) {
    int toR = j;
    for (int i = 0; i < k; i++ ) {
      toR = p(toR);
    }
    return toR;
  }
    int findKNext(int k, int j) {
    int toR = j;
    for (int i = 0; i < k; i++ ) {
      toR =n(toR);
    }
    return toR;
  }
  void smoothB(pt[] B, pt[]tmpB) {
    pt[] tmpB2 = new pt[nv];
    float s = 0.5;
    int smoothL  = 2;
    //tuck
    for (int j = 0; j < smoothL; j++) {
    for (int i=0; i<nv; i++) {
        pt pA = tmpB[p(i)], pB =tmpB[i], pC = tmpB[n(i)];
        vec MB =V(V(pB,pA),V(pB,pC));
        tmpB2[i] = P(pB,V(s,MB));
    }
        for (int i=0; i<nv; i++) {
        pt pA = tmpB2[p(i)], pB =tmpB2[i], pC = tmpB2[n(i)];
        vec MB =V(V(pB,pA),V(pB,pC));
        tmpB[i] = P(pB,V(s,MB));
    }
    }
    //untuck
        for (int j = 0; j < smoothL; j++) {
   for (int i=0; i<nv; i++) {
        pt pA = tmpB[p(i)], pB =tmpB[i], pC = tmpB[n(i)];
        vec MB =V(V(pB,pA),V(pB,pC));
        tmpB2[i] = P(pB,V(-s,MB));
    }
        for (int i=0; i<nv; i++) {
        pt pA = tmpB2[p(i)], pB =tmpB2[i], pC = tmpB2[n(i)];
        vec MB =V(V(pB,pA),V(pB,pC));
        tmpB[i] = P(pB,V(-s,MB));
    }
        }
        for (int i=0; i<nv; i++) {
        B[i] = tmpB[i];
    }
  }  
} // end of pts class