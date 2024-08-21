// import 'package:flutter/material.dart';
// import 'package:majan_road/hotels/UserBookingsPage.dart';
// import 'package:majan_road/localization/app_localization.dart';
// import 'package:majan_road/maps/map.dart';
// import 'package:majan_road/seconderyPage/CustomerSupportPage.dart';
// import 'package:majan_road/seconderyPage/ReportBugPage.dart';
// import 'package:majan_road/seconderyPage/prayerTimesPage.dart';
// import 'package:majan_road/settings/settingsPage.dart';
// import 'package:provider/provider.dart';
// import 'package:majan_road/widgets/themeNotiffier.dart';
// import 'package:majan_road/events/eventsPage.dart';
// import 'package:majan_road/hotels/booking_status_page.dart';

// class CustomDrawer extends StatelessWidget {
//   final Function(Locale) changeLanguage;
//   final Function(int) onPageSelected;

//   const CustomDrawer({
//     Key? key,
//     required this.changeLanguage,
//     required this.onPageSelected,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       // backgroundColor: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.only(top: 50.0),
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               child: Image.asset(
//                 'assets/images/majan.png',
//                 height: MediaQuery.of(context).size.height / 9,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             ListTile(
//               title: Row(
//                 children: [
//                   Icon(Icons.settings),
//                   SizedBox(width: 10),
//                   Text(AppLocalizations.of(context)?.translate('settings') ??
//                       'Settings'),
//                 ],
//               ),
//               onTap: () {
//                 Navigator.pop(context); // Close the drawer
//                 onPageSelected(3); // Index of SettingsPage in PageView
//               },
//             ),
//             const Divider(),
//             ListTile(
//               title: Row(
//                 children: [
//                   Icon(Icons.map),
//                   SizedBox(width: 10),
//                   Text(AppLocalizations.of(context)?.translate('maps') ??
//                       'Maps'),
//                 ],
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => MapScreen()),
//                 );
//               },
//             ),
//             const Divider(),
//             ListTile(
//               title: Row(
//                 children: [
//                   Icon(Icons.event),
//                   SizedBox(width: 10),
//                   Text(AppLocalizations.of(context)?.translate('events') ??
//                       'Events'),
//                 ],
//               ),
//               onTap: () {
//                 Navigator.pop(context); // Close the drawer
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => EventsPage()),
//                 );
//               },
//             ),
//             const Divider(),
//             ListTile(
//               title: Row(
//                 children: [
//                   Icon(Icons.person),
//                   SizedBox(width: 10),
//                   Text(AppLocalizations.of(context)?.translate('prayer') ??
//                       'Prayer'),
//                 ],
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const PrayerTime()),
//                 );
//               },
//             ),
//             const Divider(),
//             ListTile(
//               title: Row(
//                 children: [
//                   Icon(Icons.dashboard_customize_rounded),
//                   SizedBox(width: 10),
//                   Text(AppLocalizations.of(context)
//                           ?.translate('customer support') ??
//                       'Customer Support'),
//                 ],
//               ),
//               onTap: () {
//                 Navigator.pop(context); // Close the drawer
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const CustomerSupportPage()),
//                 );
//               },
//             ),
//             const Divider(),
//             ListTile(
//               title: Row(
//                 children: [
//                   Icon(Icons.bug_report),
//                   SizedBox(width: 10),
//                   Text(
//                       AppLocalizations.of(context)?.translate('report a bug') ??
//                           'Report a Bug'),
//                 ],
//               ),
//               onTap: () {
//                 Navigator.pop(context); // Close the drawer
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const ReportBugPage()),
//                 );
//               },
//             ),
//             const Divider(),
//             ListTile(
//               title: Row(
//                 children: [
//                   Icon(Icons.book_online),
//                   SizedBox(width: 10),
//                   Text(AppLocalizations.of(context)
//                           ?.translate('Booking_Status') ??
//                       'Booking Status'),
//                 ],
//               ),
//               onTap: () {
//                 Navigator.pop(context); // Close the drawer
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) =>
//                           UserBookingsPage()), // Navigate to the new page
//                 );
//               },
//             ),
//             const Divider(),
//             ListTile(
//               title: Row(
//                 children: [
//                   Icon(Icons.dark_mode),
//                   SizedBox(width: 10),
//                   Text(AppLocalizations.of(context)?.translate('dark mode') ??
//                       'Dark Mode'),
//                 ],
//               ),
//               onTap: () {
//                 context.read<ThemeNotifier>().toggleTheme();
//               },
//             ),
//             const Divider(),
//             ListTile(
//               title: Row(
//                 children: [
//                   Icon(Icons.language),
//                   SizedBox(width: 10),
//                   Text(AppLocalizations.of(context)?.translate('language') ??
//                       'Language'),
//                 ],
//               ),
//               onTap: () {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: Text(
//                           AppLocalizations.of(context)?.translate('language') ??
//                               'Language'),
//                       content: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           ListTile(
//                             title: Text('English'),
//                             onTap: () {
//                               changeLanguage(Locale('en'));
//                               Navigator.of(context).pop();
//                             },
//                           ),
//                           ListTile(
//                             title: Text('عربي'),
//                             onTap: () {
//                               changeLanguage(Locale('ar'));
//                               Navigator.of(context).pop();
//                             },
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:majan_road/localization/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:majan_road/widgets/themeNotiffier.dart';
import 'package:majan_road/maps/map.dart';
import 'package:majan_road/events/eventsPage.dart';
import 'package:majan_road/seconderyPage/CustomerSupportPage.dart';
import 'package:majan_road/seconderyPage/ReportBugPage.dart';
import 'package:majan_road/seconderyPage/prayerTimesPage.dart';
import 'package:majan_road/settings/settingsPage.dart';
import 'package:majan_road/hotels/booking_status_page.dart';
import 'package:majan_road/hotels/UserBookingsPage.dart';

class CustomDrawer extends StatelessWidget {
  final Function(Locale) changeLanguage;
  final Function(int) onPageSelected;

  const CustomDrawer({
    Key? key,
    required this.changeLanguage,
    required this.onPageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/majan.png',
                height: MediaQuery.of(context).size.height / 9,
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.settings),
                  SizedBox(width: 10),
                  Text(AppLocalizations.of(context)?.translate('settings') ??
                      'Settings'),
                ],
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                onPageSelected(3); // Index of SettingsPage in PageView
              },
            ),
            const Divider(),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.map),
                  SizedBox(width: 10),
                  Text(AppLocalizations.of(context)?.translate('maps') ??
                      'Maps'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.event),
                  SizedBox(width: 10),
                  Text(AppLocalizations.of(context)?.translate('events') ??
                      'Events'),
                ],
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventsPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Text(AppLocalizations.of(context)?.translate('prayer') ??
                      'Prayer'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrayerTime()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.dashboard_customize_rounded),
                  SizedBox(width: 10),
                  Text(AppLocalizations.of(context)
                          ?.translate('customer support') ??
                      'Customer Support'),
                ],
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CustomerSupportPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.bug_report),
                  SizedBox(width: 10),
                  Text(
                      AppLocalizations.of(context)?.translate('report a bug') ??
                          'Report a Bug'),
                ],
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ReportBugPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.book_online),
                  SizedBox(width: 10),
                  Text(AppLocalizations.of(context)
                          ?.translate('Booking_Status') ??
                      'Booking Status'),
                ],
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserBookingsPage(
                      toggleDarkMode: context.read<ThemeNotifier>().toggleTheme,
                      changeLanguage: changeLanguage,
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.dark_mode),
                  SizedBox(width: 10),
                  Text(AppLocalizations.of(context)?.translate('dark mode') ??
                      'Dark Mode'),
                ],
              ),
              onTap: () {
                context.read<ThemeNotifier>().toggleTheme();
              },
            ),
            const Divider(),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.language),
                  SizedBox(width: 10),
                  Text(AppLocalizations.of(context)?.translate('language') ??
                      'Language'),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                          AppLocalizations.of(context)?.translate('language') ??
                              'Language'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text('English'),
                            onTap: () {
                              changeLanguage(Locale('en'));
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Text('عربي'),
                            onTap: () {
                              changeLanguage(Locale('ar'));
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
