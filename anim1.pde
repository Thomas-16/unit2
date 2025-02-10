

int y = -100;
void setup() {
  size(600, 600);
  
  frameRate(60);
}

void draw() {
  background(255);
  strokeWeight(5);
  ellipse(300, y, 200, 200);
  y++;
  if(y >= height + 100) {
    y = -100;
  }
}
