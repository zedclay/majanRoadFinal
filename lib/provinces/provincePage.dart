import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:majan_road/localization/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:majan_road/localization/local_notifier.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class LocationPage extends StatefulWidget {
  final int placeId;
  final String imagePath;

  const LocationPage({Key? key, required this.placeId, required this.imagePath})
      : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool isFavorite = false;
  List<String> imagePaths = [];
  List<String> videoPaths = [];
  String placeName = '';
  String description = '';
  String _translatedPlaceName = '';
  String _translatedDescription = '';
  double? latitude;
  double? longitude;
  bool isLoading = true;
  late PageController _pageController;
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    fetchPlaceData(widget.placeId);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> fetchPlaceData(int placeId) async {
    final dio = Dio();
    try {
      final response =
          await dio.get('http://167.71.230.108/api/places/$placeId');
      var data = response.data;

      List<String> images = (data['pictures'] as List)
          .map((picture) =>
              'http://167.71.230.108/storage' +
              picture['path'].replaceFirst('public/', '/'))
          .toList();

      List<String> videos = data['videos'] != null
          ? (data['videos'] as List)
              .map((video) =>
                  'http://167.71.230.108/storage' +
                  video['path'].replaceFirst('public/', '/'))
              .toList()
          : [];

      setState(() {
        placeName = data['name'];
        description = data['description'];
        latitude = double.tryParse(data['latitude']);
        longitude = double.tryParse(data['longitude']);
        imagePaths = images;
        videoPaths = videos;
        if (videos.isNotEmpty) {
          _initializeVideoPlayer(videos.first);
        }
        _initializeTranslations();
      });
    } catch (e) {
      print('Failed to load place data: $e');
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load place data');
    }
  }

  void _initializeVideoPlayer(String url) {
    _videoPlayerController = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController?.play();
      }).catchError((error) {
        print('Error initializing video player: $error');
      });
  }

  Future<void> _initializeTranslations() async {
    final localeNotifier = Provider.of<LocaleNotifier>(context, listen: false);
    final currentLocale = localeNotifier.locale.languageCode;

    if (currentLocale == 'ar') {
      _translatedPlaceName =
          await AppLocalizations.of(context)!.translateText(placeName, 'ar');
      _translatedDescription =
          await AppLocalizations.of(context)!.translateText(description, 'ar');
    } else {
      _translatedPlaceName = placeName;
      _translatedDescription = description;
    }

    setState(() {
      isLoading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(_translatedPlaceName.isEmpty
            ? 'Location Details'
            : _translatedPlaceName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: imagePaths.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imagePaths[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.3,
                  minChildSize: 0.3,
                  maxChildSize: 0.7,
                  builder: (context, scrollController) {
                    return Container(
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
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                _translatedPlaceName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _translatedDescription,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (_videoPlayerController != null &&
                                  _videoPlayerController!.value.isInitialized)
                                AspectRatio(
                                  aspectRatio:
                                      _videoPlayerController!.value.aspectRatio,
                                  child: VideoPlayer(_videoPlayerController!),
                                ),
                              const SizedBox(height: 20),
                              if (latitude != null && longitude != null)
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Card(
                                    elevation: 6,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        if (latitude != null &&
                                            longitude != null) {
                                          _openMap(latitude!, longitude!);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: Colors.orangeAccent,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.map,
                                                color: Colors.white),
                                            const SizedBox(width: 10),
                                            Text(
                                              'Open in Maps',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
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
                Positioned(
                  right: 20,
                  top: MediaQuery.of(context).padding.top + 10,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.8),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
