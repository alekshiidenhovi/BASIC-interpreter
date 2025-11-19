final RegExp numberPattern = RegExp(r'\d');
final RegExp numberLiteralPattern = RegExp(r'(-?\d+(\.\d+)?)');
final RegExp stringLiteralPattern = RegExp(r'"(.*?)"');
final RegExp keywordOrIdentifierPattern = RegExp(r'[A-Za-z][A-Za-z0-9]*');

final RegExp comparisonStartingOperatorPattern = RegExp(r'=|>|<');
final RegExp comparisonOperatorPattern = RegExp(
  r'>=|<=|<>|=|<|>',
); // IMPORTANT: The pattern matching happens from left to right, so we need to matched GE/LE before GT/LT.
final RegExp arithmeticOperatorPattern = RegExp(r'\+|-|\*|/');
