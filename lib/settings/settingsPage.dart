import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:majan_road/auth/loginPage.dart';
import 'package:majan_road/auth/updatePassword.dart';
import 'package:majan_road/localization/app_localization.dart';
import 'package:majan_road/settings/helpCenter.dart';
import 'package:majan_road/settings/profilePage.dart';
import 'package:majan_road/widgets/notificationMenu.dart';
import 'package:majan_road/widgets/profileMenu.dart';
import 'package:majan_road/widgets/profilePic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  static String routeName = "/settings";

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationActive = true;
  Map<String, dynamic> _user = {};
  String _profileImage = '';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  void _fetchProfile() async {
    try {
      var dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token') ?? '';

      if (token.isNotEmpty) {
        dio.options.headers['Authorization'] = 'Bearer $token';
        var response = await dio.get('http://167.71.230.108/api/profile');

        if (response.data['success']) {
          setState(() {
            _user = response.data['user'];
            _profileImage = _user['profile_picture'] != null
                ? 'http://167.71.230.108/storage' +
                    _user['profile_picture']['path']
                        .replaceFirst('public/', '/')
                : 'https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg';
          });
        }
      } else {
        print('Token not found');
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ProfilePic(imageUrl: _profileImage),
              SizedBox(height: 20),
              // Text(
              //   _user['name'] ?? 'Name not available',
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
              // SizedBox(height: 5),
              // Text(
              //   _user['email'] ?? 'Email not available',
              //   style: TextStyle(fontSize: 20),
              // ),
              // SizedBox(height: 30),
              // const SizedBox(height: 20),
              ProfileMenu(
                text: AppLocalizations.of(context)?.translate('my account') ??
                    "My Account",
                icon: "assets/icons/User Icon.svg",
                press: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  )
                },
              ),
              // NotificationMenu(
              //   text: "Notifications",
              //   icon: "assets/icons/Bell.svg",
              //   press: () {
              //     setState(() {
              //       notificationActive = !notificationActive;
              //     });
              //   },
              //   isActive: notificationActive,
              // ),
              ProfileMenu(
                text: AppLocalizations.of(context)?.translate('Password') ??
                    "Password",
                icon: "assets/icons/Settings.svg",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdatePassword()),
                  );
                },
              ),
              ProfileMenu(
                text: AppLocalizations.of(context)?.translate('help center') ??
                    "Help Center",
                icon: "assets/icons/Question mark.svg",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpCenterPage()),
                  );
                },
              ),
              ProfileMenu(
                text: AppLocalizations.of(context)?.translate('log out') ??
                    "Log Out",
                icon: "assets/icons/Log out.svg",
                press: _confirmLogout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    try {
      var dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token') ?? '';

      if (token.isNotEmpty) {
        dio.options.headers['Authorization'] = 'Bearer $token';
        var response = await dio.post('http://167.71.230.108/api/logout');

        if (response.statusCode == 200) {
          await prefs.remove('token');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => SignIn(changeLanguage: (locale) {
                      // Your language change logic
                    })),
          );
        } else {
          print('Failed to log out');
        }
      } else {
        print('Token not found');
      }
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}
