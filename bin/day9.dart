import 'dart:io' show File;
import 'dart:collection' show LinkedHashMap;

List<String> lines;
List<String> visited;
Map<String, Map<String, int>> paths = {};

main() async {
  lines = await new File('inputs/day9_input.txt').readAsLines();
  print("Part 1: ${await bestTravelDistance()}");
  print("Part 2: ${await bestTravelDistance(closest: false)}");
  await parseFile();
}

parseFile() async {
  visited = [];
  for (String line in lines) {
    List<String> tokens = line.split(' ');
    int distance = int.parse(tokens[4]);
    if (paths[tokens[0]] == null) paths[tokens[0]] = {};
    if (paths[tokens[2]] == null) paths[tokens[2]] = {};
    paths[tokens[0]][tokens[2]] = distance;
    paths[tokens[2]][tokens[0]] = distance;
  }
}


getNext(String city, {bool closest: true}) {
  sorter(city1, city2) => (paths[city][city1] - paths[city][city2]) * (closest ? 1 : -1);
  var keys = paths[city].keys.toList()..sort(sorter);
  var sorted = new LinkedHashMap.fromIterable(keys, value: (v) => paths[city][v]);
  return sorted.keys.firstWhere((p) => !visited.contains(p), orElse: () => null);
}

bestTravelDistance({bool closest: true}) async {
  await parseFile();
  var distances = [];
  for (int i = 0; i < paths.keys.length; i++) {
    distances.add(travelDistance(paths.keys.elementAt(i), closest: closest));
    await parseFile();
  }
  distances.sort();
  return closest ? distances.first : distances.last;
}

travelDistance(String startingCity, {bool closest: true}) {
  var current = startingCity;
  String next;
  int distance = 0;
  while ((next = getNext(current, closest: closest)) != null) {
    distance += paths[current][next];
    visited.add(current);
    current = next;
  }
  return distance;
}