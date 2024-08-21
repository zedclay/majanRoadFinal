import 'package:flutter/material.dart';

class CardHotels extends StatelessWidget {
  final String image;
  final String placeName;
  final String placeNumber;

  const CardHotels({
    Key? key,
    required this.image,
    required this.placeName,
    required this.placeNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      width: 250,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              image, // Replace with your image path
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.15),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      placeName.length <= 17
                          ? placeName
                          : placeName.substring(0, 17) + '...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          '$placeNumber places',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 20,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 20,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 20,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 20,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 20,
                            ),
                          ],
                        )
                      ],
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
