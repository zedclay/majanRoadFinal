import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:majan_road/localization/app_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New passwords do not match')),
      );
      return;
    }

    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var data = FormData.fromMap({
      'old_password': oldPassword,
      'new_password': newPassword,
      'new_password_confirmation': confirmPassword,
    });

    var dio = Dio();
    try {
      var response = await dio.request(
        'http://167.71.230.108/api/password/update',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        print('Password updated: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully')),
        );
        Navigator.pop(context);
      } else {
        print('Response status: ${response.statusMessage}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to update password: ${response.data}')),
        );
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          print('Error data: ${e.response?.data}');
          print('Error status code: ${e.response?.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error updating password: ${e.response?.data}')),
          );
        } else {
          print('Error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating password')),
          );
        }
      } else {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          AppLocalizations.of(context)?.translate('Update Password') ??
              'Update Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)
                        ?.translate('Update Your Password') ??
                    'Update Your Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 30.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)
                            ?.translate('Enter old password ') ??
                        "Enter old password ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  const SizedBox(height: 20.0),
                  // Old Password Input
                  TextField(
                    controller: _oldPasswordController,
                    obscureText: _obscureOldPassword,
                    decoration: InputDecoration(
                      labelText: '**********',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureOldPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureOldPassword = !_obscureOldPassword;
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
                  Text(
                    AppLocalizations.of(context)
                            ?.translate('Enter new password ') ??
                        "Enter new password ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  const SizedBox(height: 20.0),
                  // New Password Input
                  TextField(
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    decoration: InputDecoration(
                      labelText: '**********',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
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
                  Text(
                    AppLocalizations.of(context)
                            ?.translate('Confirm new Password ') ??
                        "Confirm new Password ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  const SizedBox(height: 20.0),
                  // Confirm Password Input
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: '**********',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
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
                onTap: _updatePassword,
                child: Container(
                  width: MediaQuery.of(context).size.width - 150,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xffF69523),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)
                              ?.translate('Update Password') ??
                          'Update Password',
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
