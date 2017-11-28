class loopss{
  int maxnc = 16000;                 //  max number of curvers
  loops[] curves = new loops [maxnc];    // geometry table (vertices)
    pt[] balls = new pt[maxnc];
    Mesh[] m = new Mesh[maxnc];
  int pc =0, // picked curve index,
    iv=0, //  insertion curve index
    n = 0; // number of curve currently used in P
 loopss(){
   
 }
 void addCurve() {
   curves[n] = new loops();
   iv++;
   n++;
 }
 void addCurve2() {
   pts tmp = new pts();
   tmp.declare();
   tmp.loadPts("data/pts3");
   curves[n] = new loops(tmp);
   iv++;
   n++;
 }
 void addCurve(loops cv) {
   curves[n] = cv;
   iv++;
   n++;
   print(n);
 }
 void displayCurves() {
   for(int i = 0 ; i < n; i++) {
     if(i == ls.pc)curves[i].createLoop();
      balls[i] = curves[i].displaySubdivision(m[i]);
      println("\n" + m[i].ratio);
    if(i == ls.pc && showControl && selectingCurve) {
     fill(red);
     curves[i].P.drawClosedCurve(3);
   }
   }
   collisionDetection();
 }
 int coN = 0;
 void collisionDetection() {
   for(int i = 0 ; i < n; i++) {
     for(int j = 1; j < n; j++) {
       if(i==j) continue;
       pt a = balls[i], b = balls[j];
       if(d(a,b) < 10) {
         //curves[i].clockwise = !curves[i].clockwise;
         //curves[j].clockwise = !curves[j].clockwise;
         curves[i].clockwise = false;
         curves[j].clockwise = false;
         //print("COLLIDE!!!!!! "+coN+"\n");
         coN++;
         break;
       }
     }
   }
 }

  void updateCurrent() {
   l1 = ls.curves[pc];
   P = l1.P;
   Q = l1.Q;
   R = l1.R;
 }
 void updateCurrent(int i) {
   l1 = ls.curves[i];
   P = l1.P;
   Q = l1.Q;
   R = l1.R;
 }
}