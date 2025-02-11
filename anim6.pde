
int posY1;
int posY2;
void setup() {
  size(600, 600);
  frameRate(60);
  posY1 = -100;
  posY2 = height + 100;
}

void draw() {
  background(255);
  strokeWeight(5);
  ellipse(150, posY1, 200, 200);
  ellipse(600-150, posY2, 200, 200);
  posY1++;
  posY2--;
  if(posY1 >= height + 100) {
    posY1 = -100;
  }
  if(posY2 <= -100) {
    posY2 = height + 100;
  }
}
