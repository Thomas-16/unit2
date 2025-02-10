
int x;
void setup() {
  size(600, 600);
  x = width + 100;
  frameRate(60);
}

void draw() {
  background(255);
  strokeWeight(5);
  ellipse(x, 300, 200, 200);
  x--;
  if(x <= -100) {
    x = width + 100;
  }
}
