import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:majan_road/auth/emailOtp.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    String email = _emailController.text;

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    var headers = {'Accept': 'application/json'};
    var data = FormData.fromMap({'email': email});

    var dio = Dio();
    try {
      var response = await dio.request(
        'http://167.71.230.108/api/password/forgot/send',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        print('OTP sent: ${response.data}');
        // Navigate to EmailOtp page with the email parameter and origin
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EmailOtp(
              email: email,
              origin: 'forgetPassword',
            ),
          ),
        );
      } else {
        print('Response status: ${response.statusMessage}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP: ${response.data}')),
        );
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          print('Error data: ${e.response?.data}');
          print('Error status code: ${e.response?.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error sending OTP: ${e.response?.data}')),
          );
        } else {
          print('Error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error sending OTP')),
          );
        }
      } else {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending OTP')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
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
                width: MediaQuery.of(context).size.height / 2.6,
                height: MediaQuery.of(context).size.height / 2.6,
                'assets/images/otp.png',
              ),
              const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const Text(
                'Don’t worry! it happens. Please enter email\n associated with your account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 30.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter your Email ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  const SizedBox(height: 20.0),
                  // Email Input
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email@gmail.com',
                      prefixIcon: const Icon(Icons.email),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: _sendCode,
                child: Container(
                  width: MediaQuery.of(context).size.width - 150,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xffF69523),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      'Send Code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
