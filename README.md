# Flutter Native HTML to PDF

A pure Dart package to convert HTML to PDF bytes. Works on **all platforms** including web (JavaScript and WASM) without any native code.

## Features

- **Pure Dart** - No native code, no platform channels
- **Web compatible** - Works with both JavaScript and WASM compilation
- **Simple API** - Just HTML in, PDF bytes out
- **CSS support** - Inline styles and `<style>` tags
- **Rich content** - Images, tables, lists, links, and more

## Installation

```yaml
dependencies:
  flutter_native_html_to_pdf: ^3.0.0
```

## Usage

### Basic Usage

```dart
import 'package:flutter_native_html_to_pdf/flutter_native_html_to_pdf.dart';

final converter = HtmlToPdfConverter();

// Convert HTML to PDF bytes
final Uint8List pdfBytes = await converter.convert(
  html: '<h1>Hello World</h1><p>This is a PDF!</p>',
);
```

### With Page Size

```dart
final pdfBytes = await converter.convert(
  html: '<h1>Letter Size Document</h1>',
  pageSize: PdfPageSize.letter,
);

// Available sizes: a3, a4, a5, letter, legal, tabloid, b5, executive
// Or create custom sizes:
final customSize = PdfPageSize.fromMillimeters(widthMm: 100, heightMm: 150);
```

### Web: Download PDF

```dart
import 'package:flutter_native_html_to_pdf/flutter_native_html_to_pdf.dart';

final pdfBytes = await converter.convert(html: myHtml);

// Trigger browser download
downloadPdf(bytes: pdfBytes, filename: 'document.pdf');

// Or open in new tab for preview
previewPdf(bytes: pdfBytes);
```

### Native: Save to File

```dart
import 'dart:io';

final pdfBytes = await converter.convert(html: myHtml);

// Save to file
final file = File('/path/to/document.pdf');
await file.writeAsBytes(pdfBytes);
```

### Platform Detection

```dart
import 'package:flutter_native_html_to_pdf/flutter_native_html_to_pdf.dart';

if (isWebPlatform) {
  downloadPdf(bytes: pdfBytes, filename: 'doc.pdf');
} else {
  // Use dart:io to save file
}
```

## Supported HTML Elements

- Headings: `<h1>` - `<h6>`
- Text: `<p>`, `<span>`, `<div>`
- Formatting: `<strong>`, `<b>`, `<em>`, `<i>`, `<u>`
- Lists: `<ul>`, `<ol>`, `<li>`
- Tables: `<table>`, `<tr>`, `<td>`, `<th>`
- Links: `<a href="...">`
- Images: `<img src="...">` (URL, base64, or data URI)
- Other: `<br>`, `<hr>`, `<blockquote>`, `<pre>`, `<code>`

## Supported CSS Properties

- `color`, `background-color`
- `font-size`, `font-weight`, `font-style`, `font-family`
- `text-decoration`, `text-align`, `line-height`
- `padding`, `margin` (including individual sides)
- `border`, `border-color`, `border-width`

## Fonts

The library automatically downloads and caches **Open Sans** from Google Fonts on first use. This provides full Unicode support including special characters like bullet points (•) and curly quotes.

For faster first conversion, you can pre-initialize fonts at app startup:

```dart
import 'package:flutter_native_html_to_pdf/flutter_native_html_to_pdf.dart';

void main() async {
  // Pre-load fonts (optional - happens automatically on first convert)
  await FontManager.instance.initialize();
  
  runApp(MyApp());
}
```

## Example

See the [example](example/) folder for a complete Flutter app demonstrating usage on all platforms.

## License

MIT License - see [LICENSE](LICENSE) for details.
