public enum FilterPrototype {
  VALUE("value_study"), TEMPERATURE("warm_cool"), LIGHTS_POSTER("lights_poster"), MEDIUMS_POSTER("mediums_poster"), DARKS_POSTER("darks_poster");
  
  public final String iconFile;
  FilterPrototype(String iconFile) {
    this.iconFile = iconFile;
  }
};

public class FilterType {
  public PImage filterIcon, filterIconShade;
  public PImage[] iconImages;
  FilterPrototype prototype;
  
  public FilterType(FilterPrototype prototype) {
    this.prototype = prototype;
    filterIcon = loadImage("imgs/" + prototype.iconFile + ".png");
    filterIconShade = loadImage("imgs/" + prototype.iconFile + "_shade.png");
    
    PImage[] iconImages = {filterIcon, filterIconShade, filterIconShade};
    this.iconImages = iconImages;
  } 
};

public class Layer {
  CustomFilter filter;
  public Button button;
  public PVector location;
  public int id;
  
  public Layer(PVector location, int id) {
    this.location = location;
    this.id = id;
    
    button = cp5.addButton("layer"+id)
       .setValue(0)
       .setCaptionLabel("")
       .setColorBackground(#FFFFFF)
       .setPosition(location.x,location.y)
       .setSize(20,20)
       ;
    button.hide();
  }
  
  public void setFilter(CustomFilter filter) {
    if (filter != null) {
      button.setImages(filter.filterType.iconImages);
      button.show();
    } else {
      button.hide();
    }
    this.filter = filter;
  }
}

public class CustomFilter {
  FilterType filterType;
  public Button button;
  protected PVector location;
  protected int id;
  
  public CustomFilter(FilterType filterType, PVector location, int id) {
    this.filterType = filterType;
    this.location = location;
    this.id = id;
    
    button = cp5.addButton("filter"+id)
       .setValue(0)
       .setCaptionLabel("")
       .setImages(filterType.iconImages)
       .setPosition(location.x,location.y)
       .setSize(20,20)
       ;
  }
  
  public PImage apply(PImage inputImage) {
    return inputImage;
  } 
  
  public void drawEditPanel() {}
  public void showEditPanel() {}
  public void hideEditPanel() {}
  public void onMouseClicked() {}
}

public class ValueFilter extends CustomFilter {
  
  private ArrayList<Slider> thresholdSliders;
  
  public ValueFilter(PVector location, int id) {
    super(new FilterType(FilterPrototype.VALUE), location, id);
    
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
  
  public PImage apply(PImage inputImage) {
    println("value");
    ArrayList<Integer> thresholds = new ArrayList<Integer>();
    for (Slider s : thresholdSliders) {
      thresholds.add(Math.round(s.getValue()));
    }
    return valueFilter(inputImage, thresholds);
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
}

public class TemperatureFilter extends CustomFilter {
  
  public TemperatureFilter(PVector location, int id) {
    super(new FilterType(FilterPrototype.TEMPERATURE), location, id);
  }
  
  public PImage apply(PImage inputImage) {
    println("temp");
    return temperatureFilter(inputImage);
  }
}