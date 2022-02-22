PImage img;
int curr = 0;
int jumpSpeed = 0;
int maxJumpSpeed = 30;

final int manHeight = 238;
final int windowHeight = 600;
final int windowWidth = 800;

final int BOTTOM = windowHeight - manHeight;
int y = BOTTOM;

int frameCounter = 0;
final int GRAVITY = -1;
final int JUMP = 30;

ArrayList<Obstacle> stuff = new ArrayList<Obstacle>();

import processing.sound.*;

SoundFile boom;
SoundFile boing;
ArrayList <SoundFile> ouch;
int lastOuch = 0;

class Obstacle {
  int x, y;
  int speedX;
  
  public Obstacle(int x, int y, int speedX){
    this.x = x;
    this.y = y;
    this.speedX = speedX;
  }
  
  public void draw(){}
  
  public void move(){
    this.x = this.x + this.speedX;
  }
  
  public float width(){
    return 0;
  }
  public float height(){
    return 0;
  }
}

class Dino extends Obstacle {
  PImage img;
   
  public Dino(){
    super(windowWidth, int(random(0, windowHeight - 235)), -7);
    img =  loadImage("dino.png");
    
  }
  
  public void draw(){
    println(this.x + " " + this.y);
    image(img, this.x , this.y);
    
    if (int(random(0,10)) == 1){
      //println("boom");
      boom.play();
    }
  }
  public float width(){
    return this.img.width;
  }
  public float height(){
    return this.img.height;
  }
}


void setup() {
  size(800, 600);
  frameRate(30);
  boom = new SoundFile(this, "sounds/boom.mp3");
  boing = new SoundFile(this, "sounds/boing.mp3");
  
  ouch = new ArrayList <SoundFile>();
  ouch.add(new SoundFile(this, "sounds/ouch1.mp3"));
  ouch.add(new SoundFile(this, "sounds/ouch2.mp3"));
  ouch.add(new SoundFile(this, "sounds/ouch3.mp3"));
}

void keyPressed() {
  // space bar is 32.
  // if I'm on the ground
  // and the spacebar is pressed...
  // then we jump!
  if (y >= BOTTOM && key == 32){
    jumpSpeed = JUMP;
    boing.play();
  }

}

void cleanUp(){
  //remove any obstacles from the list that are off screen
  for (int i = stuff.size() - 1; i>=0; i--){
    Obstacle thing = stuff.get(i);
    if (thing.x < 0 || thing.x > windowWidth || thing.y < 0 || thing.y > windowHeight)
      stuff.remove(i);
  }
}
void draw() {
  clear();
  background(255, 255, 255);
  
  if (y < BOTTOM || jumpSpeed > 0){
    // recalculate the jump
    y = y - jumpSpeed;
    jumpSpeed = jumpSpeed + GRAVITY;
  }
  
  frameCounter = (frameCounter + 1)%4;
  
  if (frameCounter == 0)
    curr = (curr + 1) % 3;
  
  img = loadImage(curr + ".png");
  image(img, 0 , y);
  
  // chose to add a random dinosaur
  if (int(random(0,100)) == 0){
    // add a dino
    println("New dino");
    stuff.add(new Dino());
  }
  for (Obstacle thing : stuff){
    thing.draw();
    thing.move();
  }
  
  // are they touching?
  lastOuch += 1;
  for (Obstacle thing : stuff){
    // check from the middle of the image.
    // is  1/2 the width of me, and 1/2 the width of
    // them less than the distance between the two points?
    // if yes for both x and y, they must be touching!
    float myX = img.width / 2;
    float theirX = thing.x + thing.width()/2;
    double distanceX = abs(myX - theirX);
    
    float myY = y + img.height / 2;
    float theirY = thing.y + thing.height()/2;
    double distanceY = abs(myY - theirY);
    
    double sumWidthX = img.width / 2 + thing.width()/2;
    double sumWidthY = img.height / 2 + thing.height()/2;
    if (distanceX <  sumWidthX &&
      distanceY < sumWidthY ){
      // bounce!
      SoundFile oucher = ouch.get(int(random(ouch.size()))); //<>//
      if (lastOuch > 10){
        oucher.play();
        lastOuch = 0;
      }
      jumpSpeed = min(jumpSpeed + JUMP, maxJumpSpeed);
    }
  }
  
  cleanUp();
}
