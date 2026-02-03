import 'dart:typed_data';

/// On web, sharing is handled via downloadPdf from the main package.
Future<void> sharePdf(Uint8List bytes, String filename) async {
  // No-op on web - use downloadPdf instead
}
