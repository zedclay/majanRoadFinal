import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:majan_road/widgets/themeNotiffier.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  CustomAppBar({
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    return AppBar(
      backgroundColor: backgroundColor,
      shadowColor: Colors.green.shade200.withOpacity(0.3),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: iconColor,
          size: 30,
        ),
        onPressed: () {
          scaffoldKey.currentState!.openDrawer();
        },
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.dark_mode,
            color: iconColor,
          ),
          onPressed: () {
            themeNotifier.toggleTheme();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
