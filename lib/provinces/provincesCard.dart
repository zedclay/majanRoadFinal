import 'package:flutter/material.dart';

class MyCardLocations extends StatelessWidget {
  final String image;
  final String placeName;
  final String provinceName;
  final String placeNumber;

  const MyCardLocations({
    Key? key,
    required this.image,
    required this.placeName,
    required this.provinceName,
    required this.placeNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final cardBackgroundColor =
        isDarkMode ? Colors.black.withOpacity(0.7) : Colors.white;
    final gradientColors = isDarkMode
        ? [Colors.black.withOpacity(0.7), Colors.black.withOpacity(0.15)]
        : [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.08)];

    return Container(
      width: 300,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  image,
                  fit: BoxFit.cover,
                );
              },
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: gradientColors,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                color: cardBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            '$provinceName | $placeName',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      placeName,
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        // Add your onPressed code here!
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        minimumSize: Size(60, 20),
                        padding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: const Text(
                        'See More',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
