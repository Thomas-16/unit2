
// Refernece1 : https://s3-alpha.figma.com/hub/file/2084046592/10f598c6-fa07-4e0f-a6db-966d67521f79-cover.png
// Reference2 : https://blog.kiprosh.com/content/images/2022/05/parallax-effect-banner-1.gif
// Reference3 : https://miro.medium.com/v2/resize:fit:1400/0*-pOySD-Yf6yiyInP.jpg
// Color palette: https://coolors.co/340f33-5c0037-930037-dc3840-fc5237-fe7537-ffe1c9

int offset1, offset2, offset3, offset4, offset5, offset6;
int v1, v2, v3, v4, v5, v6;
int seed1, seed2, seed3, seed4, seed5, seed6;
int stepSize = 20;

// ORANGE PALLETTE BRIGHT TO DARK
color[] colors = {
  color(255, 225, 201),    
  color(254, 117, 55),  
  color(252, 82, 55), 
  color(220, 56, 64),
  color(147, 0, 55),
  color(92, 0, 55),
  color(52, 15, 51)
};

// ORANGE PALLETTE DARK TO BRIGHT
//color[] colors = {
//  color(255, 225, 201),
//  color(52, 15, 51),
//  color(92, 0, 55),
//  color(147, 0, 55),
//  color(220, 56, 64),
//  color(252, 82, 55), 
//  color(254, 117, 55)
//};


void setup() {
  size(1400, 900);
  frameRate(60);
  
  offset1 = 0;
  offset2 = 0;
  offset3 = 0;
  offset4 = 0;
  offset5 = 0;
  offset6 = 0;
  seed1 = int(random(-5000, 5000));
  seed2 = int(random(-5000, 5000));
  seed3 = int(random(-5000, 5000));
  seed4 = int(random(-5000, 5000));
  seed5 = int(random(-5000, 5000));
  seed6 = int(random(-5000, 5000));
  v1 = 10;
  v2 = 12;
  v3 = 14;
  v4 = 16;
  v5 = 18;
  v6 = 20;
}

void draw() {
  println(frameRate);
  
  offset1 += v1;
  offset2 += v2;
  offset3 += v3;
  offset4 += v4;
  offset5 += v5;
  offset6 += v6;
  
  background(colors[0]);
  
  // layer 1
  fill(colors[1]);
  noStroke();
  beginShape();
  vertex(0, height);
  vertex(0, noiseFunction1(0));
  for(int i = 0; i <= width; i += stepSize) {
    curveVertex(i, noiseFunction1(i));
  }
  vertex(width, noiseFunction1(width));
  vertex(width, height);
  endShape();
  
  // layer 2
  fill(colors[2]);
  noStroke();
  beginShape();
  vertex(0, height);
  vertex(0, noiseFunction2(0));
  for(int i = 0; i <= width; i += stepSize) {
    curveVertex(i, noiseFunction2(i));
  }
  vertex(width, noiseFunction2(width));
  vertex(width, height);
  endShape();
  
  // layer 3
  fill(colors[3]);
  noStroke();
  beginShape();
  vertex(0, height);
  vertex(0, noiseFunction3(0));
  for(int i = 0; i <= width; i += stepSize) {
    curveVertex(i, noiseFunction3(i));
  }
  vertex(width, noiseFunction3(width));
  vertex(width, height);
  endShape();

  // layer 4
  fill(colors[4]);
  noStroke();
  beginShape();
  vertex(0, height);
  vertex(0, noiseFunction4(0));
  for(int i = 0; i <= width; i += stepSize) {
    curveVertex(i, noiseFunction4(i));
  }
  vertex(width, noiseFunction4(width));
  vertex(width, height);
  endShape();
  
  // layer 5
  fill(colors[5]);
  noStroke();
  beginShape();
  vertex(0, height);
  vertex(0, noiseFunction5(0));
  for(int i = 0; i <= width; i += stepSize) {
    curveVertex(i, noiseFunction5(i));
  }
  vertex(width, noiseFunction5(width));
  vertex(width, height);
  endShape();
  
  // layer 6
  fill(colors[6]);
  noStroke();
  beginShape();
  vertex(0, height);
  vertex(0, noiseFunction6(0));
  for(int i = 0; i <= width; i += stepSize + 10) {
    curveVertex(i, noiseFunction6(i));
  }
  vertex(width, noiseFunction6(width));
  vertex(width, height);
  endShape();
}

float noiseFunction1(int x) {
  return height * (1 - (noise((x+offset1 + seed1)/270f) / 4.3f + noise((x+offset1 + seed1)/600f) / 1.2f + noise((x+offset1 + seed1)/40f) / 20f) * 0.5f) - 440;
}
float noiseFunction2(int x) {
  return height * (1 - (noise((x+offset2 + seed2)/290f) / 4f + noise((x+offset2 + seed2)/340f) / 1.7f) * 0.4f) - 420;
}
float noiseFunction3(int x) {
  return height * (1 - (noise((x+offset3 + seed3)/200f) / 4f + noise((x+offset3 + seed3)/280f) / 1.7f) * 0.27f) - 400;
}
float noiseFunction4(int x) {
  return height * (1 - (noise((x+offset4 + seed4)/350f) / 1.4f) * 0.3f) - 320;
}
float noiseFunction5(int x) {
  return height * (1 - (noise((x+offset5 + seed5)/350f) / 1.4f) * 0.3f) - 230;
}
float noiseFunction6(int x) {
  return height * (1 - (noise((x+offset6 + seed6)/400f) / 1.4f) * 0.4f) - 140;
}


void drawTree() {
  
}

