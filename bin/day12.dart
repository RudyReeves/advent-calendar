import 'dart:io';
import 'dart:convert';

main() async {
  String contents = await new File('inputs/day12_input.txt').readAsString();
  Map json = JSON.decode(contents);
  List nums = extractNumbers(json);
  print(nums);
  print(nums.fold(0, (prev, e) => prev + e));
}

extractNumbers(json) {
  List result = [];
  if (json is List) {
    for (var e in json) {
      if (e is num) {
        result.add(e);
      } else if (e is Map) {
        result.addAll(extractNumbers(e));
      } else if (e is List) {
        result.addAll(extractNumbers(e));
      }
    }
  }

  if (json is Map) {
    if (json.containsValue('red')) return [];

    json.forEach((key, value) {
      if (value is num) {
        result.add(value);
      } else if (value is Map) {
        result.addAll(extractNumbers(value));
      } else if (value is List) {
        result.addAll(extractNumbers(value));
      }
    });
  }
  return result;
}