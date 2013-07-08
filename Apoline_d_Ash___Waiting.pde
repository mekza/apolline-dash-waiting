import ddf.minim.*;

Minim minim;
AudioPlayer track;
SoundSampler samp;
ArrayList buffL;
ArrayList buffR;
int buffMax = 90;
Boolean isPlaying = false;

void setup()
{
  size(250 , 600, OPENGL);
  minim = new Minim(this);
  track = minim.loadFile("track.mp3", 2048);
  samp = new SoundSampler();
  buffL = new ArrayList();
  buffR = new ArrayList();
  track.addListener(samp);
  track.play();
}

void draw() {
 background (0);
 
 if (samp.isInit()) {
   buffL.add(samp.getSampL());
   buffR.add(samp.getSampR());
   if (buffL.size() > buffMax) {
     buffL.remove(0);
   } 
   if (buffR.size() > buffMax) {
     buffR.remove(0);
   }
   drawWave(buffL,false);
   drawWave(buffR,true);
   rotateZ(30);
 }
}

void drawWave(ArrayList buff, Boolean invert) {
   float[] snd;
   
   pushMatrix();
   for (int i = buff.size() - 1 ; i >= 0; i --) {
     snd = (float[]) buff.get(i);  
     noFill();
     stroke(i * 1 + 55,50);
     beginShape();
     for ( int j = 0; j < snd.length; j++ ) {
       if (invert) {
         vertex(width - j, height - 50 + snd[j]*50);
       } else {
         vertex(j / 2, height - 50 + snd[j]*50);  
       }
     }
    endShape();
    translate(0, - (height - 40) / buffMax);
   }
   popMatrix();
  
}

void stop()
{
  track.close();
  minim.stop();
  super.stop();
}

class SoundSampler implements AudioListener
{
  private float[] left;
  private float[] right;
  public Boolean init = false;
  
 SoundSampler ()
  {
    left = null; 
    right = null;
  }
  
  synchronized void samples(float[] samp)
  {
    left = samp;
    init = true;
  }
  
  synchronized void samples(float[] sampL, float[] sampR)
  {
    left = sampL;
    right = sampR;
    init = true;
  }
  
 float[] getSampL() {
   return left;
 }
 float[] getSampR() {
  return right; 
 }
 
 Boolean isInit() {
  return init; 
 }
}


