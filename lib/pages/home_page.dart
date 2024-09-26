import 'package:flutter/material.dart';
import 'package:health_tracker/utils/bmi_calculator.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/authentication.dart';
import '../components/custom_snackbar.dart';
import 'login_page.dart';
import './sub_pages/daily_stats_page.dart';
import './sub_pages/my_info_page.dart';
import './sub_pages/stats_history_page.dart';
import 'sub_pages/ask_ai_page.dart';
import './sub_pages/schedule_diet_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  final String accMail;

  const HomePage({super.key, required this.accMail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Authentication _authentication = Authentication();
  final db = FirebaseFirestore.instance;
  final message = CustomSnackbar();
  String bmi = '...';
  String greetingName = "";
  String? bodyType;

  getLatestStats() async {
    QuerySnapshot latestDailyStats = await db
        .collection('users/${widget.accMail}/dailyStats')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    final latestData = latestDailyStats.docs.first;
    if (latestDailyStats.size > 0 && latestData.exists) {
      setState(() {
        bmi = latestData.get('bmi').toString();
      });
    }
  }

  getUserInfoName() async {
    var userDocSnapshot = await db.doc('users/${widget.accMail}').get();
    if (userDocSnapshot.exists) {
      Map<String, dynamic>? userData = userDocSnapshot.data();
      setState(() {
        if (userData != null && userData['name'] != null) {
          greetingName = userData['name'];
        } else {
          greetingName = widget.accMail;
        }
        if (userData != null && userData['name'] != null) {
          bodyType = userData['bodyType'];
        }
      });
    }
  }

  @override
  void initState() {
    getLatestStats();
    getUserInfoName();
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
          drawer: Drawer(
              child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                ),
                child: Text(
                  'Chúc bạn một ngày tốt lành !\n $greetingName',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.person_outline,
                  color: Colors.indigo,
                ),
                title: const Text('Thông tin của tôi'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyInfoPage(
                                accMail: widget.accMail,
                                updateInfo: getUserInfoName,
                              )));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout_outlined,
                  color: Colors.indigo,
                ),
                title: const Text('Đăng xuất'),
                onTap: () {
                  context.loaderOverlay.show();
                  try {
                    _authentication.logout();
                    GoogleSignIn().signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  } catch (e) {
                    message.error('there was an error', context);
                  }
                  context.loaderOverlay.hide();
                },
              )
            ],
          )),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
          floatingActionButton: Builder(
              builder: (context) => FloatingActionButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(
                      Icons.menu,
                      color: Colors.indigo,
                    ),
                  )),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(40, 90, 40, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Xin chào',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    greetingName,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  height: 50,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text('BMI: $bmi'),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                        child: Text(
                            'Phân loại: ${bmi != '...' ? BmiCalculator().getClassification(double.parse(bmi), bodyType) : bmi}'),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DailyStatsPage(
                          accMail: widget.accMail,
                          bodyType: bodyType,
                        ),
                      ),
                    )
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    height: 65,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Icon(
                            Icons.task_outlined,
                            size: 40,
                            color: Colors.indigo,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                          child: Text(
                            'Cập nhật BMI ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                StatsHistoryPage(accMail: widget.accMail)))
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    height: 65,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Icon(
                            Icons.bar_chart_outlined,
                            size: 40,
                            color: Colors.indigo,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                          child: Text(
                            'Lịch sử chỉ số',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScheduleDietPage(
                                  accMail: widget.accMail,
                                )))
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    height: 65,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Icon(
                            Icons.schedule_outlined,
                            size: 40,
                            color: Colors.indigo,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                          child: Text(
                            'Lịch trình & chế độ ăn',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AskAiPage(
                                  accMail: widget.accMail,
                                )))
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    height: 65,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Icon(
                            Icons.question_answer_outlined,
                            size: 40,
                            color: Colors.indigo,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                          child: Text(
                            'Hỏi đáp với AI',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    ]);
  }
}
