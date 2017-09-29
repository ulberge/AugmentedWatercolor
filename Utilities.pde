public void printColor(color c) {
    text(printColorString(c), 0, 0);
}

public String printColorString(color c) {
    return "R: " + red(c) + ", G: " + green(c) + ", B: " + blue(c);
}

color getPixel(PImage imageToUse, int x, int y) {
  return imageToUse.pixels[(y*imageToUse.width)+x];
}

void setPixel(PImage imageToUse, int x, int y, color c) {
  imageToUse.pixels[(y*imageToUse.width)+x] = c;
}

PVector getColorVector(color c) {
  float r = c >> 16 & 0xFF;  // Very fast to calculate red
  float g = c >> 8 & 0xFF;  // Very fast to calculate green
  float b = c & 0xFF; // Very fast to calculate blue
  
  return new PVector(r, g, b);
}

PVector getHSBColorVector(color c) {
  float h = hue(c);
  float s = saturation(c);
  float b = brightness(c); // Very fast to calculate blue
  
  return new PVector(h, s, b);
}

int getBrightness(color c) {
  float r = c >> 16 & 0xFF;  // Very fast to calculate red
  float g = c >> 8 & 0xFF;  // Very fast to calculate green
  float b = c & 0xFF; // Very fast to calculate blue
  return (int) sqrt(
      r * r * .241 + 
      g * g * .691 + 
      b * b * .068);
}

// get warmth on scale from 0.0-1.0
public float getWarmth(color c) {
  //colorMode(HSB, 100);
  // 0-80 and 330-360
  // 0-22, 92-100
  // warmest == 7 == 1.0
  // coldest == 62 == 0.0
  // 22 = 0.5
  // 92 = 0.5
  float h = 2*PI*((hue(c)-80)/255.0);
  float s = saturation(c)/255.0;
  //float h = 2*PI*(hue(c)/255.0);
  //colorMode(RGB, 255);
  //return 0.5 + (0.5*sin(h));
  return 0.5 + s*(-0.5*sin(h));
}

boolean isColorEqual(color c0, color c1) {
  float r0 = c0 >> 16 & 0xFF;  // Very fast to calculate red
  float g0 = c0 >> 8 & 0xFF;  // Very fast to calculate green
  float b0 = c0 & 0xFF; // Very fast to calculate blue  
  
  float r1 = c1 >> 16 & 0xFF;  // Very fast to calculate red
  float g1 = c1 >> 8 & 0xFF;  // Very fast to calculate green
  float b1 = c1 & 0xFF; // Very fast to calculate blue
  
  return (r1 == r0) && (g1 == g0) && (b1 == b0);
}

// goal = (0, 0, 255), current = (255, 255, 255) ===> (0, 0, 255)
// goal = (255, 255, 255), current = (255, 255, 255) ===> (255, 255, 255)
// c0 = goal, c1 = current
// calculate what transparent color to add to c1 to get c0
color getColorDiff(color c0, color c1) {
  float r0 = c0 >> 16 & 0xFF;  // Very fast to calculate red
  float g0 = c0 >> 8 & 0xFF;  // Very fast to calculate green
  float b0 = c0 & 0xFF; // Very fast to calculate blue  
  
  float r1 = c1 >> 16 & 0xFF;  // Very fast to calculate red
  float g1 = c1 >> 8 & 0xFF;  // Very fast to calculate green
  float b1 = c1 & 0xFF; // Very fast to calculate blue  
  
  float diffR = 255-max(r1-r0, 0);
  float diffG = 255-max(g1-g0, 0);
  float diffB = 255-max(b1-b0, 0);
  return color(diffR, diffG, diffB);
}

color applyShade(color toShade, color shade) {
  int shadeValue = 255 - getBrightness(shade);
  PVector colorVector = getColorVector(toShade);
  return color(max(0, colorVector.x-shadeValue), max(0, colorVector.y-shadeValue), max(0, colorVector.z-shadeValue));
}

color getSwatchColor(PImage swatch, int tolerance) {
  PImage areaToAverage = swatch;
  areaToAverage.loadPixels();
  
  color pixelSelectedColor = get(mouseX, mouseY);
  float selectedR = pixelSelectedColor >> 16 & 0xFF;  // Very fast to calculate red
  float selectedG = pixelSelectedColor >> 8 & 0xFF;  // Very fast to calculate green
  float selectedB = pixelSelectedColor & 0xFF; // Very fast to calculate blue
  
  float totalR = 0;
  float totalG = 0;
  float totalB = 0;
  int countPixels = 0;
  for (int y = 0; y < areaToAverage.height; y++) {
    for (int x = 0; x < areaToAverage.width; x++) {
      color c = getPixel(areaToAverage, x, y);
      
      float r = c >> 16 & 0xFF;  // Very fast to calculate red
      float g = c >> 8 & 0xFF;  // Very fast to calculate green
      float b = c & 0xFF; // Very fast to calculate blue
      
      // only use if all colors are within tolerance of selected pixel
      if ((abs(r - selectedR) < tolerance) && (abs(g - selectedG) < tolerance) && (abs(b - selectedB) < tolerance)) {
        totalR += r;
        totalG += g;
        totalB += b;
        countPixels++;
      } else {
        setPixel(areaToAverage, x, y, color(255));
      }
    }
  }
  
  color c = color((int) (totalR/countPixels), (int) (totalG/countPixels), (int) (totalB/countPixels));
  
  areaToAverage.updatePixels();
  return c;
}