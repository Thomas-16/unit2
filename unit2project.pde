
// Refernece1 : https://s3-alpha.figma.com/hub/file/2084046592/10f598c6-fa07-4e0f-a6db-966d67521f79-cover.png
// Reference2 : https://blog.kiprosh.com/content/images/2022/05/parallax-effect-banner-1.gif
// Color palette: https://coolors.co/340f33-5c0037-930037-dc3840-fc5237-fe7537-ffe1c9

int offset1, offset2;
int v1, v2;
int seed1, seed2;
color[] colors = {
  color(255, 225, 201),    
  color(254, 117, 55),  
  color(252, 82, 55), 
  color(220, 56, 64),
  color(147, 0, 55),
  color(92, 0, 55),
  color(52, 15, 51)
};

void setup() {
  size(1400, 900);
  frameRate(60);
  
  offset1 = 0;
  offset2 = 0;
  seed1 = int(random(-5000, 5000));
  seed2 = int(random(-5000, 5000));
  v1 = 5;
  v2 = 8;
}

void draw() {
  offset1 += v1;
  offset2 += v2;
  
  background(colors[0]);
  
  fill(colors[1]);
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
  
  fill(colors[2]);
  noStroke();
  beginShape();
  vertex(0, height);
  vertex(0, noiseFunction2(0));
  for(int i = 0; i <= width; i += 5) {
    curveVertex(i, noiseFunction2(i));
  }
  vertex(width, noiseFunction2(width));
  vertex(width, height);
  endShape();
  
}

float noiseFunction1(int x) {
  return height * (1 - (noise((x+offset1 + seed1)/270f) / 4.3f + noise((x+offset1 + seed1)/600f) / 1.2f) * 0.55f) - 400;
}

float noiseFunction2(int x) {
  return height * (1 - (noise((x+offset2 + seed2)/270f) / 4.3f + noise((x+offset2 + seed2)/600f) / 1.2f) * 0.55f) - 300;
}
