public class MediumsPosterFilter extends PosterFilter {
  Button makePosterButton;
  Slider swatchSizeSlider, swatchToleranceSlider, darkFilterSlider, lightFilterSlider;
  
  public MediumsPosterFilter(PVector location, int id) {
    super(FilterPrototype.MEDIUMS_POSTER, location, id);
  
    swatchSize_m = 10;
    swatchTolerance_m = 30;
    lightFilter_m = 120;
    darkFilter_m = 20;
    
    loadPickedColors();
    
    makePosterButton = cp5.addButton("makePoster_m")
     .setCaptionLabel("Make Poster")
     .setPosition(editLocation.x + 250, editLocation.y + 250)
     .setSize(80, 30)
     ;
    makePosterButton.hide();
    
    swatchSizeSlider = cp5.addSlider("swatchSize_m")
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
    
    swatchToleranceSlider = cp5.addSlider("swatchTolerance_m")
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
    
    lightFilterSlider = cp5.addSlider("lightFilter_m")
     .setPosition(editLocation.x + 400, editLocation.y + 110)
     .setSize(100,20)
     .setRange(0,255)
     .setValue(200)
     .setCaptionLabel("Lights")
     .setColorCaptionLabel(color(0))
     .setColorValueLabel(color(0))
     .setNumberOfTickMarks(256)
     ;
    lightFilterSlider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    lightFilterSlider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    lightFilterSlider.hide();
    
    darkFilterSlider = cp5.addSlider("darkFilter_m")
     .setPosition(editLocation.x + 400, editLocation.y + 150)
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
  
  public void drawEditPanel() {
    pushMatrix();
    translate(editLocation.x, editLocation.y);
    
    pushMatrix();
    translate(30, 30);
    PImage filtered = filterDarksAndLights(original, lightFilter_m, darkFilter_m);
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
  
  public void showEditPanel() {
    makePosterButton.show();
    swatchSizeSlider.show();
    swatchToleranceSlider.show();
    darkFilterSlider.show();
    lightFilterSlider.show();
    
  }
  
  public void hideEditPanel() {
    makePosterButton.hide();
    swatchSizeSlider.hide();
    swatchToleranceSlider.hide();
    darkFilterSlider.hide();
    lightFilterSlider.hide();
  }
  
  public void makePoster() {
    poster = getPoster(original, pickedColors, lightFilter_m, darkFilter_m);
    poster.save(getPosterFilename());
  }
  
  public String getPickedColorsFilename() {
    return "pickedColors_m.ser";
  }
  
  public String getPosterFilename() {
    return "poster_m.png";
  }
}