int NUMBER_OF_STARS = 100;
int WIDTH = 640;
int HEIGHT = 360;
int MAX_SIZE = 10;
float MOVE_AM0UNT = 10;

abstract class Thing{
  protected float x, y;
  public Thing(float x, float y){
    this.x = x;
    this.y = y;
  }
  public float getX(){ return x;}
  public float getY(){ return y;}
  abstract public void draw();
  
  public boolean isTimedout(){
    // should we get rid of this element?
    return false; 
  }
}

class Laser extends Thing{
  protected int timeout;
  final int HOW_LONG = 100; //ms
  final float LASER_WIDTH = 3;
  public Laser (float x, float y){
    // y is the middle height of the ship
    super(x, y);
    timeout = millis() + HOW_LONG;
  }
  
  void draw(){
    stroke(255, 0, 0);
    // width of the screen long.
    rect(x, y - LASER_WIDTH, WIDTH, LASER_WIDTH ); //<>//
  }
  
  public boolean isTimedout(){
    return timeout - millis() < 0;
  }

}

class Ship extends Thing{
  PImage img;
  protected int w, h;

  public Ship(String path, int w, int h){
    super(85, HEIGHT/2);
    img =  loadImage(path);
    this.w = w;
    this.h = h;
    // was 678×652
    img.resize(w, h);
  }
  private Ship(PImage img, float x, float y){
    super(x,y);
    this.img =  img;
  }
  public Ship clone(){
    Ship that = new Ship(this.img, this.x, this.y);
    return that;
  }
  public void draw(){
    image(img, this.x , this.y);
  }
  
  public int getW(){
    return w;
  }
  public int getH(){
    return h;
  }
  
 
  public void up(){
    this.y = this.y - MOVE_AM0UNT;
    if (this.y < 0){
      this.y = 0;
    }
    
  }
  public void down(){
    this.y = this.y + MOVE_AM0UNT;
    if (this.y > HEIGHT - img.height){
      this.y = HEIGHT - img.height;
    }
  }
  
  public void left(){
    // no check for off screen
    this.x = this.x - MOVE_AM0UNT;
  }
  
  public void setToLeft(){
    // random spot on the left
    this.x = WIDTH;
    this.y = random(0, HEIGHT);
  }
}

class Star extends Thing{
  protected float size;
  public Star(float x, float y, float size){
    super(x, y);
    this.size = size;
  }
  
  public void draw(){
    circle(this.x, this.y, this.size);
  }
  public void move(){
    this.x = (this.x - this.size);
    if (this.x < 0){
      this.x = this.x + WIDTH;
    }
  }
   
}

Ship[] createEnemies(){
  Ship[] enemies = {
      new Ship("ship.jpg", 360/8, 360/8),
      new Ship("dino.png", 238/2, 235/2),
      new Ship("Alien1.jpg", 238/2, 235/2),
      new Ship("Alien2.jpg", 238/2, 235/2),
      new Ship("Alien3.jpg", 238/2, 235/2),
      new Ship("Alien4.jpg", 238/2, 235/2),
      new Ship("Alien5.jpg", 238/2, 235/2),
      new Ship("Alien6.png", 238/2, 235/2),
      new Ship("Alien7.png", 238/2, 235/2)
  };
  return enemies;
}

Star[] createStars(){
  Star [] stars = new Star[NUMBER_OF_STARS];
  
  for(int i = 0; i < NUMBER_OF_STARS; i++){
    stars[i] = new Star(random(WIDTH), random(HEIGHT), random(MAX_SIZE));
  }
  return stars; 
}

Star [] stars;
Ship ship;
Ship[] enemies;
ArrayList<Ship> enemiesOnScreen;
ArrayList<Thing> bullets;
void setup() {
  size(640, 360);
  stars = createStars();
  ship = new Ship("ship.jpg", 360/8, 360/8);
  enemies = createEnemies();
  enemiesOnScreen = new ArrayList<Ship>(); 
  bullets =  new ArrayList<Thing>();
}

void keyPressed() {
  // space bar is 32.
  // if I'm on th            e  ground
  // and the spacebar is pressed...
  // then we jump!
  if(key == 'w'){
    // move up
    ship.up();
  }
  if (key == 's'){
    // move down
    ship.down();
  }
  if (key == ' '){
    // shoot the laser!
    bullets.add(new Laser(ship.getX() + ship.getW(), ship.getY() + ship.getH()/2));
  }

}

void draw() {
  // clear the background
  background(0);
  stroke(0,0,0);
  // will we add a new enemy
  if (int(random(0,100)) == 0){
    // add a dino
    println("New ship");
    int which = int(random(0,enemies.length));
    Ship newShip = enemies[which].clone();
    newShip.setToLeft();
    enemiesOnScreen.add(newShip);
  }
  
  // draw the stars
  for(int i = 0 ; i < stars.length; i++){
    stars[i].draw();
  }
  // draw the ship
  ship.draw();
  
  // draw and mosve the enemies
  for (int i = enemiesOnScreen.size() - 1 ; i >= 0; i--){
    enemiesOnScreen.get(i).left();
    // remove it, or draw it.
    if (enemiesOnScreen.get(i).getX() <0)
      enemiesOnScreen.remove(i);
    else
      enemiesOnScreen.get(i).draw();
  }
  
  // move the stars
  for(int i = 0 ; i < stars.length; i++){
    stars[i].move();
  }
  
  for (int i = bullets.size() - 1; i >= 0; i--){
    bullets.get(i).draw();
    if (bullets.get(i).isTimedout()){
      bullets.remove(i);
    }
  }
}
