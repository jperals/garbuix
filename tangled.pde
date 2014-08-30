Controller controller;

void setup() {
  size(500, 500);
  controller = new Controller(this);
}

void draw() {
  controller.draw();
  controller.update();
}

void keyPressed() {
  controller.triggerAction(key);
}
