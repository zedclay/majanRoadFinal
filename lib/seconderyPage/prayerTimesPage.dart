import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:majan_road/localization/app_localization.dart';

class PrayerTime extends StatefulWidget {
  const PrayerTime({Key? key}) : super(key: key);

  @override
  State<PrayerTime> createState() => _PrayerTimeState();
}

class _PrayerTimeState extends State<PrayerTime> {
  Map<String, String> prayerTimes = {};
  bool isLoading = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes();
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
      if (mounted) {
        fetchPrayerTimes();
      } else {
        _timer
            .cancel(); // Cancel the timer explicitly if the widget is disposed
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> fetchPrayerTimes() async {
    setState(() {
      isLoading = true;
    });

    final Uri uri = Uri.parse(
        'http://api.aladhan.com/v1/timingsByCity?city=dhofar&country=Oman&method=4');
    final response = await http.get(uri);
    print('API Response: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final timings = data['data']['timings'];
      if (mounted) {
        setState(() {
          prayerTimes = {
            'Fajr': timings['Fajr'],
            'Sunrise': timings['Sunrise'],
            'Dhuhr': timings['Dhuhr'],
            'Asr': timings['Asr'],
            'Maghrib': timings['Maghrib'],
            'Isha': timings['Isha'],
          };
          isLoading = false;
        });
      }
    } else {
      throw Exception('Failed to load prayer times');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context)?.translate('Prayer Times in Dhofar') ??
              'Prayer Times in Dhofar',
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff55A5A4),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: const Color(0xff55A5A4),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      AppLocalizations.of(context)?.translate(
                              'Prayer times for Dhofar city, Oman') ??
                          'Prayer times for Dhofar city, Oman',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xff55A5A4),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: prayerTimes.length,
                    itemBuilder: (BuildContext context, int index) {
                      String key = prayerTimes.keys.elementAt(index);
                      String value = prayerTimes[key]!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Card(
                          color: const Color(0xffF75D37),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.access_time,
                              color: Colors.white,
                            ),
                            title: Text(
                              AppLocalizations.of(context)?.translate(key) ??
                                  key,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            trailing: Text(
                              value,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      'assets/images/muslim.png', // Replace with a valid image URL
                      height: MediaQuery.of(context).size.height / 2.4,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
