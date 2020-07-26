

import ketai.camera.*;
import ketai.ui.KetaiVibrate;

import com.jsyn.util.*;
import processing.sound.AudioSample;

import java.io.*;

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

FileWriter slog;

float[] buf;
AudioSample sm;

int picwidth=320, picheight=240;

void setup() {
  fullScreen();
  orientation(PORTRAIT);
  try {slog=new FileWriter("/storage/emulated/0/APulse/sound.txt",true);
  } catch (Exception anal){};
  //frameRate(30);
 // buf=samples();
 // sm=new AudioSample(this,buf,6000);
  //sm.loop();
  imageMode(CENTER);
  textAlign(CENTER, CENTER);
  textSize(displayDensity * 25);
  cam = new KetaiCamera(this, 320, 240, 24);
  samplerG =new Sampler(123, 0x66ff66);
  samplerR=new Sampler(123, 0xff6666);
  samplerB=new Sampler(123, 0x6666ff);
  auto=new AutoCorrelator(100);
  cam.setCameraID(1);
  cam.manualSettings();
  cam.start();
  println(cam.dump());
  vibe=new KetaiVibrate(this);
}

float period=666, conf=777;
int pp=0;

Floar rate=new Floar(5,0.5);
float bpm=0;

void draw() {
  background(color(8,11,160));
  pushMatrix();
  
  if (cam != null && cam.isStarted()) { 
    fill(255);
    if(cam.isFlashEnabled())
     rect(0,0,width/4,k1);
    
    if(bpm==0){
      text("Put a finger on the\n front camera to \ndetect your heart rate",
        width/2,height/4);
    }//else
    {
      
    
    text(" "//+nf(frameRate,2,1)+" "
    +int(bpm)+" bpm" ,width/2, height-3*k1);
    text(" f/p:"+nf (period, 2, 2)+" conf:"+int(conf*100)+"% #"+pp, width/2, height-k1);
    //  cam.read();
    }
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
  if(slog!=null) try{slog.write(""+sig);
  slog.write("\n");
  } catch (Exception anal){};
  if (auto.addSample(sig)) {
    pp++;
    float pperiod=(float)auto.getPeriod();
    float cconf=(float)auto.getConfidence();
    if(cconf>0.8) rate.addSample(pperiod,cconf*0.5);
    //vibe.vibrate(50);
    
    if (cconf>0.8||cconf>conf){
      period=pperiod;
    }
    conf=cconf;
  };
  float r=rate.get(3);
  bpm= 60.0*( r/15);
  samplerB.addSample(t,bpm);
}


//port jsyn.util.AudioSample;

BufferedReader olog;
WaveFileWriter recorder;


float [] samples(){
  String line;
  FloatList fl=new FloatList(10000);
  
 
  
  olog=createReader( "/storage/emulated/0/APulse/sound.txt");
  while(true){
    
  
try { line = olog.readLine(); }
 catch (IOException e) 
 { e.printStackTrace(); line = null; }
  if (line == null) {
     // Stop reading because of an error or file is empty 
     break;} 
   else { 
     fl.append(float(line)*1);
   //  String[] pieces = split(line, TAB); 
    // int x = int(pieces[0]); int y = int(pieces[1]); point(x, y);
  }
  }
  println("Samples: "+fl.size());
  try{
  WaveFileWriter writer = new WaveFileWriter(
   new File( "/storage/emulated/0/APulse/sound.wav"));
  writer.setFrameRate(22050);
  writer.setBitsPerSample(24); 
  writer.write(fl.array()); 
  writer.close(); 
  } catch (Exception me){};
  return fl.array();
}



