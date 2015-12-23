var input = 'hxbxxyzz';

main() {
  print(nextPassword(input));
}

nextPassword(password) {
  do {
    password = increment(password);
  } while (!isValidPassword(password));
  return password;
}

isValidPassword(password) {
  if (new RegExp(r'(i|o|l)').hasMatch(password)) {
    return false;
  }
  if (!new RegExp(r'([a-z])\1[a-z]*([a-z])\2').hasMatch(password)) {
    return false;
  }
  int count = 1;
  bool triple = false;
  var prev;
  for (var char in password.split('')) {
    if (prev == null) {
      prev = char;
      count = 1;
    } else if (incrementLetter(prev) == char && prev != 'z') {
      count++;
      if (count >= 3) {
        triple = true;
      }
      prev = char;
    } else {
      prev = char;
      count = 1;
    }
  }
  return triple;
}

incrementLetter(char) {
  if (char == 'z') return 'a';
  return new String.fromCharCode(char.codeUnits.first + 1);
}

increment(String str) {
  int index = str.length - 1;
  var char;
  do {
    char = str[index];
    str = str.substring(0, index) + incrementLetter(char) + str.substring(index + 1);
    index--;
  } while (char == 'z');
  return str;
}