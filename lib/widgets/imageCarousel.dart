// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';

// class ImageCarousel extends StatelessWidget {
//   final List<String> imageUrls;

//   ImageCarousel({required this.imageUrls});

//   @override
//   Widget build(BuildContext context) {
//     return CarouselSlider(
//       options: CarouselOptions(
//         autoPlay: true,
//         enlargeCenterPage: true,
//         aspectRatio: 2.0,
//         viewportFraction: 1.0,
//       ),
//       items: imageUrls.map((imageUrl) {
//         return Builder(
//           builder: (BuildContext context) {
//             return Container(
//               width: MediaQuery.of(context).size.width,
//               margin: EdgeInsets.symmetric(horizontal: 5.0),
//               child: Image.asset(imageUrl, fit: BoxFit.cover),
//             );
//           },
//         );
//       }).toList(),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;

  ImageCarousel({required this.imageUrls});

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_currentPage < widget.imageUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 4,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            child: Image.asset(widget.imageUrls[index], fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
