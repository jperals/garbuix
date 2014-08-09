import java.util.*;

interface Command {
  void runCommand();
}

public class MutationActions {
  HashMap<Character, MutationAction> map;
  Options options;
  MutationActions(Options options1) {
    options = options1;
    map = new HashMap<Character, MutationAction>();
    Command helpCommand = new Command() {
      public void runCommand() {
        for(Map.Entry entry : map.entrySet()) {
          Character entryKey = (Character)entry.getKey();
          MutationAction action = (MutationAction)entry.getValue();
          println(entryKey, action.mutationName, action.mutationDescription);
        }
      }
    };
    MutationAction helpAction = new MutationAction("Help", "Show this text", helpCommand);
    map.put('h', helpAction);
    Command attractionIncreaseCommand = new Command() {
      public void runCommand() {
        options.attraction += 0.1;
      }
    };
    MutationAction attractionIncreaseAction = new MutationAction("Increase attraction", "Increase attraction between artifacts", attractionIncreaseCommand);
    map.put('+', attractionIncreaseAction);
    Command attractionDecreaseCommand = new Command() {
      public void runCommand() {
        options.attraction -= 0.1;
      }
    };
    MutationAction attractionDecreaseAction = new MutationAction("Decrease attraction", "Decrease attraction between artifacts", attractionDecreaseCommand);
    map.put('-', attractionDecreaseAction);
  }
  public void invokeByKey(char key) {
    MutationAction action = map.get(key);
    if(action != null) {
      action.invoke();
    }
  }
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
