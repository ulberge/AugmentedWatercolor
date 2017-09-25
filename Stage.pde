// each stage is a 800x600 view
public abstract class Stage {
  public abstract void draw();
  public void onShow() {};
  public void onHide() {};
  public void onMouseClick() {};
  public void onMousePressed() {};
  public void onMouseReleased() {};
  public void onKeyPressed() {};
}