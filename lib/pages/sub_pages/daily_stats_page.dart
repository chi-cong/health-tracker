import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../utils/bmi_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyStatsPage extends StatefulWidget {
  final String accMail;
  final String? bodyType;
  const DailyStatsPage({super.key, required this.accMail, this.bodyType});

  @override
  State<DailyStatsPage> createState() => _DailyStatsPageState();
}

class _DailyStatsPageState extends State<DailyStatsPage> {
  final today = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final _dailyKey = GlobalKey<FormState>();
  final bmiCal = BmiCalculator();
  final db = FirebaseFirestore.instance;
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  void _showBmiDialog(double bmi) {
    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        'Chỉ số BMI của bạn là $bmi, Bạn thuộc nhóm ${bmiCal.getClassification(bmi, widget.bodyType)}. Để biết thêm thông tin, hãy vào mục "Lịch trình & chế độ ăn" '),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            ));
  }

  getLatestStats() async {
    QuerySnapshot latestDailyStats = await db
        .collection('users/${widget.accMail}/dailyStats')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    final latestData = latestDailyStats.docs.first;
    if (latestDailyStats.size > 0 && latestData.exists) {
      weightController.text = latestData.get('weight');
      heightController.text = latestData.get('height');
    }
  }

  @override
  void initState() {
    getLatestStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (Stack(children: [
      Positioned.fill(
          child: Image.asset(
        './assets/bg_img/bg1.jpg',
        fit: BoxFit.cover,
      )),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Cập nhật BMI trong ngày'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          body: SingleChildScrollView(
              physics: const ClampingScrollPhysics(
                  parent: NeverScrollableScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(50, 70, 50, 0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hôm nay là $today',
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
                      width: double.infinity,
                      height: 470,
                      decoration: const BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Form(
                          key: _dailyKey,
                          child: SizedBox(
                            width: 200,
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    TextFormField(
                                        controller: weightController,
                                        decoration: const InputDecoration(
                                            prefixIcon:
                                                Icon(Icons.scale_outlined),
                                            border: UnderlineInputBorder(),
                                            labelText: 'Cân nặng (Kg)'),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        validator: (value) {
                                          if (value != null && value.isEmpty) {
                                            return 'Đây là thông tin bắt buộc';
                                          }
                                          return null;
                                        }),
                                    const SizedBox(
                                      height: 70,
                                    ),
                                    TextFormField(
                                        controller: heightController,
                                        decoration: const InputDecoration(
                                            prefixIcon:
                                                Icon(Icons.height_outlined),
                                            border: UnderlineInputBorder(),
                                            labelText: 'Chiều cao (Cm)'),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value != null && value.isEmpty) {
                                            return 'Đây là thông tin bắt buộc';
                                          }
                                          return null;
                                        }),
                                    const SizedBox(
                                      height: 70,
                                    ),
                                    FilledButton(
                                        onPressed: () async {
                                          final bmi = bmiCal.getBmi(
                                              double.parse(
                                                  heightController.text),
                                              double.parse(
                                                  weightController.text));

                                          if (_dailyKey.currentState!
                                              .validate()) {
                                            db
                                                .doc(
                                                    'users/${widget.accMail}/dailyStats/$today')
                                                .set({
                                              'date': today,
                                              'timestamp': DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              'bmi': bmi,
                                              'weight': weightController.text,
                                              'height': heightController.text
                                            });
                                            _showBmiDialog(bmi);
                                          }
                                        },
                                        child:
                                            const Text('Nhận kết quả hôm nay'))
                                  ],
                                ),
                              ],
                            ),
                          )),
                    )
                  ])))
    ]));
  }
}
