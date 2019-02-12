class Button {
  float x, y, w, h;
  boolean highlight;
  int fill;

  Button(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.fill = 255;
    this.highlight = false;
  }

  void display() {
    stroke(0);
    strokeWeight(1);
    
    if (highlight) {
       fill(100, 55, 100);
    } else {
      fill(fill);
    }
    
    ellipse(x, y, w, h);
  }
  
  boolean overButton(int mX, int mY) {
   if (mX >= x - w/2 && mX <= x + w/2 && mY >= y - h/2 && mY <= y + h/2) {
     return true;
   } else {
     return false;
   }
  }
}
