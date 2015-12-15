import 'dart:io';

List<Wire> wires = [];
List<Gate> gates = [];

class Wire {
  final String name;

  int _signal;
  get signal => _signal;

  /// Tells every gate this wire is an input for that is has a signal now
  set signal(signal) {
    _signal = signal;
    gates.where((gate) => gate.input1 == this || gate.input2 == this)
        .forEach((gate) => gate.operate());
  }

  Wire(this.name); // Dart constructor


  /// Returns whether a token is an int or a wire name
  static bool isWire(token) {
    if (token == null) return false;

    if (token is int) return false;
    if (token is Wire) return true;

    // token is a String :(
    try {
      int.parse(token);
      return false;
    } on FormatException catch (_) {
      return true;
    }
  }
}

class Gate {
  final String operation;

  // Could be an int or Wire
  final input1;
  final input2;

  // Never null, the Gate outputs to this Wire
  final Wire outputWire;

  Gate(this.operation, this.outputWire, this.input1, [this.input2]) {
    operate();
  }

  operate() {
    // If input is a Wire (not an int), gets its int signal
    int signal1 = Wire.isWire(input1) ? input1.signal : input1;
    int signal2 = Wire.isWire(input2) ? input2.signal : input2;

    if (signal1 == null) return;

    // It's okay if signal2 is null for unary operations ("NOT" and "a->b")
    if (operation != null && operation != "NOT" && signal2 == null) return;

    // Each update to Wire.signal will check all the gates it may be an input for
    switch (operation) {
      case "NOT":
        outputWire.signal = (~signal1) & 0xFFFF;
        break;
      case "AND":
        outputWire.signal = (signal1 & signal2) & 0xFFFF;
        break;
      case "OR":
        outputWire.signal = (signal1 | signal2) & 0xFFFF;
        break;
      case "RSHIFT":
        outputWire.signal = (signal1 >> signal2) & 0xFFFF;
        break;
      case "LSHIFT":
        outputWire.signal = (signal1 << signal2) & 0xFFFF;
        break;
      default:
        outputWire.signal = signal1;
        break;
    }
  }
}

/// A token is a wire name or an int
/// If it's a wire name that doesn't exist, creates a new Wire.
parseToken(token) {
  if (Wire.isWire(token)) {
    try {
      return wires.where((w) => w.name == token).single;
    } catch (_) {
      var wire = new Wire(token);
      wires.add(wire);
      return wire;
    }
  }
  return int.parse(token);
}

main() async {
  List instructions = await new File('inputs/day7_input.txt').readAsLines();


  for (String instruction in instructions) {
    List<String> tokens = instruction.split(' ');

    // The getByToken() calls may return an int or a Wire
    switch (tokens.length) {
      case 5: // Binary op
        var input1 = parseToken(tokens.first);
        var input2 = parseToken(tokens[2]);
        Wire outputWire = parseToken(tokens.last);
        gates.add(new Gate(tokens[1], outputWire, input1, input2));
        break;
      case 4: // "NOT" op
        var input = parseToken(tokens[1]);
        var outputWire = parseToken(tokens.last);
        gates.add(new Gate('NOT', outputWire, input));
        break;
      case 3: // Operation of the sort "a->b"
        var input = parseToken(tokens[0]);
        Wire outputWire = parseToken(tokens.last);
        gates.add(new Gate(null, outputWire, input));
        break;
    }
  }

  print(parseToken('a').signal);
}
