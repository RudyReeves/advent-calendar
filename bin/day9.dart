import 'dart:io';

List places = [];
Map neighbors = {};

main() async {
  List lines = await new File('inputs/day9_input.txt').readAsLines();

  for (var line in lines) {
    var tokens = line.split(' ');
    var possibleDestination = tokens[2];
    int distance = int.parse(tokens[4]);
    if (!places.contains(tokens.first)) {
      places.add(tokens.first);
      neighbors.putIfAbsent(
          tokens.first, () => [[possibleDestination, distance]]);
    } else {
      neighbors[tokens.first].add([possibleDestination, distance]);
    }
  }

  for (var place in places) {
    var route = [];
    var nearestNeighbor = findNearestNeighbor(place);
    var neighbor = nearestNeighbor[0];
    var distance = nearestNeighbor[1];
    print("The nearest neighbor to $place is $neighbor (distance $distance)");
  }
}

findNearestNeighbor(place) {
    var localPlaces = neighbors[place];
    var nearest = localPlaces.first;
    int distance = nearest[1];
    for (var place in localPlaces) {
      if (place[1] < distance) {
        distance = place[1];
        nearest = place;
      }
    }
    return nearest;
}