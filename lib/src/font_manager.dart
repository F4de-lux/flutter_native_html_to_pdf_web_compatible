import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;

/// Manages font loading and caching for PDF generation.
///
/// Downloads Open Sans from Google Fonts and caches it for reuse.
class FontManager {
  static FontManager? _instance;

  /// Gets the singleton instance.
  static FontManager get instance => _instance ??= FontManager._();

  FontManager._();

  pw.Font? _regular;
  pw.Font? _bold;
  pw.Font? _italic;
  pw.Font? _boldItalic;

  bool _initialized = false;
  bool _initializing = false;

  /// Google Fonts URLs for Open Sans (v44)
  static const _regularUrl =
      'https://fonts.gstatic.com/s/opensans/v44/memSYaGs126MiZpBA-UvWbX2vVnXBbObj2OVZyOOSr4dVJWUgsjZ0C4n.ttf';
  static const _boldUrl =
      'https://fonts.gstatic.com/s/opensans/v44/memSYaGs126MiZpBA-UvWbX2vVnXBbObj2OVZyOOSr4dVJWUgsg-1y4n.ttf';
  static const _italicUrl =
      'https://fonts.gstatic.com/s/opensans/v44/memQYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWq8tWZ0Pw86hd0Rk8ZkaVc.ttf';
  static const _boldItalicUrl =
      'https://fonts.gstatic.com/s/opensans/v44/memQYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWq8tWZ0Pw86hd0RkyFjaVc.ttf';

  /// Whether fonts have been loaded.
  bool get isInitialized => _initialized;

  /// The regular font.
  pw.Font? get regular => _regular;

  /// The bold font.
  pw.Font? get bold => _bold;

  /// The italic font.
  pw.Font? get italic => _italic;

  /// The bold italic font.
  pw.Font? get boldItalic => _boldItalic;

  /// Initializes fonts by downloading from Google Fonts.
  ///
  /// This is called automatically on first PDF conversion.
  /// Call this manually at app startup for faster first conversion.
  Future<void> initialize() async {
    if (_initialized || _initializing) return;
    _initializing = true;

    try {
      // Download all font variants in parallel
      final results = await Future.wait([
        _downloadFont(_regularUrl),
        _downloadFont(_boldUrl),
        _downloadFont(_italicUrl),
        _downloadFont(_boldItalicUrl),
      ]);

      if (results[0] != null) {
        _regular = pw.Font.ttf(results[0]!.buffer.asByteData());
      }
      if (results[1] != null) {
        _bold = pw.Font.ttf(results[1]!.buffer.asByteData());
      }
      if (results[2] != null) {
        _italic = pw.Font.ttf(results[2]!.buffer.asByteData());
      }
      if (results[3] != null) {
        _boldItalic = pw.Font.ttf(results[3]!.buffer.asByteData());
      }

      _initialized = true;
    } catch (e) {
      // If font loading fails, we'll fall back to built-in fonts
      _initialized = true;
    } finally {
      _initializing = false;
    }
  }

  Future<Uint8List?> _downloadFont(String url) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(
            const Duration(seconds: 15),
          );
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (_) {
      // Silently fail - will use fallback fonts
    }
    return null;
  }

  /// Gets the appropriate font based on weight and style.
  pw.Font? getFont({
    pw.FontWeight? weight,
    pw.FontStyle? style,
  }) {
    final isBold = weight == pw.FontWeight.bold;
    final isItalic = style == pw.FontStyle.italic;

    if (isBold && isItalic) return _boldItalic ?? _bold ?? _italic ?? _regular;
    if (isBold) return _bold ?? _regular;
    if (isItalic) return _italic ?? _regular;
    return _regular;
  }

  /// Creates a ThemeData with Open Sans fonts.
  pw.ThemeData createTheme() {
    return pw.ThemeData(
      defaultTextStyle: pw.TextStyle(
        font: _regular,
        fontBold: _bold,
        fontItalic: _italic,
        fontBoldItalic: _boldItalic,
      ),
    );
  }

  /// Resets the font manager (useful for testing).
  void reset() {
    _regular = null;
    _bold = null;
    _italic = null;
    _boldItalic = null;
    _initialized = false;
    _initializing = false;
  }
}
