import 'package:flutter/material.dart';
import 'package:majan_road/trips/model/tripsModel.dart';
import 'package:majan_road/trips/tripsDescriptionPage.dart';

class TripCard extends StatefulWidget {
  final Trip trip;

  const TripCard({
    Key? key,
    required this.trip,
  }) : super(key: key);

  @override
  _TripCardState createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return SizedBox(
      width: MediaQuery.of(context).size.width - 10, // Adjusted for padding
      height: MediaQuery.of(context).size.height / 5,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TripDescription(
                trip: widget.trip,
              ),
            ),
          );
        },
        child: Card(
          color: cardColor,
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3.3,
                height: MediaQuery.of(context).size.height / 5,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  child: Image.network(
                    widget.trip.tripImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.trip.name,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                  color: textColor,
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
                                color: const Color(0xffF75D37),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.yellow),
                            SizedBox(width: 4),
                            Text(widget.trip.rating.toString(),
                                style: TextStyle(color: textColor)),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 70,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.trip.location,
                                style: TextStyle(color: textColor)),
                            const SizedBox(height: 5),
                            Text('\$${widget.trip.price}/Person',
                                style: TextStyle(color: textColor)),
                          ],
                        ),
                      ],
                    ),
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
