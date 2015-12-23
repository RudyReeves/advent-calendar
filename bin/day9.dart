import 'dart:io' show File;

List<String> lines;
List<Place> places = [];
List<Place> visited = [];

class Place {
  final String name;
  Map<Place, int> routes;

  static getPlaceByName(String name)
    => places.where((place) => place.name == name);

  Place getClosest() {
    Place closest;
    try {
      closest = routes.keys.firstWhere((p) => !visited.contains(p));
    } catch (_) {
      return null;
    }

    int shortest = routes[closest];

    for (Place route in routes.keys) {
      if (visited.contains(route) || !places.contains(route)) continue;

      if (routes[route] < shortest) {
        shortest = routes[route];
        closest = route;
      }
    }

    return closest;
  }

  Place(this.name, this.routes);
  toString() => '($name, ${routes.length})';
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
    Place place;
    var lookup = Place.getPlaceByName(name);

    if (lookup.isEmpty) {
      // Encountered a new city
      place = new Place(name, {});
      places.add(place);
    } else {
      // Get a handle on the existing city
      place = lookup.single;
    }

    // Lookup the route
    Place routePlace;
    var routeLookup = Place.getPlaceByName(route);

    if (routeLookup.isEmpty) {
      // Encountered a new city
      routePlace = new Place(route, {place: distance});
      places.add(routePlace);
    } else {
      // Get a handle on the existing city
      routePlace = routeLookup.single;
    }

    // Make place route to routePlace and vice-versa
    place.routes[routePlace] = distance;
    routePlace.routes[place] = distance;
  }
}

main() async {
  await readFile();
  final n = places.length;

  int shortest;
  int index;

  for (int i = 0; i < n; i++) {
    int distance = takeRoute(places[i]);
    if (shortest == null || distance < shortest) {
      shortest = distance;
      index = i;
    }
    await readFile();
  }

  print("\nWinner: $shortest (${places[index].name})");
}

takeRoute(Place place) {
  var sb = new StringBuffer();
  sb.write(place.name);

  int distance = 0;
  Place current = place;


  while (places.isNotEmpty) {
    Place closest = current.getClosest();
    if (closest == null) break;
    visited.add(closest);

    sb.write(" ->  ${closest.name}");
    distance += current.routes[closest];

    places.remove(current);
    closest.routes.remove(place);
    current.routes.remove(place);
    closest.routes.remove(current);
    current.routes.remove(closest);

    current = closest;
  }

  print('$distance: $sb');
  return distance;
}