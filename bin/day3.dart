import 'dart:io' show File;
import 'dart:math' show Point;

main() async {
  List directions = (await new File('bin/day3_input.txt').readAsString()).split('');
  List housesVisited = [];
  Point root = const Point(0, 0);

  visitHouse(Point house) {
    if (!housesVisited.contains(house)) {
      housesVisited.add(house);
      root = house;
    } else {
      root = house;
    }
  }

  visitHouse(root);

  for (var direction in directions) {
    switch (direction) {
      case '<':
        visitHouse(root + const Point(-1, 0));
        break;
      case '>':
        visitHouse(root + const Point(1, 0));
        break;
      case '^':
        visitHouse(root + const Point(0, 1));
        break;
      case 'v':
        visitHouse(root + const Point(0, -1));
        break;
    }
  }

  print(housesVisited.length);
}