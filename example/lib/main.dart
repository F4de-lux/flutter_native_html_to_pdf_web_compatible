import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'package:flutter_native_html_to_pdf/flutter_native_html_to_pdf.dart';

// Conditional imports for platform-specific file saving
import 'platform_utils_stub.dart'
    if (dart.library.io) 'platform_utils_io.dart'
    if (dart.library.js_interop) 'platform_utils_web.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Uint8List? pdfBytes;
  PdfPageSize selectedPageSize = PdfPageSize.a4;
  bool isLoading = false;

  final _converter = HtmlToPdfConverter();

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  String get _sampleHtml => """
<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { color: #2196F3; }
        .highlight { background-color: #FFF9C4; padding: 10px; }
        .box { border: 2px solid #9C27B0; padding: 15px; margin: 10px 0; }
    </style>
</head>
<body>
    <h1>Flutter HTML to PDF</h1>
    <p><strong>Platform:</strong> ${kIsWeb ? 'Web' : 'Native'}</p>
    <p><strong>Page Size:</strong> ${selectedPageSize.name}</p>
    <div class="highlight">
        <p>This PDF was generated from HTML using pure Dart!</p>
    </div>
    <div class="box">
        <p>Works on all platforms: iOS, Android, Web, Windows, macOS, Linux.</p>
    </div>
    <h2>Features</h2>
    <ul>
        <li>Pure Dart - no native code</li>
        <li>Web compatible (JS and WASM)</li>
        <li>CSS styling support</li>
        <li>Images, tables, lists</li>
    </ul>
</body>
</html>
""";

  Future<void> _generatePdf() async {
    setState(() => isLoading = true);

    try {
      final bytes = await _converter.convert(
        html: _sampleHtml,
        pageSize: selectedPageSize,
      );

      setState(() {
        pdfBytes = bytes;
        isLoading = false;
      });

      _showSnackBar('PDF generated! (${bytes.length} bytes)');
    } catch (e) {
      setState(() => isLoading = false);
      _showSnackBar('Error: $e', isError: true);
    }
  }

  void _downloadOrShare() {
    if (pdfBytes == null) return;

    final filename = 'document_${DateTime.now().millisecondsSinceEpoch}.pdf';

    if (kIsWeb) {
      downloadPdf(bytes: pdfBytes!, filename: filename);
      _showSnackBar('Download started');
    } else {
      sharePdf(pdfBytes!, filename);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTML to PDF Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('HTML to PDF'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Platform badge
                Chip(
                  label: Text(kIsWeb ? 'Web Platform' : 'Native Platform'),
                  backgroundColor:
                      kIsWeb ? Colors.purple[100] : Colors.green[100],
                ),
                const SizedBox(height: 24),

                // Page size selector
                DropdownButton<PdfPageSize>(
                  value: selectedPageSize,
                  items: [
                    PdfPageSize.a4,
                    PdfPageSize.letter,
                    PdfPageSize.legal,
                    PdfPageSize.a3,
                    PdfPageSize.a5,
                  ]
                      .map((size) => DropdownMenuItem(
                            value: size,
                            child: Text(size.name),
                          ))
                      .toList(),
                  onChanged: (size) {
                    if (size != null) {
                      setState(() {
                        selectedPageSize = size;
                        pdfBytes = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Generate button
                if (isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Generate PDF'),
                    onPressed: _generatePdf,
                  ),

                const SizedBox(height: 24),

                // Result
                if (pdfBytes != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 48),
                          const SizedBox(height: 8),
                          Text('${pdfBytes!.length} bytes'),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton.icon(
                                icon:
                                    Icon(kIsWeb ? Icons.download : Icons.share),
                                label: Text(kIsWeb ? 'Download' : 'Share'),
                                onPressed: _downloadOrShare,
                              ),
                              if (kIsWeb) ...[
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.open_in_new),
                                  label: const Text('Preview'),
                                  onPressed: () => previewPdf(bytes: pdfBytes!),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
