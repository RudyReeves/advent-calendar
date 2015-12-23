import 'dart:io' show File;

const turnOn = 'turn on ';
const turnOff = 'turn off ';
const toggle = 'toggle ';
const through = ' through ';

List grid = new List<List<bool>>.generate(1000, (_) => new List<bool>.filled(1000, false));
List grid2 = new List<List<int>>.generate(1000, (_) => new List<int>.filled(1000, 0));

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
  print("Part 2: ${part2(instructions)}");
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

part2(instructions) {
  for (var instruction in instructions) {
    if (instruction.startsWith(turnOn)) {
      handleTurnOn2(instruction);
    } else if (instruction.startsWith(turnOff)) {
      handleTurnOff2(instruction);
    } else if (instruction.startsWith(toggle)) {
      handleToggle2(instruction);
    }
  }
  return countBrightness();
}

handleTurnOn2(instruction) {
  var details = instruction.substring(turnOn.length);
  var pair1 = details.substring(0, details.indexOf(' '));
  var indexes1 = pair1.split(',').map((s) => int.parse(s)).toList();
  var pair2 = details.substring(pair1.length + through.length);
  var indexes2 = pair2.split(',').map((s) => int.parse(s)).toList();

  for (int row = indexes1[0]; row <= indexes2[0]; row++) {
    grid2[row][indexes1[1]]++;
    for (int col = indexes1[1] + 1; col <= indexes2[1]; col++) {
      grid2[row][col]++;
    }
  }
}

handleTurnOff2(instruction) {
  var details = instruction.substring(turnOff.length);
  var pair1 = details.substring(0, details.indexOf(' '));
  var indexes1 = pair1.split(',').map((s) => int.parse(s)).toList();
  var pair2 = details.substring(pair1.length + through.length);
  var indexes2 = pair2.split(',').map((s) => int.parse(s)).toList();

  for (int row = indexes1[0]; row <= indexes2[0]; row++) {
    if (grid2[row][indexes1[1]] > 0) {
      grid2[row][indexes1[1]]--;
    }
    for (int col = indexes1[1] + 1; col <= indexes2[1]; col++) {
      if (grid2[row][col] > 0) {
        grid2[row][col]--;
      }
    }
  }
}

handleToggle2(instruction) {
  var details = instruction.substring(toggle.length);
  var pair1 = details.substring(0, details.indexOf(' '));
  var indexes1 = pair1.split(',').map((s) => int.parse(s)).toList();
  var pair2 = details.substring(pair1.length + through.length);
  var indexes2 = pair2.split(',').map((s) => int.parse(s)).toList();

  for (int row = indexes1[0]; row <= indexes2[0]; row++) {
    grid2[row][indexes1[1]] += 2;
    for (int col = indexes1[1] + 1; col <= indexes2[1]; col++) {
      grid2[row][col] += 2;
    }
  }
}

countBrightness() {
  int count = 0;
  for (int row = 0; row < grid2.length; row++) {
    for (int col = 0; col < grid2[row].length; col++) {
      count += grid2[row][col];
    }
  }
  return count;
}