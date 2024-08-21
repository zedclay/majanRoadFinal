import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'booking_status_page.dart';
import 'package:provider/provider.dart';
import 'package:majan_road/localization/app_localization.dart';
import 'package:majan_road/localization/local_notifier.dart';

class BookingForm extends StatefulWidget {
  final String hotelName;
  final int hotelId;

  BookingForm({required this.hotelName, required this.hotelId});

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController hotelNameController = TextEditingController();
  TextEditingController checkInDateController = TextEditingController();
  TextEditingController checkOutDateController = TextEditingController();
  String? selectedRoomType;
  DateTime? selectedCheckInDate;
  DateTime? selectedCheckOutDate;

  List<String> roomTypes = ['Single', 'Double', 'Suite'];

  @override
  void initState() {
    super.initState();
    hotelNameController.text = widget.hotelName;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');

      if (userId == null) {
        _showSnackBar(
          context,
          AppLocalizations.of(context)
                  ?.translate('User ID not found. Please login again.') ??
              'User ID not found. Please login again.',
          AnimatedSnackBarType.error,
        );
        return;
      }

      try {
        var formData = {
          'user_id': userId,
          'hotel_id': widget.hotelId,
          'check_in_date': checkInDateController.text,
          'check_out_date': checkOutDateController.text,
          'status': 'pending',
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'hotel_name': hotelNameController.text,
          'room_type': selectedRoomType,
        };

        var response = await _dio.post('http://167.71.230.108/api/bookings',
            data: formData);

        int bookingId = response.data['id'];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)
                      ?.translate("Booking Request Received") ??
                  "Booking Request Received"),
              content: Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width / 1.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/pending.png',
                        color: Colors.greenAccent,
                        height: MediaQuery.of(context).size.height / 5,
                        width: MediaQuery.of(context).size.width / 4),
                    SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)?.translate(
                              "We will call you to confirm your reservation.") ??
                          "We will call you to confirm your reservation.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookingStatusPage(bookingId: bookingId),
                      ),
                    );
                  },
                  child: Text(
                      AppLocalizations.of(context)?.translate("OK") ?? "OK"),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, DateTime? initialDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  static void _showSnackBar(
      BuildContext context, String message, AnimatedSnackBarType type) {
    AnimatedSnackBar.material(
      message,
      type: type,
      duration: Duration(seconds: 2),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.translate('Booking Form') ??
            'Booking Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)?.translate('First Name') ??
                            'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)
                            ?.translate('Please enter your first name') ??
                        'Please enter your first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)?.translate('Last Name') ??
                            'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)
                            ?.translate('Please enter your last name') ??
                        'Please enter your last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)?.translate('Email') ??
                            'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return AppLocalizations.of(context)
                            ?.translate('Please enter a valid email') ??
                        'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)?.translate('Phone') ??
                            'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)
                            ?.translate('Please enter your phone number') ??
                        'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: hotelNameController,
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)?.translate('Hotel Name') ??
                            'Hotel Name'),
                readOnly: true,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)?.translate('Room Type') ??
                            'Room Type'),
                value: selectedRoomType,
                items: roomTypes.map((String roomType) {
                  return DropdownMenuItem<String>(
                    value: roomType,
                    child: Text(roomType),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRoomType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return AppLocalizations.of(context)
                            ?.translate('Please select a room type') ??
                        'Please select a room type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: checkInDateController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)
                            ?.translate('Check-In Date') ??
                        'Check-In Date'),
                readOnly: true,
                onTap: () => _selectDate(
                    context, checkInDateController, selectedCheckInDate),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)
                            ?.translate('Please select a check-in date') ??
                        'Please select a check-in date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: checkOutDateController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)
                            ?.translate('Check-Out Date') ??
                        'Check-Out Date'),
                readOnly: true,
                onTap: () => _selectDate(
                    context, checkOutDateController, selectedCheckOutDate),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)
                            ?.translate('Please select a check-out date') ??
                        'Please select a check-out date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(AppLocalizations.of(context)?.translate('Submit') ??
                    'Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
