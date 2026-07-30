import 'dart:convert';
import 'dart:io';

void main() async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(Uri.parse('https://raw.githubusercontent.com/semarketir/quranjson/master/source/surah.json'));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    final List<dynamic> data = jsonDecode(responseBody);
    final counts = data.map((surah) => surah['count'] as int).toList();
    print('Counts length: ${counts.length}');
    print(counts.join(', '));
  } catch (e) {
    print('Error: $e');
  } finally {
    client.close();
  }
}
