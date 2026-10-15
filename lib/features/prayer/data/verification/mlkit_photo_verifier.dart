import 'dart:io';

import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/repositories/photo_verifier.dart';

/// Labels the picture with Google ML Kit's bundled model. Runs on the phone
/// without a network and sends nothing anywhere.
class MlKitPhotoVerifier implements PhotoVerifier {
  @override
  Future<PhotoVerdict> check(String path) async {
    final labeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.4));
    try {
      final found = await labeler.processImage(InputImage.fromFilePath(path));
      return judgePhotoLabels([for (final l in found) PhotoLabel(l.label, l.confidence)]);
    } finally {
      await labeler.close();
    }
  }
}

/// Camera only: the user cannot pick an old picture from the gallery.
class CameraPhotoSource implements PhotoSource {
  CameraPhotoSource([ImagePicker? picker]) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<String?> takePhoto() async {
    final shot = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      imageQuality: 80,
    );
    return shot?.path;
  }

  @override
  Future<void> discard(String path) async {
    try {
      await File(path).delete();
    } catch (_) {}
  }
}
