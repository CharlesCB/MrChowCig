import toxi.geom.*;
import plethora.core.*;
import peasy.*;

PeasyCam cam;

PImage[] cig = new PImage[99];
int skip = 10;
int sec = 1;
boolean record = false;
float alpha = 0;
float cubeAlpha = 0;
int unTour = 2120;
float speed = -0.002;

ArrayList manyBoids;
int pop = 1100;
int count = 0;

void setup() {
  pixelDensity(displayDensity());
  frameRate(24);
  background(0);
  size(960, 540, P3D);

  for (int i = 0; i < cig.length; i++) {
    int j = i + 1;
    cig[i] = loadImage("cig"+j+".jpg");
  }
  cam = new PeasyCam(this, 500);

  manyBoids = new ArrayList();

  for (int i = 0; i < pop; i++) {
    Vec3D origin = new Vec3D(random(-400, 400), random(-300, 300), 0);
    Ple_Agent boid = new Ple_Agent(this, origin);
    manyBoids.add(boid);
  }
}

void draw() {

  if (frameCount > cig.length * skip) {
    if (cubeAlpha < 50) {
      cubeAlpha += 1;
    }
    noFill();
    stroke(255, cubeAlpha);
    strokeWeight(1);
    box(600);
    cam.rotateX(speed);
    cam.rotateZ(speed);
    if (frameCount > cig.length * skip + unTour) {
      if (frameCount % 10 == 0) {
        speed += 0.0001;
      } else if (speed > 0) {
        speed = 0;
      }
    }
  }
  if (alpha < 49) {
    alpha += 0.2;
  }

  for (int i = 0; i < manyBoids.size(); i++) {
    Ple_Agent boid = (Ple_Agent) manyBoids.get(i);
    float x = boid.getLocation().x + width/2;
    float y = boid.getLocation().y + height/2;
    color c = 0;

    if (frameCount % skip == 0) {
      sec = frameCount / skip;
    }
    if (sec<cig.length) {
      c = cig[sec].get(int(x), int(y));
    }
    if (frameCount == cig.length*skip) {
      alpha = 5;
    } 
    stroke(c, alpha);
    strokeWeight(2);
    boid.drawLinesInRange(manyBoids, 5, 20);
    boid.displayPoint();

    Vec3D target = new Vec3D (0, 0, 0);
    boid.seek(target, 0.7);
    boid.flock(manyBoids, 80, 50, 30, 0, 0.2, 2);

    boid.update();
    boid.bounceSpace(600, 300, 300);
  } 
  //println(frameRate);
  if (frameCount%24 == 0) {
    println("temps écoulé : " + frameCount/24 + " secondes");
  }
  if (record == true) {
    saveFrame("frames/####.png");
  }
}
