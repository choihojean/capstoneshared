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
            title: 'Item 1',
            subtitle: 'Test subtitle',
          ),
          _buildListItem(
            context,
            image: 'assets/latpulldown.png',
            title: 'Item 2',
            subtitle: 'Test subtitle',
          ),
          _buildListItem(
            context,
            image: 'assets/seatedrow.png',
            title: 'Item 3',
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