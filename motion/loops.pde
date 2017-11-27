class loops {
  public pts P,Q,R;
  public loops() { 
  P = new pts(); 
  Q = new pts();
  R = new pts(); 
  P.declare(); Q.declare(); R.declare(); // P is a polyloop in 3D: declared in pts
  P.loadPts("data/pts");  Q.loadPts("data/pts2"); // loads saved models from file (comment out if they do not exist yet)
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
    R.displaySubdivision();
  }
}