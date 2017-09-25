public class Stage2 extends Stage {
  
  PImage secondLayer;
  Slider lightSlider, darkSlider;
  
  public Stage2() {
    secondLayer = null;
    
    lightSlider = cp5.addSlider("lightFilter")
     .setPosition((int) 4 + (0.5*width), (int) (0.5*height))
     .setSize(200,20)
     .setRange(0,255)
     .setValue(205)
     .setCaptionLabel("Lights")
     .setColorCaptionLabel(color(0))
     .setColorValueLabel(color(0))
     .setNumberOfTickMarks(256)
     ;
    lightSlider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    lightSlider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    lightSlider.hide();
    
    darkSlider = cp5.addSlider("darkFilter")
     .setPosition((int) 4 + (0.5*width), (int) (0.5*height) + 40)
     .setSize(200,20)
     .setRange(0,255)
     .setValue(0)
     .setCaptionLabel("Darks")
     .setColorCaptionLabel(color(0))
     .setColorValueLabel(color(0))
     .setNumberOfTickMarks(256)
     ;
    darkSlider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    darkSlider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    darkSlider.hide();
  }
  
  public void draw() {
    background(255);
    
    image(original, 0, 0, width/3.0, height/3.0);
    image(poster, width/3.0, 0, width/3.0, height/3.0);
    
    //if (poster != null) {
    //  image(poster, width/2.0, 0, width/2.0, height/2.0);
    //}
    
    PImage filtered = filterDarksAndLights(original, lightFilter, darkFilter);
    image(filtered, 2.0*width/3.0, 0, width/3.0, height/3.0);
    
    PImage secondLayer = getColorsToAdd(poster, filtered);
    image(secondLayer, 0, height/2.0, width/2.0, height/2.0);
    setWorkspaceViewImage(secondLayer);
    
    //if (poster != null && secondLayer != null) {
    //  image(poster, width/2.0, height/2.0, width/2.0, height/2.0);
    //  blend(secondLayer, 0, 0, secondLayer.width, secondLayer.height, (int) (width/2.0), (int) (height/2.0), (int) (width/2.0), (int) (height/2.0), ADD);
    //}
    
  }
  
  public void onShow() {
    //secondLayer = getColorsToAdd(poster, original);
    lightSlider.show();
    darkSlider.show();
  }
  public void onHide() {
    lightSlider.hide();
    darkSlider.hide();
  }
  
  public void onMouseClick() {}
  public void onKeyPressed() {}
}