Controller controller;

void setup() {
  size(displayWidth, displayHeight);
  controller = new Controller(this);
}

void draw() {
  controller.draw();
  controller.update();
}

void keyPressed() {
  switch(key) {
  case 'g':
    controller.toggleGifExport(this);
    break;
  case 'p':
    controller.togglePngExport();
    break;
  case 'r':
    controller.requestReset();
    break;
  case 'R':
    controller = new Controller(this);
    break;
  case 's':
    controller.saveCurrentFrame();
    break;
  }
}

