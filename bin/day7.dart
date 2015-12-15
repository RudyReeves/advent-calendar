import 'dart:io';

List<Wire> wires = [];
List<Gate> gates = [];

class Wire {
  final String name;
  Wire link;
  int _signal;

  get signal => _signal ?? link?.signal;

  set signal(signal) => _signal = signal;

  Wire(this.name);
  toString() => '$name';
}

class Gate {
  final String operation;
  final input1;
  final input2;
  final output;

  Gate(this.operation, this.output, this.input1, [this.input2]);

  bool isConnected() {
    // Inputs can be Wires or ints - convert Wires to their int signals
    int signal1 = isWire(input1) ? input1.signal : input1;
    int signal2 = isWire(input2) ? input2.signal : input2;

    if (signal1 == null) return false;
    if (operation != "NOT" && signal2 == null) return false;
    return true;
  }

  run() {
    if (!isConnected()) return;

    // Inputs can be Wires or ints - convert Wires to their int signals
    int signal1 = isWire(input1) ? input1.signal : input1;
    int signal2 = isWire(input2) ? input2.signal : input2;

    switch (operation) {
      case "NOT":
        output.signal = (~signal1) & 0xFFFF;
        break;
      case "AND":
        output.signal = (signal1 & signal2) & 0xFFFF;
        break;
      case "OR":
        output.signal = (signal1 | signal2) & 0xFFFF;
        break;
      case "RSHIFT":
        output.signal = (signal1 >> signal2) & 0xFFFF;
        break;
      case "LSHIFT":
        output.signal = (signal1 << signal2) & 0xFFFF;
        break;
    }
  }
}

/// Whether a token is a Wire or int
bool isWire(token) {
  if (token == null) return false;
  if (token is int) return false;
  if (token is Wire) return true;
  // The token is a String
  return !stringIsInt(token);
}

bool stringIsInt(token) {
  try {
    int.parse(token);
    return true;
  } catch (_) {
    return false;
  }
}

/// Takes a token and returns an int or Wire
parseToken(token) {
  if (!isWire(token)) {
    return int.parse(token);
  }

  // Return the wire or create a new one
  try {
      return wires.where((w) => w.name == token).single;
  } catch (_) {
    var wire = new Wire(token);
    wires.add(wire);
    return wire;
  }
}

runGates() {
  var _gates = new List.from(gates);
  for (var gate in _gates) {
    if (gate.isConnected()) {
      gate.run();
      gates.remove(gate);
      return runGates();
    }
  }
}

main() async {
  List instructions = await new File('inputs/day7_input.txt').readAsLines();

  for (var instruction in instructions) {
    List tokens = instruction.split(' ');

    // The parseToken() calls may return an int or a Wire
    switch (tokens.length) {
      case 5: // Binary operation
        var input1 = parseToken(tokens.first);
        var input2 = parseToken(tokens[2]);
        Wire outputWire = parseToken(tokens.last);
        gates.add(new Gate(tokens[1], outputWire, input1, input2));
        break;
      case 4: // "NOT" operation
        var input = parseToken(tokens[1]);
        var outputWire = parseToken(tokens.last);
        gates.add(new Gate('NOT', outputWire, input));
        break;
      case 3: // Instructions like "a->b"
        var input = parseToken(tokens[0]);
        var output = parseToken(tokens.last);
        if (input is int) {
          output.signal = input;
        } else {
          output.link = input;
        }
        break;
    }
  }

  runGates();

  print("\nResult: ${parseToken('a').signal}");
}
