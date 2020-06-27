
class Sample {
  public float t;
  public float val;
  public Sample(float tt,float vval){
    t=tt;val=vval;
  }
}


class Sampler extends ArrayList<Sample>{
  int window=512,col=0xffffffff;
  
  public Sampler () {
    super(512);
    init(0.0);
    
  }
  
  public Sampler (int w,int c) {
    super(w);
    window=w;
    col=c;
    init(0.5);
  }
  
  synchronized public void init(float init){
    clear();
    for(int i=0;i<window;i++)
    add(new Sample(millis(),init));
  }
  
  synchronized public Sampler addSample(float t,float val){
    if(size()>window) removeRange(0,1);
    add(new Sample(t,val));
    return this;
  }
  
  synchronized void draw(){
  int cnt=0;
  for(Sample s:this){
    float ux=(s.t/10000)%1.0;
    float uy=(s.val+0.5);
    //-floar.get())*10+0.5;
    pushStyle();
    rectMode(CENTER);
    noStroke();
    fill(col|(int(cnt++/(window/255.0))<<24));
    rect(width*ux,height*uy/2,5,5);
    stroke(0x554444ff);
    line(0,height/4,width,height/4);
    popStyle();
    
  }
}


}


