import 'dart:io' show File;
import 'dart:math' show Point;

main() async {
  List directions = (await new File('inputs/day3_input.txt').readAsString()).split('');

  Point currentHouse = const Point(0, 0);
  Set housesVisited = new Set()..add(currentHouse);

  for (var direction in directions) {
    var delta;
    switch (direction) {
      case '<':
        delta = const Point(-1, 0);
        break;
      case '>':
        delta = const Point(1, 0);
        break;
      case '^':
        delta = const Point(0, 1);
        break;
      case 'v':
        delta = const Point(0, -1);
        break;
    }

    currentHouse += delta;
    housesVisited.add(currentHouse);
  }

  print(housesVisited.length);
}