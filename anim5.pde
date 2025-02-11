
int size = 0;
int posX = 0;
void setup() {
  size(600, 600);
  frameRate(60);
}

void draw() {
  background(255);
  strokeWeight(5);
  ellipse(posX, 300, size, size);
  posX += 5;
  size += 1;
  if(posX >= width + (size / 2)) {
    posX = 0;
    size = 0;
  }
}
