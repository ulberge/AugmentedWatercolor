public class MainView extends Stage {
  
  PImage currentView;
  int layerSquareSize = 20;
  ArrayList<Filter> filters;
  ArrayList<Filter> layers;
  Filter draggingFilter;
  PVector draggingOffset;
  
  public MainView() {
    currentView = original;
    draggingFilter = null;
    
    filters = new ArrayList<Filter>();
    filters.add(new Filter("value_study", new PVector(100, 365), 0));
    filters.add(new Filter("warm_cool", new PVector(100, 395), 1));
    
    filters.get(0).filterOption = FilterOption.VALUE;
    filters.get(1).filterOption = FilterOption.TEMPERATURE;
    
    layers = new ArrayList<Filter>();
    layers.add(filters.get(0));
   
    for (int i = 0; i < 5; i++) {
      cp5.addButton("layerSlot"+i)
       .setValue(0)
       .setCaptionLabel("")
       .setColorBackground(#CCCCCC)
       .setColorActive(#CCCCCC)
       .setColorForeground(#666666)
       .setPosition(501,51+(i*(layerSquareSize+10)))
       .setSize(layerSquareSize,layerSquareSize)
       ;
    }
    
    //cp5.addButton("createFilter")
    // .setValue(0)
    // .setCaptionLabel("Create Filter")
    // .setColorCaptionLabel(#FFFFFF)
    // .setPosition(100, 20)
    // .setSize(80,20)
    // ;
  }
  
  public void draw() {
    background(255);
    
    // preview
    image(currentView, 0, 0, 400, 300);
    
    // drag and drop layers area
    pushMatrix();
    fill(0);
    
    pushMatrix();
    translate(450, 35);
    text("Layers", 0, 0);
    //for (int i = 0; i < 5; i++) {
    //  stroke(0);
    //  fill(255);
    //  rect(0, layerSquareSize*i, layerSquareSize, layerSquareSize);
    //}
    popMatrix();
    
    pushMatrix();
    translate(50, 350);
    text("Filters", 0, 0);
    //translate(0, 15);
    //for (int i = 0; i < filters.size(); i++) {
    //  image(filters.get(i).filterIcon, 0, 0, 20, 20);
    //  translate(0, 30);
    //}
    popMatrix();
    
    popMatrix();
  
    if (draggingFilter != null) {
      pushMatrix();
      tint(255, 100);
      image(draggingFilter.filterIcon, mouseX-50-draggingOffset.x, mouseY-draggingOffset.y, 20, 20);
      tint(255, 255);
      popMatrix();
    }
    
    // edit layer area
    
    // create poster layer
    // create default layer
  }
  
  public void onShow() {
  }
  public void onHide() {
  }
  
  public void onMousePressed() {
    if (draggingFilter == null) {
      for (Filter f : filters) {
        if (f.filterButton.isMouseOver()) {
          draggingFilter = f;
          draggingOffset = new PVector(mouseX - f.location.x, mouseY - f.location.y);
        }
      }
    }
  }
  
  public void onMouseReleased() {
    if (draggingFilter != null) {
      for (Filter f : layers) {
        if (f.filterButton.isMouseOver()) {
          f = draggingFilter;
        }
      }
    }
    draggingFilter = null;
  }
  
  public void onKeyPressed() {
  }
}