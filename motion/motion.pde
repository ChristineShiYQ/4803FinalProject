
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

int
  f=0, maxf=2*30, level=6, method=0;
String SDA = "angle";
float defectAngle=0;
pts P = new pts(); // polyloop in 3D
pts Q = new pts(); // second polyloop in 3D
pts R = new pts(); // inbetweening polyloop L(P,t,Q);
vec Up = V(0, 0, 1); // up vector
Frame[] frames = new Frame[2];
Mesh myMesh;
void setup() {
  textureMode(NORMAL);          
  size(900, 900, P3D); // P3D means that we will do 3D graphics
  P.declare(); Q.declare(); R.declare(); // P is a polyloop in 3D: declared in pts
  P.loadPts("data/pts");  Q.loadPts("data/pts2"); // loads saved models from file (comment out if they do not exist yet)
  frames[0] = new Frame(P(0, 0, 0));
  frames[1] = new Frame(P(100, 100, 0));
  noSmooth();
  read_mesh ("my.ply");
  //read_mesh ("torus.ply", mymesh2);
  frameRate(30);
  }

void draw() {
  background(255);
  hint(ENABLE_DEPTH_TEST); 
  setView();
  //frames[0].M = mymesh;
  pushMatrix();   // to ensure that we can restore the standard view before writing on the canvas
  for (int v=0; v<Q.nv-1; v++)frames[1].O = Q.G[v];
  drawArrows(frames[1].O, frames[1].I, frames[1].J, frames[1].K);
  R.copyFrom(P); 
  for(int i=0; i<level; i++) 
    {
    Q.copyFrom(R); 
    Q.subdivideQuintic(R);
    }
      change = true;
      showSkater = false;
      R.displaySubdivision();
      showKeys = false;
      showCurve = false;
  popMatrix(); // done with 3D drawing. Restore front view for writing text on canvas
  hint(DISABLE_DEPTH_TEST); // no z-buffer test to ensure that help text is visible

  if(keyPressed) {stroke(red); fill(white); ellipse(mouseX,mouseY,26,26); fill(red); text(key,mouseX-5,mouseY+4);}
  
  change=false; // to avoid capturing frames when nothing happens (change is set uppn action)
  }

  void drawArrows(pt O, vec I, vec J, vec K) {
    fill(#FF653E);
    arrow(O, V(100, I), 5);
    fill(#0383FF);
    arrow(O, V(100, J), 5);
    fill(#FFC800);
    arrow(O, V(100, K), 5);
  }