import processing.svg.*;

/*
  SETTINGS
  
  NAME: Name of image-file in directory 'data'.
  SIZE: Size of larger side of the image after downscale.
  LEVELS: Number of differentiated brightness-levels. Maximum n-1 lines.
  SQ_SIZE: Size of one pixel when upscaled for output.
*/

static final String NAME = "katze.jpeg";
static final int SIZE = 100;
static final int LEVELS = 4;
static final float SQ_SIZE = 10;

/*
  END OF SETTINGS
*/

static PImage img;
static float[] delta = new float[LEVELS];

void settings() {
  size((int) (SIZE * SQ_SIZE), (int) (SIZE * SQ_SIZE));
}

void setup() {
  // resize and load image
  img = loadImage("data/" + NAME);
  if (img == null) exit();
  if (img.width >= img.height) {
    img.resize(SIZE, 0);
  } else {
    img.resize(0, SIZE);
  }
  img.loadPixels();
  
  beginRecord(SVG, "out/output.svg");
  
  // pre-calculate distances between lines for levels
  delta[0] = SQ_SIZE;
  for (int i = 1; i < delta.length; i++) {
    delta[i] = SQ_SIZE / i;
  }
  
  // iterate through pixels and draw lines according to brightness
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      double b = brightness(img.pixels[y * img.width + x]);
      int lines = (LEVELS - 1) - (int) ((b * LEVELS) / 256);
      float dt = delta[lines];
      for (int i = 0; i < lines; i++) {
        line(x * SQ_SIZE + (i + 1) * dt, y * SQ_SIZE, x * SQ_SIZE + (i + 1) * dt, (y + 1) * SQ_SIZE);
      }
    }
  }
  
  endRecord();
  exit();
}
