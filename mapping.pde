import processing.sound.*;
Amplitude amp;
AudioIn in;

import controlP5.*;
ControlP5 cp5;

int[] samples = new int[2000000];
int current = 0;
int max = 0;
int buffer = 1000;
boolean pause=false;


public void setup() {
  size(1920, 800);
  frameRate(200);

  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);

  stroke(255);
  strokeWeight(2);
  noFill();

  cp5 = new ControlP5(this);
  ControlFont controlFont = new ControlFont(createFont("Arial", 12)); //font for percentage button
  int stepCount = 100; 
  cp5.addSlider("position")
    .setPosition(900, 0)
    .setSize(300, 40)
    .setRange(0, stepCount-1)
    .setValue(int(stepCount/2))
    .setNumberOfTickMarks(stepCount)
    .setCaptionLabel("position")
    ;

  cp5.getController("position").getValueLabel().setVisible(false);
  cp5.getController("position").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  cp5.getController("position").getCaptionLabel().setFont(controlFont);

  controlFont = new ControlFont(createFont("Arial", 18));

  cp5.addButton("Pause")
    .setValue(100)
    .setPosition(750, 0)
    .setSize(50, 40)
    .setLabel("||")
    ;

  cp5.getController("Pause").getCaptionLabel().setFont(controlFont);

  cp5.addButton("Play")
    .setValue(0)
    .setPosition(800, 0)
    .setSize(50, 40)
    .setLabel(">")
    ;

  cp5.getController("Play").getCaptionLabel().setFont(controlFont);
}

public void draw() {
  background(0);

  if (!pause) {
    samples[current] = int(height-(2*height*amp.analyze()));
    current++;
    max = current;
  }

  beginShape();
  for (int i = 0; i < buffer; i++) {
    if (i<current) {
      //vertex(map(i, 0, buffer, 0, width), samples[current-i]);
      star(map(i*4, 0, buffer, 0, width), samples[current-i], 3+samples[current-i]%3, 5, 4+samples[current-i]%2);
    }
  }

  endShape();

}

void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  if (y%5>4) {
    beginShape();
  } else if (y%4>4)
  { 
    beginShape(POINTS);
  } else
  {
    beginShape(LINES);
  }
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

void position() {
 
  if (pause) {
    current = max - (int(cp5.getController("position").getValue()));
    if (current<0) current=0;
  }
}

void Pause() {
  pause = true;
  cp5.getController("position").setMax(max);
  cp5.getController("position").setValue(0);
}
void Play() {
  pause = false;
  current = max;
}
