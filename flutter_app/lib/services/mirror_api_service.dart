import 'dart:convert';
import 'package:http/http.dart' as http;

class MirrorApiService {
  final String baseUrl;

  MirrorApiService({required this.baseUrl});

  Future<Map<String, dynamic>> fetchGensetData(String utoken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/genset'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'utoken': utoken}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load genset data: ${response.body}');
    }
  }
}
