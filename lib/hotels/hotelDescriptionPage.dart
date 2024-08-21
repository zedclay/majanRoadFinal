import 'package:flutter/material.dart';
import 'package:majan_road/hotels/BookingForm.dart';
import 'package:provider/provider.dart';
import 'package:majan_road/localization/app_localization.dart';
import 'package:majan_road/localization/local_notifier.dart';

class HotelDescription extends StatefulWidget {
  final String tripName;
  final String tripDescription;
  final List<String> imageUrls; // List of image URLs
  final double rating;
  final String location;
  final double price;
  final int hotelId; // Add hotelId parameter
  final List<String> amenities; // Add amenities field

  HotelDescription({
    required this.tripName,
    required this.tripDescription,
    required this.imageUrls, // Accept the list of image URLs
    required this.rating,
    required this.location,
    required this.price,
    required this.hotelId, // Accept hotelId parameter
    required this.amenities, // Initialize amenities
  });

  @override
  State<HotelDescription> createState() => _HotelDescriptionState();
}

class _HotelDescriptionState extends State<HotelDescription> {
  late PageController _pageController;

  String _translatedTripName = '';
  String _translatedTripDescription = '';
  List<String> _translatedAmenities = [];
  String _translatedRating = '';
  String _translatedPrice = '';
  String _translatedLocation = '';
  String _translatedAmenitiesLabel = '';
  String _translatedGoodToKnow = '';
  String _translatedBookNow = '';
  String _translatedFriendlyStaff = '';
  String _translatedConciergeServices = '';
  String _translatedFitnessCenter = '';
  String _translatedFamilyFriendly = '';
  String _translatedOutdoorPools = '';
  String _translatedFriendlyStaffDesc = '';
  String _translatedConciergeServicesDesc = '';
  String _translatedFitnessCenterDesc = '';
  String _translatedFamilyFriendlyDesc = '';
  String _translatedOutdoorPoolsDesc = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeTranslations();
    });
  }

  Future<void> _initializeTranslations() async {
    final localeNotifier = Provider.of<LocaleNotifier>(context, listen: false);
    final currentLocale = localeNotifier.locale.languageCode;

    if (currentLocale == 'ar') {
      _translatedTripName = await AppLocalizations.of(context)!
              .translateText(widget.tripName, 'ar') ??
          widget.tripName;
      _translatedTripDescription = await AppLocalizations.of(context)!
              .translateText(widget.tripDescription, 'ar') ??
          widget.tripDescription;
      _translatedAmenities =
          await _translateList(context, widget.amenities, 'ar');
      _translatedRating =
          await AppLocalizations.of(context)!.translate('Rating') ?? 'Rating';
      _translatedPrice =
          await AppLocalizations.of(context)!.translate('price') ?? 'Price';
      _translatedLocation =
          await AppLocalizations.of(context)!.translate('location') ??
              'Location';
      _translatedAmenitiesLabel =
          await AppLocalizations.of(context)!.translate('Amenities') ??
              'Amenities';
      _translatedGoodToKnow =
          await AppLocalizations.of(context)!.translate('Good to know') ??
              'Good to know';
      _translatedBookNow =
          await AppLocalizations.of(context)!.translate('Book Now') ??
              'Book Now';
      _translatedFriendlyStaff =
          await AppLocalizations.of(context)!.translate('Friendly Staff') ??
              'Friendly Staff';
      _translatedConciergeServices =
          await AppLocalizations.of(context)!.translate('Concierge Services') ??
              'Concierge Services';
      _translatedFitnessCenter =
          await AppLocalizations.of(context)!.translate('Fitness Center') ??
              'Fitness Center';
      _translatedFamilyFriendly =
          await AppLocalizations.of(context)!.translate('Family-Friendly') ??
              'Family-Friendly';
      _translatedOutdoorPools =
          await AppLocalizations.of(context)!.translate('Outdoor Pools') ??
              'Outdoor Pools';
      _translatedFriendlyStaffDesc = await AppLocalizations.of(context)!.translate(
              'Guests rave about the exceptional and friendly hotel staff.') ??
          'Guests rave about the exceptional and friendly hotel staff.';
      _translatedConciergeServicesDesc = await AppLocalizations.of(context)!
              .translate('Let the concierge help you plan your stay.') ??
          'Let the concierge help you plan your stay.';
      _translatedFitnessCenterDesc = await AppLocalizations.of(context)!
              .translate('Work out in the on-site fitness center.') ??
          'Work out in the on-site fitness center.';
      _translatedFamilyFriendlyDesc = await AppLocalizations.of(context)!.translate(
              'Families enjoy the spacious family units and convenient access to the beach.') ??
          'Families enjoy the spacious family units and convenient access to the beach.';
      _translatedOutdoorPoolsDesc = await AppLocalizations.of(context)!
              .translate(
                  'Take a dip in one of the two outdoor swimming pools.') ??
          'Take a dip in one of the two outdoor swimming pools.';
    } else {
      _translatedTripName = widget.tripName;
      _translatedTripDescription = widget.tripDescription;
      _translatedAmenities = widget.amenities;
      _translatedRating = 'Rating';
      _translatedPrice = 'Price';
      _translatedLocation = 'Location';
      _translatedAmenitiesLabel = 'Amenities';
      _translatedGoodToKnow = 'Good to know';
      _translatedBookNow = 'Book Now';
      _translatedFriendlyStaff = 'Friendly Staff';
      _translatedConciergeServices = 'Concierge Services';
      _translatedFitnessCenter = 'Fitness Center';
      _translatedFamilyFriendly = 'Family-Friendly';
      _translatedOutdoorPools = 'Outdoor Pools';
      _translatedFriendlyStaffDesc =
          'Guests rave about the exceptional and friendly hotel staff.';
      _translatedConciergeServicesDesc =
          'Let the concierge help you plan your stay.';
      _translatedFitnessCenterDesc = 'Work out in the on-site fitness center.';
      _translatedFamilyFriendlyDesc =
          'Families enjoy the spacious family units and convenient access to the beach.';
      _translatedOutdoorPoolsDesc =
          'Take a dip in one of the two outdoor swimming pools.';
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<List<String>> _translateList(BuildContext context, List<String> items,
      String targetLanguageCode) async {
    List<String> translatedItems = [];
    for (String item in items) {
      translatedItems.add(await AppLocalizations.of(context)!
              .translateText(item, targetLanguageCode) ??
          item);
    }
    return translatedItems;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300.0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.imageUrls.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(widget.imageUrls[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                _translatedTripName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                _translatedTripDescription,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _translatedRating,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: textColor,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.star,
                                              color: Colors.yellow),
                                          Text(
                                            widget.rating.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              color: textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _translatedPrice,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: textColor,
                                        ),
                                      ),
                                      Text(
                                        '\$${widget.price}/Room/Night',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _translatedLocation,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: textColor,
                                        ),
                                      ),
                                      Text(
                                        widget.location,
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Text(
                                _translatedAmenitiesLabel,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _translatedAmenities
                                    .map((amenity) => Text(
                                          '• $amenity',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: textColor,
                                          ),
                                        ))
                                    .toList(),
                              ),
                              SizedBox(height: 20),
                              Text(
                                _translatedGoodToKnow,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(height: 10),
                              Column(
                                children: [
                                  _buildGoodToKnowItem(_translatedFriendlyStaff,
                                      _translatedFriendlyStaffDesc),
                                  _buildGoodToKnowItem(
                                      _translatedConciergeServices,
                                      _translatedConciergeServicesDesc),
                                  _buildGoodToKnowItem(_translatedFitnessCenter,
                                      _translatedFitnessCenterDesc),
                                  _buildGoodToKnowItem(
                                      _translatedFamilyFriendly,
                                      _translatedFamilyFriendlyDesc),
                                  _buildGoodToKnowItem(_translatedOutdoorPools,
                                      _translatedOutdoorPoolsDesc),
                                ],
                              ),
                              SizedBox(height: 20),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  margin: EdgeInsets.only(top: 20),
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Color(0xffFF9900),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BookingForm(
                                            hotelName: widget
                                                .tripName, // Pass the hotel name
                                            hotelId: widget
                                                .hotelId, // Pass the hotel id
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      _translatedBookNow,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildGoodToKnowItem(String title, String description) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: Colors.orange),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
