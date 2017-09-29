PImage transparencyFilter(PImage toProcess, float opacity) {
  PImage processed = toProcess.copy();
  processed.loadPixels();

  for (int y = 0; y < processed.height; y++) {
    for (int x = 0; x < processed.width; x++) {
      color c = getPixel(processed, x, y);
      color processedColor = getColorWithSecondOrderOpacity(c, opacity);
      setPixel(processed, x, y, processedColor);
    }
  }
 
  processed.updatePixels();
  return processed;
}

color getColorWithSecondOrderOpacity(color c, float opacity) {
  PVector colorVector = getColorVector(c);
  float calculatedOpacity = alpha(c)*(opacity/255.0);
  return color(colorVector.x, colorVector.y, colorVector.z, calculatedOpacity);
}

PImage removeWhite(PImage toProcess) {
  colorMode(HSB, 255);
  PImage processed = toProcess.copy();
  processed.loadPixels();

  for (int y = 0; y < processed.height; y++) {
    for (int x = 0; x < processed.width; x++) {
      color c = getPixel(processed, x, y);
      PVector colorVector = getHSBColorVector(c);
      color processedColor = removeWhite(colorVector);
      setPixel(processed, x, y, processedColor);
    }
  }
 
  processed.updatePixels();
  
  colorMode(RGB, 255);
  return processed;
}

color removeWhite(PVector colorVector) {
  float h = colorVector.x;
  float s = colorVector.y;
  float b = colorVector.z;
  return color(h, (128+s)-((255-b)*0.66), b, s+((255-b)*1.2));
}

//PImage removeBlack(PImage original, float opacity) {
//  PImage processed = original.copy();
//  processed.loadPixels();
  
//  float opacityRatio = opacity/255.0;

//  for (int y = 0; y < processed.height; y++) {
//    for (int x = 0; x < processed.width; x++) {
//      color c = getPixel(processed, x, y);
//      PVector colorVector = getColorVector(c);
//      PVector processedVector = removeBlack(colorVector);
//      setPixel(processed, x, y, color(processedVector.x, processedVector.y, processedVector.z));
//    }
//  }
 
//  processed.updatePixels();
//  return processed;
//}

//PVector removeBlack(PVector colorVector) {
//  float r = colorVector.x;
//  float g = colorVector.y;
//  float b = colorVector.z;
//  // remove black
//  float minValue;
//  if (r > g && r > b) {
//    minValue = r;
//  } else if (g > b) {
//    minValue = g;
//  } else {
//    minValue = b;
//  }
//  float offset = 255 - minValue;
//  r = r + offset;
//  g = g + offset;
//  b = b + offset;
  
//  return new PVector(r, g, b);
//}