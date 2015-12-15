import 'dart:io';

List<Wire> wires = [];
List<Gate> gates = [];

class Wire {
  final String name;
  int signal;
  Wire(this.name); // Dart constructor
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
    int signal1 = isWireName(input1) ? input1.signal : input1;
    int signal2 = isWireName(input2) ? input2.signal : input2;

    if (signal1 == null) return;

    // It's okay if signal2 is null for "NOT" operations
    if (operation != "NOT" && signal2 == null) return;

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
    }
  }
}

/// Returns whether a token is an int or a wire name
bool isWireName(token) {
  if (token == null) return false;
  if (token is int) return false;
  if (token is Wire) return true;

  // The token is a String :(
  try {
    int.parse(token);
    return false;
  } on FormatException catch (_) {
    return true;
  }
}

/// A token is a wire name or an int
/// If it's a wire name that doesn't exist, creates a new Wire.
parseToken(token) {
  if (isWireName(token)) {
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

    // The parseToken() calls may return an int or a Wire
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
