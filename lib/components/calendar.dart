import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'database_helper.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  TextEditingController _memoController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _memos = [];

  @override
  void initState() {
    super.initState();
    // _selectedDay가 null이 아닌 경우에만 메모 로드
    if (_selectedDay != null) {
      _loadMemos(_selectedDay!);
    }
  }

  @override
  void dispose() {
    _memoController.dispose(); // TextEditingController 해제
    super.dispose();
  }

  Future<void> _loadMemos(DateTime selectedDay) async {
    String formattedDate = selectedDay.toString().substring(0, 10);
    List<Map<String, dynamic>> memos = await _dbHelper.getMemos(formattedDate);
    setState(() {
      _memos = memos;
    });
  }

  Future<void> _saveMemo() async {
    if (_selectedDay != null) {
      String formattedDate = _selectedDay!.toString().substring(0, 10);
      await _dbHelper.insertMemo(formattedDate, _memoController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('메모가 저장되었습니다.')),
      );
      // 메모 저장 후 최신 메모 로드
      _loadMemos(_selectedDay!);
      _memoController.clear();
    }
  }

  Future<void> _deleteMemo(int id) async {
    await _dbHelper.deleteMemo(id);
    if (_selectedDay != null) {
      _loadMemos(_selectedDay!);
    }
  }

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
                  _loadMemos(selectedDay);
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
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _memoController,
                              decoration: InputDecoration(
                                hintText: '여기에 기록을 작성하세요',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: null,
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              await _saveMemo();
                            },
                            child: Text('완료'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        '운동 기록:',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      ..._memos.map((memo) {
                        return ListTile(
                          title: Text(memo['memo']),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await _deleteMemo(memo['id']);
                            },
                          ),
                        );
                      }).toList(),
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
