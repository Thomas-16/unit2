
// Refernece1 : https://s3-alpha.figma.com/hub/file/2084046592/10f598c6-fa07-4e0f-a6db-966d67521f79-cover.png
// Reference2 : https://blog.kiprosh.com/content/images/2022/05/parallax-effect-banner-1.gif
// Color palette: https://coolors.co/340f33-5c0037-930037-dc3840-fc5237-fe7537-ffe1c9

int offset = 0;

void setup() {
  size(1000, 600);
  frameRate(60);
  
}

void draw() {
  background(#FFE1C9);
  offset += 10;
  fill(254, 117, 55);
  noStroke();
  beginShape();
  vertex(0, height);
  vertex(0, noiseFunction1(0));
  for(int i = 0; i <= width; i += 5) {
    curveVertex(i, noiseFunction1(i));
  }
  vertex(width, noiseFunction1(width));
  vertex(width, height);
  endShape();
}

float noiseFunction1(int x) {
  return height * (1 - ( noise((x+offset)/180f) / 2f + noise((x+offset)/450f) / 1.8f)) - 0;
}
