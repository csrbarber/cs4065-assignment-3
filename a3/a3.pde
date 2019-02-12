import javax.swing.JOptionPane;

// TODO Commented out for debugging
//int NUM_TRIALS = 21;
int NUM_TRIALS = 5;
int NUM_ROUNDS = 4;

ArrayList<Button> gridButtons;
String user;
int condition, round, trialNum, startTime, numErrors;
Button previousTarget, currentTarget;

void setup() {
  // TODO Commented out for debugging
  //fullScreen();
  size(700, 700);
  background(204);
  round = 0;
  trialNum = 0;
  
  user = JOptionPane.showInputDialog("Enter user ID:");
  condition = Integer.parseInt(JOptionPane.showInputDialog("Enter condition (0 or 1):"));
  String buttonText = "Please select highlighted buttons as quickly and accurately as possible.\n" +
    "This is round " + (round + 1) + " of " + NUM_ROUNDS + ".\n" + "Click OK to begin practice.";
  JOptionPane.showConfirmDialog(null, buttonText, "", JOptionPane.DEFAULT_OPTION);

  gridButtons = new ArrayList<Button>();
  
  int startX = (int) width/2 - 80;
  int startY = (int) height/2 - 80;

  for (int i = 0; i < 5; i++) {
    for (int j = 0; j < 5; j++) {
      // 15 padding + 12.5 radius + 12.5 radius = 40 spacing
        gridButtons.add(new Button(startX + i*40, startY + j*40, 25, 25));
    }  
  }
  
  int randomIndex = (int) random(gridButtons.size());
  currentTarget = gridButtons.get(randomIndex);
  currentTarget.highlight = true;
}

void draw() {
  for (Button b : gridButtons) {
      b.display();
  }
  
  if (trialNum == NUM_TRIALS) {
    trialNum = 0;
    round++;
    
    if (round == NUM_ROUNDS) {
      exit();
    } else {
      String buttonText = "Please select highlighted buttons as quickly and accurately as possible.\n" +
      "This is round " + (round + 1) + " of " + NUM_ROUNDS + ".\n" + "Click OK to begin";
      if (round == 2) {
        buttonText += " practice.";
      } else {
        buttonText += " evaluation.";
      }
      JOptionPane.showConfirmDialog(null, buttonText, "", JOptionPane.DEFAULT_OPTION); 
    }
  }
}


void mousePressed() {
  for (Button button : gridButtons) {
      if (button.overButton()) {
        button.highlight = true;
      }
  }
  
  if (currentTarget.overButton()) {
    int randomIndex = (int) random(gridButtons.size());
    while (randomIndex == gridButtons.indexOf(currentTarget)) {
      randomIndex = (int) random(gridButtons.size());
    }
    
    // Round 0 & 2 are practice rounds
    if (round != 0 && round != 2) {
      int elapsedTime = millis() - startTime;
      startTime = millis();
      float targetDistance = sqrt(sq(currentTarget.x - previousTarget.x) + sq(currentTarget.y - previousTarget.y));
      if (trialNum != 0) {
        print("user#: " + user + " trial# " + trialNum
              + " condition: " + condition + " elapsedTime: " + elapsedTime
              + " numberOferrors: " + numErrors + " distanceToTarget: " + targetDistance + "\n");
      }
    }
        
    currentTarget.highlight = false;
    previousTarget = currentTarget;
    
    currentTarget = gridButtons.get(randomIndex);
    currentTarget.highlight = true;
    
    trialNum++;
    numErrors = 0;
  } else {
    numErrors++;
  }
}
