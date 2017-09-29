public final PVector editLocation = new PVector(100, 300);

public class MainView extends Stage {
  
  PImage currentView;
  int layerSquareSize = 20;
  ArrayList<Filter> filters;
  ArrayList<Layer> layers;
  ArrayList<Slider> layerSliders;
  Filter activeFilter;
  Slider layer0Slider, layer1Slider, layer2Slider, layer3Slider, layer4Slider;
  
  public MainView() {
    currentView = null;
    activeFilter = null;
    
    filters = new ArrayList<Filter>();
    filters.add(new ValueFilter(new PVector(50, 371), 0));
    filters.add(new TemperatureFilter(new PVector(50, 401), 1));
    filters.add(lightsFilter);
    filters.add(mediumsFilter);
    filters.add(darksFilter);
    
    layers = new ArrayList<Layer>();
    for (int i = 0; i < 5; i++) {
      layers.add(new Layer(new PVector(450, 56+(layerSquareSize*i*1.5)), i));
    }
    
    addSliders();
  }
  
  public void draw() {
    background(255);
    
    // preview
    if (currentView != null) {
      image(currentView, 0, 0, 400, 300);
    }
    
    // drag and drop layers area
    pushMatrix();
    translate(450, 35);
    fill(0);
    text("Layers", 0, 0);
    translate(-1, 20);
    for (int i = 0; i < 5; i++) {
      stroke(0);
      fill(255);
      rect(0, 0, layerSquareSize+1, layerSquareSize+1);
      translate(0, layerSquareSize*1.5);
    }
    popMatrix();
    
    pushMatrix();
    translate(50, 350);
    fill(0);
    text("Filters", 0, 0);
    translate(-1, 20);
    for (int i = 0; i < filters.size(); i++) {
      stroke(0);
      fill(255);
      rect(0, 0, layerSquareSize+1, layerSquareSize+1);
      translate(0, layerSquareSize*1.5);
    }
    popMatrix();
    
    // edit layer area
    if (activeFilter != null) {
      pushMatrix();
      noFill();
      strokeWeight(2);
      stroke(30);
      rect(activeFilter.location.x-2, activeFilter.location.y-2, 23, 23);
      strokeWeight(1);
      stroke(0);
      popMatrix();
      
      activeFilter.drawEditPanel();
    }
  }
  
  public void onMouseDragged() {
    updateCurrentView();
  }
  
  public void onMouseClicked() {
    // Pass events to subview
    if (activeFilter != null) {
      activeFilter.onMouseClicked();
    }
    
    // Check custom buttons
    removeLayerIfClicked();
    addAndSelectFilterIfClicked();
    updateCurrentView();
  }
  
  private void addAndSelectFilterIfClicked() {
    for (Filter f : filters) {
      if (f.button.isMouseOver()) {
        addAndSelectFilter(f);
      }
    }
  }
  
  private void addAndSelectFilter(Filter f) {
    if (activeFilter != null) {
      activeFilter.hideEditPanel();
    }
    
    for (Layer l : layers) {
      if (l.filter == f) {
        break;  
      }
      if (l.filter == null) {
        l.setFilter(f);
        break;
      }
    }
    
    f.showEditPanel();
    activeFilter = f;
    
    updateCurrentView();
  }
  
  private void removeLayerIfClicked() {
    Layer prevLayer = null;
    boolean removedFilter = false;
    for (Layer l : layers) {
      if (!removedFilter) {
        if (isMouseOverLocation(l.location, new PVector(layerSquareSize, layerSquareSize))) {
          l.setFilter(null);
          updateCurrentView();
          removedFilter = true;
        }
      } else {
        if (prevLayer != null) {
          prevLayer.setFilter(l.filter);
        }
      }
      prevLayer = l;
    }
  }
  
  public boolean isMouseOverLocation(PVector location, PVector size) {
    return mouseX >= location.x && mouseX <= (location.x+size.x) && mouseY >= location.y && mouseY <= (location.y+size.y);
  }
  
  public void onKeyPressed() {
  }
  
  public void updateCurrentView() {
    //PImage newView = createImage(400, 300, RGB);//getEmptyImage();
    PGraphics pg = createGraphics(400, 300);
    pg.beginDraw();
    for (int i = 0; i < layers.size(); i++) {
      Layer l = layers.get(i);
      if (l.filter != null) {
        float opacity = layerSliders.get(i).getValue();
        l.filter.apply(pg, opacity);
      }
    }
    
    pg.endDraw();
    currentView = pg;
    setWorkspaceViewImage(currentView);
  }
  
  public PImage getEmptyImage() {
    PImage img = createImage(400, 300, RGB);
    img.loadPixels();
    for (int i = 0; i < img.pixels.length; i++) {
      img.pixels[i] = color(255, 255, 255); 
    }
    img.updatePixels();  
    return img;
  }
  
  public void onShow() {
    for (Filter f : filters) {
      f.button.show();
    }
    for (Slider s : layerSliders) {
      s.show();
    }
    setWorkspaceViewImage(currentView);
  }
  
  public void onHide() {
    for (Layer l : layers) {
      l.button.hide();
    }
    for (Filter f : filters) {
      f.button.hide();
    }
    for (Slider s : layerSliders) {
      s.hide();
    }
  }
  
  private void addSliders() {
    layerSliders = new ArrayList<Slider>();
    layer0Slider = cp5.addSlider("layer0Opacity")
     .setPosition(490, 56)
     .setSize(100,20)
     .setRange(1,255)
     .setCaptionLabel("")
     .setNumberOfTickMarks(100)
     ;
    layer0Slider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    layer0Slider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    layer0Slider.hide(); 
    layerSliders.add(layer0Slider);
    
    layer1Slider = cp5.addSlider("layer1Opacity")
     .setPosition(490, 86)
     .setSize(100,20)
     .setRange(1,255)
     .setCaptionLabel("")
     .setNumberOfTickMarks(100)
     ;
    layer1Slider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    layer1Slider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    layer1Slider.hide(); 
    layerSliders.add(layer1Slider); 
    
    layer2Slider = cp5.addSlider("layer2Opacity")
     .setPosition(490, 116)
     .setSize(100,20)
     .setRange(1,255)
     .setCaptionLabel("")
     .setNumberOfTickMarks(100)
     ;
    layer2Slider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    layer2Slider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    layer2Slider.hide();  
    layerSliders.add(layer2Slider);
    
    layer3Slider = cp5.addSlider("layer3Opacity")
     .setPosition(490, 146)
     .setSize(100,20)
     .setRange(1,255)
     .setCaptionLabel("")
     .setNumberOfTickMarks(100)
     ;
    layer3Slider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    layer3Slider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    layer3Slider.hide();  
    layerSliders.add(layer3Slider);
    
    layer4Slider = cp5.addSlider("layer4Opacity")
     .setPosition(490, 176)
     .setSize(100,20)
     .setRange(1,255)
     .setCaptionLabel("")
     .setNumberOfTickMarks(100)
     ;
    layer4Slider.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    layer4Slider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    layer4Slider.hide();  
    layerSliders.add(layer4Slider);
  }
}