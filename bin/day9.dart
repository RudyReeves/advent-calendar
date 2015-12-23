import 'dart:io' show File;
import 'dart:collection' show LinkedHashMap;

List<String> lines;
List<Place> places = [];
List<Place> visited = [];

class Place {
  final String name;
  Map<Place, int> distances;

  static getPlaceByName(String name) {
    var lookup = places.where((place) => place.name == name);
    if (lookup.isEmpty) {
      Place place = new Place(name, {});
      places.add(place);
      return place;
    } else {
      return lookup.single;
    }
  }

  getNextCity({bool closest: true}) {
    sorter(p1, p2) => (distances[p1] - distances[p2]) * (closest ? 1 : -1);
    var sorted = new LinkedHashMap.fromIterable(distances.keys.toList()..sort(sorter), value: (v) => distances[v]);
    try {
      return sorted.keys.firstWhere((p) => !visited.contains(p));
    } catch (_) {
      return null;
    }
  }

  Place(this.name, this.distances);
  toString() => '($name, ${distances.length})';
}

main() async {
  print("Part 1: ${await tryAllPaths(1)}");
  print("Part 2: ${await tryAllPaths(2, closest: false)}");
}

readFile() async {
  places = [];
  visited = [];
  if (lines == null) {
    lines = await new File('inputs/day9_input.txt').readAsLines();
  }

  for (String line in lines) {
    List<String> tokens = line.split(' ');
    var place1 = Place.getPlaceByName(tokens[0]);
    var place2 = Place.getPlaceByName(tokens[2]);
    int distance = int.parse(tokens[4]);

    place1.distances[place2] = distance;
    place2.distances[place1] = distance;
  }
}

tryAllPaths(int part, {bool closest: true}) async {
  await readFile();
  List distances = [];
  for (int i = 0; i < places.length; i++) {
    distances.add(tryPath(places[i], closest: closest));
    await readFile();
  }
  distances.sort((d1, d2) => (d1 - d2) * (closest ? 1 : -1));
  return distances.first;
}

tryPath(Place place, {bool closest: true}) {
  int distance = 0;
  var current = place;
  while (places.isNotEmpty) {
    Place next = current.getNextCity(closest: closest);
    if (next == null) break;

    distance += current.distances[next];
    places.remove(current);
    visited.add(current);
    current = next;
  }
  return distance;
}