// Read polygon mesh from .ply file

Mesh read_mesh (String filename, Mesh myMesh){
  int i;
  String[] words;
  
  String lines[] = loadStrings(filename);
  
  words = split (lines[0], " ");
  int num_vertices = int(words[1]);
  // println ("number of vertices = " + num_vertices);
  
  words = split (lines[1], " ");
  int num_faces = int(words[1]);
  // println ("number of faces = " + num_faces);
  
  myMesh = new Mesh(num_vertices,num_faces);
  
  // read in the vertices
  pt currVertex;
  for (i = 0; i < num_vertices; i++) {
    words = split (lines[i+2], " ");
    //println(words[0]);
    //println(float(words[0]));
    currVertex = new pt(40*float(words[0]),40*float(words[1]),40*float(words[2]));
    myMesh.verticies.add(currVertex);
  }
  
  // read in the faces
  for (i = 0; i < num_faces; i++) {
    
    int j = i + num_vertices + 2;
    words = split (lines[j], " ");
    
    int nverts = int(words[0]);
    if (nverts != 3) {
      println ("error: this face is not a triangle." + j);
      exit();
    }
    myMesh.geometry[i*3] = int(words[1]); 
    myMesh.geometry[i*3+1] = int(words[2]); 
    myMesh.geometry[i*3+2] = int(words[3]); 
    
  }
  
  
  // fill in OPPOSITES table
  myMesh.opposite = myMesh.makeCorners(myMesh.geometry);
  // make a face normal table which will be number of faces
  myMesh.faceNormals = myMesh.faceNormals();
  myMesh.vertexNormals = myMesh.vertexNormalFill();
  return myMesh;
}

public class Mesh{
  ArrayList<pt> verticies;
  ArrayList<pt> faceNormals;
  ArrayList<pt> vertexNormals;
  int[] opposite;
  int[] geometry;
  int[] randomNumbers;
  float ratio;
  Mesh(int numVert, int numFace){
    geometry = new int[3*numFace];
    opposite = new int[3*numFace];
    verticies = new ArrayList<pt>();
    faceNormals = new ArrayList<pt>();
    vertexNormals = new ArrayList<pt>();
    randomNumbers = new int[500];
    for(int winWhenLose=0; winWhenLose<500; winWhenLose++){
      randomNumbers[winWhenLose] = (int)random(255);
    }
    ratio = 10;
  }
  
  int[] makeCorners(int[] temp){
  pt aNextVert, bPrevVert, aPrevVert, bNextVert;
  println(temp.length);
  int[] tempRet = new int[temp.length];
  for(int a=0; a<temp.length; a++){
    for(int b=0; b<temp.length; b++){
      aNextVert = this.verticies.get(temp[nextCorner(a)]);
      bPrevVert = this.verticies.get(temp[prevCorner(b)]);
      aPrevVert = this.verticies.get(temp[prevCorner(a)]);
      bNextVert = this.verticies.get(temp[nextCorner(b)]);
      if((aNextVert.equalTo(bPrevVert))&&(aPrevVert.equalTo(bNextVert))){
        tempRet[a] = b;
        tempRet[b] = a;
      }
    }
  }
  return tempRet;
}
ArrayList<pt> faceNormals(){
  pt point1, point2, point3,calcFaceNorm, tempVertNormal;
  ArrayList<pt> tempFaceRet = new ArrayList<pt>();
  for(int x=0; x<this.geometry.length/3; x++){
    point1 = this.verticies.get(this.geometry[x*3]);
    point2 = this.verticies.get(this.geometry[x*3+1]);
    point3 = this.verticies.get(this.geometry[x*3+2]);
    calcFaceNorm = triangleNormal(point1,point2,point3);
    tempFaceRet.add(calcFaceNorm);
    //print("facetable");
  }
  return tempFaceRet;
}
ArrayList<pt> vertexNormalFill(){
  ArrayList<pt> tempVertRet = new ArrayList<pt>();
  ArrayList<pt> runTwo;
  pt testAdd;
  for(int tryAgain=0; tryAgain<this.verticies.size(); tryAgain++){
    runTwo = new ArrayList<pt>();
    for(int iterateThrough=0; iterateThrough<this.geometry.length; iterateThrough++){
      if(this.geometry[iterateThrough]==tryAgain){
        // triangle the pt is apart of
        int triGle = iterateThrough/3;
      runTwo.add(this.faceNormals.get(triGle));
      }
    }
    testAdd = runTwo.get(0);
    for(int raand=1; raand<runTwo.size(); raand++){
      testAdd = testAdd.adding(runTwo.get(raand));
    }
    tempVertRet.add(testAdd.normalizeVert());
  }
  return tempVertRet;
}
int nextCorner(int currCorner){
  //print("sizeOfCorners: " + this.opposite.length);
  //println("curr corner:" + currCorner);
  int triangleCorner = currCorner/3;
  //println("next corner:" + (triangleCorner*3 + ((currCorner+1)%3)));
  return triangleCorner*3 + ((currCorner+1)%3);
}
int swing(int currCorner){
  //println("swing: " +nextCorner(this.opposite[nextCorner(currCorner)]));
  return nextCorner(this.opposite[nextCorner(currCorner)]);
}
int prevCorner(int currCorner){
  int nextC = nextCorner(currCorner);
  return nextCorner(nextC);
}
int indexGeoTable(pt currVert){
  for(int i=0; i<this.verticies.size(); i++){
    if(currVert.equalTo(this.verticies.get(i))){
      return i;
    }
  }
  return -1;
}
int indexCornersTable(int currI){
  for(int unIter=0; unIter<this.geometry.length; unIter++){
    if(this.geometry[unIter]==currI){
      return unIter;
    }
  }
  return -1;
}
pt centroidTriangle(pt v1, pt v2, pt v3){
  float xMean = (v1.x+v2.x+v3.x)/3;
  float yMean = (v1.y+v2.y+v3.y)/3;
  float zMean = (v1.z+v2.z+v3.z)/3;
  pt centroid = new pt(xMean, yMean, zMean);
  return centroid;
}
pt triangleNormal(pt v1, pt v2, pt v3){
  pt U = v2.subtract(v1);
  pt V = v3.subtract(v1);
  return U.crossProd(V).normalizeVert();
}
}