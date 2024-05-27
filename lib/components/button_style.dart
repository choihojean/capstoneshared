import 'package:flutter/material.dart';

class MyButtonStyle {
  static final ButtonStyle outlinedButtonStyle = ButtonStyle(
    side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.blue)), // 테두리 색상 지정
    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 255, 255)), // 버튼의 배경색을 흰색으로 변경
    foregroundColor: MaterialStateProperty.all<Color>(Colors.blue), // 버튼 텍스트의 색상을 파란색으로 변경
    textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 16)), // 버튼 텍스트의 크기를 변경
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(15)), // 버튼의 패딩 설정
    shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // 버튼의 모서리를 둥글게 변경
      ),
    ),
  );
}