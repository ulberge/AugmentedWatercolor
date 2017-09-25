public class Stage0 extends Stage {
  
  Button makePosterButton;
  Slider swatchSizeSlider, swatchToleranceSlider, darkFilterSlider, darkFilterSlider2;
  
  public Stage0() {
    makePosterButton = cp5.addButton("makePoster")
     .setCaptionLabel("Make Poster")
     .setPosition((int) (0.8*width), (int) (0.4*height) + 40)
     .setSize(80, 30)
     ;
    makePosterButton.hide();
    
    swatchSizeSlider = cp5.addSlider("swatchSize")
     .setPosition((int) 4 + (0.5*width), (int) (0.5*height))
     .setSize(200,20)
     .setRange(1,30)
     .setCaptionLabel("Size")
     .setColorCaptionLabel(color(0))
     .setColorValueLabel(color(0))
     .setNumberOfTickMarks(30)
     ;
    swatchSizeSlider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    swatchSizeSlider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    swatchSizeSlider.hide();
    
    swatchToleranceSlider = cp5.addSlider("swatchTolerance")
     .setPosition((int) 4 + (0.5*width), (int) (0.5*height) + 40)
     .setSize(200,20)
     .setRange(1,100)
     .setCaptionLabel("Tolerance")
     .setColorCaptionLabel(color(0))
     .setColorValueLabel(color(0))
     .setNumberOfTickMarks(100)
     ;
    swatchToleranceSlider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    swatchToleranceSlider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    swatchToleranceSlider.hide();
    
    darkFilterSlider = cp5.addSlider("darkFilter0")
     .setPosition((int) 4 + (0.5*width), (int) (0.5*height) + 80)
     .setSize(200,20)
     .setRange(0,255)
     .setCaptionLabel("Darks")
     .setColorCaptionLabel(color(0))
     .setColorValueLabel(color(0))
     .setNumberOfTickMarks(256)
     ;
    darkFilterSlider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    darkFilterSlider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    darkFilterSlider.hide();
    
    darkFilterSlider2 = cp5.addSlider("darkFilter02")
     .setPosition((int) 4 + (0.5*width), (int) (0.5*height) + 120)
     .setSize(200,20)
     .setRange(0,255)
     .setCaptionLabel("Darks")
     .setColorCaptionLabel(color(0))
     .setColorValueLabel(color(0))
     .setNumberOfTickMarks(256)
     ;
    darkFilterSlider2.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    darkFilterSlider2.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    darkFilterSlider2.hide();
  }
  
  public void onShow() {
    makePosterButton.show();
    swatchSizeSlider.show();
    swatchToleranceSlider.show();
    darkFilterSlider.show();
    darkFilterSlider2.show();
  }
  
  public void onHide() {
    makePosterButton.hide();
    swatchSizeSlider.hide();
    swatchToleranceSlider.hide();
    darkFilterSlider.hide();
    darkFilterSlider2.hide();
  }
  
  public void draw() {
    background(255);
    
    //image(original, 0, 0, width/2.0, height/2.0);
    
    PImage filtered = filterDarksAndLights(original, 255, darkFilter0);
    image(filtered, 0, 0, 400, 300);
    
    pushMatrix();
    translate(700, 0);
    int colorSize = 20;
    for (color c : pickedColors) {
      fill(c);
      stroke(0);
      rect(0, 0, colorSize, colorSize);
      pushMatrix();
      translate(colorSize + 10, 2);
      textAlign(LEFT,TOP);
      printColor(c);
      popMatrix();
      translate(0, colorSize);
    }
    popMatrix();
    
    drawSwatchSelection();
    
    if (poster != null) {
      PImage filtered2 = filterDarksAndLights(poster, 255, darkFilter02);
      image(filtered2, 0, 300, 400, 300);
      //PImage filtered2 = filterDarksAndLights(original, darkFilter0, darkFilter02);
      //tint(255, 130);
      //image(filtered2, 0, height/2.0, width/2.0, height/2.0);
      //tint(255, 255);
    }
  
    readSwatch();
  }
  
  private void drawSwatchSelection() {
    if (swatch != null) {
      pushMatrix();
      translate(400, 0);
      
      if (mouseHover != null) {
        image(mouseHover, 0, 0, width/4.0, height/4.0);
        stroke(0);
        noFill();
        int targetSize = swatchSize*8;
        rect(-targetSize + width/8.0, -targetSize + height/8.0, targetSize*2, targetSize*2);
      }
      
      translate(0, height/4.0);
      image(swatch, 0, 0, width/8.0, height/8.0);
      fill(swatchColor);
      noStroke();
      rect(width/8.0, 0, -1 + width/8.0, -1 + height/8.0);
      fill(0);
      pushMatrix();
      translate(10, height/8.0 + 10);
      textAlign(LEFT,TOP);
      printColor(swatchColor);
      popMatrix();
      popMatrix();
    }
  }
  
  private void readSwatch() {
    swatch = get(mouseX-swatchSize, mouseY-swatchSize, swatchSize*2, swatchSize*2);
    swatchColor = getSwatchColor(swatch, swatchTolerance);
  }
  
  public void onMouseClick() {
    boolean isAdd = true;
    color selectedColor = get(mouseX, mouseY);
    for(int i = pickedColors.size() - 1; i >= 0; i--) {
      if (pickedColors.get(i) == selectedColor) {
        pickedColors.remove(i);
        savePickedColors();
        isAdd = false;
      }
    }
    
    if (isAdd && (brightness(selectedColor) < 254)) {
      pickedColors.add(swatchColor);
      savePickedColors();
    }
  }
  
  public void onKeyPressed() {
  }
}