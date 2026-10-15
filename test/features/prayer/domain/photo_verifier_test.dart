import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/features/prayer/domain/repositories/photo_verifier.dart';

void main() {
  PhotoVerdict judge(Map<String, double> labels) =>
      judgePhotoLabels([for (final e in labels.entries) PhotoLabel(e.key, e.value)]);

  test('a mosque or a place of worship is accepted on its own', () {
    expect(judge({'Mosque': 0.7}).accepted, isTrue);
    expect(judge({'Place of worship': 0.55, 'Sky': 0.9}).accepted, isTrue);
  });

  test('a strong label below the threshold is not enough', () {
    expect(judge({'Mosque': 0.45}).accepted, isFalse);
  });

  test('one supporting label alone is not enough, two are', () {
    expect(judge({'Carpet': 0.9}).accepted, isFalse);
    expect(judge({'Carpet': 0.9, 'Pattern': 0.7}).accepted, isTrue);
  });

  test('supporting labels below their threshold do not count', () {
    expect(judge({'Carpet': 0.9, 'Pattern': 0.5}).accepted, isFalse);
  });

  test('unrelated pictures are rejected', () {
    expect(judge({'Dog': 0.95, 'Pet': 0.9, 'Grass': 0.8}).accepted, isFalse);
    expect(judge({}).accepted, isFalse);
  });

  test('matching ignores case and spaces, and labels come back strongest first', () {
    final v = judge({'Floor': 0.7, '  RUG ': 0.9});
    expect(v.accepted, isTrue);
    expect(v.labels.first.confidence, 0.9);
  });
}
