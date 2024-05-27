import 'package:flutter/material.dart';
import 'button_style.dart';

class Bmi extends StatefulWidget {
  @override
  _BmiState createState() => _BmiState();
}

class _BmiState extends State<Bmi> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  String bmiResult = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI 계산기'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: '키 (cm)'),
            ),
            TextFormField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: '몸무게 (kg)'),
            ),
            SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                double height = double.tryParse(heightController.text) ?? 0.0;
                double weight = double.tryParse(weightController.text) ?? 0.0;
                if (weight > 0 && height > 0) {
                  double bmi = weight / ((height / 100) * (height / 100));
                  setState(() {
                    bmiResult = 'BMI 수치: ${bmi.toStringAsFixed(1)} - ${_getBmiMessage(bmi)}';
                  });
                }
              },
              style: MyButtonStyle.outlinedButtonStyle,
              child: Text('확인'),
            ),
            
            SizedBox(height: 20),
            Text(
              bmiResult,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  String _getBmiMessage(double bmi) {
    if (bmi <= 18.5) {
      return '저체중 입니다';
    } else if (bmi >= 18.5 && bmi <= 22.9) {
      return '정상체중 입니다';
    } else if (bmi >= 23.0 && bmi <= 24.9) {
      return '과체중 입니다';
    } else {
      return '비만 입니다';
    }
  }
}