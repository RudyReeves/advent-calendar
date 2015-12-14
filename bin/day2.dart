import 'dart:io';
import 'dart:math' show min;

main() async {
  List boxes = await new File('day2_input.txt').readAsLines();

  int area = 0;
  for (String box in boxes) {
    List dimensions = box.split('x');
    int l = int.parse(dimensions[0]);
    int w = int.parse(dimensions[1]);
    int h = int.parse(dimensions[2]);

    var areaTop = l * w;
    var areaFront = l * h;
    var areaLeft = w * h;
    var areaSmallest = min(areaTop, min(areaFront, areaLeft));
    
    area += 2 * (areaTop + areaFront + areaLeft) + areaSmallest;
  }
  print(area);
}