public class Options {
  HashMap<String, Option> options;
  public boolean lerp;
  public color backgroundColor;
  public float attraction, mass;
  private float minAttraction = -1;
  private float maxAttraction = 1;
  public PVector canvasStart, canvasEnd;
  public int exportFrameDelay, minExportFrameDelay = 1, maxExportFrameDelay = 300;
  public int lerpLevels;
  public int maxLerpLevels = 5;
  public int minNumberOfNodes = 500;
  public int maxNumberOfNodes = 1000;
  public int numberOfNodes;
  
  Options() {
    this(width, height);
  }

  Options(int w, int h) {
    options = new HashMap<String, Option>();
    backgroundColor = color(random(0, 127), random(0, 127), random(0, 127));
    minExportFrameDelay = 1;
    maxExportFrameDelay = 300;
    exportFrameDelay = 1;
    lerp = true;//random(1) < 0.5;
    canvasStart = new PVector(-w*0.25, -h*0.25);
    canvasEnd = new PVector(w*1.25, h*1.25);
    lerpLevels = 1;//lerp ? 1 : (int)random(maxLerpLevels);
  }
  public boolean getAsBoolean(String s) {
    boolean value;
    try {
      value = options.get(s).getAsBoolean();
    }
    catch(Exception e1) {
      try {
        value = options.get(s).getAsInt() == 1;
      }
      catch(Exception e2) {
        try {
          value = options.get(s).getAsFloat() == 1;
        }
        catch(Exception e3) {
          try {
            value = options.get(s).getAsString() == "1";
          }
          catch(Exception e4) {
            println(e4);
            value = false;
          }
        }
      }
    }
    return value;
  }
  public float getAsFloat(String s) {
    return options.get(s).getAsFloat();
  }
  public int getAsInt(String s) {
    return options.get(s).getAsInt();
  }
  public String getAsString(String s) {
    return options.get(s).getAsString();
  }
  public Option get(String s) {
      return options.get(s);
  }
  public void set(String s, boolean value) {
    options.put(s, new Option(value));
  }
  public void set(String s, float value) {
    options.put(s, new Option(value));
  }
  public void set(String s, int value) {
    options.put(s, new Option(value));
  }
  public void set(String s, String value) {
    options.put(s, new Option(value));
  }
  public void toggle(String s) {
    set(s, !getAsBoolean(s));
  }
  private BooleanOption newBooleanOption(boolean value) {
    return new BooleanOption(value);
  }
  class Option {
    boolean booleanValue;
    float floatValue;
    int intValue;
    String stringValue;
    String type;
    Option() {
    }
    Option(boolean b) {
      booleanValue = b;
      type = "boolean";
    }
    Option(float f) {
      floatValue = f;
      type = "float";
    }
    Option(int i) {
      intValue = i;
      type = "int";
    }
    Option(String s) {
      stringValue = s;
      type = "string";
    }
    public String getType() {
      return type;
    }
    public boolean getAsBoolean() {
      if(type == "float") booleanValue = floatValue == 1;
      else if(type == "int") booleanValue = intValue == 1;
      else if(type == "string") booleanValue = stringValue == "1";
      return booleanValue;
    }
    public float getAsFloat() {
      return floatValue;
    }
    public int getAsInt() {
      return intValue;
    }
    public String getAsString() {
      return stringValue;
    }
    public void set(boolean b) {
      booleanValue = b;
    }
    public void set(float f) {
      floatValue = f;
    }
    public void set(int i) {
      intValue = i;
    }
    public void set(String s) {
      stringValue = s;
    }
  }
  class BooleanOption extends Option {
    boolean value;
    BooleanOption() {
    }
    BooleanOption(boolean b) {
      value = b;
    }
    public boolean get() {
      return value;
    }
  }
}
