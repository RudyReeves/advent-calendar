import 'dart:io' show File;

List<String> lines;
List<Map<String, int>> auntsInfo = [];

List allKeys = [
  'id',
  'children',
  'cats',
  'samoyeds',
  'pomeranians',
  'akitas',
  'vizslas',
  'goldfish',
  'trees',
  'cars',
  'perfumes'
];

Map known = {
  'children': 3,
  'cats': 7,
  'samoyeds': 2,
  'pomeranians': 3,
  'akitas': 0,
  'vizslas': 0,
  'goldfish': 5,
  'trees': 3,
  'cars': 2,
  'perfumes': 1
};

main() async {
  lines = await new File('inputs/day16_input.txt').readAsLines();
  await parseFile();

  var results = [];
  for (Map aunt in auntsInfo) {
    bool match = true;
    for (String key in known.keys) {
      if (aunt[key] != null)
        if (key == 'cats' || key == 'trees') {
          match = match && known[key] < aunt[key];
        } else if (key == 'pomeranians' || key == 'goldfish') {
          match = match && known[key] > aunt[key];
        } else {
          match = match && known[key] == aunt[key];
        }
    }
    if (match) {
      results.add(aunt);
    }
  }
  results.forEach(print);
}

parseFile() async {
  for (String line in lines) {
    List<String> tokens = line.split(' ');
    int id = int.parse(tokens[1].replaceAll(':', ''));
    Map info = {"id": id};

    for (int i = 2; i < tokens.length; i += 2) {
      String key = tokens[i].replaceAll(':', '');
      int value = int.parse(tokens[i + 1].replaceAll(',', ''));
      info.putIfAbsent(key, () => value);
    }

    auntsInfo.add(info);
  }
}