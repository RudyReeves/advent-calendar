import 'dart:io' show File;

List<Place> places = [];
int shortest;

class Place {
  final String from;
  final String to;
  final int distance;
  const Place(this.from, this.to, this.distance);
}

main() async {
  List<String> lines = await new File('inputs/day9_input.txt').readAsLines();

//  Mock data
//  List lines = [
//    'London to Dublin = 464',
//    'London to Belfast = 518',
//    'Dublin to Belfast = 141'
//  ];

  for (String line in lines) {
    // Parse input
    List<String> tokens = line.split(' ');
    String from = tokens[0];
    String to = tokens[2];
    int distance = int.parse(tokens[4]);

    places.add(new Place(from, to, distance));
  }

  // Get *all* the permutations of the places (even if they're not neighbors)
  List permutations = permute(places);

  // Assume the first permutation is the shortest
  int shortest = routeDistance(permutations.first);

  // Loop through the other permutations and try to find a shorter one
  for (List permutation in permutations) {
    int dist = routeDistance(permutation);
    if (dist < shortest) {
      shortest = dist;
    }
  }

  print(shortest);
}

// Gets the *total* distance of the route in the places[] argument
int routeDistance(List<Place> places) {
  int dist = 0;
  for (int i = 1; i < places.length; i++) {
    dist += places[i].distance;
  }
  return dist;
}

// Takes any list and returns a list *all* its permutations
List<List> permute(List list) {
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