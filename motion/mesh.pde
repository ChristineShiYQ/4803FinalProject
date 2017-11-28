// Read polygon mesh from .ply file

Mesh read_mesh (String filename){
  int i;
  String[] words;
  
  String lines[] = loadStrings(filename);
  
  words = split (lines[0], " ");
  int num_vertices = int(words[1]);
  // println ("number of vertices = " + num_vertices);
  
  words = split (lines[1], " ");
  int num_faces = int(words[1]);
  // println ("number of faces = " + num_faces);
  
  Mesh myMesh = new Mesh(num_vertices,num_faces);
  
  // read in the vertices
  pt currVertex;
  for (i = 0; i < num_vertices; i++) {
    words = split (lines[i+2], " ");
    println(words[0]);
    println(float(words[0]));
    currVertex = new pt(40*float(words[0]),40*float(words[1]),40*float(words[2]));
    myMesh.verticies.add(currVertex);
  }
  
  // read in the faces
  for (i = 0; i < num_faces; i++) {
    
    int j = i + num_vertices + 2;
    words = split (lines[j], " ");
    
    int nverts = int(words[1]);
    if (nverts != 3) {
      println ("error: this face is not a triangle." + j);
      exit();
    }
    myMesh.geometry[i*3] = int(words[2]); 
    myMesh.geometry[i*3+1] = int(words[3]); 
    myMesh.geometry[i*3+2] = int(words[4]); 
  }
  
  
  // fill in OPPOSITES table
  myMesh.opposite = makeCorners(myMesh.geometry, myMesh);
  // make a face normal table which will be number of faces
  myMesh.faceNormals = faceNormals(myMesh);
  myMesh.vertexNormals = vertexNormalFill(myMesh);
  return myMesh;
}

public class Mesh{
  ArrayList<pt> verticies;
  ArrayList<pt> faceNormals;
  ArrayList<pt> vertexNormals;
  int[] opposite;
  int[] geometry;
  int[] randomNumbers;
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
  }
}