

void mousePressed()
{
  if(mouseY<k4||mouseY>k5) return;
  //Toggle Camera on/off
  if (mouseX < width/3 )
  {
    if (cam.isStarted())
    {
      cam.stop();
    } else
      cam.start();
  }

  if (mouseX < 2*width/3 && mouseX > width/3)
  {
    if (cam.getNumberOfCameras() > 1)
    {
      cam.setCameraID((cam.getCameraID() + 1 ) % cam.getNumberOfCameras());
      cam.manualSettings();
  //cam.start();
  //println(cam.dump());
    }
  }

  //Toggle Camera Flash
  if (mouseX > 2*width/3 )
  {
    if (cam.isFlashEnabled())
      cam.disableFlash();
    else
      cam.enableFlash();
  }
}

int k4=400;
int k1=100;
int k5=k1+k4;

void drawUI()
{
  k4=height/2;
  k5=k4+k1;
  pushStyle();
  textAlign(LEFT);
  fill(0);
  stroke(255);
  rect(0, k4, width/3, k1);
  rect(width/3, k4, width/3, k1);

  rect((width/3)*2, k4, width/3, k1);

  fill(255);
  if (cam.isStarted())
    text("Off", 5, k4+80); 
  else
    text("On", 5, k4+80); 

  if (cam.getNumberOfCameras() > 0)
  {
    text("Camera", width/3 + 5, k4+80);
  }

  if (cam.isFlashEnabled())
    text("Flash", width/3*2 + 5, k4+80); 
  else
    text("Flash", width/3*2 + 5, k4+80); 


  popStyle();
}


