//import 'dart:io' show File;

List<Place> places = [];

class Place {
  final String from;
  final String to;
  final int distance;
  const Place(this.from, this.to, this.distance);
}

int shortest;

main() async {
//  List<String> lines = await new File('inputs/day9_input.txt').readAsLines();

  List lines = [
    'London to Dublin = 464',
    'London to Belfast = 518',
    'Dublin to Belfast = 141'
  ];

  for (String line in lines) {
    // Parse input
    List<String> tokens = line.split(' ');
    String from = tokens[0];
    String to = tokens[2];
    int distance = int.parse(tokens[4]);

    Place place = new Place(from, to, distance);
    places.add(place);
  }

  List permutations = permute(places);
  int shortest = distance(permutations.first);

  for (List permutation in permutations) {
    int dist = distance(permutation);
    if (dist < shortest) {
      shortest = dist;
    }
  }

  print(shortest);
}

int distance(List<Place> places) {
  int dist = 0;
  for (int i = 1; i < places.length; i++) {
    dist += places[i].distance;
  }
  return dist;
}

List permute(List list) {
  if (list.isEmpty) return [[]];

  var firstElement = list.removeAt(0);
  List returnValue = [];
  List permutations = permute(list);

  for (List permutation in permutations) {
    for (int i = 0; i <= permutation.length; i++) {
      List temp = new List.from(permutation);
      temp.insert(i, firstElement);
      returnValue.add(temp);
    }
  }
  return returnValue;
}