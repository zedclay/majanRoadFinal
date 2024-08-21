import 'package:flutter/material.dart';

class MyCardDestination extends StatelessWidget {
  final String image;
  final String placeName;
  final String price;

  const MyCardDestination({
    Key? key,
    required this.image,
    required this.placeName,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      width: MediaQuery.of(context).size.width / 2.3,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3), // Shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(
                    0,
                    3,
                  ), // Shadow offset
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  placeName.length <= 17
                      ? placeName
                      : placeName.substring(0, 10) + '...',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Color(0xff55A5A4),
                    ),
                    Text(
                      'From $price',
                      style: TextStyle(
                        color: Color(0xff55A5A4),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
