public class Layer {
  Filter filter;
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
  
  public void setFilter(Filter filter) {
    if (filter != null) {
      button.setImages(filter.iconImages);
      button.show();
    } else {
      button.hide();
    }
    this.filter = filter;
  }
}