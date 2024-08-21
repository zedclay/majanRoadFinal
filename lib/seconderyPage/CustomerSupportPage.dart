import 'package:flutter/material.dart';
import 'package:majan_road/localization/app_localization.dart';

class CustomerSupportPage extends StatelessWidget {
  const CustomerSupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xffF75D37),
        title: Text(
            style: TextStyle(color: Colors.white),
            AppLocalizations.of(context)?.translate('customer support') ??
                'Customer Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)?.translate('customer support') ??
                  'Customer Support',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff55A5A4)),
            ),
            SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)?.translate('support_description') ??
                  'For any assistance, please contact us at majanroad.om@gmail.com or call us at +96893337706.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Add your email support logic here
              },
              icon: Icon(Icons.email),
              label: Text(
                  AppLocalizations.of(context)?.translate('email_support') ??
                      'Email Support'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff55A5A4),
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                // Add your phone support logic here
              },
              icon: Icon(Icons.phone),
              label: Text(
                  AppLocalizations.of(context)?.translate('call_support') ??
                      'Call Support'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff55A5A4),
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)?.translate('faq') ??
                  'Frequently Asked Questions',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffF75D37)),
            ),
            SizedBox(height: 10),
            ExpansionTile(
              title: Text(
                  AppLocalizations.of(context)?.translate('faq1_question') ??
                      'How can I reset my password?'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppLocalizations.of(context)
                          ?.translate('faq1_answer') ??
                      'To reset your password, go to the login page and click on "Forgot Password". Follow the instructions to reset your password.'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                  AppLocalizations.of(context)?.translate('faq2_question') ??
                      'How can I contact support?'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppLocalizations.of(context)
                          ?.translate('faq2_answer') ??
                      'You can contact support via email at majanroad.om@gmail.com or call us at +96893337706.'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
