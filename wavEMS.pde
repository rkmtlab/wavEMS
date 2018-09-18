/*
2018/9/7
Michinari Kono
U-Tokyo

wavEMS
audio output ver. for EMS

based on the Minim example

sin waves, saw waves, square waves, russian current

*/

import ddf.minim.*;
import ddf.minim.ugens.*;
import javax.sound.sampled.*;


//change the polar feat.
final int MONO = 0;
final int BI = 1;

//wave form
final int SINW = 0;
final int SAWW = 1;
final int SQUAREW = 2;
final int RUSSIAN = 3; 

//number of mode variations
final int NMODE = 4;

//freq variations
float freqs[] = {20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, 240, 260, 280, 300, 320, 340, 360, 400};
float pulseWidths[] = {40, 60, 80, 100, 120, 140, 160, 180, 200, 220, 240, 260, 280, 300, 320, 340, 360, 400, 440, 480, 520, 560, 600};

//create waves
Minim minim;
AudioSample wave_square1, wave_square2, wave_saw1, wave_saw2, wave_sin1, wave_sin2, wave_russian1, wave_russian2;
AudioSample wave;

AudioSample waves1[] = new AudioSample[NMODE];
AudioSample waves2[] = new AudioSample[NMODE];


//initialize
int pole = MONO; // pole
int mode = SQUAREW; // mode of wave from
float waveFrequency  = 160; // default freq.
int freqsi = 7; //8th parameter in freqs array
int sec = 1; //output second
float pulseWidth = 120; //default pulse
int pulsesi = 4; //5th parameter

float pulseWidthMapped;

float waveSampleRate = 44100f;

//1000000/44100=22.675

//set the gains, tends to be sq > sin > saw so it requires adjustement
float gainSin = 2;
float gainSaw = 6;
float gainSq = -2;


AudioFormat format = new AudioFormat( waveSampleRate, // sample rate
    16, // sample size in bits
    1, // channels
    true, // signed
    true   // bigEndian
   );



void setup()
{
  
  size(1000, 300);

  textSize(18);

  minim = new Minim(this);
  
    
}



//draw the interface
void draw() {
  background(0);
  stroke(255);

  if (wave != null) {
    //text("VOL:" + wave.getVolume(), 0, 0);
    // use the mix buffer to draw the waveforms.
    for (int i = 0; i < wave.bufferSize() - 1; i++) {
      line(i, 80 - wave.left.get(i)*50, i+1, 80 - wave.left.get(i+1)*50);
    }
  }

  int posx = 60;

  text("SIN", posx, 180);
  text("SAW", posx, 180 + 30);
  text("SQUARE", posx, 180 + 60);
  text("RUSSIAN", posx, 180 + 90);

  text("" + waveFrequency + " Hz (+/-)", posx + 130, 180);
  text("" + pulseWidth + " PulseWidth (w/e)", posx + 130, 210);

  if(pole == MONO)text("Mono  Pole (Mono/Bi)", posx + 130, 240);
  else if(pole == BI)text("Bi  Pole (p)", posx + 130, 240);
  
  
  text("LEFT/RIGHT:trigger  UP/DOWN:wave type", posx + 130, 180+90);

  noFill();
  rect(posx - 10, 164 + mode * 30, 100, 25);
  
 
  pulseWidthMapped = map(pulseWidth, 0, 1000000, 0, 44100);
 
}



void keyPressed() {
  println("key=" + key + " keyCode:" + keyCode);

  if (keyCode == LEFT) {
    trigger();
    wave = waves1[mode];
    
    if(mode == SINW){
      wave.setGain(gainSin);
    }
    else if(mode == SAWW){
      wave.setGain(gainSaw);
    }
    else if(mode == SQUAREW){
      wave.setGain(gainSq);
    }    
    else if(mode == RUSSIAN){
      wave.setGain(gainSin);
    }
    
    println(wave.getGain());
    
    wave.trigger();

  } else if (keyCode == RIGHT) {
    trigger();
    wave = waves2[mode];
    
    if(mode == SINW){
      wave.setGain(gainSin);
    }
    else if(mode == SAWW){
      wave.setGain(gainSaw);
    }
    else if(mode == SQUAREW){
      wave.setGain(gainSq);
    }
    else if(mode == RUSSIAN){
      wave.setGain(gainSin);
    }
    
    println(wave.getGain());
    
    wave.trigger();
  } else if (keyCode == UP) {
    mode = (mode - 1 + NMODE) % NMODE;
  } else if (keyCode == DOWN) {
    mode = (mode + 1) % NMODE;
  } else if (keyCode == 61) { //+
    freqsi = (freqsi + 1) % freqs.length;
    waveFrequency = freqs[freqsi];
  } else if (keyCode == 45) { //-
    freqsi = (freqsi - 1 + freqs.length) % freqs.length;
    waveFrequency = freqs[freqsi];
  } else if (key == ' ') { // reset
    freqsi = 7;
    waveFrequency = freqs[freqsi];
    mode = SQUAREW;
    pole = MONO;
  } else if (keyCode == 80) { //p
    if(pole == MONO)pole = BI;
    else if(pole == BI)pole = MONO;
  } else if (keyCode == 69) { //e
    pulsesi = (pulsesi + 1) % pulseWidths.length;
    pulseWidth = pulseWidths[pulsesi];
  } else if (keyCode == 87) { //w
    pulsesi = (pulsesi - 1 + pulseWidths.length) % pulseWidths.length;
    pulseWidth = pulseWidths[pulsesi];
  }
  
}


void trigger(){
  float[] samples1 = new float[(int)waveSampleRate*sec];
  float[] samples2 = new float[(int)waveSampleRate*sec];

  float dur = waveSampleRate / waveFrequency; //cycle

  if(mode == SINW){
    sinwaves(dur, samples1, samples2, pole);
    //wave.setGain(gainSin);
  }
  else if(mode == SAWW){
    sawwaves(dur, samples1, samples2, pole);
    //wave.setGain(gainSaw);
  }
  else if(mode == SQUAREW){
    squarewaves(dur, samples1, samples2, pole);
    //wave.setGain(gainSq);
  }
  else if(mode == RUSSIAN){
    russian(dur, samples1, samples2, pole);
    //wave.setGain(gainSq);
  }
}


void sinwaves(float dur, float[] samples1, float[] samples2, int pole){
   
  for(int j = 0; j < samples1.length/dur; j++){
    
    for(int i = 0; i < (int)pulseWidthMapped; i++){ 
      samples1[i+(int)dur*j] = (float)Math.sin(i/pulseWidthMapped * 1 * Math.PI);
    }
    if(pole == BI){
      for(int i = (int)pulseWidthMapped; i < pulseWidthMapped*2; i++){ 
        samples1[i+(int)dur*j] = (float)Math.sin(i/pulseWidthMapped * 1 * Math.PI);
      }
    }
      
    for(int ii = 0; ii < (dur - (pulseWidthMapped*(pole+1)) ); ii++){
      samples1[(int)pulseWidthMapped*(pole+1) + ii +(int)dur*j] = 0;
    }
  }  
    
  //reverse the signals to sample2
  for(int k = 0; k < samples1.length; k++)samples2[k] = -samples1[k];
  
  // finally, create the AudioSample
  wave_sin1 = minim.createSample( samples1, format);
  wave_sin2 = minim.createSample( samples2, format);

  waves1[0] = wave_sin1;
  waves2[0] = wave_sin2;
  
}



void sawwaves(float dur, float[] samples1, float[] samples2, int pole){

  for(int j = 0; j < samples1.length/dur; j++){
    
    for(int i = 0; i < ((int)pulseWidthMapped); i++){ 
      samples1[i+(int)dur*j] = i/(pulseWidthMapped-1);
    }
    if(pole == BI){
      for(int i = (int)pulseWidthMapped; i < ((pulseWidthMapped*2) + 1); i++){ 
        samples1[i+(int)dur*j] = -(i-pulseWidthMapped)/(pulseWidthMapped);    
      }
    }
      
    for(int ii = 0; ii < (dur - (pulseWidthMapped*(pole+1)) ); ii++){
      samples1[(int)pulseWidthMapped*(pole+1) + ii +(int)dur*j] = 0;
    }
  }  
    
  //reverse the signals to sample2
  for(int k = 0; k < samples1.length; k++)samples2[k] = -samples1[k];
  
  // finally, create the AudioSample
  wave_saw1 = minim.createSample( samples1, format);
  wave_saw2 = minim.createSample( samples2, format);

  waves1[1] = wave_saw1;
  waves2[1] = wave_saw2;
}


void squarewaves(float dur, float[] samples1, float[] samples2, int pole){

  //whole dur in one pulse and rest: dur
    
  for(int j = 0; j < samples1.length/dur; j++){
    
    for(int i = 0; i < (int)pulseWidthMapped; i++){ 
      samples1[i+(int)dur*j] = 1;
    }
    if(pole == BI){
      for(int i = (int)pulseWidthMapped; i < pulseWidthMapped*2; i++){ 
        samples1[i+(int)dur*j] = -1;
      }
    }
      
    for(int ii = 0; ii < (dur - (pulseWidthMapped*(pole+1)) ); ii++){
      samples1[(int)pulseWidthMapped*(pole+1) + ii +(int)dur*j] = 0;
    }
  }

  //reverse the signals to sample2
  for(int k = 0; k < samples1.length; k++)samples2[k] = -samples1[k];

  // finally, create the AudioSample
  wave_square1 = minim.createSample( samples1, format);
  wave_square2 = minim.createSample( samples2, format);

  waves1[2] = wave_square1;
  waves2[2] = wave_square2;

}


void russian(float dur, float[] samples1, float[] samples2, int pole){
   
  //pulseWidth = 400/2
  //frequency = 2.5 khz
  //10ms ON and 10ms OFF
  
  //waveFrequency = 2500;
  //float cycle = waveSampleRate/2500;
  
  pulseWidth = 200;
  pulseWidthMapped = map(pulseWidth, 0, 1000000, 0, 44100);

  
  for(int j = 0; j < samples1.length/882; j++){
    
    for (int a = 0; a < 25; a ++){  
      for(int i = 0; i < (int)pulseWidthMapped; i++){ 
        samples1[i+ j*882 +(int)pulseWidthMapped*2*a] = (float)Math.sin(i/pulseWidthMapped * 1 * Math.PI);
      }
      for(int i = (int)pulseWidthMapped; i < pulseWidthMapped*2; i++){ 
        samples1[i+ j*882 +(int)pulseWidthMapped*2*a] = (float)Math.sin(i/pulseWidthMapped * 1 * Math.PI);
      }
    }
    
    for (int b = 0; b < (int)waveSampleRate/100; b ++){
        /////
        samples1[(int)pulseWidthMapped*2*25 + b + j*882] = 0;
    }
      
  }  
    
  //reverse the signals to sample2
  for(int k = 0; k < samples1.length; k++)samples2[k] = -samples1[k];
  
  // finally, create the AudioSample
  wave_russian1 = minim.createSample( samples1, format);
  wave_russian2 = minim.createSample( samples2, format);

  waves1[3] = wave_russian1;
  waves2[3] = wave_russian2;
  
}
