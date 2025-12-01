import 'dart:io';

void main() {
  final file = File('coverage/lcov.info');

  if (!file.existsSync()) {
    print('coverage/lcov.info not found. Run `flutter test --coverage` first.');
    exit(1);
  }

  final lines = file.readAsLinesSync();

  int total = 0;
  int covered = 0;

  for (final line in lines) {
    // lcov DA line format: DA:<line number>,<execution count>
    if (line.startsWith('DA:')) {
      final parts = line.substring(3).split(',');
      if (parts.length == 2) {
        total++;
        final hits = int.tryParse(parts[1]) ?? 0;
        if (hits > 0) {
          covered++;
        }
      }
    }
  }

  if (total == 0) {
    print('No executable lines found in coverage file.');
    return;
  }

  final percent = (covered / total) * 100;
  print('Line coverage: ${percent.toStringAsFixed(2)}% '
      '($covered of $total lines)');
}
