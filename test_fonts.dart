import 'package:http/http.dart' as http;

void main() async {
  // Try to get the CSS which contains the actual font URLs
  const cssUrl =
      'https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,400;0,700;1,400;1,700&display=swap';

  print('Fetching Google Fonts CSS...');
  try {
    final response = await http.get(
      Uri.parse(cssUrl),
      headers: {
        // User-agent affects which font format is returned
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      },
    ).timeout(const Duration(seconds: 30));

    print('Status: ${response.statusCode}');
    print('CSS content:');
    print(response.body);
  } catch (e) {
    print('Error: $e');
  }
}
