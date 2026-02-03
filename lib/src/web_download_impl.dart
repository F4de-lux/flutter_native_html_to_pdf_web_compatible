import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Web implementation for downloading PDF files.
void downloadPdfImpl({
  required Uint8List bytes,
  required String filename,
}) {
  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(type: 'application/pdf'),
  );

  final url = web.URL.createObjectURL(blob);

  final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
  anchor.href = url;
  anchor.download = filename;
  anchor.style.display = 'none';

  web.document.body?.appendChild(anchor);
  anchor.click();
  web.document.body?.removeChild(anchor);

  web.URL.revokeObjectURL(url);
}

/// Web implementation for previewing PDF files in a new tab.
void previewPdfImpl({required Uint8List bytes}) {
  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(type: 'application/pdf'),
  );

  final url = web.URL.createObjectURL(blob);
  web.window.open(url, '_blank');
}

/// Returns true on web platforms.
bool get isWebPlatformImpl => true;
