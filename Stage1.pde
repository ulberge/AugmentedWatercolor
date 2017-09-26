public class Stage1 extends Stage {
  
  PImage currentView;
  Slider filterOpacitySlider;
  Toggle colorDiffToggle, valueDiffToggle;
  color mouseHoverColor;
  
  public Stage1() {
    currentView = poster;
    
    filterOpacitySlider = cp5.addSlider("opacityOfRest")
     .setPosition((int) 4 + (0.5*width), (int) (0.5*height))
     .setSize(200,20)
     .setRange(0,255)
     .setValue(70)
     .setCaptionLabel("Opacity of Rest")
     .setColorCaptionLabel(color(0))
     .setColorValueLabel(color(0))
     .setNumberOfTickMarks(256)
     ;
    filterOpacitySlider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    filterOpacitySlider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    filterOpacitySlider.hide();
    
    colorDiffToggle = cp5.addToggle("colorDiffIsActive")
     .setPosition(480,350)
     .setSize(50,20)
     .setCaptionLabel("Show Color Diff")
     .setColorCaptionLabel(color(0))
     .setValue(false)
     .setMode(ControlP5.SWITCH)
     ;
    colorDiffToggle.hide();
    
    valueDiffToggle = cp5.addToggle("valueDiffIsActive")
     .setPosition(480,390)
     .setSize(50,20)
     .setCaptionLabel("Show Shade")
     .setColorCaptionLabel(color(0))
     .setValue(false)
     .setMode(ControlP5.SWITCH)
     ;
    valueDiffToggle.hide();
  }
  
  public void draw() {
    background(255);
    
    if (currentView != null) {
      image(currentView, 0, 0, 400, 300);
    }
    
    image(original, 0, 300, 400, 300);
    
    pushMatrix();
    translate(500, 0);
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
    readSwatch();
    pushMatrix();
    fill(0);
    translate(0, 10);
    printColor(mouseHoverColor);
    popMatrix();
    
    popMatrix();
  }
  
  private void readSwatch() {
    mouseHoverColor = get(mouseX, mouseY);
  }
  
  public void onShow() {
    filterOpacitySlider.show();
    colorDiffToggle.show();
    valueDiffToggle.show();
    setCurrentView(poster);
  }
  public void onHide() {
    filterOpacitySlider.hide();
    colorDiffToggle.hide();
    valueDiffToggle.hide();
  }
  
  public void setCurrentView(PImage newView) {
    this.currentView = newView;
    workspaceView.setCurrentView(newView);
    println("test");
    //workspaceView.currentView = original;
  }
  
  public void onMouseClicked() {
    boolean isPickedColor = false;
    color selectedColor = get(mouseX, mouseY);
    for(int i = pickedColors.size() - 1; i >= 0; i--) {
      if (pickedColors.get(i) == selectedColor) {
        isPickedColor = true;
      }
    }
    
    if (isPickedColor) {
      // only show that color in poster
      PImage selectedColorView = selectColor(poster, selectedColor, opacityOfRest, colorDiffIsActive, valueDiffIsActive);
      setCurrentView(selectedColorView);
    } else {
      setCurrentView(poster);
    }
      
  }
  public void onKeyPressed() {}
}