//*****************************************************************************
// TITLE:         Point sequence for editing polylines and polyloops  
// AUTHOR:        Prof Jarek Rossignac
// DATE CREATED:  September 2012
// EDITS:         Last revised Sept 10, 2016
//*****************************************************************************
class pts 
  {
  int nv=0;                                // number of vertices in the sequence
  int pv = 0;                              // picked vertex 
  int iv = 0;                              // insertion index 
  int maxnv = 100*2*2*2*2*2*2*2*2;         //  max number of vertices
  Boolean loop=true;                       // is a closed loop

  pt[] G = new pt [maxnv];                 // geometry table (vertices)
  char[] L = new char [maxnv];             // labels of points
 // CREATE


  pts() {}
  
  void declare() {for (int i=0; i<maxnv; i++) G[i]=P(); }               // creates all points, MUST BE DONE AT INITALIZATION

  void resetLabels() 
    {
    for (int i=0; i<maxnv; i++) 
      {
      if(i%6==0) L[i]='f';
      if(i%6==1) L[i]='f';
      if(i%6==2) L[i]='f';
      if(i%6==3) L[i]='s';
      if(i%6==4) L[i]='b';
      if(i%6==5) L[i]='f';
      }
    }              

  void setPicekdLabel(char c) {L[pv]=c;}
    
  void empty() {nv=0; pv=0; }                                                 // empties this object
  
  void addPt(pt P) { G[nv].x = P.x;G[nv].y = P.y; G[nv].z = P.z; pv=nv; nv++;  }                    // appends a point at position P
  
  void addPt(float x,float y, float z) { G[nv].x=x; G[nv].y=y; G[nv].z=z; pv=nv; nv++; }    // appends a point at position (x,y)
  
  void insertPt(pt P)  // inserts new point after point pv
    { 
    for(int v=nv-1; v>pv; v--) G[v+1].setTo(G[v]); 
    pv++; 
    G[pv].setTo(P);
    nv++; 
    }
     
  void makeGrid (int w) // make a 2D grid of w x w vertices
   {
   empty();
   for (int i=0; i<w; i++) 
     for (int j=0; j<w; j++) 
       addPt(P(.7*height*j/(w-1)+.1*height,.7*height*i/(w-1)+.1*height));
   }    

  void deletePickedPt() {
    for(int i=pv; i<nv; i++) 
      G[i].setTo(G[i+1]);
    pv=max(0,pv-1);       // reset index of picked point to previous
    nv--;  
    }
  
  void setPt(pt P, int i) 
    { 
    G[i].setTo(P); 
    }
  
  void drawCurve() 
    {
    if(loop) drawClosedCurve(); 
    else drawOpenCurve(); 
    }
    
  void drawOpenCurve() 
    {
    beginShape(); 
      for (int v=0; v<nv; v++) G[v].v(); 
    endShape(); 
    }
    
  void drawClosedCurve()   
    {
    beginShape(); 
      for (int v=0; v<nv; v++) G[v].v(); 
    endShape(CLOSE); 
    }

  // FILE I/O   
     
  void savePts(String fn) 
    {
    String [] inppts = new String [nv+1];
    int s=0;
    inppts[s++]=str(nv);
    for (int i=0; i<nv; i++) {inppts[s++]=str(G[i].x)+","+str(G[i].y);}
    saveStrings(fn,inppts);
    };
  

  void loadPts(String fn) 
    {
    println("loading: "+fn); 
    String [] ss = loadStrings(fn);
    String subpts;
    int s=0;   int comma, comma1, comma2;   float x, y, z;   int a, b, c;
    nv = int(ss[s++]); print("nv="+nv);
    for(int k=0; k<nv; k++) {
      int i=k+s; 
      comma=ss[i].indexOf(',');   
      x=float(ss[i].substring(0, comma));
      y=float(ss[i].substring(comma+1, ss[i].length()));
      z = 0;
      G[k].setTo(x,y, z);
      };
    pv=0;
    }; 
    
    
  void next() {pv=n(pv);}
  int n(int v) {return (v+1)%nv;}
  int p(int v) {if(v==0) return nv-1; else return v-1;}

  }  // end class pts