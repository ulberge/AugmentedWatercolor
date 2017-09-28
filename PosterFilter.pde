abstract public class PosterFilter extends CustomFilter {
  protected ArrayList<Integer> pickedColors;
  protected PImage poster;
  protected String pickedColorsFilename;
  protected PImage swatch;
  protected color swatchColor;
  
  public PosterFilter(FilterPrototype prototype, PVector location, int id) {
    super(new FilterType(prototype), location, id);
    
    pickedColorsFilename = getPickedColorsFilename();
    loadPickedColors();
    poster = loadImage(getPosterFilename());
  }
  
  public PImage apply(PImage inputImage) {
    if (poster != null) {
      println("poster");
      return poster.copy();
    } else {
      return inputImage;
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
  
  protected void readSwatch() {
    swatch = mouseHover.get((int) (10-(swatchSize*0.5)), (int) (10-(swatchSize*0.5)), swatchSize, swatchSize);
    swatchColor = getSwatchColor(swatch, swatchTolerance);
  }
  
  protected void drawSwatchSelection() {
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