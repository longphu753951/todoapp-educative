import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/admob.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime initialDaySelected;
  final Function changeDay;
  const CalendarWidget({super.key, required this.initialDaySelected, required this.changeDay});


  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  DateTime firstDay = DateTime(2000, 1, 1);
  DateTime lastDay = DateTime(2100, 1, 1);

  InterstitialAd? _interstitialAd;
  final admob = AdMob();

  @override
  void initState() {
    super.initState();
    admob.createInterstitialAd();
    _focusedDay = widget.initialDaySelected;
  }

  @override
  void dispose() {
    _interstitialAd = admob.interstitialAd;
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: firstDay,
      lastDay: lastDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected:(selectedDay, focusDay) {
        admob.showInterstitialAd();
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusDay;
          widget.changeDay(_selectedDay);
        });
      }
    );
  }
}
