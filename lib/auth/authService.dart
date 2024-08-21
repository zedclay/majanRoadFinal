// import 'dart:convert';
// import 'dart:io';
// import 'package:animated_snack_bar/animated_snack_bar.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:majan_road/auth/loginPage.dart';
// import 'package:majan_road/base/homePage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
//   static const String _baseUrl = 'http://167.71.230.108/api';

//   static Future<bool> login(BuildContext context, String email, String password,
//       Function(Locale) changeLanguage) async {
//     if (email.isEmpty || password.isEmpty) {
//       _showSnackBar(context, 'Please enter both email and password.',
//           AnimatedSnackBarType.error);
//       return false;
//     }

//     final String url = '$_baseUrl/login';
//     Dio dio = Dio();

//     try {
//       final response = await dio.post(
//         url,
//         data: {
//           'email': email,
//           'password': password,
//         },
//         options: Options(
//           followRedirects: true,
//           validateStatus: (status) {
//             return status! < 500;
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = response.data;
//         final String token = responseData['access_token'] ?? '';
//         final int userId = responseData['user']['id'];

//         if (token.isNotEmpty) {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           await prefs.setString('token', token);
//           await prefs.setInt('user_id', userId);

//           _showSnackBar(
//               context, 'Login successful!', AnimatedSnackBarType.success);
//           print(token);

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => Homepage(
//                 changeLanguage: changeLanguage,
//                 toggleDarkMode: () {},
//               ),
//             ),
//           );

//           return true;
//         } else {
//           _showSnackBar(context, 'Token not found in response.',
//               AnimatedSnackBarType.error);
//         }
//       } else {
//         _handleErrorResponse(context, response);
//       }
//     } catch (e) {
//       _showSnackBar(
//           context, 'An error occurred: $e', AnimatedSnackBarType.error);
//     }

//     return false;
//   }

//   static Future<void> signUp(
//     BuildContext context, {
//     required String email,
//     required String password,
//     required String passwordConfirmation,
//     required String name,
//     String? phoneNumber,
//     String? country,
//     String? city,
//     required int conditions,
//     File? picture,
//   }) async {
//     final String url = '$_baseUrl/signup';
//     Dio dio = Dio();

//     try {
//       FormData formData = FormData.fromMap({
//         'email': email,
//         'password': password,
//         'password_confirmation': passwordConfirmation,
//         'name': name,
//         if (phoneNumber != null) 'phone_number': phoneNumber,
//         if (country != null) 'country': country,
//         if (city != null) 'city': city,
//         'conditions': conditions.toString(),
//         if (picture != null)
//           'picture': await MultipartFile.fromFile(picture.path),
//       });

//       final response = await dio.post(
//         url,
//         data: formData,
//         options: Options(
//           followRedirects: true,
//           validateStatus: (status) {
//             return status! < 500;
//           },
//         ),
//       );

//       print('Response Status Code: ${response.statusCode}');
//       print('Response Body: ${response.data}');

//       if (response.statusCode == 201) {
//         _showSnackBar(
//             context, 'Sign Up successful!', AnimatedSnackBarType.success);
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => SignIn(
//               changeLanguage: (Locale) {},
//             ),
//           ),
//         );
//       } else {
//         _handleErrorResponse(context, response);
//       }
//     } catch (e) {
//       _showSnackBar(
//           context, 'An error occurred: $e', AnimatedSnackBarType.error);
//     }
//   }

//   static void _handleErrorResponse(BuildContext context, Response response) {
//     print('Response Status Code: ${response.statusCode}');
//     print('Response Body: ${response.data}');

//     try {
//       if (response.headers
//               .value('content-type')
//               ?.contains('application/json') ??
//           false) {
//         final Map<String, dynamic> responseData = response.data;
//         final String errorMessage =
//             responseData['message'] ?? 'Unknown error occurred';

//         _showSnackBar(context, errorMessage, AnimatedSnackBarType.error);
//       } else {
//         _showSnackBar(context, 'Unexpected response format. Please try again.',
//             AnimatedSnackBarType.error);
//       }
//     } catch (e) {
//       _showSnackBar(context, 'Failed to parse error response: $e',
//           AnimatedSnackBarType.error);
//     }
//   }

//   static void _showSnackBar(
//       BuildContext context, String message, AnimatedSnackBarType type) {
//     AnimatedSnackBar.material(
//       message,
//       type: type,
//       duration: Duration(seconds: 2),
//     ).show(context);
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:majan_road/auth/loginPage.dart';
import 'package:majan_road/base/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'http://167.71.230.108/api';

  static Future<bool> login(BuildContext context, String email, String password,
      Function(Locale) changeLanguage) async {
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(context, 'Please enter both email and password.',
          AnimatedSnackBarType.error);
      return false;
    }

    final String url = '$_baseUrl/login';
    Dio dio = Dio();

    try {
      final response = await dio.post(
        url,
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final String token = responseData['access_token'] ?? '';
        final int userId = responseData['user']['id'];

        if (token.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setInt('user_id', userId);

          _showSnackBar(
              context, 'Login successful!', AnimatedSnackBarType.success);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Homepage(
                changeLanguage: changeLanguage,
                toggleDarkMode: () {},
              ),
            ),
          );

          return true;
        } else {
          _showSnackBar(context, 'Token not found in response.',
              AnimatedSnackBarType.error);
        }
      } else {
        _handleErrorResponse(context, response);
      }
    } catch (e) {
      _showSnackBar(
          context, 'An error occurred: $e', AnimatedSnackBarType.error);
    }

    return false;
  }

  static Future<void> signUp(
    BuildContext context, {
    required String email,
    required String password,
    required String passwordConfirmation,
    required String name,
    String? phoneNumber,
    String? country,
    String? city,
    required int conditions,
    File? picture,
  }) async {
    final String url = '$_baseUrl/signup';
    Dio dio = Dio();

    try {
      Map<String, String> headers = {'Accept': 'application/json'};

      MultipartFile? compressedPicture;
      if (picture != null) {
        final originalImage = img.decodeImage(picture.readAsBytesSync());
        if (originalImage != null) {
          final resizedImage =
              img.copyResize(originalImage, width: 500); // Resize the image
          final compressedImage =
              img.encodeJpg(resizedImage, quality: 70); // Compress the image
          compressedPicture = MultipartFile.fromBytes(compressedImage,
              filename: picture.path.split('/').last);
        }
      }

      FormData formData = FormData.fromMap({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (country != null) 'country': country,
        if (city != null) 'city': city,
        'conditions': conditions.toString(),
        if (compressedPicture != null) 'picture': compressedPicture,
      });

      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: headers,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 201) {
        _showSnackBar(
            context, 'Sign Up successful!', AnimatedSnackBarType.success);

        // Ensure the snackbar is shown before navigating
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => SignIn(
                changeLanguage: (Locale) {},
              ),
            ),
          );
        });
      } else if (response.statusCode == 302) {
        // Handle redirection if needed
        final redirectUrl = response.headers.value('location');
        if (redirectUrl != null) {
          final redirectedResponse = await dio.get(redirectUrl);
          _handleErrorResponse(context, redirectedResponse);
        } else {
          _showSnackBar(context, 'Redirection error. Please try again.',
              AnimatedSnackBarType.error);
        }
      } else {
        _handleErrorResponse(context, response);
      }
    } catch (e) {
      _showSnackBar(
          context, 'An error occurred: $e', AnimatedSnackBarType.error);
    }
  }

  static void _handleErrorResponse(BuildContext context, Response response) {
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.data}');

    try {
      if (response.headers
              .value('content-type')
              ?.contains('application/json') ??
          false) {
        final Map<String, dynamic> responseData = response.data;
        final String errorMessage =
            responseData['message'] ?? 'Unknown error occurred';

        _showSnackBar(context, errorMessage, AnimatedSnackBarType.error);
      } else {
        _showSnackBar(context, 'Unexpected response format. Please try again.',
            AnimatedSnackBarType.error);
      }
    } catch (e) {
      _showSnackBar(context, 'Failed to parse error response: $e',
          AnimatedSnackBarType.error);
    }
  }

  static void _showSnackBar(
      BuildContext context, String message, AnimatedSnackBarType type) {
    if (context != null) {
      AnimatedSnackBar.material(
        message,
        type: type,
        duration: Duration(seconds: 2),
      ).show(context);
    }
  }
}
