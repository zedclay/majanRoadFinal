import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';

class ProfilePic extends StatefulWidget {
  const ProfilePic({Key? key, required String imageUrl}) : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  String? imagePath;
  int? userId;

  @override
  void initState() {
    super.initState();
    _fetchProfileImage();
  }

  Future<void> _fetchProfileImage() async {
    try {
      var dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token') ?? '';

      if (token.isNotEmpty) {
        dio.options.headers['Authorization'] = 'Bearer $token';
        var response = await dio.get('http://167.71.230.108/api/profile');

        if (response.data['success']) {
          var user = response.data['user'];
          userId = user['id']; // Store the user ID
          if (user['profile_picture'] != null) {
            var pictureUrl = 'http://167.71.230.108/storage' +
                user['profile_picture']['path'].replaceFirst('public/', '/');
            print('Modified profile picture URL: $pictureUrl');
            setState(() {
              imagePath = pictureUrl;
            });
          } else {
            setState(() {
              imagePath =
                  'https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg';
            });
          }
        } else {
          print('Failed to fetch profile data: ${response.data}');
        }
      } else {
        print('Token not found');
      }
    } catch (e) {
      print('Error fetching profile image: $e');
    }
  }

  Future<void> _uploadImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var token = prefs.getString('token') ?? '';

        if (token.isNotEmpty && userId != null) {
          var dio = Dio();
          dio.options.headers['Authorization'] = 'Bearer $token';
          var data = FormData.fromMap({
            'picture': await MultipartFile.fromFile(pickedImage.path,
                filename: pickedImage.name),
          });

          var response = await dio.post(
            'http://167.71.230.108/api/users/picture/$userId',
            data: data,
          );

          if (response.statusCode == 200) {
            print('Profile image updated successfully.');
            setState(() {
              imagePath = pickedImage.path;
            });
          } else {
            print('Failed to update profile image: ${response.statusMessage}');
          }
        } else {
          print('Token or user ID not found');
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundImage: imagePath != null && imagePath!.isNotEmpty
                  ? (imagePath!.startsWith('http')
                      ? NetworkImage(imagePath!)
                      : FileImage(File(imagePath!))) as ImageProvider
                  : NetworkImage(
                          'https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg')
                      as ImageProvider,
            ),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.black12),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: _uploadImage,
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
