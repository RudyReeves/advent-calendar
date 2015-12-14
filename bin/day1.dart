main(List args) {
  String floors = args[0];
  int floorChange(c) =>
    c == '(' ? 1 : (c == ')' ? -1 : 0);
  int floor = floors.split('').fold(0, (prev, c) => prev + floorChange(c));
  print(floor);
}