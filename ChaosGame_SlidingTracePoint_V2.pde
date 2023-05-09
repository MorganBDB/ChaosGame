// Morgan Brooke-deBock
// May 9 2023
// Interactive Animation of the chaos game

TracePoint Trace;  // Variable to store a TracePoint Object
AttractorPoint[] APoints; // Array to store a list of AttractorPoint Objects

int TotalNum;  //Specify desired total number of simulation steps
int CurrentStep; // Specify the current step in the simulation
PVector CurrentPosition; // For smooth transitions between steps
float LerpAmount; // Determines the Animation speed
float diameter; // Diameter of the TracePoints

boolean AutoAdvance; // Specify if the animation should advance automatically or not
int GameMode;        // Specify the game mode

PImage BackgroundPlate; // store a background image
void setup() {
  //size(1280, 720);
  fullScreen();
  smooth();
  colorMode(HSB, 360, 100, 100, 100);
  BackgroundPlate = loadImage("rulesonly.png");

  frameRate(30);
  CurrentStep = 0;
  TotalNum = 0;
  AutoAdvance = false;
  GameMode = 1;
  LerpAmount = 0.05;

  APoints = GenerateNgon(3, 0, -(width/4), 0);
  Trace = new TracePoint(width/2 - (width/4), height/2, 1 - ScaleFactor(3));
  CurrentPosition = new PVector(Trace.pos.x, Trace.pos.y);
}

void draw() {
  //background(0);
  image(BackgroundPlate, 0, 0);

  for (int i = 0; i < APoints.length; i++) {
    APoints[i].show(16);
  }

  GetGameMode();
  showCount(50, 50, 48);
  ShowCurrentPosition();
  
}

void GetGameMode() {
  if (GameMode == 1) {
    AutoLerp(LerpAmount);
    Trace.show(true, false, diameter, 0, CurrentStep - 1);
  } else if (GameMode == 2) {
    FastBuild(100);
    Trace.show(true, false, diameter, 0, CurrentStep - 1);
  } else if (GameMode == 3) {
    DragMode(TotalNum);
    println(TotalNum);
  }
}


void LerpTransition(float Amount) {
  CurrentPosition.lerp(Trace.pos, Amount);
}

void AutoLerp(float Amount) {
  // The slow game mode. The tracepoint will animate from point to point
  // The speed of the animation can be increased or decreased by pressing the right and left arrow keys
  // The maximum speed of animation is one step per frame.
  diameter = 8;
  if (CurrentPosition.dist(Trace.pos) < 8 && AutoAdvance == true) {
    NextStep();
  }
  CurrentPosition.lerp(Trace.pos, Amount);
}

void FastBuild(int PerFrame) {
  // The fast game mode. Multiple steps of the chaos game will be made in each frame.
  // The input (int PerFrame) determines the speed of the simlulation.
  // For example, if PerFrame = 100, then 100 steps of the chaos game will be made per frame.
  diameter = 1;
  if (AutoAdvance) {
    for (int i = 0; i < PerFrame; i++) {
      NextStep();
    }
    CurrentPosition.set(Trace.pos.x, Trace.pos.y);
  }
}

void DragMode(int TotalSteps) {
  // Mode which allows the AttractorPoints to be dragged around the screen
  // Everytime an AttractorPoint is dragged, the program will simulate TotalSteps worth of Chaos Game steps between them.
  // THE TOTAL STEPS COUNTER DOES NOT WORK PROPERLY IN THIS MODE, NEEDS TO BE FIXED.
  while (Trace.PreviousPoints.size() < TotalSteps) {
    Trace.UpdatePosition(APoints);
  }
  Trace.show(true, false, diameter, 0, TotalSteps);
  CurrentPosition.set(Trace.pos.x, Trace.pos.y);
}

void showCount(float x, float y, float FontSize) {
  // Display the total number of steps taken in the game
  // ISSUES WITH THIS LABEL IN DRAG MODE!
  fill(360);
  PFont font = createFont("Courier", FontSize);
  textFont(font);
  String Label = "Total Steps: ";
  text(Label, x, y);
  if (GameMode == 3) {
    text(TotalNum, x + textWidth(Label), y);
  } else {
    text(CurrentStep, x + textWidth(Label), y);
  }
}


void NextStep() {
  // Advance one step in the chaos game
  Trace.UpdatePosition(APoints);
  CurrentStep = CurrentStep + 1;
  TotalNum = TotalNum + 1;
}

void ShowCurrentPosition() {
  // Show the current location of the trace point.
  // In AutoLerp mode, the TracePoint will smoothly slide between steps.
  fill(0, 0, 100, 100);
  ellipse(CurrentPosition.x, CurrentPosition.y, 8, 8);
}


void mouseDragged() {
  // Function to drag AttractorPoints around the canvas
  for (int i = 0; i < APoints.length; i++) {
    if (abs(mouseX - APoints[i].pos.x) < 16 && abs(mouseY - APoints[i].pos.y) < 16) {
      APoints[i].UpdatePosition(mouseX, mouseY);
      Trace.reset();
      CurrentStep = 0;
    }
  }
}

void keyPressed() {
  // Get inputs from the keyboard and determines the game settings
  if (key == CODED) {

    if (keyCode == RIGHT) {
      // If the RIGHT ARROW key is pressed, double the animation speed
      if (LerpAmount * 2 <= 1.0) {
        LerpAmount = LerpAmount * 2;
      } else {
        LerpAmount = 1.0;
      }
    } else if (keyCode == LEFT && LerpAmount >= 0.0) {
      // If the LEFT ARROW ket is pressed, half the animation speed
      LerpAmount = LerpAmount / 2;
    } else if (keyCode == SHIFT) {
      // Pressing the shift key will toggle AutoPlay on and off
      AutoAdvance = !AutoAdvance;
    }
  } else if (key == '1') { // If the 1 key is pressed, put the game into AutoLerp mode
    GameMode = 1;
  } else if (key == '2') { // If the 2 key is pressed, put the game into FastBuild mode
    GameMode = 2;
  } else if (key == '3') { // If the 3 key is pressed, put the game into Drag mode
    GameMode = 3;
  } else if (key == ' ') {
    NextStep();
  } else {                 // If any other key is pressed, reset the Game board
    Trace.reset();
    CurrentStep = 0;
    TotalNum = 0;
  }
}

void NoiseUpdate(AttractorPoint A) {
  // Function to move an attractor point around the canvas using perlin noise

  A.UpdatePosition(noise(A.xoff) * width, noise(A.yoff) * height);
  A.xoff += 0.005;
  A.yoff += 0.005;
  Trace.reset();
}

AttractorPoint[] GenerateNgon(int n, float InitialAngle, float Xoff, float Yoff) {
  // Function to return an array of AttractorPoint objects arrange in a regular ngon

  float R = height/2 - (height * 0.05); // Set the radius to be 95% the height of the canvas
  float midx = width/2 + Xoff;          // place the center point of shape at the center of the canvas
  float midy = height/2 + Yoff;
  float angle_increment = TWO_PI/n;
  AttractorPoint[] points = new AttractorPoint[n];

  for (int i = 0; i < n; i++) {
    float x = midx + (R * cos(InitialAngle + (angle_increment * i)));
    float y = midy + (R * sin(InitialAngle + (angle_increment * i)));
    int HueValue = floor(map(angle_increment * i, 0, TWO_PI, 0, 360));

    color c = color(HueValue, 80, 80);
    AttractorPoint point = new AttractorPoint(x, y, c);
    points[i] = point;
  }

  return points;
}


float ScaleFactor(int n) {
  // Function to calculate the correct scale factor to generate sierpinski n-flakes

  float sum = 0;

  for (int i = 1; i < (floor(n/4)) + 1; i++) {
    sum = sum + cos((2 * PI * i) / n);
  }

  float r = 1 / (2 * (1 + sum));
  return r;
}
