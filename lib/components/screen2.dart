import 'package:flutter/material.dart';
import 'memo.dart';

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          _buildListItem(
            context,
            image: 'assets/pullup.png',
            title: '풀 업',
            subtitle: '풀업(턱걸이)',
          ),
          _buildListItem(
            context,
            image: 'assets/latpulldown.png',
            title: '렛 풀다운',
            subtitle: '등',
          ),
          _buildListItem(
            context,
            image: 'assets/seatedrow.png',
            title: '시티드 케이블 로우',
            subtitle: '등',
          ),
          _buildListItem(
            context,
            image: 'assets/seatedrow.png',
            title: 'Item 4',
            subtitle: 'Test subtitle',
          ),
          _buildListItem(
            context,
            image: 'assets/seatedrow.png',
            title: 'Item 5',
            subtitle: 'Test subtitle',
          ),
          _buildListItem(
            context,
            image: 'assets/seatedrow.png',
            title: 'Item 6',
            subtitle: 'Test subtitle',
          ),
          _buildListItem(
            context,
            image: 'assets/seatedrow.png',
            title: 'Item 7',
            subtitle: 'Test subtitle',
          ),
          // 추가적인 리스트 아이템들을 필요에 따라 추가할 수 있습니다.
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, {required String image, required String title, required String subtitle}) {
    return ListTile(
      leading: Image.asset(image),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {
        // 해당 목록을 클릭하면 Memo 페이지로 이동합니다.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Memo(title: title),
          ),
        );
      },
    );
  }
}