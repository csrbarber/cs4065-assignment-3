import javax.swing.JOptionPane;

int NUM_TRIALS = 21 ;
int NUM_ROUNDS = 4;
int AREA_CLICK_DIAMETER = 25;
boolean VIEW_CLICK_AREA = false;

ArrayList<Button> gridButtons;
String user;
int condition, round, trialNum, startTime, numErrors;
Button previousTarget, currentTarget;

void setup() {
  fullScreen();
  background(204);
  round = 0;
  trialNum = 0;
  
  user = JOptionPane.showInputDialog("Enter user ID:");
  condition = Integer.parseInt(JOptionPane.showInputDialog("Enter condition (0 or 1):"));
  String buttonText = "Please select highlighted buttons as quickly and accurately as possible.\n" +
    "This is round " + (round + 1) + " of " + NUM_ROUNDS + ".\n" + "Click OK to begin practice.";
  JOptionPane.showConfirmDialog(null, buttonText, "", JOptionPane.DEFAULT_OPTION);
  
  
  // Create grid of buttons
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
  // Tool for debugging
  if (VIEW_CLICK_AREA && condition == 1) {
     background(204); 
   }
  
  for (Button b : gridButtons) {
      b.display();
  }
  
  // Tool for debugging
  if (VIEW_CLICK_AREA && condition == 1) {
    fill(255, 255, 0, 250);
    ellipse(mouseX, mouseY, AREA_CLICK_DIAMETER, AREA_CLICK_DIAMETER);
  }
  
  // Go to next trial
  if (trialNum == NUM_TRIALS) {
    trialNum = 0;
    round++;
    
    // If final round exit, else go to next round
    if (round == NUM_ROUNDS) {
      exit();
    } else {
      String buttonText = "Please select highlighted buttons as quickly and accurately as possible.\n" +
      "This is round " + (round + 1) + " of " + NUM_ROUNDS + ".\n" + "Click OK to begin";
      if (round == 2) {
        buttonText += " practice.";
        if (condition == 0) {
          condition = 1;
        } else {
          condition = 0;
        }
      } else {
        buttonText += " evaluation.";
      }
      JOptionPane.showConfirmDialog(null, buttonText, "", JOptionPane.DEFAULT_OPTION); 
    }
  }
}


void mousePressed() {
  // Condition 0 is default click
  if (condition == 0) {
    if  (currentTarget.overButton(mouseX, mouseY)) {
      completeTrial();
    } else {
      numErrors++;
    }
  } else {
    // Condition 1 is area click
    boolean hit = false;
    int d;
    //  Determine if points along circumference are over currentTarget
    for (d = 0; d < 360; d++) {
      float rads = radians(d);
      int x = (int) (((AREA_CLICK_DIAMETER/2) * cos(rads)) + mouseX);
      int y = (int) (((AREA_CLICK_DIAMETER/2) * sin(rads)) + mouseY);
      if (currentTarget.overButton(x, y)) { 
        hit = true;
        break;
      }
    }
    
    // If point on circumference over currentTarget complete the trial
    if (hit) {
      completeTrial();
    } else {
      numErrors++;
    }
  }
}

/*
Swap currentTarget with previousTarget.
Select new random currentTarget.
Display stats for currentTarget and reset variables for next target.
*/
void completeTrial() {
  int randomIndex = (int) random(gridButtons.size());
  // Ensure we don't highlight the same target
  while (randomIndex == gridButtons.indexOf(currentTarget)) {
    randomIndex = (int) random(gridButtons.size());
  }
  
  // Round 0 & 2 are practice rounds
  if (round != 0 && round != 2) {
    // For first trial of each round startTime is unset
    int elapsedTime = millis() - startTime;
    startTime = millis();
    float targetDistance = sqrt(sq(currentTarget.x - previousTarget.x) + sq(currentTarget.y - previousTarget.y));
    if (trialNum != 0) {
      print("user#: " + user + " trial# " + trialNum
            + " condition: " + condition + " elapsedTime: " + elapsedTime
            + " numberOferrors: " + numErrors + " distanceToTarget: " + targetDistance + "\n");
    }
  }
  
  // Update currentTarget and previousTarget on target click
  currentTarget.highlight = false;
  previousTarget = currentTarget;
  currentTarget = gridButtons.get(randomIndex);
  currentTarget.highlight = true;
  
  // Reset trial stats
  trialNum++;
  numErrors = 0;
}
