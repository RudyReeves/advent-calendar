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

// Whether a token string looks like a wire name, or int
bool isWire(token) {
  if (token == null) return false;
  if (token is int) return false;
  if (token is Wire) return true;

  // The token is a String :(
  try {
    int.parse(token);
    return false;
  } catch (_) {
    return true;
  }
}

// Takes a token string and returns a Wire or int
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

main() async {
  List instructions = await new File('inputs/day7_input.txt').readAsLines();

  for (var instruction in instructions) {
    List tokens = instruction.split(' ');

    switch (tokens.length) {
      case 5: // Binary operation
        var input1 = parseToken(tokens.first); // Wire or int
        var input2 = parseToken(tokens[2]); // Wire or int
        Wire outputWire = parseToken(tokens.last); // Wire
        gates.add(new Gate(tokens[1], outputWire, input1, input2));
        break;
      case 4: // "NOT" operation
        var input = parseToken(tokens[1]); // Wire
        var outputWire = parseToken(tokens.last); // Wire
        gates.add(new Gate('NOT', outputWire, input));
        break;
      case 3: // Instructions like "a->b"
        var input = parseToken(tokens[0]); // Wire or int
        var output = parseToken(tokens.last); // Wire
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
  print("Part2: ${part2(instructions)}");
}

part2(instructions) {
  for (var instruction in instructions) {
    List tokens = instruction.split(' ');

    switch (tokens.length) {
      case 5: // Binary operation
        var input1 = parseToken(tokens.first); // Wire or int
        var input2 = parseToken(tokens[2]); // Wire or int
        Wire outputWire = parseToken(tokens.last); // Wire
        gates.add(new Gate(tokens[1], outputWire, input1, input2));
        break;
      case 4: // "NOT" operation
        var input = parseToken(tokens[1]); // Wire
        var outputWire = parseToken(tokens.last); // Wire
        gates.add(new Gate('NOT', outputWire, input));
        break;
      case 3: // Instructions like "a->b"
        var input = parseToken(tokens[0]); // Wire or int
        var output = parseToken(tokens.last); // Wire
        if (input is int) {
          output.signal = input;
        } else {
          output.link = input;
        }
        break;
    }
  }

  parseToken('b').signal = 46065;
  runGates();
  return parseToken('a').signal;
}
