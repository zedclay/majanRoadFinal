// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:majan_road/hotels/cardHotels.dart';
// import 'package:majan_road/hotels/hotelDescriptionPage.dart';
// import 'package:majan_road/localization/app_localization.dart';
// import 'package:majan_road/provinces/MyCardDestination.dart';
// import 'package:majan_road/provinces/provincePage.dart';
// import 'package:majan_road/provinces/provincesCard.dart';
// import 'package:majan_road/trips/tripsDescriptionPage.dart';
// import 'package:majan_road/widgets/imageCarousel.dart';

// class HomepageContent extends StatefulWidget {
//   const HomepageContent({Key? key}) : super(key: key);

//   @override
//   State<HomepageContent> createState() => _HomepageContentState();
// }

// class _HomepageContentState extends State<HomepageContent> {
//   List<dynamic> provinces = [];
//   List<dynamic> places = [];
//   String selectedProvince = "Oman";
//   List<dynamic> selectedPlaces = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchProvinces();
//     fetchPlaces();
//   }

//   Future<void> fetchProvinces() async {
//     final response = await http.get(Uri.parse('http://167.71.230.108/api/provinces'));
//     if (response.statusCode == 200) {
//       setState(() {
//         provinces = json.decode(response.body);
//         selectedPlaces = provinces
//             .expand((province) => province['places'] as List<dynamic>)
//             .toList();
//       });
//     } else {
//       throw Exception('Failed to load provinces');
//     }
//   }

//   Future<void> fetchPlaces() async {
//     final response = await http.get(Uri.parse('http://167.71.230.108/api/places'));
//     if (response.statusCode == 200) {
//       setState(() {
//         places = json.decode(response.body);
//       });
//     } else {
//       throw Exception('Failed to load places');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ImageCarousel(
//               imageUrls: [
//                 'assets/images/tourism1.png',
//                 'assets/images/tourism2.png',
//               ],
//             ),
//             const SizedBox(height: 20),
//             Text(
//               "Welcome to",
//               style: TextStyle(
//                 fontSize: 34,
//                 fontFamily: 'Modernist-Regular',
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             Text(
//               "Oman",
//               style: TextStyle(
//                 fontSize: 38,
//                 fontFamily: 'Wanderlust',
//                 color: Color(0xffF75D37),
//               ),
//             ),
//             const SizedBox(height: 20),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: provinces.map((province) {
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedProvince = province['name']!;
//                         selectedPlaces = province['places'];
//                       });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(15),
//                             child: Image.network(
//                               'http://167.71.230.108/' + province['pictures'][0]['path'],
//                               fit: BoxFit.cover,
//                               height: 100,
//                               width: 100,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             province['name']!,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Discover Must-Visit Places In ',
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xffF75D37),
//               ),
//             ),
//             Text(
//               selectedProvince,
//               style: const TextStyle(
//                 fontSize: 30,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Wanderlust',
//                 color: Color(0xff55A5A4), // Change to your desired color
//               ),
//             ),
//             const SizedBox(height: 20),
//             selectedPlaces.isNotEmpty
//                 ? SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: selectedPlaces.map((place) {
//                         return Padding(
//                           padding: const EdgeInsets.only(right: 10.0),
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) => LocationPage(
//                                     imagePath: 'http://167.71.230.108/' + place['pictures'][0]['path'],
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: MyCardLocations(
//                               placeName: place['name'],
//                               provinceName: selectedProvince,
//                               image: 'http://167.71.230.108/' + place['pictures'][0]['path'],
//                               placeNumber: '20', // Example value, update as needed
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   )
//                 : Text(
//                     'No places available in $selectedProvince',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.normal,
//                     ),
//                   ),
//             const SizedBox(height: 20),
//             Text(
//               AppLocalizations.of(context)?.translate('popular trips') ??
//                   'Popular Trips',
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xffF75D37),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => TripDescription(
//                               tripName: 'Desert Safari in Wahiba Sands',
//                               tripDescription:
//                                   'Enjoy an exhilarating ride in the Wahiba Sands desert with breathtaking views and thrilling experiences.',
//                               imageName: 'assets/images/5.jpeg',
//                             ),
//                           ),
//                         );
//                       },
//                       child: const MyCardDestination(
//                         placeName: 'Desert Safari in Wahiba Sands',
//                         image: 'assets/images/5.jpeg',
//                         placeNumber: '20',
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => TripDescription(
//                               tripName: 'Jebel Shams Trekking',
//                               tripDescription:
//                                   'Experience the magnificent views and challenging trails of Jebel Shams, the highest mountain in Oman.',
//                               imageName: 'assets/images/6.jpeg',
//                             ),
//                           ),
//                         );
//                       },
//                       child: const MyCardDestination(
//                         placeName: 'Jebel Shams Trekking',
//                         image: 'assets/images/6.jpeg',
//                         placeNumber: '20',
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => TripDescription(
//                               tripName: 'Dolphin Watching in Musandam',
//                               tripDescription:
//                                   'Join a boat tour to watch dolphins in their natural habitat in the pristine waters of Musandam.',
//                               imageName: 'assets/images/8.jpg',
//                             ),
//                           ),
//                         );
//                       },
//                       child: const MyCardDestination(
//                         placeName: 'Dolphin Watching in Musandam',
//                         image: 'assets/images/8.jpg',
//                         placeNumber: '20',
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => TripDescription(
//                               tripName: 'Historical Tour of Nizwa',
//                               tripDescription:
//                                   'Explore the rich history and culture of Nizwa with guided tours of ancient forts and bustling souks.',
//                               imageName: 'assets/images/7.jpeg',
//                             ),
//                           ),
//                         );
//                       },
//                       child: const MyCardDestination(
//                         placeName: 'Historical Tour of Nizwa',
//                         image: 'assets/images/7.jpeg',
//                         placeNumber: '20',
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Text(
//               AppLocalizations.of(context)?.translate('popular hotels') ??
//                   'Popular Hotels',
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xffF75D37),
//               ),
//             ),
//             const SizedBox(height: 20),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => HotelDescription(
//                             tripName: 'The Chedi Muscat',
//                             tripDescription: AppLocalizations.of(context)
//                                     ?.translate('chedi description') ??
//                                 'Dreamland beach there are white coral rocks that surround the beach, this creates a beautiful view of its own.',
//                             imageName: 'hotel11.jpg',
//                           ),
//                         ),
//                       );
//                     },
//                     child: CardHotels(
//                       placeName: 'The Chedi Muscat',
//                       image: 'assets/images/hotel1.webp',
//                       placeNumber: '20',
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => HotelDescription(
//                             tripName: 'Al Bustan Palace, a Ritz-Carlton Hotel',
//                             tripDescription: AppLocalizations.of(context)
//                                     ?.translate('bustan description') ??
//                                 'Dreamland beach there are white coral rocks that surround the beach, this creates a beautiful view of its own.',
//                             imageName: 'hotel22.jpg',
//                           ),
//                         ),
//                       );
//                     },
//                     child: CardHotels(
//                       placeName: 'Al Bustan Palace, a Ritz-Carlton Hotel',
//                       image: 'assets/images/hotel2.jpg',
//                       placeNumber: '20',
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => HotelDescription(
//                             tripName: 'Six Senses Zighy Bay',
//                             tripDescription: AppLocalizations.of(context)
//                                     ?.translate('zighy description') ??
//                                 'Dreamland beach there are white coral rocks that surround the beach, this creates a beautiful view of its own.',
//                             imageName: 'hotel33.jpg',
//                           ),
//                         ),
//                       );
//                     },
//                     child: CardHotels(
//                       placeName: 'Six Senses Zighy Bay',
//                       image: 'assets/images/hotel3.webp',
//                       placeNumber: '20',
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => HotelDescription(
//                             tripName: 'Shangri-La Barr Al Jissah Resort & Spa',
//                             tripDescription: AppLocalizations.of(context)
//                                     ?.translate('shangri-la description') ??
//                                 'Dreamland beach there are white coral rocks that surround the beach, this creates a beautiful view of its own.',
//                             imageName: 'hotel44.jpg',
//                           ),
//                         ),
//                       );
//                     },
//                     child: CardHotels(
//                       placeName: 'Shangri-La Barr Al Jissah Resort & Spa',
//                       image: 'assets/images/hotel44.jpg',
//                       placeNumber: '20',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:majan_road/base/searchBar.dart';
import 'package:majan_road/hotels/cardHotels.dart';
import 'package:majan_road/hotels/hotelDescriptionPage.dart';
import 'package:majan_road/localization/app_localization.dart';
import 'package:majan_road/provinces/MyCardDestination.dart';
import 'package:majan_road/provinces/provincePage.dart';
import 'package:majan_road/provinces/provincesCard.dart';
import 'package:majan_road/trips/model/tripsModel.dart';
import 'package:majan_road/trips/tripsDescriptionPage.dart';
import 'package:majan_road/widgets/imageCarousel.dart';

class HomepageContent extends StatefulWidget {
  const HomepageContent({Key? key}) : super(key: key);

  @override
  State<HomepageContent> createState() => _HomepageContentState();
}

class _HomepageContentState extends State<HomepageContent> {
  List<Hotel> hotels = [];
  List<Hotel> filteredHotels = [];
  List<dynamic> provinces = [];
  List<dynamic> places = [];
  List<dynamic> trips = [];
  String selectedProvince = "Oman";
  List<dynamic> selectedPlaces = [];

  @override
  void initState() {
    super.initState();
    fetchProvinces();
    fetchPlaces();
    fetchTrips();
    fetchHotels();
  }

  Future<void> fetchProvinces() async {
    final response =
        await http.get(Uri.parse('http://167.71.230.108/api/cities'));
    if (response.statusCode == 200) {
      List<dynamic> provincesData = json.decode(response.body);

      // Remove 'public' from picture URLs and prepend base URL
      for (var province in provincesData) {
        if (province['pictures'] != null && province['pictures'].isNotEmpty) {
          for (var picture in province['pictures']) {
            picture['path'] = 'http://167.71.230.108/storage' +
                picture['path'].replaceFirst('public/', '/');
            print('Modified province picture URL: ${picture['path']}');
          }
        }
      }

      setState(() {
        provinces = provincesData;
        if (provinces.isNotEmpty) {
          selectedProvince = provinces[0]['name'];
          selectedPlaces = places
              .where((place) => place['city_id'] == provinces[0]['id'])
              .toList();
        }
      });
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  Future<void> fetchPlaces() async {
    final response =
        await http.get(Uri.parse('http://167.71.230.108/api/places'));
    if (response.statusCode == 200) {
      List<dynamic> placesData = json.decode(response.body);

      for (var place in placesData) {
        if (place['pictures'] != null && place['pictures'].isNotEmpty) {
          for (var picture in place['pictures']) {
            picture['path'] = 'http://167.71.230.108/storage' +
                picture['path'].replaceFirst('public/', '/');
          }
        }
        if (place['videos'] != null && place['videos'].isNotEmpty) {
          for (var video in place['videos']) {
            video['path'] = 'http://167.71.230.108/storage' +
                video['path'].replaceFirst('public/', '/');
          }
        }
      }

      setState(() {
        places = placesData;
      });
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<void> fetchTrips() async {
    final response =
        await http.get(Uri.parse('http://167.71.230.108/api/trips'));
    if (response.statusCode == 200) {
      List<dynamic> tripsData = json.decode(response.body);

      // Remove 'public' from picture URLs and prepend base URL
      for (var trip in tripsData) {
        if (trip['pictures'] != null && trip['pictures'].isNotEmpty) {
          for (var picture in trip['pictures']) {
            picture['path'] = 'http://167.71.230.108/storage' +
                picture['path'].replaceFirst('public/', '/');
          }
        }

        // Parse the string fields to JSON lists
        trip['categories'] = json.decode(trip['categories']);
        trip['whats_included'] = json.decode(trip['whats_included']);
        trip['whats_not_included'] = json.decode(trip['whats_not_included']);
        trip['what_to_bring'] = json.decode(trip['what_to_bring']);
        trip['cancellation_refund_policy'] =
            json.decode(trip['cancellation_refund_policy']);
      }

      setState(() {
        trips = tripsData;
      });
    } else {
      throw Exception('Failed to load trips');
    }
  }

  Future<void> fetchHotels() async {
    final response =
        await http.get(Uri.parse('http://167.71.230.108/api/hotels'));
    if (response.statusCode == 200) {
      List<dynamic> hotelsData = json.decode(response.body);

      List<Hotel> fetchedHotels = hotelsData.map((data) {
        List<String> imageUrls =
            (data['pictures'] as List<dynamic>).map((picture) {
          return 'http://167.71.230.108/storage' +
              picture['path'].replaceFirst('public/', '/');
        }).toList();
        return Hotel(
          id: data['id'],
          name: data['name'],
          description: data['description'],
          imageUrls: imageUrls,
          rating: double.tryParse(data['rating'].toString()) ?? 0.0,
          location: data['city']['name'],
          price: double.tryParse(data['price'].toString()) ?? 0.0,
        );
      }).toList();

      setState(() {
        hotels = fetchedHotels;
        filteredHotels = hotels;
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

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            right: screenWidth * 0.02,
            left: screenWidth * 0.02,
            top: screenWidth * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImageCarousel(
              imageUrls: [
                'assets/images/tourism1.png',
                'assets/images/tourism2.png'
              ],
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)?.translate('welcome to') ??
                  "Welcome to",
              style: TextStyle(
                fontSize: 34,
                fontFamily: 'Modernist-Regular',
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            ),
            Text(
              AppLocalizations.of(context)?.translate('oman') ?? "Oman",
              style: TextStyle(
                fontSize: 38,
                fontFamily: 'Wanderlust',
                color: Color(0xffF75D37),
              ),
            ),
            const SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: provinces.map((province) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedProvince = province['name'];
                        selectedPlaces = places
                            .where(
                                (place) => place['city_id'] == province['id'])
                            .toList();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              province['pictures'] != null &&
                                      province['pictures'].isNotEmpty
                                  ? province['pictures'][0]['path']
                                  : 'http://167.71.230.108/default-image.png',
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/default-image.png',
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            province['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)
                      ?.translate('Discover Must-Visit Places In ') ??
                  "Discover Must-Visit Places In ",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xffF75D37),
              ),
            ),
            Text(
              selectedProvince,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Wanderlust',
                color: Color(0xff55A5A4),
              ),
            ),
            const SizedBox(height: 20),
            selectedPlaces.isNotEmpty
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: selectedPlaces.map((place) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LocationPage(
                                    imagePath: place['pictures'] != null &&
                                            place['pictures'].isNotEmpty
                                        ? place['pictures'][0]['path']
                                        : 'http://167.71.230.108/default-image.png',
                                    placeId: place['id'],
                                  ),
                                ),
                              );
                            },
                            child: MyCardLocations(
                              placeName: place['name'],
                              provinceName: selectedProvince,
                              image: place['pictures'] != null &&
                                      place['pictures'].isNotEmpty
                                  ? place['pictures'][0]['path']
                                  : 'http://167.71.230.108/default-image.png',
                              placeNumber:
                                  '20', // Example value, update as needed
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No places available in $selectedProvince',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: textColor,
                        ),
                      ),
                      Center(
                        child: Lottie.asset(
                          'assets/images/animate.json',
                          fit: BoxFit.fill,
                          height: MediaQuery.of(context).size.height / 4,
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)?.translate('popular trips') ??
                  'Popular Trips',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xffF75D37),
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...trips.map((trip) {
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Trip selectedTrip = Trip(
                              name: trip['name'],
                              rating: 4.5, // Assuming a default rating
                              location: trip[
                                  'destination'], // Assuming a default location
                              price:
                                  double.tryParse(trip['price'].toString()) ??
                                      0.0,
                              description: trip['description'],
                              tripImage: trip['pictures'] != null &&
                                      trip['pictures'].isNotEmpty
                                  ? trip['pictures'][0]['path']
                                  : 'http://167.71.230.108/default-image.png',
                              startDate: trip['start_date'],
                              endDate: trip['end_date'],
                              categories:
                                  List<String>.from(trip['categories'] ?? []),
                              whatsIncluded: List<String>.from(
                                  trip['whats_included'] ?? []),
                              whatsNotIncluded: List<String>.from(
                                  trip['whats_not_included'] ?? []),
                              whatToBring: List<String>.from(
                                  trip['what_to_bring'] ?? []),
                              cancellationRefundPolicy: List<String>.from(
                                  trip['cancellation_refund_policy'] ?? []),
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripDescription(
                                  trip: selectedTrip,
                                ),
                              ),
                            );
                          },
                          child: MyCardDestination(
                            placeName: trip['name'],
                            image: trip['pictures'] != null &&
                                    trip['pictures'].isNotEmpty
                                ? trip['pictures'][0]['path']
                                : 'http://167.71.230.108/default-image.png',
                            price: trip['price'],
                          ),
                        ),
                        SizedBox(width: 10), // Add spacing between each card
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)?.translate('popular hotels') ??
                  'Popular Hotels',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xffF75D37),
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filteredHotels.map((hotel) {
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HotelDescription(
                                tripName: hotel.name,
                                tripDescription: hotel.description,
                                imageUrls: hotel.imageUrls,
                                rating: hotel.rating,
                                location: hotel.location,
                                price: hotel.price,
                                hotelId: hotel.id,
                                amenities: [], // Pass the hotel ID
                              ),
                            ),
                          );
                        },
                        child: CardHotels(
                          placeName: hotel.name,
                          image: hotel.imageUrls.isNotEmpty
                              ? hotel.imageUrls[0]
                              : 'http://167.71.230.108/default-image.png',
                          placeNumber: '20', // Example value, update as needed
                        ),
                      ),
                      SizedBox(width: 10), // Add spacing between each card
                    ],
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
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

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrls,
    required this.rating,
    required this.location,
    required this.price,
  });
}
