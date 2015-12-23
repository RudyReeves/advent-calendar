import 'dart:io' show File;
import 'dart:collection' show LinkedHashMap;

List<String> lines;
List<City> cities;
List<City> visited;

main() async {
  print("Part 1: ${await bestTravelDistance()}");
  print("Part 2: ${await bestTravelDistance(closest: false)}");
}

readFile() async {
  cities = [];
  visited = [];
  if (lines == null) {
    lines = await new File('inputs/day9_input.txt').readAsLines();
  }

  for (String line in lines) {
    List<String> tokens = line.split(' ');
    var place1 = City.getByName(tokens[0]);
    var place2 = City.getByName(tokens[2]);
    int distance = int.parse(tokens[4]);

    place1.distances[place2] = distance;
    place2.distances[place1] = distance;
  }
}

class City {
  final String name;
  Map<City, int> distances;
  City(this.name, this.distances);

  static getByName(String name) {
    var lookup = cities.where((place) => place.name == name);
    if (lookup.isEmpty) {
      City place = new City(name, {});
      cities.add(place);
      return place;
    } else {
      return lookup.single;
    }
  }

  getNext({bool closest: true}) {
    sorter(p1, p2) => (distances[p1] - distances[p2]) * (closest ? 1 : -1);
    var keys = distances.keys.toList()..sort(sorter);
    var sorted = new LinkedHashMap.fromIterable(keys, value: (v) => distances[v]);
    return sorted.keys.firstWhere((p) => !visited.contains(p), orElse: () => null);
  }
}

bestTravelDistance({bool closest: true}) async {
  await readFile();
  var distances = [];
  for (int i = 0; i < cities.length; i++) {
    distances.add(travelDistance(cities[i], closest: closest));
    await readFile();
  }
  distances.sort();
  return closest ? distances.first : distances.last;
}

travelDistance(City city, {bool closest: true}) {
  int distance = 0;
  var current = city;
  while (cities.isNotEmpty) {
    City next = current.getNext(closest: closest);
    if (next == null) break;

    distance += current.distances[next];
    cities.remove(current);
    visited.add(current);
    current = next;
  }
  return distance;
}