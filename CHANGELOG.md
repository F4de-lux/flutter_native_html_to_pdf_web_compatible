# Changelog

## 3.0.0

### Breaking Changes
- **Simplified API**: Renamed `convertHtmlToPdfBytes` to `convert`
- **Removed file operations**: Removed `convertHtmlToPdf` method that wrote files directly
- **Returns bytes only**: The library now returns `Uint8List` only - users handle file saving themselves

### New Features
- **Full web support**: Works on web platform (JavaScript and WASM)
- **Web download helpers**: Added `downloadPdf()` and `previewPdf()` for web
- **Platform detection**: Added `isWebPlatform` getter
- **Open Sans font**: Automatically downloads and caches Open Sans from Google Fonts
- **Full Unicode support**: Bullet points, curly quotes, and all Unicode characters now render correctly
- **FontManager**: Exposed for optional pre-initialization at app startup

### Migration from 2.x
```dart
// Before (2.x)
final bytes = await converter.convertHtmlToPdfBytes(html: html);
final file = await converter.convertHtmlToPdf(
  html: html,
  targetDirectory: dir,
  targetName: 'doc',
);

// After (3.0)
final bytes = await converter.convert(html: html);

// Save file yourself on native:
await File('$dir/doc.pdf').writeAsBytes(bytes);

// Or download on web:
downloadPdf(bytes: bytes, filename: 'doc.pdf');
```

## 2.0.0

- Pure Dart implementation (no native code)
- CSS support (inline and `<style>` tags)
- Page size customization
- Support for images, tables, lists, and more

## 1.0.0

- Initial release
