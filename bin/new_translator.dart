import 'package:dio/dio.dart';

class NewTranslator {
  final String apiKey;
  final String targetLangCode;
  final String sourceLangCode;

  const NewTranslator({
    required this.apiKey,
    this.sourceLangCode = 'en',
    this.targetLangCode = 'ar',
  });

  Future<String> translate(String text) async {
    try {
      var res = await Dio()
          .post('https://api-translate.systran.net/translation/text/translate',
              options: Options(headers: {
                'Authorization': "Key $apiKey",
              }),
              data: {
            'input': text,
            'target': targetLangCode,
            'source': sourceLangCode,
          });
      return ((res.data['outputs'] as List).first)['output'] as String;
    } on DioError catch (e) {
      print(e);
      // return 'dio-error';
      rethrow;
    }
  }
}
