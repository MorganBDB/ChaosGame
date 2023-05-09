class AttractorPoint {
  PVector pos;       // Store the Position of the point
  color ColorValue;  // Stores the color of the point
  
  float xoff = random(0, 10000);  // x offset for perlin noise motion
  float yoff = random(0, 10000); // y offset for perlin noise motion


  AttractorPoint(float x0, float y0, color c) {
    pos = new PVector(x0, y0);
    ColorValue = c;
  }

  void UpdatePosition(float x, float y) {
    // Change the position of the AttractorPoints
    // Inputs an x value and a y value, and sets hte coordinates of the 
    
    pos.set(x, y);
  }

  void show(float diameter) {
    fill(ColorValue);
    noStroke();
    ellipse(pos.x, pos.y, diameter, diameter);
  }
}
