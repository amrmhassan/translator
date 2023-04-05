import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'new_translator.dart';
import 'target_langs.dart';

String apiKey = 'd24d44ce-3f3e-4655-a599-6ecbc2ba301c';
//! pa language not supported
//! nb language not supported

void main(List<String> arguments) async {
  String translationsPath = arguments.first;
  if (arguments.isEmpty) {
    print('please provide a valid folder path with ');
    return;
  }
  for (var i = 0; i < targetLanguages.length; i++) {
    String langCode = targetLanguages.entries.elementAt(i).value.toLowerCase();
    print('starting $langCode');
    await translateLanguage(langCode, translationsPath);
    print('language $langCode done');
  }
}

// d24d44ce-3f3e-4655-a599-6ecbc2ba301c

Future<void> translateLanguage(String targetLanCode, String folder) async {
  NewTranslator translator = NewTranslator(
    apiKey: apiKey,
    targetLangCode: targetLanCode,
  );
  Map<String, dynamic> enData =
      json.decode(File('$folder/en.json').readAsStringSync());
  Map<String, dynamic> targetLang = {};
  File targetFile = File('$folder/$targetLanCode.json');
  if (targetFile.existsSync()) {
    Map<String, dynamic> loadedTargetData =
        json.decode(targetFile.readAsStringSync());
    loadedTargetData.forEach((key, value) {
      targetLang[key] = value;
    });
  }

  for (var i = 0; i < enData.length; i++) {
    String key = enData.entries.elementAt(i).key;
    String value = enData.entries.elementAt(i).value;
    if (targetLang.containsKey(key)) continue;
    try {
      var translation = await translator.translate(value);
      targetLang[key] = translation;
      print('$key => $translation');
    } catch (e) {
      if (e is DioError) {
        print('key $key ${e.response?.data['message']}');
        break;
      } else {
        print('error at $key');
      }
    }
  }
  // done
  Map<String, dynamic> arrangedTargetFile = {};
  enData.forEach((key, value) {
    try {
      String value = targetLang[key];
      arrangedTargetFile[key] = value;
    } catch (e) {
      //
    }
  });

  targetFile.writeAsStringSync(json.encode(arrangedTargetFile));
}
