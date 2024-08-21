import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:majan_road/auth/loginPage.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  final String token;
  final Function(Locale) changeLanguage;

  const ResetPassword(
      {Key? key,
      required this.email,
      required this.token,
      required this.changeLanguage})
      : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _obscureText = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    String newPassword = _passwordController.text;
    String newPasswordConfirmation = _confirmPasswordController.text;

    if (newPassword.isEmpty || newPasswordConfirmation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    if (newPassword != newPasswordConfirmation) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    var headers = {'Accept': 'application/json'};
    var data = FormData.fromMap({
      'email': widget.email,
      'new_password': newPassword,
      'new_password_confirmation': newPasswordConfirmation,
      'token': widget.token,
    });

    var dio = Dio();
    try {
      var response = await dio.request(
        'http://167.71.230.108/api/password/reset',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        print('Password reset: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignIn(
              changeLanguage: widget.changeLanguage,
            ),
          ),
        );
      } else {
        print('Response status: ${response.statusMessage}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reset password: ${response.data}')),
        );
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          print('Error data: ${e.response?.data}');
          print('Error status code: ${e.response?.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error resetting password: ${e.response?.data}')),
          );
        } else {
          print('Error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error resetting password')),
          );
        }
      } else {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error resetting password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Reset',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
                'Reset Your Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const Text(
                'Now you can reset your old password',
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
                    "Enter new password ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  const SizedBox(height: 20.0),
                  // Password Input
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: '**********',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "Confirm new Password ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  const SizedBox(height: 20.0),
                  // Confirm Password Input
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: '**********',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0,
                      ),
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
                onTap: _resetPassword,
                child: Container(
                  width: MediaQuery.of(context).size.width - 150,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xffF69523),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      'Reset Password',
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
