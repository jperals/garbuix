import processing.core.*;

/*public static void main(String args[]) {
    PApplet.main(new String[] { "--present", "Tangled" });
}*/

public class Tangled extends PApplet {

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

}