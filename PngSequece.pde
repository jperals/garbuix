/* Useful to export a sequence of PNG, which can later be put together as an animation
 * (for example to GIF with the command line tool "convert") */

public class PngSequenceMaker {
  public String imageFilenamePrefix;
  PngSequenceMaker() {
    this("");
  }
  PngSequenceMaker(String imageFilenamePrefix) {
    this.imageFilenamePrefix = imageFilenamePrefix;
  }
  public void saveCurrentFrame() {
    saveFrame(imageFilenamePrefix + ".png");
  }
}
