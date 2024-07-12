import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatsHistoryPage extends StatefulWidget {
  final String accMail;
  const StatsHistoryPage({super.key, required this.accMail});

  @override
  State<StatsHistoryPage> createState() => _StatsHistoryState();
}

class _StatsHistoryState extends State<StatsHistoryPage> {
  final db = FirebaseFirestore.instance;
  List<FlSpot> bmiSpots = [];
  List<Card> statsCardList = [];
  QuerySnapshot? statsList;

  List<Color> gradientColors = [Colors.cyan, Colors.blue];

  getStats() async {
    QuerySnapshot recentStats = await db
        .collection('users/${widget.accMail}/dailyStats')
        .orderBy('timestamp', descending: true)
        .limit(7)
        .get();
    if (recentStats.size > 0) {
      double index = recentStats.size - 1;
      for (var stats in recentStats.docs) {
        double addedValue = stats['bmi'];
        if (addedValue > 40) {
          addedValue = 40;
        }
        addedValue = addedValue / 10;
        setState(() {
          bmiSpots.add(FlSpot(index, addedValue));
        });
        index -= 1;

        setState(() {
          statsList = recentStats;
          if (statsList != null && statsList!.size > 0) {
            statsCardList.add(Card(
              child: ListTile(
                title: Text('${stats['date']} - BMI ${stats['bmi']}',
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text(
                    'Cân nặng: ${stats['weight']}Kg  Chiều cao: ${(stats['height'])}Cm'),
              ),
            ));
          }
        });
      }
    }
  }

  void getNextStats() async {
    if (statsList != null && statsList!.size == 7) {
      final lastSnapshot = statsList!.docs[statsList!.size - 1];
      final next = await db
          .collection('users/${widget.accMail}/dailyStats')
          .orderBy('timestamp', descending: true)
          .startAfterDocument(lastSnapshot)
          .limit(7)
          .get();
      if (next.size > 0) {
        setState(() {
          statsList = next;
          statsCardList = [];
          for (var stats in next.docs) {
            statsCardList.add(Card(
              child: ListTile(
                title: Text(
                  '${stats['date']} - BMI ${stats['bmi']}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                    'Cân  nặng: ${stats['weight']}Kg  Chiều cao: ${stats['height']}Cm'),
              ),
            ));
          }
        });
      }
    }
  }

  void getPrevStats() async {
    if (statsList != null && statsList!.size > 0) {
      final firstSnapshot = statsList!.docs[0];
      final prev = await db
          .collection('users/${widget.accMail}/dailyStats')
          .orderBy('timestamp', descending: true)
          .endBeforeDocument(firstSnapshot)
          .limit(7)
          .get();
      if (prev.size > 0) {
        setState(() {
          statsList = prev;
          statsCardList = [];
          for (var stats in prev.docs) {
            statsCardList.add(Card(
              child: ListTile(
                title: Text('${stats['date']} - BMI ${stats['bmi']}',
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text(
                    'Cân nặng: ${stats['weight']}Kg Chiều cao: ${stats['height']}Cm'),
              ),
            ));
          }
        });
      }
    }
  }

  @override
  void initState() {
    getStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
          child: Image.asset(
        './assets/bg_img/bg1.jpg',
        fit: BoxFit.cover,
      )),
      Scaffold(
        appBar: AppBar(
          title: const Text('Lịch Sử Chỉ Số'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 200),
            child: Column(
              children: [
                const Center(
                    child: Text('BMI của 7 lần cập nhật gần nhất',
                        style: TextStyle(color: Colors.white70, fontSize: 20))),
                const SizedBox(height: 30),
                AspectRatio(aspectRatio: 1.7, child: LineChart(bmiChartData())),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton.filled(
                        onPressed: getPrevStats,
                        icon: const Icon(Icons.arrow_back)),
                    const Text('Lịch sử chỉ số',
                        style: TextStyle(color: Colors.white70, fontSize: 20)),
                    IconButton.filled(
                        onPressed: getNextStats,
                        icon: const Icon(Icons.arrow_forward_outlined))
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  children:
                      statsCardList.map((statsCard) => statsCard).toList(),
                )
              ],
            )),
      ),
    ]);
  }

  Widget bmiTiltle(double bmiValue, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blueGrey);
    String text;
    switch (bmiValue) {
      case 1:
        text = '10';
        break;
      case 2:
        text = '20';
        break;
      case 3:
        text = '30';
        break;
      case 4:
        text = '40';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData bmiChartData() {
    return LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Colors.blueGrey,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return const FlLine(
              color: Colors.blueGrey,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
                axisNameWidget: const Text(
                  'BMI',
                  style: TextStyle(color: Colors.blueGrey),
                ),
                sideTitles: SideTitles(
                    getTitlesWidget: bmiTiltle,
                    showTitles: true,
                    interval: 1,
                    reservedSize: 42))),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.blueGrey),
        ),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 5,
        lineBarsData: [
          LineChartBarData(
            spots: bmiSpots,
            isCurved: true,
            gradient: LinearGradient(colors: gradientColors),
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: const FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors
                    .map((color) => color.withOpacity(0.3))
                    .toList(),
              ),
            ),
          ),
        ]);
  }
}
