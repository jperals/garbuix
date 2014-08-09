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
        options.attraction += 0.1;
        println("Attraction: " + options.attraction);
      }
    };
    MutationAction attractionIncreaseAction = new MutationAction("Increase attraction", "Increase attraction between artifacts", attractionIncreaseCommand);
    map.put('a', attractionIncreaseAction);
    
    Command attractionDecreaseCommand = new Command() {
      public void runCommand() {
        options.attraction -= 0.1;
        println("Attraction: " + options.attraction);
      }
    };
    MutationAction attractionDecreaseAction = new MutationAction("Decrease attraction", "Decrease attraction between artifacts", attractionDecreaseCommand);
    map.put('A', attractionDecreaseAction);
    
    Command toggleClearCommand = new Command() {
      public void runCommand() {
        options.clear = !options.clear;
      }
    };
    MutationAction toggleClearAction = new MutationAction("Toggle clear after each frame", "Toggle clear after each frame", toggleClearCommand);
    map.put('c', toggleClearAction);
    
    Command toggleDelaunayCommand = new Command() {
      public void runCommand() {
        options.delaunay = !options.delaunay;
      }
    };
    MutationAction toggleDelaunayAction = new MutationAction("Toggle Delaunay diagram", "Toggle the visualization of the Delaunay diagram", toggleDelaunayCommand);
    map.put('d', toggleDelaunayAction);
    
    Command toggleLineCommand = new Command() {
      public void runCommand() {
        options.drawLine = !options.drawLine;
      }
    };
    MutationAction toggleLineAction = new MutationAction("Toggle line", "Toggle the visualization of one line from each artifact to its closest neighbour", toggleLineCommand);
    map.put('l', toggleLineAction);
    
    Command numberOfArtifactsIncreaseCommand = new Command() {
      public void runCommand() {
        options.numberOfArtifacts += 1;
      }
    };
    MutationAction numberOfArticatsIncreaseAction = new MutationAction("Increase number of artifacts", "Increase number of artifacts", numberOfArtifactsIncreaseCommand);
    map.put('n', numberOfArticatsIncreaseAction);
    
    Command numberOfArtifactsDecreaseCommand = new Command() {
      public void runCommand() {
        options.numberOfArtifacts -= 1;
      }
    };
    MutationAction numberOfArticatsDecreaseAction = new MutationAction("Decrease number of artifacts", "Decrease number of artifacts", numberOfArtifactsDecreaseCommand);
    map.put('N', numberOfArticatsDecreaseAction);
    
    Command toggleVoronoiCommand = new Command() {
      public void runCommand() {
        options.voronoi = !options.voronoi;
      }
    };
    MutationAction toggleVoronoiAction = new MutationAction("Toggle Voronoi diagram", "Toggle the visualization of the Voronoi diagram", toggleVoronoiCommand);
    map.put('v', toggleVoronoiAction);
    
  }
  public void invokeByKey(char key) {
    MutationAction action = map.get(key);
    if(action != null) {
      action.invoke();
    }
  }
}
