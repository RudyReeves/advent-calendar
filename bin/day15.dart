import 'dart:io' show File;

const int N = 100;
const int maxCalories = 500;

List<String> lines = [];
List<List<int>> ingredients = [];
int numLines;

main() async {
  lines = await new File('inputs/day15_input.txt').readAsLines();
  numLines = lines.length;
  await parseFile();
  print(cookieTotal(optimumTeaspoons()));
}

parseFile() async {
  for (String line in lines) {
    List<String> tokens = line.split(' ');
    int capacity = int.parse(tokens[2].replaceAll(',', ''));
    int durability = int.parse(tokens[4].replaceAll(',', ''));
    int flavor = int.parse(tokens[6].replaceAll(',', ''));
    int texture = int.parse(tokens[8].replaceAll(',', ''));
    int calories = int.parse(tokens[10]);
    ingredients.add([capacity, durability, flavor, texture, calories]);
  }
}

List<List<int>> combinations(int n, int sum) {
  List<List<int>> results = [];
  for (int a = 1; a < sum - 2; a++) {
    for (int b = 1; (a + b) < sum - 1; b++) {
      for (int c = 1; (a + b + c) < sum; c++) {
        for (int d = 1; (a + b + c + d) <= sum; d++) {
          if ((a + b + c + d) == sum) {
            results.add([a, b, c, d]);
          }
        }
      }
    }
  }
  return results;
}

List<int> optimumTeaspoons() {
  List<List<int>> teaspoonCombos = combinations(4, N);
  List<int> result;
  int max;
  for (List<int> teaspoons in teaspoonCombos) {
    if (caloriesTotal(teaspoons) > maxCalories) continue;
    int total = cookieTotal(teaspoons);
    if (max == null || total > max) {
      max = total;
      result = teaspoons;
    }
  }
  return result;
}

int caloriesTotal(List<int> teaspoons) {
  int caloryTotal = 0;
  for (int i = 0; i < teaspoons.length; i++) {
    caloryTotal += teaspoons[i] * ingredients[i][4];
  }
  return caloryTotal;
}

int cookieTotal(List<int> teaspoons) {
  int capacityTotal = 0, durabilityTotal = 0, flavorTotal = 0, textureTotal = 0;

  for (int i = 0; i < teaspoons.length; i++) {
    capacityTotal   += teaspoons[i] * ingredients[i][0];
    durabilityTotal += teaspoons[i] * ingredients[i][1];
    flavorTotal     += teaspoons[i] * ingredients[i][2];
    textureTotal    += teaspoons[i] * ingredients[i][3];
  }

  if (capacityTotal <= 0 || durabilityTotal <= 0 || flavorTotal <= 0 || textureTotal <= 0) {
    return 0;
  }

  return capacityTotal * durabilityTotal * flavorTotal * textureTotal;
}
