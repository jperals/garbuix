public color myColorLerp(color color1, color color2, float lerpAmount) {
  int lerpedRed = (int)(round(lerp(red(color1), red(color2), lerpAmount)));
  int lerpedGreen = (int)(round(lerp(green(color1), green(color2), lerpAmount)));
  int lerpedBlue = (int)(round(lerp(blue(color1), blue(color2), lerpAmount)));
  int lerpedAlpha = (int)(round(lerp(alpha(color1), alpha(color2), lerpAmount)));
  color lerpedColor = color(lerpedRed, lerpedGreen, lerpedBlue, lerpedAlpha);
  return lerpedColor;
}
