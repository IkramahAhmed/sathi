/// Opens the camera and returns the path of the new picture, or null if the
/// user backed out. Throws if the camera cannot be used.
abstract interface class PhotoSource {
  Future<String?> takePhoto();

  /// Deletes the picture. Photos are only ever checked, never kept.
  Future<void> discard(String path);
}

/// One thing the image model thinks it sees.
class PhotoLabel {
  const PhotoLabel(this.text, this.confidence);

  final String text;
  final double confidence;
}

class PhotoVerdict {
  const PhotoVerdict({required this.accepted, required this.labels});

  final bool accepted;

  /// What the phone saw, strongest first. Shown so a rejection is explainable.
  final List<PhotoLabel> labels;
}

/// Looks at a picture on this phone. Nothing is uploaded.
abstract interface class PhotoVerifier {
  Future<PhotoVerdict> check(String path);
}

/// Words that clearly mean a place of prayer.
const Set<String> _strongLabels = {
  'mosque',
  'place of worship',
  'prayer',
  'prayer rug',
  'prayer mat',
  'minaret',
  'dome',
  'religion',
  'worship',
};

/// Words that fit a prayer mat or a prayer room. One alone is not enough.
const Set<String> _supportingLabels = {
  'carpet',
  'rug',
  'mat',
  'floor',
  'flooring',
  'textile',
  'pattern',
  'tile',
  'tiles',
  'arch',
  'building',
  'architecture',
  'room',
  'interior design',
  'linens',
  'tapestry',
  'symmetry',
};

const double kStrongConfidence = 0.5;
const double kSupportingConfidence = 0.6;

/// Decides from [labels] whether the picture shows a place of prayer.
///
/// Accepted when one strong label is seen, or two supporting ones. This is a
/// friendly check, not proof: it keeps the feature honest-by-habit and cannot
/// know that a prayer happened.
PhotoVerdict judgePhotoLabels(List<PhotoLabel> labels) {
  final sorted = [...labels]..sort((a, b) => b.confidence.compareTo(a.confidence));
  final strong = sorted
      .where((l) => l.confidence >= kStrongConfidence && _strongLabels.contains(l.text.toLowerCase().trim()))
      .length;
  final supporting = sorted
      .where((l) => l.confidence >= kSupportingConfidence && _supportingLabels.contains(l.text.toLowerCase().trim()))
      .length;
  return PhotoVerdict(accepted: strong >= 1 || supporting >= 2, labels: sorted);
}
