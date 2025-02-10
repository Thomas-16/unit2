
int size;
void setup() {
  size(600, 600);
  size = 0;
  frameRate(60);
}

void draw() {
  background(255);
  strokeWeight(5);
  ellipse(300, 300, size, size);
  size++;
  if(size >= sqrt(2) * 2 * 300) {
    size = 0;
  }
}
