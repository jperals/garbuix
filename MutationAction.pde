import java.util.*;

interface Command {
  void runCommand();
}

public class MutationActions {
  HashMap<Character, MutationAction> map;
  MutationActions() {
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
    MutationAction helpAction = new MutationAction("help", "Show help", helpCommand);
    map.put('h', helpAction);
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
