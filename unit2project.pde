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

    // draw trunk
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
  int x;
  int y;
  float speed;
  float size;
  color birdColor;
  float flapSpeed; // in degrees
  float currentAngle; // in degrees

  Bird(int x, int y, float speed, float size, color birdColor, float flapSpeed, float currentAngle) {
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.size = size;
    this.birdColor = birdColor;
    this.flapSpeed = flapSpeed;
    this.currentAngle = currentAngle;
  }

  void update() {
    x += speed;
    currentAngle += flapSpeed;
    if (x > width + 20) {
      x = -30;
    }
    if (currentAngle > 50) {
      flapSpeed = -flapSpeed;
    }
    if (currentAngle < -50) {
      flapSpeed = -flapSpeed;
    }
  }

  void draw() {
    pushMatrix();
    translate(x, y);
    scale(size);
    stroke(0);
    strokeWeight(size);
    fill(birdColor);

    line(0, 0, cos(radians(currentAngle)) * 10, sin(radians(currentAngle)) * 10);
    line(0, 0, -cos(radians(currentAngle)) * 10, sin(radians(currentAngle)) * 10);

    popMatrix();
  }
}

class Cloud {
  float x, y;
  float scale;
  color cloudColor;
  int type;

  Cloud(float x, float y, float scale, color cloudColor, int type) {
    this.x = x;
    this.y = y;
    this.scale = scale;
    this.cloudColor = cloudColor;
    this.type = type;
  }

  void update() {
    x -= cloudSpeed;
    if (x < -150) {
      x = width + 150 + width;
    }
  }

  void draw() {
    pushMatrix();
    translate(x, y);
    scale(scale);
    noStroke();
    fill(cloudColor);

    if (type == 1) {
      ellipse(20, 0, 80, 40);
      ellipse(-10, 0, 90, 60);
      ellipse(-60, 15, 70, 35);
    } else {
      ellipse(-20, -15, 100, 80);
      ellipse(-60, 10, 90, 55);
      ellipse(20, -5, 100, 60);
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
PImage skyGradient;
ArrayList<Bird> birds;
float cloudSpeed = 1;
Cloud cloud1, cloud2, cloud3, cloud4;


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
    3, 5, 7, 9, 11, 13
  };

  for (int layer = 1; layer <= 6; layer++) {
    float scaleFactor = map(layer, 1, 6, FURTHEST_TREE_SCALE, CLOSEST_TREE_SCALE);
    int worldStart = seeds[layer - 1] - treeMargin;
    int worldEnd = seeds[layer - 1] + width + treeMargin;

    int x = worldStart;
    while (x < worldEnd) {
      float spacing = random(35, 60) * scaleFactor;
      float treeW = random(70, 80);
      float treeH = treeW * 1.8;
      float offsetY = random(30, 40);
      float rotation = radians(random(-7, 7));
      treeLists[layer - 1].add(new Tree(x, offsetY, treeW, treeH, rotation, scaleFactor, colors[layer]));
      x += spacing;
    }
  }

  birds = new ArrayList<Bird>();
  for (int i = 0; i < 10; i++) {
    int startX = int(random(-200, width - 100));
    int startY = int(random(80, 300));
    float speed = random(4.5, 6);
    float size = random(1, 1.8);
    float flapSpeed = speed * 2.6;
    birds.add(new Bird(startX, startY, speed, size, color(0), flapSpeed, int(random(-45, 45))));
  }

  cloud1 = new Cloud(400, 130, 1.4f, color(229, 242, 162), 1);
  cloud2 = new Cloud(1200, 200, 1.3f, color(229, 242, 162), 2);
  cloud3 = new Cloud(400 + width, 130, 1.4f, color(229, 242, 162), 1);
  cloud4 = new Cloud(1200 + width, 200, 1.3f, color(229, 242, 162), 2);
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

  // clouds
  cloud1.update();
  cloud1.draw();
  cloud2.update();
  cloud2.draw();
  cloud3.update();
  cloud3.draw();
  cloud4.update();
  cloud4.draw();

  // mountain layers and trees
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


  // birds
  for (Bird bird : birds) {
    bird.update();
    bird.draw();
  }

  println(frameRate);
}

void drawTreeLayer(ArrayList<Tree> treeList, int layerIndex) {
  for (Tree tree : treeList) {
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
  for (int i = 0; i <= width; i += terrainStepSize) {
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
    noiseVal = noise((x+offset + seed)/270f)/4.3 + noise((x+offset + seed)/500f)/1.5;
    return height * (1 - noiseVal * 0.5) - 480;
  case 2:
    noiseVal = noise((x+offset + seed)/290f)/4 + noise((x+offset + seed)/300f)/1.7;
    return height * (1 - noiseVal * 0.4) - 450;
  case 3:
    noiseVal = noise((x+offset + seed)/200f)/4 + noise((x+offset + seed)/250f)/1.7;
    return height * (1 - noiseVal * 0.3) - 420;
  case 4:
    noiseVal = noise((x+offset + seed)/320f)/1.4;
    return height * (1 - noiseVal * 0.35) - 360;
  case 5:
    noiseVal = noise((x+offset + seed)/330f)/1.4;
    return height * (1 - noiseVal * 0.35) - 260;
  case 6:
    noiseVal = noise((x+offset + seed)/420f)/1.5;
    return height * (1 - noiseVal * 0.44) - 130;
  default:
    return 0;
  }
}
