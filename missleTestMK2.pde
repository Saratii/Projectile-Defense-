float sizeM = 0.1;
int offset = -1050;
int frame = 0;
Projectile rocket;
Projectile shadow;
Projectile anti = null;
int leadTime = 80;
boolean going = true;
boolean boomed;
void setup(){
  size(1500, 1200);
  set();
}

void draw() {
  //drawing
  background(135,206,235);
  noStroke();
  
  linearAim();
  fill(0, 0, 255);
  if(!boomed){
    rocket.drawP();
  }
  fill(255, 0, 0);
  //shadow.drawP();
  rocket.move();
  shadow.move(); 
  if(anti!=null){
    anti.drawP();
    anti.move();
    checkHit();
  }
  if(!going){
    set();  
  }
  drawAntiMissleDefense();
}

void drawAntiMissleDefense(){
  fill(102);
  beginShape();
  vertex(140*sizeM, 900*sizeM-offset);
  vertex(150*sizeM, 750*sizeM-offset);
  vertex(250*sizeM, 750*sizeM-offset);
  vertex(260*sizeM, 900*sizeM-offset);
  endShape(CLOSE);
  beginShape();
  vertex(100*sizeM, 1100*sizeM-offset);
  vertex(300*sizeM, 1100*sizeM-offset);
  vertex(280*sizeM, 900*sizeM-offset); 
  vertex(120*sizeM, 900*sizeM-offset);
  endShape(CLOSE);
  fill(26, 26, 26);
  rect(0, 1100*sizeM-offset, 1500, 180);
  fill(140, 140, 140);
  rect(1200, 1100*sizeM-offset-10, 150, 10);
}

void linearAim(){
  pushMatrix();
  translate(80*sizeM+(240*sizeM)/2, 750*sizeM-offset+(120*sizeM)/2);
  if(rocket.posY<800){
    float b = 1131-shadow.posY;
    float a = shadow.posX-19;
    float angleOfRotation = atan(b/a);
    if(a<0){
      angleOfRotation-=PI;
    }
    rotate(-angleOfRotation);
    fill(255, 0, 0);
    //rect(0, 0-.2/2, 2000, .2);
    fill(150, 150, 150);
    rect(0-(240*sizeM)/2, 0-(120*sizeM)/2, 240*sizeM, 120*sizeM);
    frame++;
    if(frame==60){
      fill(0, 255, 0);
      shoot();
    }
    
  } else {
    fill(150, 150, 150);
    rect(0-(240*sizeM)/2, 0-(120*sizeM)/2, 240*sizeM, 120*sizeM);
  }
  popMatrix(); 
}

class Projectile{
  float posX = 1275-15;
  float posY = 1100*sizeM-offset-15-30;
  float speedX = 5;
  float speedY = 12;
  float accX;
  float accY;
  Projectile(float posX, float posY, float speedX, float speedY, float accX, float accY){
   this.posX = posX;
   this.posY = posY;
   this.speedX = speedX;
   this.speedY = speedY; 
   this.accX = accX;
   this.accY = accY; 
  }
  void move(){
    posX -= speedX;
    posY -= speedY;
    speedX += accX;
    speedY += accY;
  }
  void drawP(){
    ellipse(posX, posY, 20, 20); 
  }
}
void shoot(){
  anti = new Projectile(32, 1125, (32-shadow.posX)/leadTime, (1125-shadow.posY)/leadTime, 0, 0);
}
void checkHit(){
  if(sqrt(sq(anti.posX - rocket.posX)+sq(anti.posY-rocket.posY)) <= 5){
    boomed = true;  
    rocket.posY = 1000;
    anti = null;
    going = false;
  }
}
void set(){
  boomed = false;
  frame = 0;
  float yspeed = random(6, 12);
  float xspeed = random(2, 7);
  rocket = new Projectile(1260, 1100*sizeM-offset-45, xspeed, yspeed, 0, -0.05);
  shadow = new Projectile(1260-leadTime*xspeed, 1100*sizeM-offset-45-yspeed*leadTime+0.05*leadTime*(leadTime+1)/2, xspeed, yspeed-leadTime*0.05, 0, -0.05);
  going = true;
}
