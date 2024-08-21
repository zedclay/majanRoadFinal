import 'package:flutter/material.dart';
import 'package:majan_road/trips/model/tripsModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:majan_road/localization/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:majan_road/localization/local_notifier.dart';

class TripDescription extends StatefulWidget {
  final Trip trip;

  TripDescription({required this.trip});

  @override
  State<TripDescription> createState() => _TripDescriptionState();
}

class _TripDescriptionState extends State<TripDescription> {
  String _translatedName = '';
  String _translatedDescription = '';
  List<String> _translatedCategories = [];
  List<String> _translatedWhatsIncluded = [];
  List<String> _translatedWhatsNotIncluded = [];
  List<String> _translatedWhatToBring = [];
  List<String> _translatedCancellationRefundPolicy = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeTranslations();
  }

  void _initializeTranslations() async {
    final localeNotifier = Provider.of<LocaleNotifier>(context, listen: false);
    final currentLocale = localeNotifier.locale.languageCode;

    if (currentLocale == 'ar') {
      _translatedName = await AppLocalizations.of(context)!
          .translateText(widget.trip.name, 'ar');
      _translatedDescription = await AppLocalizations.of(context)!
          .translateText(widget.trip.description, 'ar');
      _translatedCategories =
          await _translateList(widget.trip.categories, 'ar');
      _translatedWhatsIncluded =
          await _translateList(widget.trip.whatsIncluded, 'ar');
      _translatedWhatsNotIncluded =
          await _translateList(widget.trip.whatsNotIncluded, 'ar');
      _translatedWhatToBring =
          await _translateList(widget.trip.whatToBring, 'ar');
      _translatedCancellationRefundPolicy =
          await _translateList(widget.trip.cancellationRefundPolicy, 'ar');
    } else {
      _translatedName = widget.trip.name;
      _translatedDescription = widget.trip.description;
      _translatedCategories = widget.trip.categories;
      _translatedWhatsIncluded = widget.trip.whatsIncluded;
      _translatedWhatsNotIncluded = widget.trip.whatsNotIncluded;
      _translatedWhatToBring = widget.trip.whatToBring;
      _translatedCancellationRefundPolicy =
          widget.trip.cancellationRefundPolicy;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<List<String>> _translateList(
      List<String> items, String targetLanguageCode) async {
    List<String> translatedItems = [];
    for (String item in items) {
      translatedItems.add(await AppLocalizations.of(context)!
          .translateText(item, targetLanguageCode));
    }
    return translatedItems;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.trip.tripImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Back Arrow
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          // DraggableScrollableSheet
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.3,
            maxChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          _translatedName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: textColor,
                          ),
                        ),
                        Text(
                          _translatedDescription,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context)
                                  ?.translate('Categories:') ??
                              'Categories: ${_translatedCategories.join(', ')}',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context)
                                  ?.translate('Whats Included:') ??
                              'What\'s Included:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                        ..._translatedWhatsIncluded
                            .map((item) => Text('- $item',
                                style: TextStyle(color: textColor)))
                            .toList(),
                        SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context)
                                  ?.translate('Whats Not Included:') ??
                              'What\'s Not Included:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                        ..._translatedWhatsNotIncluded
                            .map((item) => Text('- $item',
                                style: TextStyle(color: textColor)))
                            .toList(),
                        SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context)
                                  ?.translate('What to Bring:') ??
                              'What to Bring:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                        ..._translatedWhatToBring
                            .map((item) => Text('- $item',
                                style: TextStyle(color: textColor)))
                            .toList(),
                        SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context)?.translate(
                                  'Cancellation & Refund Policy:') ??
                              'Cancellation & Refund Policy:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                        ..._translatedCancellationRefundPolicy
                            .map((item) => Text('- $item',
                                style: TextStyle(color: textColor)))
                            .toList(),
                        SizedBox(height: 20),
                        Text(
                          AppLocalizations.of(context)?.translate(
                                  'For Reservation Call: +96893337706') ??
                              'For Reservation Call: +96893337706',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                          ?.translate('price') ??
                                      'Price',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '\$${widget.trip.price}',
                                      style: TextStyle(
                                        color: Color(0xffFF9900),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '/person',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                          ?.translate('rating') ??
                                      'RATING',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      widget.trip.rating.toString(),
                                      style: TextStyle(
                                        color: Color(0xffFF9900),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '/5',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                          ?.translate('duration') ??
                                      'DURATION',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${widget.trip.duration}',
                                      style: TextStyle(
                                        color: Color(0xffFF9900),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'days',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: GestureDetector(
                            onTap: () => _makePhoneCall("+96893337706"),
                            child: Container(
                              width: 300,
                              decoration: BoxDecoration(
                                color: Color(
                                    0xffFF9900), // Set background color for the button
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.all(
                                  12), // Add padding for better appearance
                              child: Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                            ?.translate('Call Now') ??
                                        'Call Now',
                                    textAlign: TextAlign
                                        .center, // Center the text horizontally
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white, // Set text color
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $phoneNumber')),
      );
    }
  }
}
