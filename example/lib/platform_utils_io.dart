import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Shares PDF bytes using the platform share sheet.
Future<void> sharePdf(Uint8List bytes, String filename) async {
  final tempDir = await getTemporaryDirectory();
  final tempFile = File('${tempDir.path}/$filename');
  await tempFile.writeAsBytes(bytes);

  await SharePlus.instance.share(
    ShareParams(
      files: [XFile(tempFile.path, mimeType: 'application/pdf')],
    ),
  );
}
