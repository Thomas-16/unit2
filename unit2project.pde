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
    this.numLayers = int(random(6, 9));
    
    this.trunkHeight = h;
    this.trunkWidth  = w * random(0.15, 0.2);
    
    layerOffsets = new float[numLayers];
    layerWidths  = new float[numLayers];
    layerHeights = new float[numLayers];

    // calculate layerOffsets, layerWidths, layerHeights data
    float canopyTotal = h;  
    float currentY = 0; 

    float baseHalfWidth = (w * 0.5) * random(0.9, 1.1);  
    layerWidths[0] = baseHalfWidth;
    
    layerHeights[0] = canopyTotal * random(0.25, 0.35);
    layerOffsets[0] = currentY; 
    currentY -= layerHeights[0]; 
    canopyTotal -= layerHeights[0];

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


int[] offsets;
int[] velocities;
int[] seeds;
int terrainStepSize = 15;
ArrayList<Tree> trees1, trees2, trees3, trees4, trees5, trees6;
float FURTHEST_TREE_SCALE = 0.3;
float CLOSEST_TREE_SCALE = 1;
int treeMargin = 200;


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
}
void draw() {
  offsets[0] += velocities[0];
  offsets[1] += velocities[1];
  offsets[2] += velocities[2];
  offsets[3] += velocities[3];
  offsets[4] += velocities[4];
  offsets[5] += velocities[5];
  
  background(colors[0]);
  
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
      return height * (1 - noiseVal * 0.4) - 470;
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
