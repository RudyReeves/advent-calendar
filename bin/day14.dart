import 'dart:io' show File;

List<String> lines;

const N = 2503;

main() async {
  lines = await new File('inputs/day14_input.txt').readAsLines();
  List stats = [];
  int maxTravel;
  for (String line in lines) {
    var tokens = line.split(' ');
    var name = tokens[0];
    var speed = int.parse(tokens[3]);
    var endurance = int.parse(tokens[6]);
    var rest = int.parse(tokens[13]);
    int travel = distanceTraveled(N, speed, endurance, rest);
    if (maxTravel == null || travel > maxTravel) {
      maxTravel = travel;
    }
    stats.add([name, speed, endurance, rest, 0]);
  }

  for (int i = 1; i <= N; i++) {
    var max, currentWinners;
    for (var stat in stats) {
      int dist = distanceTraveled(i, stat[1], stat[2], stat[3]);
      if (max == null || dist > max) {
        max = dist;
        currentWinners = [stat];
      } else if (dist == max) {
        currentWinners.add(stat);
      }
    }
    currentWinners.forEach((w) => w[4]++);
  }
  var finalWinner = stats..sort((s1, s2) => s2[4] - s1[4]);
  print('Part 1: $maxTravel');
  print('Part 2: ${finalWinner.first[4]}');
}

distanceTraveled(int n, int speed, int endurance, int rest) {
  int session = endurance + rest;
  int numSessions = n ~/ session;
  int leftover = n % session;
  leftover = (leftover > endurance ? endurance : leftover);
  int travel = speed * endurance * numSessions;
  return travel + (leftover * speed);
}