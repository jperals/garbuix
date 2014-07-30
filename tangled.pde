Controller controller;

void setup() {
  size(250, 250);
  controller = new Controller(this);
}

void draw() {
  controller.draw();
  controller.update();
}

void keyPressed() {
  controller.triggerAction(key);
}

