abstract public class Filter {
  public Button button;
  protected PVector location;
  protected int id;
  public String iconFile;
  public PImage filterIcon, filterIconShade;
  public PImage[] iconImages;
  
  public Filter(PVector location, int id) {
    this.location = location;
    this.id = id;
    
    filterIcon = loadImage("imgs/" + getIconFilename() + ".png");
    filterIconShade = loadImage("imgs/" + getIconFilename() + "_shade.png");
    
    PImage[] iconImages = {filterIcon, filterIconShade, filterIconShade};
    this.iconImages = iconImages;
    
    button = cp5.addButton("filter"+id)
       .setValue(0)
       .setCaptionLabel("")
       .setImages(iconImages)
       .setPosition(location.x,location.y)
       .setSize(20,20)
       ;
  }
  
  public void apply(PGraphics pg, float opacity) {} 
  public void drawEditPanel() {}
  public void showEditPanel() {}
  public void hideEditPanel() {}
  public void onMouseClicked() {}
  abstract public String getIconFilename();
}

public class ValueFilter extends Filter {
  
  private ArrayList<Slider> thresholdSliders;
  
  public ValueFilter(PVector location, int id) {
    super(location, id);
    
    int numThresholds = 5;
    thresholdSliders = new ArrayList<Slider>();
    
    int valueSegment = (int) 255.0/numThresholds;
    
    for (int i = 0; i < numThresholds; i++) {
      Slider thresholdSlider = cp5.addSlider("thresholds_"+id+"_"+i)
       .setPosition(location.x + 50, location.y + (i*20*1.5))
       .setSize(100,20)
       .setRange(0,255)
       .setValue(i*valueSegment)
       .setCaptionLabel("")
       .setNumberOfTickMarks(64)
       ;
      thresholdSlider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
      thresholdSlider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
      thresholdSlider.hide();
      thresholdSliders.add(thresholdSlider);
    }
  }
  
  public void apply(PGraphics pg, float opacity) {
    println("value");
    ArrayList<Integer> thresholds = new ArrayList<Integer>();
    for (Slider s : thresholdSliders) {
      thresholds.add(Math.round(s.getValue()));
    }
    
    PImage compressed = compressValueFilter(original, thresholds);
    PImage transpg = removeWhite(compressed);
    PImage adjtranspg = transparencyFilter(transpg, opacity);
    pg.image(adjtranspg, 0, 0);
  }
  
  public void showEditPanel() {
    for (Slider s : thresholdSliders) {
      s.show();
    }
  }
  
  public void hideEditPanel() {
    for (Slider s : thresholdSliders) {
      s.hide();
    }
  }
  
  public String getIconFilename() {
    return "value_study";
  }
}

public class TemperatureFilter extends Filter {
  
  public TemperatureFilter(PVector location, int id) {
    super(location, id);
  }
  
  public void apply(PGraphics pg, float opacity) {
    println("temp");
    pg.image(temperatureFilter(pg), 0, 0);
  }
  
  public String getIconFilename() {
    return "warm_cool";
  }
}

abstract public class PosterFilter extends Filter {
  protected ArrayList<Integer> pickedColors;
  protected PImage poster;
  protected String pickedColorsFilename;
  protected PImage swatch;
  protected color swatchColor;
  
  public PosterFilter(PVector location, int id) {
    super(location, id);
    
    pickedColorsFilename = getPickedColorsFilename();
    loadPickedColors();
    poster = loadImage(getPosterFilename());
  }
  
  public void apply(PGraphics pg, float opacity) {
    if (poster != null) {
      PGraphics buffer = createGraphics(400, 300);
      buffer.beginDraw();
      buffer.image(poster, 0, 0);
      PImage transpg = removeWhite(buffer);
      PImage adjtranspg = transparencyFilter(transpg, opacity);
      buffer.endDraw();
      pg.image(adjtranspg, 0, 0);
      println("poster");
    }
  }
  
  protected void loadPickedColors() {
    Object o = loadObject(pickedColorsFilename);
    if (o != null) {
      pickedColors = (ArrayList<Integer>) o;
    } else {
      pickedColors = new ArrayList<Integer>();
    }
  }
  
  protected Object loadObject(String filename) {
    Object obj = null;
    // read it back in
    try {
      FileInputStream f=new FileInputStream(filename);
      ObjectInputStream o=new ObjectInputStream(f);
      obj = o.readObject();
      o.close(); 
    } catch (Exception e) {
      println(e);
    }  
    
    return obj;
  }
  
  protected void savePickedColors() {
    try {
        // serialise an object to disc..
      FileOutputStream f=new FileOutputStream(pickedColorsFilename);
      ObjectOutputStream o=new ObjectOutputStream(f);
      o.writeObject(pickedColors);
      o.close();
    } catch (Exception e) { // The object "e" is the exception object that was thrown.
        // this is where you handle it if an error occurs
        println(e);
    }
  }
  
  protected void drawPickedColors() {
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
  
  protected void readSwatch(int swatchSize, int swatchTolerance) {
    swatch = mouseHover.get((int) (10-(swatchSize*0.5)), (int) (10-(swatchSize*0.5)), swatchSize, swatchSize);
    swatchColor = getSwatchColor(swatch, swatchTolerance);
  }
  
  protected void drawSwatchSelection(int swatchSize) {
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
  
  abstract public void makePoster();
  abstract public String getPickedColorsFilename();
  abstract public String getPosterFilename();
}

public class DarksPosterFilter extends PosterFilter {
  Button makePosterButton;
  Slider swatchSizeSlider, swatchToleranceSlider, darkFilterSlider, lightFilterSlider;
  
  public DarksPosterFilter(PVector location, int id) {
    super(location, id);
  
    swatchSize_d = 10;
    swatchTolerance_d = 30;
    lightFilter_d = 70;
    darkFilter_d = 0;
    
    loadPickedColors();
    
    makePosterButton = cp5.addButton("makePoster_d")
     .setCaptionLabel("Make Poster")
     .setPosition(editLocation.x + 250, editLocation.y + 250)
     .setSize(80, 30)
     ;
    makePosterButton.hide();
    
    swatchSizeSlider = cp5.addSlider("swatchSize_d")
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
    
    swatchToleranceSlider = cp5.addSlider("swatchTolerance_d")
     .setPosition(editLocation.x + 400, editLocation.y + 70)
     .setSize(100,20)
     .setRange(1,50)
     .setCaptionLabel("Tolerance")
     .setColorCaptionLabel(color(0))
     .setColorValueLabel(color(0))
     .setNumberOfTickMarks(50)
     ;
    swatchToleranceSlider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    swatchToleranceSlider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    swatchToleranceSlider.hide();
    
    lightFilterSlider = cp5.addSlider("lightFilter_d")
     .setPosition(editLocation.x + 400, editLocation.y + 110)
     .setSize(100,20)
     .setRange(0,255)
     .setValue(60)
     .setCaptionLabel("Lights")
     .setColorCaptionLabel(color(0))
     .setColorValueLabel(color(0))
     .setNumberOfTickMarks(256)
     ;
    lightFilterSlider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    lightFilterSlider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    lightFilterSlider.hide();
    
    darkFilterSlider = cp5.addSlider("darkFilter_d")
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
    PImage filtered = valueFilter(original, lightFilter_d, darkFilter_d);
    image(filtered, 0, 0, 200, 150);
    if (poster != null) {
      image(poster, 0, 180, 200, 150);
    }
    popMatrix();
    
    pushMatrix();
    translate(260, 30);
    drawSwatchSelection(swatchSize_d);
    popMatrix();
    
    pushMatrix();
    translate(600, 30);
    drawPickedColors();
    popMatrix();
    
    popMatrix();
    
    readSwatch(swatchSize_d, swatchTolerance_d);
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
    poster = posterFilter(original, pickedColors, lightFilter_d, darkFilter_d);
    poster.save(getPosterFilename());
  }
  
  public String getPickedColorsFilename() {
    return "pickedColors_d.ser";
  }
  
  public String getPosterFilename() {
    return "poster_d.png";
  }
  
  public String getIconFilename() {
    return "darks_poster";
  }
}

public class LightsPosterFilter extends PosterFilter {
  Button makePosterButton;
  Slider swatchSizeSlider, swatchToleranceSlider, darkFilterSlider;
  
  public LightsPosterFilter(PVector location, int id) {
    super(location, id);
  
    swatchSize = 10;
    swatchTolerance = 30;
    darkFilter = 0;
    
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
     .setRange(1,50)
     .setCaptionLabel("Tolerance")
     .setColorCaptionLabel(color(0))
     .setColorValueLabel(color(0))
     .setNumberOfTickMarks(50)
     ;
    swatchToleranceSlider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    swatchToleranceSlider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    swatchToleranceSlider.hide();
    
    darkFilterSlider = cp5.addSlider("darkFilter")
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
  
  public void drawEditPanel() {
    pushMatrix();
    translate(editLocation.x, editLocation.y);
    
    pushMatrix();
    translate(30, 30);
    PImage filtered = valueFilter(original, 255, darkFilter);
    image(filtered, 0, 0, 200, 150);
    if (poster != null) {
      image(poster, 0, 180, 200, 150);
    }
    popMatrix();
    
    pushMatrix();
    translate(260, 30);
    drawSwatchSelection(swatchSize);
    popMatrix();
    
    pushMatrix();
    translate(600, 30);
    drawPickedColors();
    popMatrix();
    
    popMatrix();
    
    readSwatch(swatchSize, swatchTolerance);
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
  
  public void makePoster() {
    poster = posterFilter(original, pickedColors, 255, darkFilter);
    poster.save(getPosterFilename());
  }
  
  public String getPickedColorsFilename() {
    return "pickedColors.ser";
  }
  
  public String getPosterFilename() {
    return "poster.png";
  }
  
  public String getIconFilename() {
    return "lights_poster";
  }
}

public class MediumsPosterFilter extends PosterFilter {
  Button makePosterButton;
  Slider swatchSizeSlider, swatchToleranceSlider, darkFilterSlider, lightFilterSlider;
  
  public MediumsPosterFilter(PVector location, int id) {
    super(location, id);
  
    swatchSize_m = 10;
    swatchTolerance_m = 30;
    lightFilter_m = 120;
    darkFilter_m = 0;
    
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
     .setRange(1,50)
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
     .setValue(120)
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
    PImage filtered = valueFilter(original, lightFilter_m, darkFilter_m);
    image(filtered, 0, 0, 200, 150);
    if (poster != null) {
      image(poster, 0, 180, 200, 150);
    }
    popMatrix();
    
    pushMatrix();
    translate(260, 30);
    drawSwatchSelection(swatchSize_m);
    popMatrix();
    
    pushMatrix();
    translate(600, 30);
    drawPickedColors();
    popMatrix();
    
    popMatrix();
    
    readSwatch(swatchSize_m, swatchTolerance_m);
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
    poster = posterFilter(original, pickedColors, lightFilter_m, darkFilter_m);
    poster.save(getPosterFilename());
  }
  
  public String getPickedColorsFilename() {
    return "pickedColors_m.ser";
  }
  
  public String getPosterFilename() {
    return "poster_m.png";
  }
  
  public String getIconFilename() {
    return "mediums_poster";
  }
}