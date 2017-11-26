class Frame {
  public pt O;
  public vec I, J, K;
  public vec i, j, k;
  public Frame() { O = P(0,0,0); I = V(1,0,0); J = V(0,1,0); K = V(0,0,1); i = V(-1,1,0); j = V(1,1,0); k = V(0,0,1);}
  public Frame(pt P, vec u, vec v, vec w, vec U, vec V, vec W) { O = P; I = u; J = v; K = w; i = U; j = V; k = W;}

  float s=1;
  public Frame translateGlobal(float x, float y, float z) {O.x += x; O.y += y; O.z += z; return this;}
  public Frame translateRotate(float angle1, float angle2, float angle3) {      
      updateRef(angle1, i, j, k);
      updateRef(angle2, j, i ,k);
      updateRef(angle3, k, i, j);
      return this;
    }
  private void updateRef(float angle, vec axis, vec M, vec N) {
     I = R(I, angle, U(M), U(N));
     J = R(J, angle, U(M), U(N));
     K = R(K, angle, U(M), U(N));
  }

}