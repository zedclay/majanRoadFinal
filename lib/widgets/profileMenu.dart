import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Color.fromARGB(255, 57, 111, 110),
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xff55A5A4).withOpacity(0.5),
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              // ignorer: deprecated_member_use

              width: 22,
              color: Colors.white,
            ),
            const SizedBox(width: 20),
            Expanded(
                child: Text(
              text,
              style: TextStyle(
                overflow:
                    TextOverflow.ellipsis, // ignorer: deprecated_member_use
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
