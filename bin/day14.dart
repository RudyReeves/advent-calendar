import 'dart:io' show File;

List<String> lines;

const N = 2503;

main() async {
  lines = await new File('inputs/day14_input.txt').readAsLines();
  List reindeer = [];
  for (String line in lines) {
    var tokens = line.split(' ');
    var speed = int.parse(tokens[3]);
    var endurance = int.parse(tokens[6]);
    var rest = int.parse(tokens[13]);
    reindeer.add([speed, endurance, rest, 0]);
  }
  for (int i = 0; i < N; i++) {
    var winner = null;
    int max = 0;
    for (var r in reindeer) {
      int dist = distanceTraveled(i, r[0], r[1], r[2]);
      if (dist > max) {
        max = dist;
        winner = r;
      }
    }
    winner[3]++;
  }
  print(reindeer);
}

distanceTraveled(int n, int speed, int endurance, int rest) {
  int session = endurance + rest;
  int numSessions = n ~/ session;
  int leftover = n % session;
  leftover = (leftover > endurance ? endurance : leftover);
  int travel = speed * endurance * numSessions;
  return travel + (leftover * speed);
}