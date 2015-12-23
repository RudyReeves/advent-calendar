import 'dart:io' show File;
import 'dart:collection' show LinkedHashMap;

List<String> lines;
List<String> visited;
Map<String, Map<String, int>> happiness = {};

main() async {
  lines = await new File('inputs/day13_input.txt').readAsLines();
  print(await getBestArrangement());
}

parseFile() {
  visited = [];
  for (String line in lines) {
    List tokens = line.split(' ');
    String person1 = tokens[0];
    String person2 = tokens[10].replaceAll('.', '');
    int amount = int.parse(tokens[3]);
    if (tokens[2] == 'lose') amount = -amount;

    if (happiness[person1] == null) happiness[person1] = {};
    happiness[person1][person2] = amount;
  }
}

arrangeSeating(String startingPerson) {
  print("Arranging for $startingPerson...");
  var current = startingPerson;
  String next;
  int amount = 0;
  while ((next = getNext(current)) != null) {
    print("  -> $next (${happiness[current][next]} for $current, ${happiness[next][current]} for $next)");
    amount += happiness[current][next] + happiness[next][current];
    visited.add(current);
    current = next;
  }
  print("  -> (${happiness[current][startingPerson]} for $current, ${happiness[startingPerson][current]} for $startingPerson)");
  amount += happiness[current][startingPerson] + happiness[startingPerson][current];
  print("  = $amount");
  return amount;
}

getNext(String person) {
  sorter(p1, p2) => (happiness[person][p2] - happiness[person][p1]);
  var keys = happiness[person].keys.toList()..sort(sorter);
  var sorted = new LinkedHashMap.fromIterable(keys, value: (v) => happiness[person][v]);
  return sorted.keys.firstWhere((p) => !visited.contains(p), orElse: () => null);
}

getBestArrangement() async{
  await parseFile();
  var amounts = [];
  for (int i = 0; i < happiness.keys.length; i++) {
    amounts.add(arrangeSeating(happiness.keys.elementAt(i)));
    await parseFile();
  }
  amounts.sort();
  return amounts.last;
}