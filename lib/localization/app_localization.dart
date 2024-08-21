// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class AppLocalizations {
//   final Locale locale;

//   AppLocalizations(this.locale);

//   static AppLocalizations? of(BuildContext context) {
//     return Localizations.of<AppLocalizations>(context, AppLocalizations);
//   }

//   static const LocalizationsDelegate<AppLocalizations> delegate =
//       _AppLocalizationsDelegate();

//   late Map<String, String> _localizedStrings;

//   Future<bool> load() async {
//     String jsonString =
//         await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
//     Map<String, dynamic> jsonMap = json.decode(jsonString);

//     _localizedStrings = jsonMap.map((key, value) {
//       return MapEntry(key, value.toString());
//     });

//     return true;
//   }

//   String? translate(String key) {
//     return _localizedStrings[key];
//   }
// }

// class _AppLocalizationsDelegate
//     extends LocalizationsDelegate<AppLocalizations> {
//   const _AppLocalizationsDelegate();

//   @override
//   bool isSupported(Locale locale) {
//     return ['en', 'ar'].contains(locale.languageCode);
//   }

//   @override
//   Future<AppLocalizations> load(Locale locale) async {
//     AppLocalizations localizations = AppLocalizations(locale);
//     await localizations.load();
//     return localizations;
//   }

//   @override
//   bool shouldReload(_AppLocalizationsDelegate old) => false;
// }
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api_keys.dart'; // Ensure this file contains your API keys and region

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, String>? _localizedStrings;

  Future<bool> load() async {
    try {
      String jsonString = await rootBundle
          .loadString('assets/lang/${locale.languageCode}.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });

      print(
          "Loaded ${locale.languageCode} localization: $_localizedStrings"); // Debug print
      return true;
    } catch (e) {
      print(
          "Error loading localization for ${locale.languageCode}: $e"); // Error print
      return false;
    }
  }

  String? translate(String key) {
    return _localizedStrings?[key];
  }

  Future<String> translateText(String text, String targetLanguageCode) async {
    final Dio _dio = Dio();
    final uri =
        'https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to=$targetLanguageCode';
    final headers = {
      'Content-Type': 'application/json',
      'Ocp-Apim-Subscription-Key': apiKey1, // from api_keys.dart
      'Ocp-Apim-Subscription-Region': region, // from api_keys.dart
    };
    final body = jsonEncode([
      {'Text': text},
    ]);

    try {
      final response =
          await _dio.post(uri, options: Options(headers: headers), data: body);
      if (response.statusCode == 200) {
        var data = response.data;
        return data[0]['translations'][0]['text'];
      } else {
        throw Exception('Failed to translate text');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to translate text');
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
