
int radius = 100;
float pos;
void setup() {
  size(600, 600);
  pos = -(radius / sqrt(2));
  frameRate(60);
}

void draw() {
  background(255);
  strokeWeight(5);
  ellipse(pos, pos, radius*2, radius*2);
  pos++;
  if(pos >= (radius / sqrt(2)) + height) {
    pos = -(radius / sqrt(2));
  }
}
