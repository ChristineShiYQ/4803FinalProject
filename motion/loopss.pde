class loopss{
  int maxnc = 16000;                 //  max number of curvers
  loops[] curves = new loops [maxnc];           // geometry table (vertices)
  int pc =0, // picked curve index,
    iv=0, //  insertion curve index
    nv = 0; // number of curve currently used in P
 loopss(){
   
 }
 void addCurve() {
   curves[nv] = new loops();
   iv++;
   nv++;
 }
 void diplayCurves() {
   for(int i = 0 ; i < nv; i++) {
     curves[i].displaySubdivision();
 }
}