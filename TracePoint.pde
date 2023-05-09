class TracePoint {

  PVector pos;    // PVector to store the current position of the Tracepoint
  float JumpSize; // Determines the jump distance in each step
  ArrayList<float[]> PreviousPoints; // Stores every step in the simulation

  TracePoint(float x0, float y0, float _JumpSize) {
    pos = new PVector(x0, y0);
    JumpSize = _JumpSize;
    PreviousPoints = new ArrayList<float[]>();
  }

  void UpdatePosition(AttractorPoint[] AttractorArray) {
    // Function to update the postion of the TracePoint
    // Inputs an array of AttractorPoint objects and chooses one at random to move the TracePoint Towards

    int RandomIndex = (int)random(AttractorArray.length); // Choose a random AttractorPoint
    AttractorPoint Choice = AttractorArray[RandomIndex];  // Get the random choice from the list of AttractorPoints
    pos.lerp(Choice.pos, JumpSize);                       // Move toward the chosen point
    float[] CurrentPoints = {pos.x, pos.y, Choice.ColorValue}; // Create an array with the new coordinates and color information
    PreviousPoints.add(CurrentPoints);                    // Save the array to the ArrayList with all of the previous points
  }

  void reset() {
    // Function to reset the TracePoint
    // Removes all points from the PreviousPoints ArrayList

    PreviousPoints.clear();
  }

  void show(Boolean WithColor, Boolean WithLine, float Diameter, float LineWeight, int MaxPoints) {
    // Function to display full trace
    // 
    // Inputs:
    //    WithColor: if true, the TracePoint dots will be colored according to the chosen AttractorPoint
    //               if false, all TracePoint dots will be color white 
    //    
    //    WithLine: if true, A line will be drawn connecting consectuive TracePoint dots
    //              if false, no lines will be drawn
    //
    //    Diameter: the diameter of each of the TracePoint dots
    //
    //    LineWeight: sets the strokeWeight of the lines between points
    //
    //    (Note: to display an image with no dots and only lines, WithLine to true and Diameter to 0)
    //
    //

    fill(360);
    stroke(360);
    for (int i = 0; i < MaxPoints; i++) {
      if (WithColor) {
        fill(floor(PreviousPoints.get(i)[2]));
        stroke(floor(PreviousPoints.get(i)[2]));
      }
      if (WithLine && i > 0) {
        strokeWeight(LineWeight);
        line(PreviousPoints.get(i-1)[0], PreviousPoints.get(i-1)[1], PreviousPoints.get(i)[0], PreviousPoints.get(i)[1]);
      }

      noStroke();
      ellipse(PreviousPoints.get(i)[0], PreviousPoints.get(i)[1], Diameter, Diameter);
    }

    //fill(0, 100, 100);
    //ellipse(PreviousPoints.get(MaxPoints)[0], PreviousPoints.get(MaxPoints)[1] , 8, 8);
  }
}
