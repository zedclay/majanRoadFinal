import 'package:flutter/material.dart';
import 'package:majan_road/events/imageScrolInternet.dart';
import 'eventsPage.dart';
import 'package:majan_road/localization/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:majan_road/localization/local_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event;

  EventDetailsPage({required this.event});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  String _translatedTitle = '';
  String _translatedDescription = '';
  List<String> _translatedAges = [];
  List<String> _translatedIdealFor = [];
  List<String> _translatedDaysOpened = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeTranslations();
  }

  Future<void> _initializeTranslations() async {
    final localeNotifier = Provider.of<LocaleNotifier>(context, listen: false);
    final currentLocale = localeNotifier.locale.languageCode;

    if (currentLocale == 'ar') {
      _translatedTitle = await AppLocalizations.of(context)!
          .translateText(widget.event.title, 'ar');
      _translatedDescription = await AppLocalizations.of(context)!
          .translateText(widget.event.description, 'ar');
      _translatedAges = await _translateList(widget.event.ages, 'ar');
      _translatedIdealFor = await _translateList(widget.event.idealFor, 'ar');
      _translatedDaysOpened =
          await _translateList(widget.event.daysOpenedDuringWeek, 'ar');
    } else {
      _translatedTitle = widget.event.title;
      _translatedDescription = widget.event.description;
      _translatedAges = widget.event.ages;
      _translatedIdealFor = widget.event.idealFor;
      _translatedDaysOpened = widget.event.daysOpenedDuringWeek;
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
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[700];
    final dividerColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];

    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoading ? '' : _translatedTitle),
        backgroundColor: isDarkMode ? Colors.black : Colors.orange,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.event.pictures.isNotEmpty)
                    ImageCarouselInter(
                      imageUrls: widget.event.pictures,
                    ),
                  SizedBox(height: 16),
                  Text(
                    _translatedTitle,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _translatedDescription,
                    style: TextStyle(fontSize: 16, color: secondaryTextColor),
                  ),
                  Divider(height: 32, color: dividerColor),
                  _buildEventDetails(context, textColor, secondaryTextColor),
                  Divider(height: 32, color: dividerColor),
                  _buildPicturesSection(textColor, secondaryTextColor),
                ],
              ),
            ),
      backgroundColor: backgroundColor,
    );
  }

  Widget _buildEventDetails(
      BuildContext context, Color textColor, Color? secondaryTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(context, Icons.calendar_today, "Start Date",
            widget.event.startDate, textColor, secondaryTextColor),
        _buildDetailRow(context, Icons.calendar_today, "End Date",
            widget.event.endDate, textColor, secondaryTextColor),
        _buildDetailRow(
            context,
            Icons.attach_money,
            "Price",
            "\$${widget.event.price.toStringAsFixed(2)}",
            textColor,
            secondaryTextColor),
        _buildDetailRow(context, Icons.location_pin, "Location",
            widget.event.location, textColor, secondaryTextColor),
        _buildCoordinateRow(
            context,
            Icons.map,
            "Coordinates",
            widget.event.latitude,
            widget.event.longitude,
            textColor,
            secondaryTextColor),
        _buildDetailRow(context, Icons.access_time, "Opening Hour",
            widget.event.openingHour, textColor, secondaryTextColor),
        _buildDetailRow(context, Icons.access_time, "Closing Hour",
            widget.event.closingHour, textColor, secondaryTextColor),
        _buildDetailRow(context, Icons.phone, "Phone Number",
            widget.event.phoneNumber, textColor, secondaryTextColor),
        _buildDetailRow(context, Icons.group, "Ages",
            _translatedAges.join(', '), textColor, secondaryTextColor),
        _buildDetailRow(context, Icons.favorite, "Ideal For",
            _translatedIdealFor.join(', '), textColor, secondaryTextColor),
        _buildDetailRow(
            context,
            Icons.calendar_view_day,
            "Days Opened During Week",
            _translatedDaysOpened.join(', '),
            textColor,
            secondaryTextColor),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label,
      String value, Color textColor, Color? secondaryTextColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange),
          SizedBox(width: 8),
          Text(
            "${AppLocalizations.of(context)?.translate(label) ?? label}: ",
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: secondaryTextColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoordinateRow(
      BuildContext context,
      IconData icon,
      String label,
      double latitude,
      double longitude,
      Color textColor,
      Color? secondaryTextColor) {
    return InkWell(
      onTap: () => _openMap(latitude, longitude),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.orange),
            SizedBox(width: 8),
            Text(
              "${AppLocalizations.of(context)?.translate(label) ?? label}: ",
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
            Expanded(
              child: Text(
                "Lat: $latitude, Long: $longitude",
                style: TextStyle(color: secondaryTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openMap(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildPicturesSection(Color textColor, Color? secondaryTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)?.translate("Pictures") ?? "Pictures",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 8),
        ...widget.event.pictures.map((picture) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(picture, fit: BoxFit.cover),
              ),
            )),
      ],
    );
  }
}
