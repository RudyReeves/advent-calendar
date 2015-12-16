import 'dart:io';

class Flightpath {
  String node1;
  String node2;
  int cost;
  Flightpath(this.node1, this.node2, this.cost);
}

Map<String, List<Flightpath>> flightsTable = {};
List visited = [];

main() async {
  List<String> lines = await new File('inputs/day9_input.txt').readAsLines();

  for (String line in lines) {
    // Parse input
    List<String> tokens = line.split(' ');
    String name = tokens[0];
    String flight = tokens[2];
    int distance = int.parse(tokens[4]);

    // Build flightsTable: [{'city': [{name, flight, distance}, ...}]]

    // From here to there
    if (!flightsTable.containsKey(name)) {
      flightsTable.putIfAbsent(name, () => [new Flightpath(name, flight, distance)]);
    } else {
      flightsTable[name].add(new Flightpath(name, flight, distance));
    }

    // From there to here
    if (!flightsTable.containsKey(flight)) {
      flightsTable.putIfAbsent(flight, () => [new Flightpath(flight, name, distance)]);
    } else {
      flightsTable[flight].add(new Flightpath(flight, name, distance));
    }
  }

  int totalCost = 0;
  for (String place in flightsTable.keys) {
    // Do not revisit locations
    if (visited.contains(place)) continue;

    // Calculate minimum distance (cost)
    Flightpath nextRoute = flightsTable[place].first;
    int shortest = nextRoute.cost;
    for (Flightpath route in flightsTable[place]) {
      if (route.cost < shortest) {
        shortest = route.cost;
        nextRoute = route;
      }
    }

    // Select next location
    place = nextRoute.node1 == place ? nextRoute.node1 : nextRoute.node2;
    print("Going to: ${place} (${nextRoute.cost})");

    // Add cost except for first location
    if (visited.length > 0) {
      totalCost += nextRoute.cost;
    }
    visited.add(place);
  }

  print(totalCost);
}