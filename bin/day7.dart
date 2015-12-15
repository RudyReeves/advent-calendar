import 'dart:io';

List<Wire> wires = [];
List<Gate> gates = [];

class Wire {
  final String name;
  int signal;
  Wire(this.name);
  toString() => '$name';
}

class Gate {
  final String operation;
  final input1;
  final input2;
  final output;

  Gate(this.operation, this.output, this.input1, [this.input2]);

  operate() {
    // Inputs can be Wires or ints - convert Wires to their int signals
    int signal1 = isWire(input1) ? input1.signal : input1;
    int signal2 = isWire(input2) ? input2.signal : input2;

    if (signal1 == null) return; // No signal
    if (operation != "NOT" && signal2 == null) return; // No signal

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
    connectWire(output);
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

/// Feeds the wire through any gates it's connected to
connectWire(wire) {
  for (var gate in gates) {
    if (gate.input1 == wire || gate.input2 == wire) {
      gate.operate();

      if (gate.operation == "NOT") {
        print("NOT ${gate.input1} -> ${gate.output.name}.signal = ${gate.output.signal}");
      } else {
        print('${gate.input1} ${gate.operation} ${gate.input2} -> ${gate.output.name}.signal = ${gate.output.signal}');
      }
    }
  }
}

main() async {
//  List instructions = await new File('inputs/day7_input.txt').readAsLines();

  List instructions = [
    '123 -> x',
    '456 -> y',
    'x AND y -> d',
    'x OR y -> e',
    'x LSHIFT 2 -> f',
    'y RSHIFT 2 -> g',
    'NOT x -> h',
    'NOT y -> i'
  ];

  List startingWires = [];

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
        Wire outputWire = parseToken(tokens.last);

        if (input is int) {
          outputWire.signal = input;
          startingWires.add(outputWire);
          print("$outputWire.signal = $input");
        }
        break;
    }
  }

  startingWires.forEach(connectWire);

  print("\nResult: ${parseToken('h').signal}");
}
