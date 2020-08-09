// This is just a simple validator which takes in positive number between 0 and 10000
String isValidNumber(String s) {
  int n = int.tryParse(s);
  if (n == null) return 'Invalid number';
  if (n < 0 || n > 10000)
    return 'Should be between 0 and 10000';
  else
    return null;
}
