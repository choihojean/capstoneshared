import 'package:flutter/material.dart';
import 'button_style.dart';

class Memo extends StatefulWidget {
  final String title;

  const Memo({Key? key, required this.title}) : super(key: key);

  @override
  _MemoScreenState createState() => _MemoScreenState();
}

class _MemoScreenState extends State<Memo> {
  String memoText = ''; // 메모 텍스트

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextField(
                maxLines: null,
                onChanged: (text) {
                  setState(() {
                    memoText = text;
                  });
                },
                decoration: InputDecoration(
                  hintText: '메모를 입력하세요...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // 메모 저장 등의 작업을 수행할 수 있습니다.
                // 여기서는 간단히 메모를 출력합니다.
                print('메모 내용: $memoText');
              },
              style: MyButtonStyle.outlinedButtonStyle,
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}