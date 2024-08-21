import 'package:flutter/material.dart';
import 'package:majan_road/localization/app_localization.dart';

class NotificationHandler extends StatefulWidget {
  @override
  _NotificationHandlerState createState() => _NotificationHandlerState();

  void showNewTrips(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set to true to display from the top
      builder: (BuildContext context) {
        return NotificationHandler();
      },
    );
  }
}

class _NotificationHandlerState extends State<NotificationHandler> {
  @override
  Widget build(BuildContext context) {
    final String newTripText =
        AppLocalizations.of(context)?.translate('you have a new trip') ??
            'You have a new trip!';
    final String placeText =
        AppLocalizations.of(context)?.translate('place') ?? 'Place: Place Name';
    final String priceText =
        AppLocalizations.of(context)?.translate('price') ?? 'Price: \$1000';

    print('New Trip Text: $newTripText');
    print('Place Text: $placeText');
    print('Price Text: $priceText');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      // Adjust height according to your content
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
      child: ListView.builder(
        itemCount: 10, // Replace this with the actual number of new trips
        itemBuilder: (BuildContext context, int index) {
          // Replace this with how you want to build each item in the list
          return Card(
            color: Color(0xff55A5A4).withOpacity(0.8),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/images/1.jpg'), // Replace with actual image path
              ),
              title: Text(newTripText),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(placeText),
                  Text(priceText), // Replace with actual price
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
