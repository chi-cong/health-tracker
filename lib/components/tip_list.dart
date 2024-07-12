import 'package:flutter/material.dart';

class TipList extends StatelessWidget {
  TipList({super.key});

  final List<Map<String, String>> tipList = [
    {
      'title': 'BMI là gì ?',
      'content':
          'BMI là chỉ số đo lường mức độ béo phì. BMI được tính theo công thức (cân nặng)/(chiều cao^2)'
    },
    {
      'title': 'Làm sao BMI đánh giá thể trạng một người ?',
      'content':
          'Thông thường một người cân đối có chỉ số BMI từ 18.5 tới 24.9, từ 18.5 tới 24.9 với người Châu Á. \nVượt quá khoảng này được xếp vào thừa cân hoặc béo phì. Dưới khoảng này được xếp vào nhóm gầy'
    },
    {
      'title': 'Tôi nên sắp xếp hoạt động thể dục thế nào ?',
      'content':
          'Hãy thực hiện hoạt động vừa sức với thể chất của bạn, không nên quá gắng sức. Các hoạt động nên có quãng nghỉ phù hợp và đừng quên bổ sung các chất cần thiết cho bữa ăn'
    }
  ];

  List<ExpansionTile> makeList() {
    List<ExpansionTile> tipListWidget = [];
    for (int i = 0; i < tipList.length; i++) {
      tipListWidget.add(ExpansionTile(
          title: Text(
            tipList[i]['title']!,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          ),
          children: [Text(tipList[i]['content']!)]));
    }
    return tipListWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: makeList(),
    );
  }
}
