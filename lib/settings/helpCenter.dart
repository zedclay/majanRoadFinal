import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterPage extends StatelessWidget {
  final List<Map<String, dynamic>> emergencyNumbers = [
    {
      'title': 'Police',
      'number': '9999',
      'icon': Icons.local_police,
    },
    {
      'title': 'Fire Department',
      'number': '9999',
      'icon': Icons.local_fire_department
    },
    {
      'title': 'Ambulance',
      'number': '9999',
      'icon': Icons.local_hospital,
    },
    {
      'title': 'Tourist Helpline',
      'number': '97803149',
      'icon': Icons.help,
    },
    {
      'title': 'Electricity Emergency',
      'number': '1011',
      'icon': Icons.electric_bolt
    },
    {
      'title': 'Water Emergency',
      'number': '1442',
      'icon': Icons.water_damage,
    },
  ];

  void _callNumber(BuildContext context, String number) async {
    try {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // Use url_launcher to open the dialer on iOS
        String url = 'tel:$number';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          print('Could not launch $number');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $number')),
          );
        }
      } else {
        // Use FlutterPhoneDirectCaller for Android
        bool? res = await FlutterPhoneDirectCaller.callNumber(number);
        if (res == null || !res) {
          print('Could not launch $number');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $number')),
          );
        } else {
          print('Launched $number successfully');
        }
      }
    } catch (e) {
      print('Error launching $number: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching $number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help Center'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'In case of any emergency, please call one of the numbers below. Our team is always ready to assist you.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: emergencyNumbers.length,
                itemBuilder: (context, index) {
                  final emergency = emergencyNumbers[index];
                  return ListTile(
                    leading: Icon(emergency['icon']),
                    title: Text(emergency['title']),
                    subtitle: Text(emergency['number']),
                    trailing: Icon(Icons.call),
                    onTap: () => _callNumber(context, emergency['number']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
