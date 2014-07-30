float randomAngle() {
  return random(TWO_PI);
}

color randomColor(float alpha) {
  return color(random(255), random(255), random(255), alpha);
}

color randomColor() {
  return randomColor(random(255)); // If alpha is not specified, make it random too
}

PVector randomPosition(int w, int h) {
  return new PVector(randomCoordinate(w), randomCoordinate(h));
}

PVector randomPosition() {
  return randomPosition(width, height);
}

float randomX() {
  return randomCoordinate(width);
}

float randomY() {
  return randomCoordinate(height);
}

float randomCoordinate(float visibleRange) {
  return random(-0.25, 1.25)*visibleRange; // This will return also positions out from the visible screen
}

