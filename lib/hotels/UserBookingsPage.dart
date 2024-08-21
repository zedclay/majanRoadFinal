import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:majan_road/localization/app_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:majan_road/hotels/booking_status_page.dart';

class UserBookingsPage extends StatefulWidget {
  final VoidCallback toggleDarkMode;
  final Function(Locale) changeLanguage;

  UserBookingsPage({
    required this.toggleDarkMode,
    required this.changeLanguage,
  });

  @override
  _UserBookingsPageState createState() => _UserBookingsPageState();
}

class _UserBookingsPageState extends State<UserBookingsPage> {
  List<Map<String, dynamic>>? bookings;
  bool isLoading = true;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchUserBookings();
  }

  Future<void> fetchUserBookings() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');

      if (userId == null) {
        setState(() {
          bookings = [];
          isLoading = false;
        });
        print('User ID not found in SharedPreferences');
        return;
      }

      var response =
          await _dio.get('http://167.71.230.108/api/bookings/user/$userId');
      List<Map<String, dynamic>> bookingsData =
          List<Map<String, dynamic>>.from(response.data);

      for (var booking in bookingsData) {
        var hotel = booking['hotel'];
        if (hotel != null) {
          int hotelId = hotel['id'];
          var hotelResponse =
              await _dio.get('http://167.71.230.108/api/hotels/$hotelId');
          if (hotelResponse.statusCode == 200) {
            var hotelData = hotelResponse.data;
            if (hotelData['pictures'] != null &&
                hotelData['pictures'].isNotEmpty) {
              hotel['pictures'] = hotelData['pictures'];
              for (var picture in hotel['pictures']) {
                picture['path'] = 'http://167.71.230.108/storage' +
                    picture['path'].replaceFirst('public/', '/');
              }
            }
          }
        }
      }

      setState(() {
        bookings = bookingsData;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching user bookings: $e');
      setState(() {
        bookings = [];
        isLoading = false;
      });
    }
  }

  Widget buildBookingCard(Map<String, dynamic> booking) {
    String imageUrl = booking['hotel']['pictures'] != null &&
            booking['hotel']['pictures'].isNotEmpty
        ? booking['hotel']['pictures'][0]['path']
        : 'assets/images/default-image.png';

    String status = booking['status'];
    Color statusColor;
    switch (status) {
      case 'confirmed':
        statusColor = Colors.green;
        break;
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: cardColor,
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingStatusPage(bookingId: booking['id']),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              child: Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/default-image.png',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking['hotel']['name'] ?? 'No Hotel Name',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Status: $status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Check-in: ${booking['check_in_date']}',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                  Text(
                    'Check-out: ${booking['check_out_date']}',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context)?.translate('My Bookings') ??
                'My Bookings',
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: backgroundColor,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : bookings == null || bookings!.isEmpty
              ? Center(
                  child: Text('No bookings found',
                      style: TextStyle(color: textColor)))
              : ListView.builder(
                  itemCount: bookings!.length,
                  itemBuilder: (context, index) {
                    return buildBookingCard(bookings![index]);
                  },
                ),
      backgroundColor: backgroundColor,
    );
  }
}
