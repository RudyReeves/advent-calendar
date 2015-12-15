import 'dart:io';

const turnOn = 'turn on ';
const turnOff = 'turn off ';
const toggle = 'toggle ';
const through = ' through ';

List grid = new List<List<bool>>.generate(1000, (_) => new List<bool>.filled(1000, false));

main(List args) async {
  List instructions = await new File('inputs/day6_input.txt').readAsLines();

  for (var instruction in instructions) {
    if (instruction.startsWith(turnOn)) {
      handleTurnOn(instruction);
    } else if (instruction.startsWith(turnOff)) {
      handleTurnOff(instruction);
    } else if (instruction.startsWith(toggle)) {
      handleToggle(instruction);
    }
  }

  print(countLitLights());
}

handleTurnOn(instruction) {
  var details = instruction.substring(turnOn.length);
  var pair1 = details.substring(0, details.indexOf(' '));
  var indexes1 = pair1.split(',').map((s) => int.parse(s)).toList();
  var pair2 = details.substring(pair1.length + through.length);
  var indexes2 = pair2.split(',').map((s) => int.parse(s)).toList();

  for (int row = indexes1[0]; row <= indexes2[0]; row++) {
      grid[row][indexes1[1]] = true;
    for (int col = indexes1[1] + 1; col <= indexes2[1]; col++) {
      grid[row][col] = true;
    }
  }
}

handleTurnOff(instruction) {
  var details = instruction.substring(turnOff.length);
  var pair1 = details.substring(0, details.indexOf(' '));
  var indexes1 = pair1.split(',').map((s) => int.parse(s)).toList();
  var pair2 = details.substring(pair1.length + through.length);
  var indexes2 = pair2.split(',').map((s) => int.parse(s)).toList();

  for (int row = indexes1[0]; row <= indexes2[0]; row++) {
    grid[row][indexes1[1]] = false;
    for (int col = indexes1[1] + 1; col <= indexes2[1]; col++) {
      grid[row][col] = false;
    }
  }
}

handleToggle(instruction) {
  var details = instruction.substring(toggle.length);
  var pair1 = details.substring(0, details.indexOf(' '));
  var indexes1 = pair1.split(',').map((s) => int.parse(s)).toList();
  var pair2 = details.substring(pair1.length + through.length);
  var indexes2 = pair2.split(',').map((s) => int.parse(s)).toList();

  for (int row = indexes1[0]; row <= indexes2[0]; row++) {
    grid[row][indexes1[1]] = !grid[row][indexes1[1]];
    for (int col = indexes1[1] + 1; col <= indexes2[1]; col++) {
      grid[row][col] = !grid[row][col];
    }
  }
}

countLitLights() {
  int count = 0;
  for (int row = 0; row < grid.length; row++) {
    for (int col = 0; col < grid[row].length; col++) {
      if (grid[row][col]) count++;
    }
  }
  return count;
}