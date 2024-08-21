import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:majan_road/auth/resetPassword.dart';
import 'package:majan_road/localization/app_localization.dart';
import 'package:majan_road/settings/profilePage.dart'; // Import the Profile page

class EmailOtp extends StatefulWidget {
  final String email;
  final String origin; // Add origin parameter

  const EmailOtp({Key? key, required this.email, required this.origin})
      : super(key: key);

  @override
  State<EmailOtp> createState() => _EmailOtpState();
}

class _EmailOtpState extends State<EmailOtp> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  late Timer _timer;
  int _start = 60;

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Future<void> _resendOtp() async {
    String email = widget.email;

    var headers = {'Accept': 'application/json'};
    var data = FormData.fromMap({'email': email});

    var dio = Dio();
    try {
      var response = await dio.request(
        'http://167.71.230.108/api/email/verify/send',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        print('OTP resent: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP has been resent to your email')),
        );
      } else {
        print('Response status: ${response.statusMessage}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to resend OTP: ${response.data}')),
        );
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          print('Error data: ${e.response?.data}');
          print('Error status code: ${e.response?.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error resending OTP: ${e.response?.data}')),
          );
        } else {
          print('Error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error resending OTP')),
          );
        }
      } else {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error resending OTP')),
        );
      }
    }
  }

  Future<void> _verifyOtp() async {
    String email = widget.email;
    String otpCode = _controllers.map((controller) => controller.text).join();

    print('Email: $email');
    print('OTP Code: $otpCode');

    if (otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the 6-character OTP code')),
      );
      return;
    }

    var headers = {'Accept': 'application/json'};
    var data = FormData.fromMap({'email': email, 'code': otpCode});

    print('Email: $email');
    print('OTP Code: $otpCode');
    print('Headers: $headers');
    print('Data: ${data.fields}');

    var dio = Dio();
    try {
      var response = await dio.request(
        widget.origin == 'profile'
            ? 'http://167.71.230.108/api/email/verify'
            : 'http://167.71.230.108/api/password/forgot/verify',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.data}');
        if (widget.origin == 'profile') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Profile()),
          );
        } else if (widget.origin == 'forgetPassword') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ResetPassword(
                      email: widget.email,
                      token: response.data['token'],
                      changeLanguage: (Locale) {},
                    )),
          );
        }
      } else {
        print('Response status: ${response.statusMessage}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to verify OTP: ${response.data}')),
        );
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          print('Error data: ${e.response?.data}');
          print('Error status code: ${e.response?.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error verifying OTP: ${e.response?.data}')),
          );
        } else {
          print('Error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error verifying OTP')),
          );
        }
      } else {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error verifying OTP')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.translate('Update Password') ??
              'Verification',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Image.asset(
                height: MediaQuery.of(context).size.height / 2.6,
                width: MediaQuery.of(context).size.height / 2.6,
                'assets/images/otp.png',
              ),
              const Text(
                'Enter code',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const Text(
                'We have sent you a 6-character code on your email',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: MediaQuery.of(context).size.width / 10,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        }
                      },
                      decoration: const InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _verifyOtp,
                child: Container(
                  width: MediaQuery.of(context).size.width - 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xffF69523),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      'Verify',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _start == 0
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          _start = 60;
                          _startTimer();
                        });
                        _resendOtp();
                      },
                      child: const Text(
                        'Resend OTP',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Text(
                      'Resend OTP ($_start)',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
