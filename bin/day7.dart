import 'dart:io';

List<Wire> wires = [];
List<Gate> gates = [];

class Wire {
  final String name;

  int _signal;
  get signal => _signal;

  /// Sets a signal for this wire
  /// Tells every gate to operate if one its inputs is this Wire
  set signal(signal) {
    _signal = signal;
    Gate.runOperations(this);
  }

  /// Constructs a Wire by its name
  Wire(this.name);

  @override String toString() => 'Wire($name)';

  /// Returns whether a token is an int or a wire name
  static bool isWire(token) {
    if (token == null) return false;

    if (token is int) return false;
    if (token is Wire) return true;

    // token is a String
    try {
      int.parse(token);
      return false;
    } on FormatException catch (_) {
      return true;
    }
  }

  /// Returns a Wire or int from its name (token)
  /// If it's a wire name that doesn't exist, creates a new Wire.
  static getByToken(token) {
    if (isWire(token)) {
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
}

/// Represents a gate that can do a binary operation
/// I consider "null" Gates to be a circuit connection (like "a->b")
class Gate {
  final String operation;

  // Could be an int (like "123 -> x")
  // Could be a Wire (which knows its own signal, if it has one)
  final input1;

  // Always null for unary Gates ("NOT" and "null" gates)
  // Could be a Wire (which knows its own signal, if it has one)
  final input2;

  // Never null, the Gate outputs to this Wire,
  // when it gets the necessary input signals
  final outputWire;

  Gate(this.operation, this.outputWire, this.input1, [this.input2]) {
    operate();
  }

  /// Performs this Gates operation
  operate() {
    bool isWire1 = Wire.isWire(input1); // Could be int or Wire
    bool isWire2 = Wire.isWire(input2); // Could be int or Wire

    // If input1 is a Wire, gets its signal (as an int)
    int signal1 = isWire1 ? input1.signal : input1;
    // If input2 is a Wire, gets its signal (as an int)
    int signal2 = isWire2 ? input2.signal : input2;

    // We need at least one signal for this Gate to output anything
    if (signal1 == null) return;

    // We need two signals for binary operations
    if (operation != null && operation != "NOT" && signal2 == null) return;

    // Each update the outputWire.signal= will trigger the runOperations() method below
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

  @override String toString() => 'Gate($operation, $input1, $input2, $outputWire)';

  /// Loops through every  gate, and calls its operation if
  /// one if its inputs is this wire (which just got a signal!)
  static runOperations(Wire wire) {
    for (Gate gate in gates) {
      if (gate.input1 == wire || gate.input2 == wire) {
        gate.operate();
      }
    }
  }
}

main() async {
  List instructions = await new File('inputs/day7_input.txt').readAsLines();


  for (String instruction in instructions) {
    List<String> tokens = instruction.split(' ');

    // The following getByToken() calls may return an int or a Wire,
    // each time creating a new Gate with the proper operation and inputs
    switch (tokens.length) {
      case 5: // Binary op
        var input1 = Wire.getByToken(tokens.first);
        var input2 = Wire.getByToken(tokens[2]);
        Wire outputWire = Wire.getByToken(tokens.last);
        gates.add(new Gate(tokens[1], outputWire, input1, input2));
        break;
      case 4: // "NOT" op
        var input = Wire.getByToken(tokens[1]);
        var outputWire = Wire.getByToken(tokens[3]);
        gates.add(new Gate('NOT', outputWire, input));
        break;
      case 3: // Operation of the sort "a->b"
        var input = Wire.getByToken(tokens[0]);
        Wire outputWire = Wire.getByToken(tokens.last);
        gates.add(new Gate(null, outputWire, input));
        break;
    }
  }

  print(Wire.getByToken('a').signal);
}
