import processing.svg.*;

/*
  SETTINGS
  
  NAME: Name of image-file in directory 'data'.
  SIZE: Size of larger side of the image after downscale.
  LEVELS: Number of differentiated brightness-levels. Maximum n-1 lines.
  SQ_SIZE: Size of one pixel when upscaled for output.
  VERTICAL: Set for shading with vertical lines, unset for shading with horizontal lines. 
*/

static final String NAME = "katze.jpeg";
static final int SIZE = 200;
static final int LEVELS = 6;
static final float SQ_SIZE = 10;
static final boolean VERTICAL = true;

/*
  END OF SETTINGS
*/

static PImage img;
static float[] delta = new float[LEVELS];
static int[] lines = new int[256]; 

void settings() {
  size((int) (SIZE * SQ_SIZE), (int) (SIZE * SQ_SIZE));
}

void setup() {
  img = loadImage("data/" + NAME);
  if (img == null) exit();
  img.resize(SIZE, 0);
  img.loadPixels();
  
  // pre-calculate distances between lines for levels
  delta[0] = SQ_SIZE;
  for (int i = 1; i < delta.length; i++) {
    delta[i] = SQ_SIZE / i;
  }
  
  // pre-calculate number of lines in relation to brightness
  for (int i = 0; i < 256; i++) {
    lines[i] = (LEVELS - 1) - (int) ((i * LEVELS) / 256);
  }
  
  beginRecord(SVG, "out/output.svg");
  
  // iterate through pixels and draw lines according to brightness
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      double b = brightness(img.pixels[y * img.width + x]);
      int nl = lines[(int) b];
      float dt = delta[nl];
      for (int i = 0; i < nl; i++) {
        if (VERTICAL) {
          line(x * SQ_SIZE + (i + 1) * dt, y * SQ_SIZE, x * SQ_SIZE + (i + 1) * dt, (y + 1) * SQ_SIZE);
        } else {
          line(x * SQ_SIZE, y * SQ_SIZE + (i + 1) * dt, (x + 1) * SQ_SIZE, y * SQ_SIZE + (i + 1) * dt);
        }
      }
    }
  }
  
  endRecord();
  exit();
}
