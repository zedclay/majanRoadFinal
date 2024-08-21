import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationMenu extends StatelessWidget {
  const NotificationMenu({
    Key? key,
    required this.text,
    required this.icon,
    required this.isActive, // Add isActive parameter to determine notification state
    this.press,
  }) : super(key: key);

  final String text, icon;
  final bool isActive; // Indicates whether notification is active or not
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Color.fromARGB(255, 57, 111, 110),
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: isActive
              ? const Color(0xff55A5A4).withOpacity(0.5)
              : Colors.grey.withOpacity(0.5),
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 22,
              color: Colors.white,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              isActive
                  ? Icons.notifications_active
                  : Icons
                      .notifications_off, // Choose appropriate icon based on isActive state
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
