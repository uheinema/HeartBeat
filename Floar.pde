
class Floar {
  int depth;
  float factor;
  float roar[];
  
  Floar(int depth){
    this(depth,0.1);
  }
  
  Floar(int depth, float factor) {
    this.depth=depth;
    this.factor=factor;
    roar=new float[depth];
    for (int i=0; i<depth; i++)
      roar[i]=0.0;
  }

  void addSample(float a) {
    roar[0]=a;
    for (int i=1; i<depth; i++) {
      roar[i]=roar[i]*factor+roar[i-1]*(1-factor);
    }
  }
  
  void addSample(float a,float conf) {
    factor=conf;
    addSample(a);
  }
  
  float get() {
    return roar[depth-1];
  }
  float get(int i) {
    return roar[i];
  }
}


