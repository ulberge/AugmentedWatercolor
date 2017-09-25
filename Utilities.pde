
// Filters
// PImage getPoster(PImage original, ArrayList<Integer> colors, int darkLimit)
// PImage filterDarksAndLights(PImage original, int lightLevel, int darkLevel)
// PImage selectColor(PImage original, color toSelect)

// PImage getColorsToAdd(PImage current, PImage goal)
// PImage removeBlack(PImage original) 

// Functions
// color getColorDiff(color c0, color c1)
// PVector removeBlack(PVector colorVector)
// PVector getColorVector(color c)
// color getSwatchColor(PImage swatch, int tolerance)

// General
// color getPixel(PImage imageToUse, int x, int y)
// void setPixel(PImage imageToUse, int x, int y, color c)
// int getBrightness(color c)
// void printColor(color c)

public static enum FilterOption {
  VALUE, TEMPERATURE
};

public class Filter {
  
  public FilterOption filterOption;
  public PImage filterIcon, filterIconShade;
  public Button filterButton;
  public PVector location;
  
  public Filter(String iconFile, PVector location, int id) {
    filterIcon = loadImage("imgs/" + iconFile + ".png");
    filterIconShade = loadImage("imgs/" + iconFile + "_shade.png");
    this.location = location;
    
    PImage[] imgs = {filterIcon, filterIconShade, filterIconShade};
    
    filterButton = cp5.addButton("filter"+id)
       .setValue(0)
       .setCaptionLabel("")
       .setImages(imgs)
       .setPosition(location.x,location.y)
       .setSize(20,20)
       ;
  }
  
  public PImage apply(PImage inputImage) {
    
    switch (filterOption) {
      case VALUE:  
        println("value");
        break;
      case TEMPERATURE:  
        println("temp");
        break;
    }
    
    return inputImage;
  }
  
  
  
}

PImage selectColor(PImage imageToProcess, color toSelect, int opacityOfRest, boolean showColorDiff, boolean showValueDiff) {
  PImage processed = imageToProcess.copy();
  processed.loadPixels();
  original.loadPixels();

  println(printColorString(toSelect));

  for (int y = 0; y < processed.height; y++) {
    for (int x = 0; x < processed.width; x++) {
      color c = getPixel(processed, x, y);
      
      if (showColorDiff) { 
        if (c != toSelect) {
          PVector cV = getColorVector(c);
          setPixel(processed, x, y, color(0, 0, 0, 255));
        } else {
          color originalColor = getPixel(original, x, y);
          color toShow = getColorDiff(originalColor, toSelect);
          setPixel(processed, x, y, toShow);
        }
      } else if (showValueDiff) {
        if (c != toSelect) {
          PVector cV = getColorVector(c);
          setPixel(processed, x, y, color(cV.x, cV.y, cV.z, opacityOfRest));
        } else {
          color originalColor = getPixel(original, x, y);
          color shadeColor = getColorDiff(originalColor, toSelect);
          color toShow = applyShade(toSelect, shadeColor);
          setPixel(processed, x, y, toShow);
        }
      } else {
        if (c != toSelect) {
          PVector cV = getColorVector(c);
          setPixel(processed, x, y, color(cV.x, cV.y, cV.z, opacityOfRest));
        }
      }
    }
  }
 
  processed.updatePixels();
  return processed;
}

color applyShade(color toShade, color shade) {
  int shadeValue = 255 - getBrightness(shade);
  PVector colorVector = getColorVector(toShade);
  return color(max(0, colorVector.x-shadeValue), max(0, colorVector.y-shadeValue), max(0, colorVector.z-shadeValue));
}

boolean isColorEqual(color c0, color c1) {
  float r0 = c0 >> 16 & 0xFF;  // Very fast to calculate red
  float g0 = c0 >> 8 & 0xFF;  // Very fast to calculate green
  float b0 = c0 & 0xFF; // Very fast to calculate blue  
  
  float r1 = c1 >> 16 & 0xFF;  // Very fast to calculate red
  float g1 = c1 >> 8 & 0xFF;  // Very fast to calculate green
  float b1 = c1 & 0xFF; // Very fast to calculate blue  
  
  //if ((abs(r1-r0) + abs(g1-g0) + abs(b1-b0)) < 10) {
  //  println(printColorString(c0));
  //}
  
  return (r1 == r0) && (g1 == g0) && (b1 == b0);
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

color getPixel(PImage imageToUse, int x, int y) {
  return imageToUse.pixels[(y*imageToUse.width)+x];
}

void setPixel(PImage imageToUse, int x, int y, color c) {
  imageToUse.pixels[(y*imageToUse.width)+x] = c;
}

PImage removeBlack(PImage original) {
  PImage processed = original.copy();
  processed.loadPixels();

  for (int y = 0; y < processed.height; y++) {
    for (int x = 0; x < processed.width; x++) {
      color c = getPixel(processed, x, y);
      PVector colorVector = getColorVector(c);
      PVector processedVector = removeBlack(colorVector);
      setPixel(processed, x, y, color(processedVector.x, processedVector.y, processedVector.z));
    }
  }
 
  processed.updatePixels();
  return processed;
}

PImage filterDarksAndLights(PImage original, int lightLevel, int darkLevel) {
  PImage processed = original.copy();
  processed.loadPixels();

  for (int y = 0; y < processed.height; y++) {
    for (int x = 0; x < processed.width; x++) {
      color c = getPixel(processed, x, y);
      float brightnessLevel = brightness(c);
      
      if (brightnessLevel >= lightLevel || brightnessLevel <= darkLevel) {
        setPixel(processed, x, y, color(255, 255, 255, 0));
      }
      
    }
  }
 
  processed.updatePixels();
  return processed;
}

PVector getColorVector(color c) {
  float r = c >> 16 & 0xFF;  // Very fast to calculate red
  float g = c >> 8 & 0xFF;  // Very fast to calculate green
  float b = c & 0xFF; // Very fast to calculate blue
  
  return new PVector(r, g, b);
}

PVector removeBlack(PVector colorVector) {
  float r = colorVector.x;
  float g = colorVector.y;
  float b = colorVector.z;
  // remove black
  float minValue;
  if (r > g && r > b) {
    minValue = r;
  } else if (g > b) {
    minValue = g;
  } else {
    minValue = b;
  }
  float offset = 255 - minValue;
  r = r + offset;
  g = g + offset;
  b = b + offset;
  
  return new PVector(r, g, b);
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

// Given an image, return a version of that image with every pixel mapped to the closest color from the supplied pallette
PImage getPoster(PImage original, ArrayList<Integer> colors, int darkLimit) {
  if (original == null || colors == null || colors.size() <= 0) {
    return null;
  }
  
  PImage poster = original.copy();
  poster.loadPixels();
  
  ArrayList<PVector> pickedColorVectors = new ArrayList<PVector>();
  for (color pickedColor : colors) {
    PVector colorVector = getColorVector(pickedColor);
    pickedColorVectors.add(colorVector);
  }
  
  for (int y = 0; y < poster.height; y++) {
    for (int x = 0; x < poster.width; x++) {
      color c = getPixel(poster, x, y);
      
      // remove really dark areas, doesn't matter what is below
      if (getBrightness(c) < darkLimit) {
        //setPixel(poster, x, y, color(255));
        continue;
      }
      
      PVector colorVector = getColorVector(c);
      
      int closestMatchIndex = 0;
      float minAngle = 90;
      float minDistance = 1000;
      float minAngleAndDistanceAverage = 10000;
      float distanceWeight = 0.00001;
      for (int i = 0; i < pickedColorVectors.size(); i++) {
        PVector pickedColorVector = pickedColorVectors.get(i);
        float angleBetween = abs(PVector.angleBetween(colorVector, pickedColorVector));
        float distanceBetween = PVector.dist(colorVector, pickedColorVector);
        float angleAndDistanceAverage = sq(sqrt(angleBetween) + sqrt(distanceBetween*distanceWeight));
        
        //if (angleBetween < minAngle) {
        //  minAngle = angleBetween;
        //  closestMatchIndex = i;
        //}
        //if (distanceBetween < minDistance) {
        //  minDistance = distanceBetween;
        //  closestMatchIndex = i;
        //}
        if (angleAndDistanceAverage < minAngleAndDistanceAverage) {
          minAngleAndDistanceAverage = angleAndDistanceAverage;
          closestMatchIndex = i;
        }
      }
      
      // Set pixel to closest color profile
      setPixel(poster, x, y, colors.get(closestMatchIndex));
    }
  }
  
  poster.updatePixels();
  return poster;
}

public void printColor(color c) {
    text(printColorString(c), 0, 0);
}

public String printColorString(color c) {
    return "R: " + red(c) + ", G: " + green(c) + ", B: " + blue(c);
}

PImage getColorsToAdd(PImage current, PImage goal) {
  if (current == null || goal == null || current.width <= 0 || current.height <= 0) {
    return null;
  }
  
  PImage colorsToAdd = goal.copy();
  colorsToAdd.resize(current.width, current.height);
  
  colorsToAdd.loadPixels();
  current.loadPixels();
  
  for (int i = 0; i < colorsToAdd.height; i++) {
    for (int j = 0; j < colorsToAdd.width; j++) {
      color c0 = colorsToAdd.pixels[(i*colorsToAdd.width)+j];
      color c1 = current.pixels[(i*current.width)+j];
      
      // ignore really dark areas, doesn't matter what is below
      if (getBrightness(c0) < 50) {
        continue;
      }
      
      color colorToAdd = getColorDiff(c0, c1);
      colorsToAdd.pixels[(i*colorsToAdd.width)+j] = colorToAdd;
    }
  }
  
  colorsToAdd.updatePixels();
  return colorsToAdd;
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