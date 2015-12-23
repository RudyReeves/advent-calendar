import 'dart:io' show File;

List<String> lines;
List<Place> places = [];
List<Place> visited = [];

class Place {
  final String name;
  Map<Place, int> distances;

  static getPlaceByName(String name, {Map distances}) {
    if (distances == null) distances = {};

    var lookup = places.where((place) => place.name == name);
    if (lookup.isEmpty) {
      Place place = new Place(name, distances);
      places.add(place);
      return place;
    } else {
      return lookup.single;
    }
  }

  Place getNextCity({bool closest: true}) {
    Place candidate;
    try {
      candidate = distances.keys.firstWhere((p) => !visited.contains(p));
    } catch (_) {
      return null;
    }

    int bestDistance = distances[candidate];

    for (Place route in distances.keys) {
      if (visited.contains(route) || !places.contains(route)) continue;

      bool isNextCandidate = closest ? (distances[route] < bestDistance) : (distances[route] > bestDistance);
      if (isNextCandidate) {
        bestDistance = distances[route];
        candidate = route;
      }
    }

    return candidate;
  }

  Place(this.name, this.distances);
  toString() => '($name, ${distances.length})';
}

main() async {
  await runAllRoutes(1);
  print('------------------------------------');
  await runAllRoutes(2, closest: false);
}

readFile() async {
  places = [];
  visited = [];

  // Read in the file's if necessary
  if (lines == null) {
    lines = await new File('inputs/day9_input.txt').readAsLines();
  }

  for (String line in lines) {
    List<String> tokens = line.split(' ');
    String name = tokens[0];
    String route = tokens[2];
    int distance = int.parse(tokens[4]);

    // Lookup the place
    var place = Place.getPlaceByName(name);

    // Lookup the route
    var routePlace = Place.getPlaceByName(route, distances: {place: distance});

    // Make place route to routePlace and vice-versa
    place.distances[routePlace] = distance;
    routePlace.distances[place] = distance;
  }
}

runAllRoutes(int part, {bool closest: true}) async {
  await readFile();
  final n = places.length;

  print("Part $part:\n");

  int bestDistance;
  int index;

  for (int i = 0; i < n; i++) {
    int distance = takeRoute(places[i], closest: closest);
    if (bestDistance == null ||
        (closest ? (distance < bestDistance) : (distance > bestDistance))) {
      bestDistance = distance;
      index = i;
    }
    await readFile();
  }

  print("\nWinner: $bestDistance (${places[index].name})");
}

takeRoute(Place place, {bool closest: true}) {
  var sb = new StringBuffer();
  sb.write(place.name);

  int distance = 0;
  Place current = place;


  while (places.isNotEmpty) {
    Place next = current.getNextCity(closest: closest);

    if (next == null) break;
    visited.add(next);

    sb.write(" ->  ${next.name}");
    distance += current.distances[next];

    places.remove(current);
    current.distances.remove(place);
    next.distances.remove(place);

    next.distances.remove(current);
    current.distances.remove(next);

    current = next;
  }

  print('$distance: $sb');
  return distance;
}