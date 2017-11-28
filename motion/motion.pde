
Boolean 
  animating=true, 
  PickedFocus=false, 
  center=true, 
  track=false, 
  showViewer=false, 
  showBalls=false, 
  showControl=false, 
  showCurve=false, 
  showPath=false, 
  showKeys=false, 
  showSkater=true, 
  scene1=false,
  solidBalls=false,
  showCorrectedKeys=true,
  showQuads=true,
  showVecs=true,
  showTube=false;
float 
  t=0, 
  s=0;
boolean addNewCurve = false;
pts newLoop;
int
  f=0, maxf=2*30, level=6, method=0;
String SDA = "angle";
float defectAngle=0;
pts P = new pts(); // polyloop in 3D
pts Q = new pts(); // second polyloop in 3D
pts R = new pts(); // inbetweening polyloop L(P,t,Q);
loops l1;
loopss ls;
vec Up = V(0, 0, 1); // up vector
Frame[] frames = new Frame[2];
Mesh mymesh;
void setup() {
  textureMode(NORMAL);          
  size(900, 900, P3D); // P3D means that we will do 3D graphics

  //P.declare(); Q.declare(); R.declare(); // P is a polyloop in 3D: declared in pts
  //P.loadPts("data/pts");  Q.loadPts("data/pts2"); // loads saved models from file (comment out if they do not exist yet)
   ls = new loopss();
   ls.addCurve();
   //l1 = new loops();
   l1 = ls.curves[0];
   P = l1.P;
   Q = l1.Q;
   R = l1.R;
  frames[0] = new Frame(P(0, 0, 0));
  frames[1] = new Frame(P(100, 100, 0));
  noSmooth();
  mymesh = read_mesh ("my.ply", mymesh);
  ls.m[0] = mymesh;
  ls.m[0].ratio = 0.01;
  //read_mesh ("torus.ply", mymesh2);
  
  newLoop = new pts();
   newLoop.declare();
   newLoop.loadPts("data/pts3");
     
  frameRate(30);
  }

void draw() {
  background(#03CEFF);
  displayHeader();
  
  directionalLight(126, 126, 126, 0, 0, -1);
  //frames[0].M = mymesh;
  hint(ENABLE_DEPTH_TEST); 
  pushMatrix();   // to ensure that we can restore the standard view before writing on the canvas
  setView();
  for (int v=0; v<l1.Q.nv-1; v++)frames[1].O = l1.Q.G[v];

  //drawArrows(frames[1].O, frames[1].I, frames[1].J, frames[1].K);
   
  ls.displayCurves();
    //fill(green);
   //newLoop.drawBalls(4);
 if(addNewCurve) {
   P = newLoop;  
   fill(green);
   P.drawClosedCurve(4);
 }
  //l1.displaySubdivision();
  doPick(); // sets Of and axes for 3D GUI (see pick Tab)
  P.SETppToIDofVertexWithClosestScreenProjectionTo(Mouse()); // for picking (does not set P.pv)
  P.showPicked();
  popMatrix(); // done with 3D drawing. Restore front view for writing text on canvas
  
  hint(DISABLE_DEPTH_TEST); // no z-buffer test to ensure that help text is visible
  
  if(keyPressed) {stroke(red); fill(white); ellipse(mouseX,mouseY,26,26); fill(red); text(key,mouseX-5,mouseY+4);}
  
  change=false; // to avoid capturing frames when nothing happens (change is set uppn action)
  //displayHeader();
  //displayFooter();
  
  }

  void drawArrows(pt O, vec I, vec J, vec K) {
    fill(#FF653E);
    arrow(O, V(100, I), 5);
    fill(#0383FF);
    arrow(O, V(100, J), 5);
    fill(#FFC800);
    arrow(O, V(100, K), 5);
  }