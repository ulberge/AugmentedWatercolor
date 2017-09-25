public class WorkspaceView extends PApplet {
  
  public PImage currentView;
  public int imageOpacity;
  
  public WorkspaceView(PImage currentView) {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
    this.currentView = currentView;
    this.imageOpacity = 50;
  } 
  
  public void settings() {
    size(900,600);
    //fullScreen(1);
  }

  public void setup() {
  }
  
  public void draw() {
    background(255);
    
    if (currentView != null) {
      float imageAspectRatio = currentView.width/(float) currentView.height;
      float adjustedImageHeight = this.width/imageAspectRatio;
      float margin = (this.height - adjustedImageHeight)/2;
      image(currentView, 400, 150, 400, 300);
    }
    
    fill(255, this.imageOpacity);
    rect(0, 0, this.width, this.height);
  }
  
  public void setCurrentView(PImage currentView) {
    this.currentView = currentView;  
  }
  
}