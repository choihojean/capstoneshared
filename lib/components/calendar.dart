import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;

  // 날짜별 메모를 저장하는 맵
  Map<DateTime, String> _memos = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 기록'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              TableCalendar(
                locale: 'ko_KR', // 한글로 변경
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2024, 12, 31),
                focusedDay: DateTime.now(),
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  // 선택된 날짜와 동일한 경우에만 true를 반환하여 원을 그립니다.
                  return isSameDay(_selectedDay, day);
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                  });
                },
              ),
              SizedBox(height: 20),
              if (_selectedDay != null) ...[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '선택한 날짜: ${_selectedDay!.toString().substring(0, 10)}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          // 메모 입력이 변경될 때마다 맵에 저장
                          setState(() {
                            _memos[_selectedDay!] = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: '여기에 기록을 작성하세요',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null,
                      ),
                      SizedBox(height: 20),
                      Text(
                        '운동 기록:',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _memos[_selectedDay] ?? '기록 없음',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
