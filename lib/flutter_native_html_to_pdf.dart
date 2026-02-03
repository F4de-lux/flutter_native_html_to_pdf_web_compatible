/// A pure Dart library for converting HTML to PDF bytes.
///
/// This library provides a simple API to convert HTML content to PDF bytes
/// without requiring any native platform code. Works on all platforms
/// including web (JavaScript and WASM).
///
/// ## Usage
///
/// ```dart
/// import 'package:flutter_native_html_to_pdf/flutter_native_html_to_pdf.dart';
///
/// final converter = HtmlToPdfConverter();
///
/// // Convert HTML to PDF bytes
/// final Uint8List pdfBytes = await converter.convert(
///   html: '<h1>Hello World</h1>',
/// );
///
/// // On web, trigger a browser download:
/// if (isWebPlatform) {
///   downloadPdf(bytes: pdfBytes, filename: 'document.pdf');
/// }
///
/// // On native, save to file:
/// // await File('path/to/file.pdf').writeAsBytes(pdfBytes);
/// ```
library;

export 'src/html_to_pdf_converter.dart' show HtmlToPdfConverter;
export 'src/pdf_page_size.dart';
export 'src/html_parser.dart' show HtmlParseResult, HtmlParser, CssStyle;
export 'src/web_download.dart' show downloadPdf, previewPdf, isWebPlatform;
