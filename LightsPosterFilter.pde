public class LightsPosterFilter extends CustomFilter {
  Button makePosterButton;
  Slider swatchSizeSlider, swatchToleranceSlider, darkFilterSlider;
  
  public LightsPosterFilter(PVector location, int id) {
    super(new FilterType(FilterPrototype.POSTER), location, id);
    
    makePosterButton = cp5.addButton("makePoster")
     .setCaptionLabel("Make Poster")
     .setPosition(editLocation.x + 250, editLocation.y + 250)
     .setSize(80, 30)
     ;
    makePosterButton.hide();
    
    swatchSizeSlider = cp5.addSlider("swatchSize")
     .setPosition(editLocation.x + 400, editLocation.y + 30)
     .setSize(100,20)
     .setRange(1,20)
     .setCaptionLabel("Size")
     .setColorCaptionLabel(color(0))
     .setColorValueLabel(color(0))
     .setNumberOfTickMarks(100)
     ;
    swatchSizeSlider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    swatchSizeSlider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    swatchSizeSlider.hide();
    
    swatchToleranceSlider = cp5.addSlider("swatchTolerance")
     .setPosition(editLocation.x + 400, editLocation.y + 70)
     .setSize(100,20)
     .setRange(1,500)
     .setCaptionLabel("Tolerance")
     .setColorCaptionLabel(color(0))
     .setColorValueLabel(color(0))
     .setNumberOfTickMarks(50)
     ;
    swatchToleranceSlider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    swatchToleranceSlider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    swatchToleranceSlider.hide();
    
    darkFilterSlider = cp5.addSlider("darkFilter0")
     .setPosition(editLocation.x + 400, editLocation.y + 110)
     .setSize(100,20)
     .setRange(0,255)
     .setCaptionLabel("Darks")
     .setColorCaptionLabel(color(0))
     .setColorValueLabel(color(0))
     .setNumberOfTickMarks(256)
     ;
    darkFilterSlider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    darkFilterSlider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    darkFilterSlider.hide();
  }
  
  public PImage apply(PImage inputImage) {
    println("poster");
    return poster.copy();
  }
  
  public void drawEditPanel() {
    pushMatrix();
    translate(editLocation.x, editLocation.y);
    
    pushMatrix();
    translate(30, 30);
    PImage filtered = filterDarksAndLights(original, 255, darkFilter0);
    image(filtered, 0, 0, 200, 150);
    if (poster != null) {
      image(poster, 0, 180, 200, 150);
    }
    popMatrix();
    
    pushMatrix();
    translate(260, 30);
    drawSwatchSelection();
    popMatrix();
    
    pushMatrix();
    translate(600, 30);
    drawPickedColors();
    popMatrix();
    
    popMatrix();
    
    readSwatch();
  }
  
  private void drawPickedColors() {
    int colorSize = 20;
    for (color c : pickedColors) {
      fill(c);
      stroke(0);
      rect(0, 0, colorSize, colorSize);
      pushMatrix();
      translate(colorSize + 10, 8);
      if (getBrightness(c) > 200) {
        fill(0);  
      }
      printColor(c);
      popMatrix();
      translate(0, colorSize);
    }
  }
  
  private void readSwatch() {
    swatch = mouseHover.get((int) (10-(swatchSize*0.5)), (int) (10-(swatchSize*0.5)), swatchSize, swatchSize);
    swatchColor = getSwatchColor(swatch, swatchTolerance);
  }
  
  private void drawSwatchSelection() {
    if (swatch != null) {
      if (mouseHover != null) {
        image(mouseHover, 0, 0, 100, 100);
        stroke(0);
        noFill();
        int targetSize = 5*swatchSize;
        rect(49-(targetSize*0.5), 49-(targetSize*0.5), targetSize+1, targetSize+1);
      }
      
      translate(0, 101);
      image(swatch, 0, 0, 50, 50);
      fill(swatchColor);
      noStroke();
      rect(50, 0, 50, 50);
      
      translate(0, 60);
      printColor(swatchColor);
    }
  }
  
  public void showEditPanel() {
    makePosterButton.show();
    swatchSizeSlider.show();
    swatchToleranceSlider.show();
    darkFilterSlider.show();
  }
  
  public void hideEditPanel() {
    makePosterButton.hide();
    swatchSizeSlider.hide();
    swatchToleranceSlider.hide();
    darkFilterSlider.hide();
  }
  
  public void onMouseClicked() {
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
}

  