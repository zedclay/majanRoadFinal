import 'package:flutter/material.dart';
import 'package:majan_road/auth/emailOtp.dart';
import 'package:majan_road/widgets/profilePic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> _user = {};
  List<String> _favoriteDestinations = [];

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _loadFavoriteDestinations();
  }

  Future<void> _fetchProfile() async {
    try {
      var dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token') ?? '';

      if (token.isNotEmpty) {
        dio.options.headers['Authorization'] = 'Bearer $token';
        var response = await dio.get('http://167.71.230.108/api/profile');

        if (response.data['success']) {
          var user = response.data['user'];
          var favoriteDestinations = List<String>.from(
              user['favorite_destinations'] ?? _favoriteDestinations);

          if (user['email_verified_at'] == null) {
            var email = user['email'];
            var headers = {'Accept': 'application/json'};
            var data = FormData.fromMap({'email': email});

            var response = await dio.request(
              'http://167.71.230.108/api/email/verify/send',
              options: Options(
                method: 'POST',
                headers: headers,
              ),
              data: data,
            );

            if (response.statusCode == 200) {
              print(json.encode(response.data));
            } else {
              print(response.statusMessage);
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => EmailOtp(
                  email: email,
                  origin: 'profile',
                ),
              ),
            );
          } else {
            setState(() {
              _user = user;
              _favoriteDestinations = favoriteDestinations;
            });
          }
        }
      } else {
        print('Token not found');
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  void _loadFavoriteDestinations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteDestinations = prefs.getStringList('favoriteDestinations') ?? [];
    });
  }

  void _saveFavoriteDestinations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoriteDestinations', _favoriteDestinations);
  }

  void _updateProfileField(String field, String value) async {
    try {
      var dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token') ?? '';
      var userId = _user['id'];

      if (token.isNotEmpty && userId != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
        var response =
            await dio.put('http://167.71.230.108/api/users/$userId', data: {
          field: value,
        });

        if (response.data['success']) {
          setState(() {
            _user = response.data['user'];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully!')),
          );
        } else {
          print('Failed to update profile');
        }
      } else {
        print('Token or User ID not found');
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  void _showEditDialog(String field, String currentValue) {
    TextEditingController _controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update $field'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter new $field'),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () {
                _updateProfileField(field, _controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _truncateText(String text, int maxLength) {
    return (text.length > maxLength)
        ? '${text.substring(0, maxLength)}...'
        : text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ProfilePic(
                imageUrl: '',
              ), // No need to pass imageUrl now
              const SizedBox(height: 20),
              Text(
                _user['name'] ?? 'Name not available',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                _user['email'] ?? 'Email not available',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 30),
              _buildInfoSection(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          "Email",
          _user['email'] ?? 'Not available',
          Icons.email,
          false,
          _user['email_verified_at'] == null ? 'Not Verified' : 'Verified',
        ),
        Divider(),
        _buildInfoRow(
            "Full Name", _user['name'] ?? 'Not available', Icons.person, false),
        Divider(),
        _buildInfoRow("Phone Number", _user['phone_number'] ?? 'Not available',
            Icons.phone, true),
        Divider(),
        _buildInfoRow(
            "Country", _user['country'] ?? 'Not available', Icons.public, true),
        Divider(),
        _buildInfoRow("City", _user['city'] ?? 'Not available',
            Icons.location_city, true),
        Divider(),
        _buildFavoriteDestinationsRow(),
        Divider(),
      ],
    );
  }

  Widget _buildInfoRow(
      String label, String value, IconData icon, bool isEditable,
      [String? verificationStatus]) {
    return GestureDetector(
      onTap: isEditable
          ? () {
              _showEditDialog(label.toLowerCase().replaceAll(' ', '_'), value);
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: Color(0xffF75D37)),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _truncateText(value, 20),
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (verificationStatus != null)
                    Text(
                      verificationStatus,
                      style: TextStyle(
                        fontSize: 12,
                        color: verificationStatus == 'Verified'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                ],
              ),
            ),
            if (isEditable) Icon(Icons.edit, color: Color(0xffF75D37)),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteDestinationsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(Icons.favorite, color: Color(0xffF75D37)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Favorite Destinations",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: () {
              _showFavoriteDestinationsSelectionDialog();
            },
            child: Row(
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Text(
                    _favoriteDestinations.join(', '),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.edit),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFavoriteDestinationsSelectionDialog() {
    final List<String> destinations = [
      'Muscat',
      'Nizwa',
      'Salalah',
      'Sur',
      'Sohar',
      'Jebel Akhdar',
      'Wahiba Sands',
      'Masirah Island'
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Select Favorite Destinations (Max 3)"),
              content: Container(
                height: 300,
                width: double.maxFinite,
                child: ListView(
                  children: destinations.map((destination) {
                    return CheckboxListTile(
                      title: Text(destination),
                      value: _favoriteDestinations.contains(destination),
                      onChanged: (value) {
                        setState(() {
                          if (value != null && value) {
                            if (_favoriteDestinations.length < 3) {
                              _favoriteDestinations.add(destination);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "You can only select up to 3 favorite destinations."),
                                ),
                              );
                            }
                          } else {
                            _favoriteDestinations.remove(destination);
                          }
                        });
                        _saveFavoriteDestinations();
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Done"),
                  onPressed: () {
                    _saveFavoriteDestinations();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
