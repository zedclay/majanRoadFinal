import 'package:flutter/material.dart';

class SearchBare extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchBare({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xff55A5A4).withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: "Search...",
          iconColor: Colors.white,
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
          ),
        ),
      ),
    );
  }
}
