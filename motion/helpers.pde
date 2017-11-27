int[] makeCorners(int[] temp){
  pt aNextVert, bPrevVert, aPrevVert, bNextVert;
  println(temp.length);
  int[] tempRet = new int[temp.length];
  for(int a=0; a<temp.length; a++){
    for(int b=0; b<temp.length; b++){
      aNextVert = myMesh.verticies.get(temp[nextCorner(a)]);
      bPrevVert = myMesh.verticies.get(temp[prevCorner(b)]);
      aPrevVert = myMesh.verticies.get(temp[prevCorner(a)]);
      bNextVert = myMesh.verticies.get(temp[nextCorner(b)]);
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
  for(int x=0; x<myMesh.geometry.length/3; x++){
    point1 = myMesh.verticies.get(myMesh.geometry[x*3]);
    point2 = myMesh.verticies.get(myMesh.geometry[x*3+1]);
    point3 = myMesh.verticies.get(myMesh.geometry[x*3+2]);
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
  for(int tryAgain=0; tryAgain<myMesh.verticies.size(); tryAgain++){
    runTwo = new ArrayList<pt>();
    for(int iterateThrough=0; iterateThrough<myMesh.geometry.length; iterateThrough++){
      if(myMesh.geometry[iterateThrough]==tryAgain){
        // triangle the pt is apart of
        int triGle = iterateThrough/3;
      runTwo.add(myMesh.faceNormals.get(triGle));
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
  //print("sizeOfCorners: " + myMesh.opposite.length);
  //println("curr corner:" + currCorner);
  int triangleCorner = currCorner/3;
  //println("next corner:" + (triangleCorner*3 + ((currCorner+1)%3)));
  return triangleCorner*3 + ((currCorner+1)%3);
}
int swing(int currCorner, Mesh myMesh){
  //println("swing: " +nextCorner(myMesh.opposite[nextCorner(currCorner)]));
  return nextCorner(myMesh.opposite[nextCorner(currCorner)]);
}
int prevCorner(int currCorner){
  int nextC = nextCorner(currCorner);
  return nextCorner(nextC);
}
int indexGeoTable(pt currVert){
  for(int i=0; i<myMesh.verticies.size(); i++){
    if(currVert.equalTo(myMesh.verticies.get(i))){
      return i;
    }
  }
  return -1;
}
int indexCornersTable(int currI){
  for(int unIter=0; unIter<myMesh.geometry.length; unIter++){
    if(myMesh.geometry[unIter]==currI){
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