

import ketai.camera.*;
import ketai.ui.KetaiVibrate;

import com.jsyn.util.*;

KetaiCamera cam;
KetaiVibrate vibe;


AutoCorrelator auto;

Sampler samplerR, samplerG,samplerB;

Floar floar=new Floar(10, 0.5);


float average(PImage pic) {
  float s=0;
  pic.loadPixels();
  for (int c : pic.pixels) {
    int r =(c>>16)&0xff;
    int g=(c>>8)&0xff;
   /* r-=g;
    r+=255;
    r/=2;*/
    s+=r;
  }
  return (s/(pic.pixels.length*255))-0.5;
}




int picwidth=320, picheight=240;

void setup() {
  fullScreen();
  orientation(PORTRAIT);
  //frameRate(30);
  imageMode(CENTER);
  textAlign(CENTER, CENTER);
  textSize(displayDensity * 25);
  cam = new KetaiCamera(this, 320, 240, 24);
  samplerG =new Sampler(123, 0x66ff66);
  samplerR=new Sampler(123, 0xff6666);
  samplerB=new Sampler(123, 0x6666ff);
  auto=new AutoCorrelator(90);
  cam.setCameraID(1);
  cam.manualSettings();
  cam.start();
  println(cam.dump());
  vibe=new KetaiVibrate(this);
}

float period=666, conf=777;
int pp=0;

Floar rate=new Floar(5,0.5);

void draw() {
  background(70);
  pushMatrix();

  if (cam != null && cam.isStarted()) { 
    fill(255);
    // rect(0,0,width/4,k1);
    float r=rate.get(3);
    float bpm= 60.0*( r/15);
    text(" "//+nf(frameRate,2,1)+" "
    +nf(bpm, 2, 1) ,width/2, height-3*k1);
    text(" "+nf (period, 2, 2)+" "+nf(conf, 0, 1)+" #"+pp, width/2, height-k1);
    //  cam.read();
    translate(width-picheight/2, picwidth/2);
    rotate(-PI/2);
    image(cam, 0, 0, picwidth, picheight);
  } else
  {
    background(2);
    text("Camera is currently off.", width/2, height/2);
  }
  popMatrix();
  samplerG.draw();
  samplerR.draw();
  samplerB.draw();
  drawUI();
}

void onCameraPreviewEvent()
{
  float t=millis();
  cam.read();
  float a=average(cam);
  floar.addSample(a);

  float sig=15.0*(floar.get(8)-floar.get(0));

  samplerR.addSample(t, a);
  samplerG.addSample(t, sig);
  
  if (auto.addSample(sig)) {
    pp++;
    float pperiod=(float)auto.getPeriod();
    float cconf=(float)auto.getConfidence();
    if(cconf>0.8) rate.addSample(pperiod,cconf*0.5);
    //vibe.vibrate(50);
    samplerB.addSample(t/10,rate.get(3)*4);
    if (cconf>0.8||cconf>conf){
      period=pperiod;
    }
    conf=cconf;
  };
}
