import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'html_parser.dart';
import 'pdf_page_size.dart';

/// A pure Dart implementation for converting HTML to PDF.
///
/// This class provides a simple method to convert HTML content to PDF bytes
/// without requiring any native platform code. Works on all platforms
/// including web (JavaScript and WASM).
///
/// ## Usage
///
/// ```dart
/// final converter = HtmlToPdfConverter();
///
/// // Convert HTML to PDF bytes
/// final Uint8List pdfBytes = await converter.convert(
///   html: '<h1>Hello World</h1>',
/// );
///
/// // Do whatever you want with the bytes:
/// // - Save to file (on native platforms)
/// // - Download in browser (on web)
/// // - Upload to server
/// // - etc.
/// ```
class HtmlToPdfConverter {
  final HtmlParser _parser = HtmlParser();

  /// Converts HTML content to PDF bytes.
  ///
  /// [html] - The HTML string to convert to PDF.
  /// [pageSize] - Optional page size configuration. Defaults to A4.
  ///
  /// Returns a [Uint8List] containing the PDF data.
  Future<Uint8List> convert({
    required String html,
    PdfPageSize? pageSize,
  }) async {
    final document = pw.Document();
    final parseResult = await _parser.parseWithStyles(html);

    // Use pageSize if provided, otherwise use default A4
    final pdfPageFormat = pageSize != null
        ? PdfPageFormat(pageSize.width, pageSize.height)
        : PdfPageFormat.a4;

    // Use body margin from CSS, or default margin if not specified
    // Ensure minimum margin of 20 for better readability
    var pageMargin = parseResult.bodyMargin ?? const pw.EdgeInsets.all(24);
    if (pageMargin.top < 20 ||
        pageMargin.right < 20 ||
        pageMargin.bottom < 20 ||
        pageMargin.left < 20) {
      pageMargin = pw.EdgeInsets.only(
        top: pageMargin.top < 20 ? 20 : pageMargin.top,
        right: pageMargin.right < 20 ? 20 : pageMargin.right,
        bottom: pageMargin.bottom < 20 ? 20 : pageMargin.bottom,
        left: pageMargin.left < 20 ? 20 : pageMargin.left,
      );
    }

    // Create page theme with background color if specified
    final pageTheme = pw.PageTheme(
      pageFormat: pdfPageFormat,
      margin: pageMargin,
      buildBackground: parseResult.bodyBackgroundColor != null
          ? (context) => pw.FullPage(
                ignoreMargins: true,
                child: pw.Container(color: parseResult.bodyBackgroundColor),
              )
          : null,
    );

    document.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        maxPages: 200,
        build: (context) => parseResult.widgets,
      ),
    );

    return await document.save();
  }
}
