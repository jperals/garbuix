import java.util.*;

interface Command {
  void runCommand();
}

public class MutationAction {
  public String mutationName,
         mutationDescription;
  Command mutationAction;
  MutationAction() {
  }
  MutationAction(String mutationName) {
    this.mutationName = mutationName;
  }
  MutationAction(String mutationName, String mutationDescription) {
    this.mutationName = mutationName;
    this.mutationDescription = mutationDescription;
  }
  MutationAction(String mutationName, String mutationDescription, Command command) {
    this.mutationName = mutationName;
    this.mutationDescription = mutationDescription;
    this.mutationAction = command;
  }
  public void invoke() {
    mutationAction.runCommand();
  }
}

public class MutationActions {
  HashMap<Character, MutationAction> map;
  Options options;
  MutationActions(Options options1) {
    options = options1;
    map = new HashMap<Character, MutationAction>();
    
    Command helpCommand = new Command() {
      public void runCommand() {
        println("====\nHELP\n====");
        for(Map.Entry entry : map.entrySet()) {
          Character entryKey = (Character)entry.getKey();
          MutationAction action = (MutationAction)entry.getValue();
          println(entryKey + ": " + action.mutationName + "\n   " + action.mutationDescription);
        }
      }
    };
    MutationAction helpAction = new MutationAction("Help", "Show this text", helpCommand);
    map.put('h', helpAction);
    
    Command attractionIncreaseCommand = new Command() {
      public void runCommand() {
        options.set("attraction", options.getAsFloat("attraction") + 0.1);
        println("Attraction: " + options.get("attraction"));
      }
    };
    MutationAction attractionIncreaseAction = new MutationAction("Increase attraction", "Increase attraction between nodes", attractionIncreaseCommand);
    map.put('a', attractionIncreaseAction);
    
    Command attractionDecreaseCommand = new Command() {
      public void runCommand() {
        options.set("attraction", options.getAsFloat("attraction") - 0.1);
        println("Attraction: " + options.get("attraction"));
      }
    };
    MutationAction attractionDecreaseAction = new MutationAction("Decrease attraction", "Decrease attraction between nodes", attractionDecreaseCommand);
    map.put('A', attractionDecreaseAction);
    
    Command toggleClearCommand = new Command() {
      public void runCommand() {
        boolean currentValue = options.getAsBoolean("clear");
        options.set("clear", !currentValue);
      }
    };
    MutationAction toggleClearAction = new MutationAction("Toggle clear after each frame", "Toggle clear after each frame", toggleClearCommand);
    map.put('c', toggleClearAction);
    
    Command toggleDelaunayCommand = new Command() {
      public void runCommand() {
        options.toggle("delaunay");
      }
    };
    MutationAction toggleDelaunayAction = new MutationAction("Toggle Delaunay diagram", "Toggle the visualization of the Delaunay diagram", toggleDelaunayCommand);
    map.put('d', toggleDelaunayAction);
    
    Command toggleLineCommand = new Command() {
      public void runCommand() {
        options.toggle("lines");
      }
    };
    MutationAction toggleLineAction = new MutationAction("Toggle line", "Toggle the visualization of one line from each node to its closest neighbour", toggleLineCommand);
    map.put('l', toggleLineAction);
    
    Command numberOfNodesIncreaseCommand = new Command() {
      public void runCommand() {
        options.set("nodes", options.getAsInt("nodes") + 1);
      }
    };
    MutationAction numberOfNodesIncreaseAction = new MutationAction("Increase number of nodes", "Increase number of nodes", numberOfNodesIncreaseCommand);
    map.put('n', numberOfNodesIncreaseAction);
    
    Command numberOfNodesDecreaseCommand = new Command() {
      public void runCommand() {
        options.set("nodes", options.getAsInt("nodes") - 1);
      }
    };
    MutationAction numberOfArticatsDecreaseAction = new MutationAction("Decrease number of nodes", "Decrease number of nodes", numberOfNodesDecreaseCommand);
    map.put('N', numberOfArticatsDecreaseAction);
    
    Command toggleVoronoiCommand = new Command() {
      public void runCommand() {
        options.toggle("voronoi");
      }
    };
    MutationAction toggleVoronoiAction = new MutationAction("Toggle Voronoi diagram", "Toggle the visualization of the Voronoi diagram", toggleVoronoiCommand);
    map.put('v', toggleVoronoiAction);
    
    Command numberOfVoronoiPolygonsCycleCommand = new Command() {
      public void runCommand() {
        options.lerpLevels = (options.lerpLevels + 1) % options.maxLerpLevels;
        println("options.lerpLevels: " + options.lerpLevels);
      }
    };
    MutationAction numberOfVoronoiPolygonsCycleAction = new MutationAction("Cycle number of Voronoi polygons", "Change the number of concentrical Voronoi polygons at each node's position", numberOfVoronoiPolygonsCycleCommand);
    map.put('V', numberOfVoronoiPolygonsCycleAction);
  }
  public void invokeByKey(char key) {
    MutationAction action = map.get(key);
    if(action != null) {
      action.invoke();
    }
  }
}
