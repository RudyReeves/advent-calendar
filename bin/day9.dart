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
    Flightpath nextFlight = flightsTable[place].first;
    int shortest = nextFlight.cost;
    for (Flightpath flight in flightsTable[place]) {
      if (flight.cost < shortest) {
        shortest = flight.cost;
        nextFlight = flight;
      }
    }

    // Select next location
    place = nextFlight.node1 == place ? nextFlight.node1 : nextFlight.node2;
    print("Going to: ${place} (${nextFlight.cost})");
    visited.add(place);

    // Add cost except for first location
    if (visited.length > 0 && visited.length != flightsTable.keys.length - 1) {
      totalCost += nextFlight.cost;
    }
  }

  print(totalCost);
}