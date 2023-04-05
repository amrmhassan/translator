import 'package:http/http.dart' as http;
import 'dart:convert';

class Translator {
  static const String defaultModel = 'nllb-200-3-3b';
  static const String defaultEndpoint = 'translation';

  final String token;
  final String model;
  final String endpoint;

  const Translator({
    required this.token,
    this.model = defaultModel,
    this.endpoint = defaultEndpoint,
  });

  static const String baseUrl = 'https://api.nlpcloud.io/v1/';

  Map<String, String> getHeaders() {
    return {
      'Authorization': 'Token $token',
      'User-Agent': 'nlpcloud-dart-client',
    };
  }

  Map<String, String> payload({
    // String? lang = '',
    // bool gpu = false,
    // bool asynchronous = false,
    // Map<String, dynamic>? payload,
    required String sourceLang,
    required String targetLang,
    required String text,
  }) {
    return {
      'source': sourceLang,
      'target': targetLang,
      'text': text,
    };
  }

  Future<dynamic> translate({
    // String? lang = '',
    // bool gpu = false,
    // bool asynchronous = false,
    // Map<String, dynamic>? payload,
    required String sourceLang,
    required String targetLang,
    required String text,
  }) async {
    String rootUrl = baseUrl;
    // if (lang == 'en') {
    //   lang = '';
    // }

    // if (gpu) {
    //   rootUrl += 'gpu/';
    // }

    // if (asynchronous) {
    //   rootUrl += 'async/';
    // }

    // if (lang != '') {
    //   rootUrl += '$lang/';
    // }

    rootUrl += model;

    String url = '$rootUrl/$endpoint';
    var headers = getHeaders();
    var body = jsonEncode(payload(
      sourceLang: sourceLang,
      targetLang: targetLang,
      text: text,
    ));
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    return response.body;
  }
}
