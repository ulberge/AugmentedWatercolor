public PImage temperatureFilter(PImage imageToProcess) {
  PImage processed = imageToProcess.copy();
  processed.loadPixels();
  
  for (int y = 0; y < processed.height; y++) {
    for (int x = 0; x < processed.width; x++) {
      color c = getPixel(processed, x, y);
      float b = getBrightness(c)/255.0;
      float w = getWarmth(c);
      
      color toShow = 0;
      if (w > 0.5) {
        toShow = color((0.75*red(c))+(64*w), 0.75*green(c), 0.75*blue(c));
      } else {
        toShow = color(0.75*red(c), 0.75*green(c), (0.75*blue(c))+(64*(1-w)));
      }
      
      setPixel(processed, x, y, toShow);
    }
  }
  
  return processed;
}

public PImage compressValueFilter(PImage imageToProcess, ArrayList<Integer> thresholds) {
  PImage processed = imageToProcess.copy();
  
  if (thresholds.size() < 1) {
    return processed;
  }
  
  int valueSegment = (int) 255.0/thresholds.size();
  
  processed.loadPixels();
  for (int y = 0; y < processed.height; y++) {
    for (int x = 0; x < processed.width; x++) {
      color c = getPixel(processed, x, y);
      int b = getBrightness(c);
      
      // Default to white
      color toShow = color(255);
      
      // If it is below any threshold, reduce it to the previous threshold
      for (int i = 1; i < thresholds.size(); i++) {
        if (b < thresholds.get(i)) {
          toShow = color((i-1)*valueSegment);
          break;
        }
      }
        
      setPixel(processed, x, y, toShow);
    }
  }
  
  return processed;
}

PImage valueFilter(PImage original, int lightLevel, int darkLevel) {
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

PImage posterFilter(PImage original, ArrayList<Integer> colors, int lightLimit, int darkLimit) {
  if (original == null || colors == null || colors.size() <= 0) {
    return null;
  }
  
  PImage poster = original.copy();
  poster.loadPixels();
  
  for (int y = 0; y < poster.height; y++) {
    for (int x = 0; x < poster.width; x++) {
      color c = getPixel(poster, x, y);
      
      // remove really dark areas, doesn't matter what is below
      int b = getBrightness(c);
      if (b < darkLimit || b > lightLimit) {
        setPixel(poster, x, y, color(255, 255, 255, 0));
        continue;
      }
      
      int matchIndex = getClosestColorIndex(c, colors);
      
      // Set pixel to closest color profile
      setPixel(poster, x, y, colors.get(matchIndex));
    }
  }
  
  poster.updatePixels();
  return poster;
}

PImage subtractionFilter(PImage current, PImage goal) {
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

PImage selectColorFilter(PImage imageToProcess, color toSelect, int opacityOfRest, boolean showColorDiff, boolean showValueDiff) {
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