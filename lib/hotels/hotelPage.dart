import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:majan_road/base/searchBar.dart';
import 'package:majan_road/hotels/hotelDescriptionPage.dart';
import 'package:majan_road/localization/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:majan_road/localization/local_notifier.dart';

class HotelPage extends StatefulWidget {
  const HotelPage({Key? key}) : super(key: key);

  @override
  State<HotelPage> createState() => _HotelPageState();
}

class _HotelPageState extends State<HotelPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Hotel> hotels = [];
  List<Hotel> filteredHotels = [];
  bool sortByPriceLowToHigh = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHotels();
  }

  Future<void> fetchHotels() async {
    final response =
        await http.get(Uri.parse('http://167.71.230.108/api/hotels'));
    if (response.statusCode == 200) {
      List<dynamic> hotelsData = json.decode(response.body);
      List<Hotel> fetchedHotels =
          await Future.wait(hotelsData.map((data) async {
        List<String> imageUrls =
            (data['pictures'] as List<dynamic>).map((picture) {
          return 'http://167.71.230.108/storage' +
              picture['path'].replaceFirst('public/', '/');
        }).toList();
        List<String> amenities =
            (json.decode(data['amenities']) as List<dynamic>)
                .map((amenity) => amenity.toString())
                .toList();

        String name = data['name'];
        String description = data['description'];

        final localeNotifier =
            Provider.of<LocaleNotifier>(context, listen: false);
        final currentLocale = localeNotifier.locale.languageCode;

        if (currentLocale == 'ar') {
          name = await AppLocalizations.of(context)!.translateText(name, 'ar');
          description = await AppLocalizations.of(context)!
              .translateText(description, 'ar');
        }

        return Hotel(
          id: data['id'],
          name: name,
          description: description,
          imageUrls: imageUrls,
          rating: double.tryParse(data['rating'].toString()) ?? 0.0,
          location: data['city']['name'],
          price: double.tryParse(data['price'].toString()) ?? 0.0,
          amenities: amenities,
        );
      }).toList());

      setState(() {
        hotels = fetchedHotels;
        filteredHotels = hotels;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load hotels');
    }
  }

  void filterHotels(String query) {
    final filtered = hotels.where((hotel) {
      final nameLower = hotel.name.toLowerCase();
      final locationLower = hotel.location.toLowerCase();
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower) ||
          locationLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredHotels = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        toolbarHeight: 2,
        backgroundColor: backgroundColor,
      ),
      key: _scaffoldKey,
      body: Padding(
        padding: EdgeInsets.only(
          right: screenWidth * 0.02,
          left: screenWidth * 0.02,
          top: screenWidth * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SearchBare(
              onChanged: (String value) {
                filterHotels(value);
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)?.translate('popular hotels') ??
                      'Popular Hotels',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffF75D37),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _showSortOptions(context);
                  },
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)?.translate('sorted by') ??
                            'Sorted by',
                        style: TextStyle(color: Color(0xffF75D37)),
                      ),
                      const Icon(Icons.sort),
                    ],
                  ),
                ),
              ],
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    flex: 1,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredHotels.length,
                      itemBuilder: (context, index) {
                        return HotelCard(
                          hotel: filteredHotels[index],
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _sortHotelsByPrice() {
    filteredHotels.sort((a, b) {
      if (sortByPriceLowToHigh) {
        return a.price.compareTo(b.price);
      } else {
        return b.price.compareTo(a.price);
      }
    });
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.arrow_upward),
                title: Text(AppLocalizations.of(context)
                        ?.translate('price low to high') ??
                    'Price (Low to High)'),
                onTap: () {
                  setState(() {
                    sortByPriceLowToHigh = true;
                    _sortHotelsByPrice();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_downward),
                title: Text(AppLocalizations.of(context)
                        ?.translate('price high to low') ??
                    'Price (High to Low)'),
                onTap: () {
                  setState(() {
                    sortByPriceLowToHigh = false;
                    _sortHotelsByPrice();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                    AppLocalizations.of(context)?.translate('latest hotel') ??
                        'Latest Hotel'),
                onTap: () {
                  // Implement sorting by latest hotel
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: Text(
                    AppLocalizations.of(context)?.translate('old hotel') ??
                        'Old Hotel'),
                onTap: () {
                  // Implement sorting by old hotel
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class Hotel {
  final int id;
  final String name;
  final String description;
  final List<String> imageUrls;
  final double rating;
  final String location;
  final double price;
  final List<String> amenities;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrls,
    required this.rating,
    required this.location,
    required this.price,
    required this.amenities,
  });
}

class HotelCard extends StatefulWidget {
  final Hotel hotel;

  const HotelCard({
    Key? key,
    required this.hotel,
  }) : super(key: key);

  @override
  _HotelCardState createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    EdgeInsets margin = EdgeInsets.symmetric(
      vertical:
          MediaQuery.of(context).size.height * 0.02, // 2% of screen height
      horizontal:
          MediaQuery.of(context).size.width * 0.04, // 4% of screen width
    );
    return Container(
      width: MediaQuery.of(context).size.width - 16,
      height: MediaQuery.of(context).size.height / 4,
      margin: margin,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HotelDescription(
                tripName: widget.hotel.name,
                tripDescription: widget.hotel.description,
                imageUrls: widget.hotel.imageUrls,
                rating: widget.hotel.rating,
                location: widget.hotel.location,
                price: widget.hotel.price,
                hotelId: widget.hotel.id,
                amenities: widget.hotel.amenities,
              ),
            ),
          );
        },
        child: Card(
          color: cardColor,
          elevation: 1,
          margin: EdgeInsets.zero,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3.5,
                height: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  child: Image.network(
                    widget.hotel.imageUrls.isNotEmpty
                        ? widget.hotel.imageUrls[0]
                        : 'http://167.71.230.108/default-image.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.hotel.name,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isBookmarked = !isBookmarked;
                              });
                            },
                            icon: Icon(
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: isBookmarked
                                  ? const Color(0xffF75D37)
                                  : const Color(0xffF75D37),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.yellow),
                          SizedBox(width: 4),
                          Text(widget.hotel.rating.toString(),
                              style: TextStyle(color: textColor)),
                        ],
                      ),
                      SizedBox(height: 2),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.hotel.location,
                              style: TextStyle(color: textColor)),
                          const SizedBox(height: 4),
                          Text('\$${widget.hotel.price}/Room/Night',
                              style: TextStyle(color: textColor)),
                          const SizedBox(height: 4),
                          Text(
                            'Amenities: ${widget.hotel.amenities.join(', ')}',
                            style: TextStyle(color: textColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
