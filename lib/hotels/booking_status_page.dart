import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:majan_road/localization/app_localization.dart';
import 'package:majan_road/localization/local_notifier.dart';

class BookingStatusPage extends StatefulWidget {
  final int bookingId;

  BookingStatusPage({required this.bookingId});

  @override
  _BookingStatusPageState createState() => _BookingStatusPageState();
}

class _BookingStatusPageState extends State<BookingStatusPage> {
  Map<String, dynamic>? bookingDetails;
  Map<String, dynamic>? hotelDetails;
  bool isLoading = true;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchBookingStatus();
  }

  Future<void> fetchBookingStatus() async {
    try {
      var response = await _dio
          .get('http://167.71.230.108/api/bookings/${widget.bookingId}');
      bookingDetails = response.data;

      // Fetch hotel details using the hotel ID from booking details
      if (bookingDetails != null && bookingDetails!['hotel_id'] != null) {
        await fetchHotelDetails(bookingDetails!['hotel_id']);
      }

      await translateFetchedData(); // Translate the fetched data

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        bookingDetails = null;
        isLoading = false;
      });
    }
  }

  Future<void> fetchHotelDetails(int hotelId) async {
    try {
      var response =
          await _dio.get('http://167.71.230.108/api/hotels/$hotelId');
      hotelDetails = response.data;
    } catch (e) {
      print(e);
      hotelDetails = null;
    }
  }

  Future<void> translateFetchedData() async {
    final localeNotifier = Provider.of<LocaleNotifier>(context, listen: false);
    final currentLocale = localeNotifier.locale.languageCode;

    if (currentLocale == 'ar') {
      if (hotelDetails != null) {
        hotelDetails!['name'] = await translateText(hotelDetails!['name']);
        hotelDetails!['description'] =
            await translateText(hotelDetails!['description']);
        if (hotelDetails!['city'] != null) {
          hotelDetails!['city']['name'] =
              await translateText(hotelDetails!['city']['name']);
        }
      }

      if (bookingDetails != null) {
        bookingDetails!['status'] =
            await translateText(bookingDetails!['status']);
        bookingDetails!['check_in_date'] =
            await translateText(bookingDetails!['check_in_date']);
        bookingDetails!['check_out_date'] =
            await translateText(bookingDetails!['check_out_date']);
      }
    }
  }

  Future<String> translateText(String text) async {
    return await AppLocalizations.of(context)!.translateText(text, 'ar') ??
        text;
  }

  Widget buildHotelImage() {
    if (hotelDetails == null ||
        hotelDetails!['pictures'] == null ||
        hotelDetails!['pictures'].isEmpty) {
      return Container(
        height: 200,
        child: Center(
          child: Text(
            AppLocalizations.of(context)?.translate('No Image Available') ??
                'No Image Available',
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      child: Image.network(
        'http://167.71.230.108/storage' +
            hotelDetails!['pictures'][0]['path'].replaceFirst('public/', '/'),
        fit: BoxFit.cover,
        height: 200,
        width: double.infinity,
      ),
    );
  }

  Widget buildHotelDetails() {
    if (hotelDetails == null) {
      return Center(
        child: Text(
          AppLocalizations.of(context)
                  ?.translate('No hotel details available') ??
              'No hotel details available',
        ),
      );
    }

    final hotelName = hotelDetails!['name'] ??
        AppLocalizations.of(context)?.translate('No name available') ??
        'No name available';
    final hotelDescription = hotelDetails!['description'] ??
        AppLocalizations.of(context)?.translate('No description available') ??
        'No description available';
    final hotelLocation = hotelDetails!['city'] != null
        ? hotelDetails!['city']['name'] ??
            AppLocalizations.of(context)?.translate('No location available') ??
            'No location available'
        : AppLocalizations.of(context)?.translate('No location available') ??
            'No location available';
    final bookingStatus = bookingDetails != null
        ? bookingDetails!['status'] ??
            AppLocalizations.of(context)?.translate('No status available') ??
            'No status available'
        : AppLocalizations.of(context)?.translate('No status available') ??
            'No status available';
    final checkInDate = bookingDetails != null
        ? bookingDetails!['check_in_date'] ??
            AppLocalizations.of(context)
                ?.translate('No check-in date available') ??
            'No check-in date available'
        : AppLocalizations.of(context)
                ?.translate('No check-in date available') ??
            'No check-in date available';
    final checkOutDate = bookingDetails != null
        ? bookingDetails!['check_out_date'] ??
            AppLocalizations.of(context)
                ?.translate('No check-out date available') ??
            'No check-out date available'
        : AppLocalizations.of(context)
                ?.translate('No check-out date available') ??
            'No check-out date available';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hotelName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            hotelDescription,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '${AppLocalizations.of(context)?.translate('Location') ?? 'Location'}: $hotelLocation',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '${AppLocalizations.of(context)?.translate('Status') ?? 'Status'}: $bookingStatus',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: bookingStatus == 'confirmed'
                  ? Colors.green
                  : bookingStatus == 'pending'
                      ? Colors.orange
                      : Colors.red,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '${AppLocalizations.of(context)?.translate('Check-in') ?? 'Check-in'}: $checkInDate',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '${AppLocalizations.of(context)?.translate('Check-out') ?? 'Check-out'}: $checkOutDate',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.translate('Booking Status') ??
            'Booking Status'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : bookingDetails == null
              ? Center(
                  child: Text(
                    AppLocalizations.of(context)
                            ?.translate('Failed to load booking details') ??
                        'Failed to load booking details',
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buildHotelImage(),
                          buildHotelDetails(),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
