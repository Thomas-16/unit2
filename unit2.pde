// Thomas Fang
// Block 2-4
// February 10, 2025

float theta;
void setup() {
  size(600, 600);
  theta = 0;
  frameRate(60);
}

void draw() {
  background(200);
  float mouseXMapped = map(mouseX, 0, width, 0, 255);
  float mouseYMapped = map(mouseY, 0, height, 0, 255);
  fill(mouseXMapped, mouseYMapped, mouseXMapped * mouseYMapped / 2f);
  int radius = 150;
  ellipse(radius * cos(theta) + 300, radius * sin(theta) + 300, 50, 50);
  theta += radians(3);
  line(300, 300, mouseX, mouseY);
}
