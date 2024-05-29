import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'database_helper.dart'; // DatabaseHelper import

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  TextEditingController _memoController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    // _selectedDay가 null이 아닌 경우에만 메모 로드
    if (_selectedDay != null) {
      _loadMemo(_selectedDay!);
    }
  }

  @override
  void dispose() {
    _memoController.dispose(); // TextEditingController 해제
    super.dispose();
  }

  Future<void> _loadMemo(DateTime selectedDay) async {
    String formattedDate = selectedDay.toString().substring(0, 10);
    String? memo = await _dbHelper.getMemo(formattedDate);
    setState(() {
      _memoController.text = memo ?? '';
    });
  }

  Future<void> _saveMemo() async {
    if (_selectedDay != null) {
      String formattedDate = _selectedDay!.toString().substring(0, 10);
      String? existingMemo = await _dbHelper.getMemo(formattedDate);
      if (existingMemo != null) {
        await _dbHelper.updateMemo(formattedDate, _memoController.text);
      } else {
        await _dbHelper.insertMemo(formattedDate, _memoController.text);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('메모가 저장되었습니다.')),
      );
      // 메모 저장 후 최신 메모 로드
      _loadMemo(_selectedDay!);
    }
  }

  void _openMemoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('메모 작성'),
          content: TextField(
            controller: _memoController,
            decoration: InputDecoration(
              hintText: '여기에 기록을 작성하세요',
            ),
            maxLines: null,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _saveMemo();
                Navigator.of(context).pop();
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
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
                  _loadMemo(selectedDay);
                },
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    return Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      margin: const EdgeInsets.all(6.0),
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                  todayBuilder: (context, day, focusedDay) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange,
                      ),
                      margin: const EdgeInsets.all(6.0),
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              if (_selectedDay != null) ...[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${_selectedDay!.toString().substring(0, 10)}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '운동 기록',
                                  style: TextStyle(fontSize: 18),
                                ),
                                ElevatedButton(
                                  onPressed: _openMemoDialog,
                                  child: Text('기록 작성'),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              _memoController.text.isNotEmpty
                                  ? _memoController.text
                                  : '기록 없음',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '운동 계획',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // 기능 미구현
                        },
                        child: Text('운동 선택하기'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
