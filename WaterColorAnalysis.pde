import controlP5.*;
import java.io.*;

ControlP5 cp5;

PImage original;

Stage pickFirstLayerColors, posterImage;
int currentStageIndex;
ArrayList<Stage> stages;

PImage swatch, mouseHover;
color swatchColor;
ArrayList<Integer> pickedColors;
PImage poster;
int swatchSize, swatchTolerance;
int lightFilter, darkFilter;
int darkFilter0, darkFilter02;
int opacityOfRest;
boolean colorDiffIsActive, valueDiffIsActive;

WorkspaceView workspaceView;

public void settings() {
  size(1100, 700);
}

void setup(){
  
  cp5 = new ControlP5(this);
  
  original = loadImage("plants.png");
  poster = loadImage("poster.png");
  original.resize(400,300);
  
  workspaceView = new WorkspaceView(poster);
  
  loadPickedColors();
  
  swatch = null;
  mouseHover = null;
  swatchColor = color(255, 255, 255);
  swatchSize = 10;
  swatchTolerance = 30;
  
  lightFilter = 90;
  darkFilter = 68;
  darkFilter0 = 50;
  darkFilter02 = 50;
  
  stages = new ArrayList<Stage>();
  
  Stage mainView = new MainView();
  stages.add(mainView);
  
  pickFirstLayerColors = new Stage0();
  stages.add(pickFirstLayerColors);
  
  Stage posterImage = new Stage1();
  stages.add(posterImage);
  
  Stage posterImage2 = new Stage2();
  stages.add(posterImage2);
  
  currentStageIndex = 0;
  stages.get(0).onShow();
  
  addStageButtons(stages);
}

void draw() {
  pushMatrix();
  translate(50, 0);
  stages.get(currentStageIndex).draw();
  popMatrix();
  
  readMouseHover();
}

void mouseClicked() {
  stages.get(currentStageIndex).onMouseClick();
}

void mousePressed() {
  stages.get(currentStageIndex).onMousePressed();
}

void mouseReleased() {
  stages.get(currentStageIndex).onMouseReleased();
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

void addStageButtons(ArrayList<Stage> stages) {
  PFont pfont = createFont("Arial",20,true); // use true/false for smooth/no-smooth
  ControlFont font = new ControlFont(pfont,24);
  
  Button previous = cp5.addButton("previousStage")
     .setPosition(0, 0)
     .setCaptionLabel("←")
     .setSize((int) 50,height)
     .setFont(font)
     ;
     
  Button next = cp5.addButton("nextStage")
     .setCaptionLabel("→")
     .setPosition((int) (0.95*width), 0)
     .setSize((int) 50,height)
     .setFont(font)
     ;
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
  poster = getPoster(original, pickedColors, darkFilter0);
  poster.save("poster.png");
  setWorkspaceViewImage(poster);
}

public void readMouseHover() {
  int size = (int) (width/64.0);
  mouseHover = get(mouseX - size, mouseY - size, size*2, size*2);
}

public void savePickedColors() {
  try {
      // serialise an object to disc..
    FileOutputStream f=new FileOutputStream("pickedColors.ser");
    ObjectOutputStream o=new ObjectOutputStream(f);
    o.writeObject(pickedColors);
    o.close();
  } catch (Exception e) { // The object "e" is the exception object that was thrown.
      // this is where you handle it if an error occurs
      println(e);
  }
}

public void loadPickedColors() {
  // read it back in
  try {
    FileInputStream f=new FileInputStream("pickedColors.ser");
    ObjectInputStream o=new ObjectInputStream(f);
    pickedColors =(ArrayList<Integer>) o.readObject();
    o.close(); 
  } catch (Exception e) {
    println(e);
    pickedColors = new ArrayList<Integer>();
  }  
}

public void setWorkspaceViewImage(PImage newView) {
  workspaceView.currentView = newView;
}