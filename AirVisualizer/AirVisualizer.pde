// Lukas Burger
// modification of https://www.openprocessing.org/sketch/738093

import hypermedia.net.*;


int PORT = 57222;
String IP = "192.168.1.2";
UDP udp;

float sensorValue = 0;

int NUM=16;
int F;

ArrayList joints=new ArrayList();

// joint class
class Joint {
  float[] p;
  float dep;

  Joint() {
    dep=0;
    p=new float[NUM];
    for (int i=0; i<NUM; i++) {
      float rad=TWO_PI/NUM*i;
      p[i]=noise((1-cos(rad))*0.5, (1-sin(rad))*0.5, F*0.001);
    }
  }

  // draw joint infinite loop
  boolean update() {
    strokeWeight(dep*0.1);
    beginShape();
    for (int i=0; i<NUM+2; i++) {
      float r=p[i%NUM];
      float rad=TWO_PI/NUM*i;
      float t=pow(dep, 1.4)*r;
      float x=cos(rad)*t;
      float y=sin(rad)*t;
      curveVertex(x, y);
    }
    
    endShape(CLOSE);
    dep++;
    if (dep>height/3) {
      return false;
    }
    return true;
  }
}

void setup() {
  // set up wifi udp reading
  udp = new UDP(this, PORT, IP);
  udp.listen(true);
  
  fullScreen();
  colorMode(HSB);
  //size(500,500);
  noFill();
}

void draw() {
  background(0);
  translate(width/2, height/2);
  
  // change the color of the zoom based off sensor values
  stroke(map(sensorValue, 60, 4095, 0, 255), 255, 255);


  // update the joints
  F=frameCount;
  if (F%20==0) {
    joints.add(new Joint());
  }
  for (int i=0; i<joints.size(); i++) {
    Joint j = (Joint)joints.get(i);
    if (j.update()==false) {
      joints.remove(i);
    }
  }
}

// read new values from udp
void receive(byte[] data, String PORT, int IP) {
   String value = new String(data);
   println(float(value));
   sensorValue = float(value);
   //println(value);
}
