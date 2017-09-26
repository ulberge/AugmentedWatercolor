public final PVector editLocation = new PVector(100, 300);

public class MainView extends Stage {
  
  PImage currentView;
  int layerSquareSize = 20;
  ArrayList<CustomFilter> filters;
  ArrayList<Layer> layers;
  CustomFilter draggingFilter;
  PVector draggingOffset;
  CustomFilter activeFilter;
  
  FilterType valueFilter, temperatureFilter;
  
  public MainView() {
    currentView = original;
    draggingFilter = null;
    activeFilter = null;
    
    filters = new ArrayList<CustomFilter>();
    filters.add(new ValueFilter(new PVector(50, 371), 0));
    filters.add(new TemperatureFilter(new PVector(50, 401), 1));
    filters.add(new LightsPosterFilter(new PVector(50, 431), 2));
    
    layers = new ArrayList<Layer>();
    for (int i = 0; i < 5; i++) {
      layers.add(new Layer(new PVector(450, 56+(layerSquareSize*i*1.5)), i));
    }
  }
  
  public void draw() {
    background(255);
    
    // preview
    image(currentView, 0, 0, 400, 300);
    
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
  
    if (draggingFilter != null) {
      pushMatrix();
      tint(255, 100);
      image(draggingFilter.filterType.filterIcon, mouseX-draggingOffset.x, mouseY-draggingOffset.y, layerSquareSize, layerSquareSize);
      tint(255, 255);
      popMatrix();
    }
    
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
    
    // create poster layer
    // create default layer
  }
  
  public void onMouseDragged() {
    updateCurrentView();
  }
  
  //public void onMousePressed() {
  //  if (draggingFilter == null) {
  //    for (CustomFilter f : filters) {
  //      if (f.button.isMouseOver()) {
  //        draggingFilter = f;
  //        draggingOffset = new PVector(mouseX - f.location.x, mouseY - f.location.y);
          
  //        if (activeFilter != null) {
  //          activeFilter.hideEditPanel();
  //        }
  //        f.showEditPanel();
  //        activeFilter = f;
  //        break;
  //      }
  //    }
  //  }
  //}
  
  //public void onMouseReleased() {
  //  if (draggingFilter != null) {
  //    for (Layer l : layers) {
  //      if (isMouseOverLocation(l.location, new PVector(layerSquareSize, layerSquareSize))) {
  //        l.setFilter(draggingFilter);
  //        updateCurrentView();
  //        break;
  //      }
  //    }
  //  }
  //  draggingFilter = null;
  //}
  
  public void onMouseClicked() {
    // Pass events to subview
    if (activeFilter != null) {
      activeFilter.onMouseClicked();
    }
    
    // Check custom buttons
    removeLayerIfClicked();
    addAndSelectFilterIfClicked();
  }
  
  private void addAndSelectFilterIfClicked() {
    for (CustomFilter f : filters) {
      if (f.button.isMouseOver()) {
        if (activeFilter != null) {
          activeFilter.hideEditPanel();
        }
        
        boolean isAdd = true;
        Layer firstEmpty = null;
        for (Layer l : layers) {
          if (l.filter == null && firstEmpty == null) {
            firstEmpty = l;
          } else if (l.filter == f) {
            isAdd = false;
            break;
          }
        }
        
        if (isAdd) {
          if (firstEmpty != null) {
            firstEmpty.setFilter(f);
          }
        }
        f.showEditPanel();
        activeFilter = f;
      }
    }
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
    PImage newView = original.copy();
    for (int i = 0; i < layers.size(); i++) {
      Layer l = layers.get(i);
      if (l.filter != null) {
        newView = l.filter.apply(newView);
      }
    }
    
    currentView = newView;
    setWorkspaceViewImage(currentView);
  }
  
  public void onShow() {
    for (CustomFilter f : filters) {
      f.button.show();
    }
    setWorkspaceViewImage(currentView);
  }
  
  public void onHide() {
    for (Layer l : layers) {
      l.button.hide();
    }
    for (CustomFilter f : filters) {
      f.button.hide();
    }
  }
}