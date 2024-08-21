import 'dart:async';
import 'package:flutter/material.dart';

class ImageCarouselInter extends StatefulWidget {
  final List<String> imageUrls;

  ImageCarouselInter({required this.imageUrls});

  @override
  _ImageCarouselInterState createState() => _ImageCarouselInterState();
}

class _ImageCarouselInterState extends State<ImageCarouselInter> {
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
            child: Image.network(widget.imageUrls[index], fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
