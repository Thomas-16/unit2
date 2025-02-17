// Refernece1 : https://s3-alpha.figma.com/hub/file/2084046592/10f598c6-fa07-4e0f-a6db-966d67521f79-cover.png
// Reference2 : https://blog.kiprosh.com/content/images/2022/05/parallax-effect-banner-1.gif
// Reference3 : https://miro.medium.com/v2/resize:fit:1400/0*-pOySD-Yf6yiyInP.jpg
// Color palette: https://coolors.co/340f33-5c0037-930037-dc3840-fc5237-fe7537-ffe1c9

class Tree {
  int worldX;        
  float offsetY;    
  float w, h; 
  float rotation;   
  float scaleFactor;
  color treeColor;
  int numLayers; 
  float trunkHeight; 
  float trunkWidth;
  float[] layerOffsets; 
  float[] layerWidths; 
  float[] layerHeights;
  
  
  Tree(int worldX, float offsetY, float w, float h, float rotation, float scaleFactor, color treeColor) {
    this.worldX = worldX;
    this.offsetY = offsetY;
    this.w = w;
    this.h = h;
    this.rotation = rotation;
    this.scaleFactor = scaleFactor;
    this.treeColor = treeColor;
    this.numLayers = int(random(4, 9));
    
    this.trunkHeight = h;
    this.trunkWidth  = w * random(0.12, 0.17);
    
    layerOffsets = new float[numLayers];
    layerWidths  = new float[numLayers];
    layerHeights = new float[numLayers];

    // calculate layerOffsets, layerWidths, layerHeights data
    float canopyTotal = h;  
    float currentY = 0; 

    layerWidths[0] = (w * 0.5) * random(0.9, 1.1);
    layerHeights[0] = canopyTotal * random(0.25, 0.35);
    layerOffsets[0] = currentY; 
    currentY -= layerHeights[0]; 
    canopyTotal -= layerHeights[0];
    
    // each layer gets smaller
    for (int i = 1; i < numLayers; i++) {
      layerWidths[i] = layerWidths[i - 1] * random(0.6, 0.9);
      layerHeights[i] = canopyTotal * random(0.25, 0.35);
      layerOffsets[i] = currentY;
      currentY -= layerHeights[i];
      canopyTotal -= layerHeights[i];
    }
  }
  

  void draw(float screenX, float mountainY) {
    pushMatrix();
    translate(screenX, mountainY + offsetY * scaleFactor);
    scale(scaleFactor);
    rotate(rotation);
    noStroke();
    fill(treeColor);
    
    // draw triangular trunk
    triangle(0, -trunkHeight, trunkWidth, 0, -trunkWidth, 0);
    
    // draw triangle layers from top to bottom
    for (int i = 0; i < numLayers; i++) {
      float bottomY = layerOffsets[i];
      float topY = bottomY - layerHeights[i];
      float halfW = layerWidths[i];

      triangle(-halfW, bottomY, halfW, bottomY, 0, topY);
    }
    
    popMatrix();
  }
}
class Bird {
  float x, y;            // Current position
  float speed;           // Horizontal movement speed (positive = right, negative = left)
  float size;            // Overall scale of the bird
  float wingFlapSpeed;   // How fast the wings flap
  float wingAngle;       // Current flap angle
  color birdColor;
  
  // Constructor
  Bird(float startX, float startY, float speed, float size, float flapSpeed, color c) {
    this.x = startX;
    this.y = startY;
    this.speed = speed;
    this.size = size;
    this.wingFlapSpeed = flapSpeed;
    this.wingAngle = 0;
    this.birdColor = c;
  }
  
  // Update position and wing angle
  void update() {
    x += speed;                // move horizontally
    wingAngle += wingFlapSpeed; // animate flapping
  }
  
  // Draw the bird silhouette, oriented in the direction of 'speed'
  void drawBird() {
    pushMatrix();
    translate(x, y);
    scale(size);
    
    // If speed < 0, flip horizontally so the bird faces left
    if (speed < 0) {
      scale(-1, 1);
    }
    
    noStroke();
    fill(birdColor);

    // We’ll define a basic side-profile geometry:
    // 1) Body: an ellipse oriented horizontally
    // 2) Head: a small circle in front (to the right if facing right)
    // 3) Tail: a small triangle behind (to the left)
    // 4) Two wings: a larger front wing + a slightly smaller “back wing”
    //    both pivot around the middle of the body and flap using sin(wingAngle).
    
    // ------------------------------------------------------------
    // Body
    // ------------------------------------------------------------
    float bodyLen    = 18;   // length of the body ellipse
    float bodyHeight = 6;    // height of the body ellipse
    ellipse(0, 0, bodyLen, bodyHeight);

    // ------------------------------------------------------------
    // Head (small circle in front)
    // ------------------------------------------------------------
    float headSize = 5;
    // Put head near the right edge of the body
    float headOffsetX = bodyLen*0.4; 
    ellipse(headOffsetX, 0, headSize, headSize);

    // ------------------------------------------------------------
    // Tail (small triangle at the back / left side)
    // ------------------------------------------------------------
    float tailLeft = -bodyLen*0.5;  // left edge of the ellipse
    beginShape();
    vertex(tailLeft, 0);
    vertex(tailLeft - 5, -3);
    vertex(tailLeft - 5,  3);
    endShape(CLOSE);

    // ------------------------------------------------------------
    // WINGS
    // ------------------------------------------------------------
    // We’ll do a “front wing” (larger) and a “back wing” (slightly smaller,
    // partly hidden behind the body) to give a bit of dimension.

    float wingPos = sin(wingAngle);       // flapping in [-1..1]
    float flapRotFront = radians(wingPos * 30); // front wing rotates ±30°
    float flapRotBack  = radians(wingPos * 25); // back wing ±25° for variation
    
    // The pivot for both wings is the center of the body (0,0).
    // Let’s define some shapes for the wings:
    //   each wing is a simple polygon that extends above/below the center.

    // --- Draw the BACK wing first (so it’s behind the body ellipse) ---
    pushMatrix();
    // Slightly shift it in the negative z or just trust painter’s order:
    rotate(flapRotBack);
    // A simple shape: perhaps a small trapezoid or triangular wing
    beginShape();
      vertex(0,  0);
      vertex(-2, -3);
      vertex(-10, -6);
      vertex(-8, -2);
    endShape(CLOSE);
    popMatrix();
    
    // --- Draw the FRONT wing ---
    pushMatrix();
    rotate(flapRotFront);
    // A bigger shape for the front wing
    beginShape();
      vertex(0,  0);
      vertex(-3, -4);
      vertex(-14, -8);
      vertex(-10, -2);
    endShape(CLOSE);
    popMatrix();
    
    popMatrix(); // end translate/scale
  }
}




int[] offsets;
int[] velocities;
int[] seeds;
int terrainStepSize = 15;
ArrayList<Tree> trees1, trees2, trees3, trees4, trees5, trees6;
float FURTHEST_TREE_SCALE = 0.3;
float CLOSEST_TREE_SCALE = 1;
int treeMargin = 200;
PImage skyGradient;
ArrayList<Bird> flock = new ArrayList<Bird>();



// GREEN PALETTE LIGHT TO DARK
color[] colors = {
  color(208, 233, 149),
  color(85, 152, 111),
  color(70, 119, 87),
  color(51, 104, 76),
  color(18, 63, 60),
  color(14, 47, 54),
  color(22, 37, 44),
};

void setup() {
  size(1400, 900);
  frameRate(60);
  
  // precompute the sky gradient
  skyGradient = createImage(width, height, RGB);
  skyGradient.loadPixels();
  color topColor = color(#CBE894); 
  color bottomColor = color(#D7ED9A);
  int bottomY = 270;

  for (int y = 0; y < height; y++) {
    float t = map(y, 0, bottomY-1, 0, 1);
    for (int x = 0; x < width; x++) {
      skyGradient.pixels[y * width + x] = (t >= 0 && t <= 1) ? lerpColor(topColor, bottomColor, t) : bottomColor;
    }
  }
  skyGradient.updatePixels();
  
  offsets = new int[] { 0, 0, 0, 0, 0, 0 };
  seeds = new int[] {
    int(random(-5000, 5000)),
    int(random(-5000, 5000)),
    int(random(-5000, 5000)),
    int(random(-5000, 5000)),
    int(random(-5000, 5000)),
    int(random(-5000, 5000)),
  };
  trees1 = new ArrayList<Tree>();
  trees2 = new ArrayList<Tree>();
  trees3 = new ArrayList<Tree>();
  trees4 = new ArrayList<Tree>();
  trees5 = new ArrayList<Tree>();
  trees6 = new ArrayList<Tree>();
  ArrayList[] treeLists = new ArrayList[] { trees1, trees2, trees3, trees4, trees5, trees6 };
  velocities = new int[] {
    2, 4, 6, 8, 10, 12
  };
  
  for(int layer = 1; layer <= 6; layer++) {
    float scaleFactor = map(layer, 1, 6, FURTHEST_TREE_SCALE, CLOSEST_TREE_SCALE);
    int worldStart = seeds[layer - 1] - treeMargin;
    int worldEnd = seeds[layer - 1] + width + treeMargin;
    
    int x = worldStart;
    while(x < worldEnd) {
      float spacing = random(45, 55) * scaleFactor;
      float treeW = random(70, 80);
      float treeH = treeW * 1.8;
      float offsetY = random(30, 40);
      float rotation = radians(random(-10, 10));
      treeLists[layer - 1].add(new Tree(x, offsetY, treeW, treeH, rotation, scaleFactor, colors[layer]));
      x += spacing;
    }
  }
  for (int i = 0; i < 8; i++) {
    float startX = random(-200, width);  // some might start off-screen left
    float startY = random(50, 300);      // near top portion of the sky
    float speed  = random(1.5, 3.5);     // how fast they cross the screen
    float s      = random(0.7, 1.2);     // overall size scale
    float flap   = random(0.08, 0.15);   // how fast wings flap
    // Typically a dark silhouette
    color birdC  = color(0);
    flock.add(new Bird(startX, startY, speed, s, flap, birdC));
  }
}
void draw() {
  offsets[0] += velocities[0];
  offsets[1] += velocities[1];
  offsets[2] += velocities[2];
  offsets[3] += velocities[3];
  offsets[4] += velocities[4];
  offsets[5] += velocities[5];
  
  // background image with gradient
  image(skyGradient, 0, 0);
  
  drawMountainLayer(1, colors[1], offsets[0], seeds[0]);
  drawTreeLayer(trees1, 0);
  
  drawMountainLayer(2, colors[2], offsets[1], seeds[1]);
  drawTreeLayer(trees2, 1);
  
  drawMountainLayer(3, colors[3], offsets[2], seeds[2]);
  drawTreeLayer(trees3, 2);
  
  drawMountainLayer(4, colors[4], offsets[3], seeds[3]);
  drawTreeLayer(trees4, 3);
  
  drawMountainLayer(5, colors[5], offsets[4], seeds[4]);
  drawTreeLayer(trees5, 4);
  
  drawMountainLayer(6, colors[6], offsets[5], seeds[5]);
  drawTreeLayer(trees6, 5);
  
  for (Bird b : flock) {
    b.update();
    b.drawBird();
    
    // If bird has flown off the right edge, reset to left side
    if (b.x > width + 50) {
      b.x = -50;
      b.y = random(50, 300);
      b.speed = random(1.5, 3.5);
      // Or keep the same speed, or randomize again
    }
  }
  
}

void drawTreeLayer(ArrayList<Tree> treeList, int layerIndex) {
  for(Tree tree : treeList) {
    int screenX = tree.worldX - (offsets[layerIndex] + seeds[layerIndex]);
    if (screenX < -treeMargin) {
      tree.worldX += (width + treeMargin * 2);
      screenX = tree.worldX - (offsets[layerIndex] + seeds[layerIndex]);
    }
    tree.draw(screenX, noiseFunction(layerIndex + 1, screenX, offsets[layerIndex], seeds[layerIndex]));
  }
}

void drawMountainLayer(int layerNum, color layerColor, int offset, int seed) {
  fill(layerColor);
  noStroke();
  beginShape();
  vertex(0, height);
  vertex(0, noiseFunction(layerNum, 0, offset, seed));
  for(int i = 0; i <= width; i += terrainStepSize) {
    curveVertex(i, noiseFunction(layerNum, i, offset, seed));
  }
  vertex(width, noiseFunction(layerNum, width, offset, seed));
  vertex(width, height);
  endShape();
}

float noiseFunction(int layer, int x, int offset, int seed) {
  float noiseVal = 0;
  switch(layer) {
    case 1: 
      noiseVal = noise((x+offset + seed)/270f)/4.3 + noise((x+offset + seed)/500f)/1.2;
      return height * (1 - noiseVal * 0.4) - 480;
    case 2:
      noiseVal = noise((x+offset + seed)/290f)/4 + noise((x+offset + seed)/300f)/1.7;
      return height * (1 - noiseVal * 0.38) - 430;
    case 3:
      noiseVal = noise((x+offset + seed)/200f)/4 + noise((x+offset + seed)/250f)/1.7;
      return height * (1 - noiseVal * 0.27) - 420;
    case 4:
      noiseVal = noise((x+offset + seed)/350f)/1.4;
      return height * (1 - noiseVal * 0.3) - 360;
    case 5:
      noiseVal = noise((x+offset + seed)/370f)/1.4;
      return height * (1 - noiseVal * 0.3) - 260;
    case 6:
      noiseVal = noise((x+offset + seed)/420f)/1.5;
      return height * (1 - noiseVal * 0.4) - 130;
    default:
      return 0;
  }
}
