import 'dart:typed_data';

/// Stub implementation for non-web platforms.
void downloadPdfImpl({
  required Uint8List bytes,
  required String filename,
}) {
  throw UnsupportedError(
    'downloadPdf is only available on web platforms.',
  );
}

/// Stub implementation for non-web platforms.
void previewPdfImpl({required Uint8List bytes}) {
  throw UnsupportedError(
    'previewPdf is only available on web platforms.',
  );
}

/// Returns false on non-web platforms.
bool get isWebPlatformImpl => false;
