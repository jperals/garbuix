import netP5.*;
import oscP5.*;

public class RemoteControlCommunication {
  Controller controller;
  NetAddressList remoteAddressList;
  Options options;
  OscP5 oscP5;
  RemoteControlCommunication(Controller controller, Options options) {
    oscP5 = new OscP5(this, listeningPort);
    remoteAddressList = new NetAddressList();
    this.controller = controller;
    this.options = options;
    connect();
  }
  private void connect() {
    OscMessage msg = new OscMessage("/connect");
    oscP5.send(msg, remoteAddressList);
  }
  private void connect(String ipAddress) {
    NetAddress newAddress = new NetAddress(ipAddress, broadcastPort);
    remoteAddressList.add(newAddress);
    println("Connected with " + ipAddress + ".");
    sendAllTo(newAddress);
  }
  private void oscEvent(OscMessage msg) {
    println("Message recieved from controller");
    String ipAddress = msg.netAddress().address();
    if(msg.addrPattern().equals("/connect") || !remoteAddressList.contains(ipAddress, broadcastPort)) {
      connect(ipAddress);
    }
    if(msg.checkAddrPattern("/artifacts")) {
      options.numberOfArtifacts = (int)msg.get(0).floatValue();
      println("Number of artifacts: " + options.numberOfArtifacts);
    }
    if(msg.checkAddrPattern("/attraction")) {
      options.attraction = msg.get(0).floatValue();
      println("attraction: " + options.attraction);
    }
    if(msg.checkAddrPattern("/background")) {
      float red = msg.get(0).floatValue();
      float green = msg.get(1).floatValue();
      float blue = msg.get(2).floatValue();
      float alpha = msg.get(3).floatValue();
      options.backgroundColor = color(red, green, blue, alpha);
      println("Background color: " + options.backgroundColor);
      /*color backgroundColor = unhex(msg.get(0).stringValue());
      options.backgroundColor = backgroundColor;
      println("Background color: " + hex(backgroundColor));*/
    }
    else if(msg.checkAddrPattern("/capture")) {
      boolean capture = msg.get(0).floatValue() == 1;
      if(capture) {
        controller.startPngExport();
      }
      else {
        controller.finishPngExport();
      }
      println("Export frames: " + capture);
    }
    else if(msg.checkAddrPattern("/delaunay")) {
      options.delaunay = msg.get(0).floatValue() == 1;
      println("Draw Delaunay triangulation: " + options.delaunay);
    }
    else if(msg.checkAddrPattern("/lines")) {
      options.drawLine = msg.get(0).floatValue() == 1;
      println("Draw lines: " + options.drawLine);
    }
    else if(msg.checkAddrPattern("/points")) {
      options.drawArtifacts = msg.get(0).floatValue() == 1;
      println("Draw artifacts: " + options.drawArtifacts);
    }
    else if(msg.checkAddrPattern("/delay")) {
      options.exportFrameDelay = (int)msg.get(0).floatValue();
      println("Delay between capture frames: " + options.exportFrameDelay);
    }
    else if(msg.checkAddrPattern("/inertia")) {
      options.inertia = msg.get(0).floatValue() == 1;
      println("Inertia: " + options.inertia);
    }
    else if(msg.checkAddrPattern("/polygons")) {
      options.lerpLevels = (int)msg.get(0).floatValue();
      options.lerp = options.lerpLevels > 0;  
      println("Lerp levels: " + options.lerpLevels);
    }
    else if(msg.checkAddrPattern("/trace")) {
      options.clear = msg.get(0).floatValue() == 0;
      println("Clear: " + options.clear);
    }
    else if(msg.checkAddrPattern("/voronoi")) {
      options.voronoi = msg.get(0).floatValue() == 1;
      println("Draw Voronoi tesselation: " + options.voronoi);
    }
    else if(msg.checkAddrPattern("/reset")) {
      controller.requestReset();
    }
    else {
      return;
    }
    int nAddresses = remoteAddressList.size();
    for(int i = 0; i < nAddresses; i++) {
      NetAddress currentAddress = remoteAddressList.get(i);
      if(! ipAddress.equals(currentAddress.address())) {
        oscP5.send(msg, currentAddress);
      }
    }
  }
  void sendAllTo(NetAddress address) {
    sendMessage("artifacts", options.numberOfArtifacts, address);
    sendMessage("attraction", options.attraction, address);
    sendMessage("inertia", options.inertia, address);
    sendMessage("points", options.drawArtifacts, address);
    sendMessage("lines", options.drawLine, address);
    sendMessage("trace", !options.clear, address);
    sendMessage("delaunay", options.delaunay, address);
    sendMessage("voronoi", options.voronoi, address);
    sendMessage("polygons", options.lerpLevels, address);
    sendMessage("delay", options.exportFrameDelay, address);
    sendColorMessage("background", options.backgroundColor, address);
    //sendMessage("background", hex(options.backgroundColor), address);
  }
  void sendColorMessage(String parameter, color value, NetAddress address) {
    OscMessage msg = new OscMessage("/" + parameter);
    msg.add(red(value));
    msg.add(green(value));
    msg.add(blue(value));
    msg.add(alpha(value));
    oscP5.send(msg, address);
  }
  void sendMessage(String parameter, boolean value, NetAddress address) {
    float floatValue = value ? 1.0f : 0.0f;
    sendMessage(parameter, floatValue, address);
  }
  void sendMessage(String parameter, int value, NetAddress address) {
    sendMessage(parameter, (float)value, address);
  }
  void sendMessage(String parameter, float value, NetAddress address) {
    println("Sending float message to address: " + address);
    OscMessage msg = new OscMessage("/" + parameter);
    println(parameter + ": " + value);
    msg.add(value);
    oscP5.send(msg, address);
  }
  void sendMessage(String parameter, String value, NetAddress address) {
    println("Sending string message to address: " + address);
    OscMessage msg = new OscMessage("/" + parameter);
    println(parameter + ": " + value);
    msg.add(value);
    oscP5.send(msg, address);
  }
}

