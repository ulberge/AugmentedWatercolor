import controlP5.*;
import java.io.*;

ControlP5 cp5;

PImage original;
int currentStageIndex;
ArrayList<Stage> stages;

PImage mouseHover;

int swatchSize, swatchTolerance, darkFilter;
int swatchSize_m, swatchTolerance_m, lightFilter_m, darkFilter_m;
int swatchSize_d, swatchTolerance_d, lightFilter_d, darkFilter_d;

int layer0Opacity, layer1Opacity, layer2Opacity, layer3Opacity, layer4Opacity;

PosterFilter lightsFilter, mediumsFilter, darksFilter;

WorkspaceView workspaceView;

public void settings() {
  size(1100, 700);
}

void setup(){
  
  cp5 = new ControlP5(this);
  textAlign(LEFT,CENTER);
  
  original = loadImage("wyeth.jpg");
  original.resize(400,300);
  
  layer0Opacity = 100;
  layer1Opacity = 100;
  layer2Opacity = 100;
  layer3Opacity = 100;
  layer4Opacity = 100;
  
  lightsFilter = new LightsPosterFilter(new PVector(50, 431), 2);
  mediumsFilter = new MediumsPosterFilter(new PVector(50, 461), 3);
  darksFilter = new DarksPosterFilter(new PVector(50, 491), 4);
  
  workspaceView = new WorkspaceView(original);
  mouseHover = null;
  
  stages = new ArrayList<Stage>();
  
  Stage mainView = new MainView();
  stages.add(mainView);
  
  currentStageIndex = 0;
  stages.get(0).onShow();
}

void draw() {
  pushMatrix();
  stages.get(currentStageIndex).draw();
  popMatrix();

  readMouseHover();
}

void mouseDragged() {
  stages.get(currentStageIndex).onMouseDragged();
}

void mouseClicked() {
  stages.get(currentStageIndex).onMouseClicked();
}

void mousePressed() {
  stages.get(currentStageIndex).onMousePressed();
}

void mouseReleased() {
  stages.get(currentStageIndex).onMouseReleased(); //<>// //<>//
}

void keyPressed() {
  stages.get(currentStageIndex).onKeyPressed();
  
  if (keyCode == LEFT) {
    workspaceView.imageOpacity = max(workspaceView.imageOpacity-50, 0);
  }
  if (keyCode == RIGHT) {
    workspaceView.imageOpacity = min(workspaceView.imageOpacity+50, 255);
  }
}

public void previousStage() {
  stages.get(currentStageIndex).onHide();
  currentStageIndex = max(currentStageIndex-1, 0);
  stages.get(currentStageIndex).onShow();
}

public void nextStage() {
  stages.get(currentStageIndex).onHide();
  currentStageIndex = min(currentStageIndex+1, stages.size()-1);
  stages.get(currentStageIndex).onShow();
}

public void makePoster() {
  lightsFilter.makePoster();  
}

public void makePoster_m() {
  mediumsFilter.makePoster();  
}

public void makePoster_d() {
  darksFilter.makePoster();  
}

public void readMouseHover() {
  int size = 10;
  mouseHover = get(mouseX - size, mouseY - size, size*2, size*2);
  //color c = get(mouseX, mouseY);
  
  ////colorMode(HSB, 255);
  ////println(getWarmth(c) + ", rgb: " + red(c) + ", " + green(c) + ", " + blue(c) + ", hue: " + hue(c));
  ////colorMode(RGB, 255);
}

public void setWorkspaceViewImage(PImage newView) {
  workspaceView.currentView = newView;
}

public abstract class Stage {
  public abstract void draw();
  public void onShow() {};
  public void onHide() {};
  public void onMouseClicked() {};
  public void onMouseDragged() {};
  public void onMousePressed() {};
  public void onMouseReleased() {};
  public void onKeyPressed() {};
}