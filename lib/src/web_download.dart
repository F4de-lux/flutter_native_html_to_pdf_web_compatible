import 'dart:typed_data';

import 'web_download_stub.dart'
    if (dart.library.js_interop) 'web_download_impl.dart';

/// Downloads a PDF file in the browser.
///
/// This function triggers a browser download dialog. It only works on web
/// platforms. On non-web platforms, it throws an [UnsupportedError].
///
/// [bytes] - The PDF file bytes to download.
/// [filename] - The suggested filename for the download.
void downloadPdf({
  required Uint8List bytes,
  required String filename,
}) {
  downloadPdfImpl(bytes: bytes, filename: filename);
}

/// Opens PDF bytes in a new browser tab for preview.
///
/// This function opens the PDF in a new browser tab. It only works on web
/// platforms. On non-web platforms, it throws an [UnsupportedError].
///
/// [bytes] - The PDF file bytes to preview.
void previewPdf({required Uint8List bytes}) {
  previewPdfImpl(bytes: bytes);
}

/// Returns true if the current platform is web.
bool get isWebPlatform => isWebPlatformImpl;
