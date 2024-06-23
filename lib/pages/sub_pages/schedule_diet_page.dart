import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../components/tip_list.dart';
import '../../utils/services/noti_service.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class ScheduleDietPage extends StatefulWidget {
  final String accMail;
  const ScheduleDietPage({super.key, required this.accMail});

  @override
  State<ScheduleDietPage> createState() => _ScheduleDietState();
}

class _ScheduleDietState extends State<ScheduleDietPage> {
  final db = FirebaseFirestore.instance;

  void _activityDialog(
      {int? actiId, String? actiDes, DateTime? actiTime, bool? actiAlarm}) {
    final actiController = TextEditingController(text: actiDes);
    DateTime? time = actiTime;
    bool alarm = actiAlarm ?? false;
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (BuildContext context, setState) => Dialog(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(Icons.close)),
                            const Text(
                              'Add Activity',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            TextButton(
                                onPressed: () {
                                  if (alarm && time != null) {
                                    NotificationService().scheduleNotification(
                                        id: UniqueKey().hashCode,
                                        scheduledDate: time!,
                                        body: actiController.text,
                                        title:
                                            'It\'s time to do your activity');
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(Icons.check))
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                            minLines: 2,
                            maxLines: 2,
                            controller: actiController,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: actiDes != null
                                    ? 'Description'
                                    : 'New Activity',
                                hintStyle:
                                    const TextStyle(color: Colors.black45))),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Time',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            TextButton(
                                onPressed: () async {
                                  await picker.DatePicker.showDateTimePicker(
                                      context,
                                      minTime: DateTime.now(),
                                      onChanged: (pickedTime) => {
                                            setState(() {
                                              time = pickedTime;
                                            })
                                          });
                                },
                                child: Text(time != null
                                    ? time.toString()
                                    : 'Select time')),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Notification',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Switch(
                                inactiveThumbColor: Colors.cyan,
                                activeTrackColor: Colors.cyan,
                                value: alarm,
                                onChanged: (bool isAlarm) {
                                  setState(() {
                                    alarm = isAlarm;
                                  });
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                )));
  }

  @override
  void initState() {
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
      DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Schedule & diet'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(
                    text: 'Schedule',
                    icon: Icon(Icons.calendar_today),
                  ),
                  Tab(
                    text: 'Diet note',
                    icon: Icon(Icons.fastfood_outlined),
                  ),
                  Tab(
                    text: 'Tips',
                    icon: Icon(Icons.lightbulb),
                  ),
                ],
                labelColor: Colors.cyan,
                unselectedLabelColor: Colors.grey,
              ),
            ),
            backgroundColor: Colors.transparent,
            body: TabBarView(
              children: <Widget>[
                Column(
                  children: [
                    scheduleTab(),
                  ],
                ),
                const Icon(Icons.directions_transit),
                tipsTab()
              ],
            )),
      ),
    ]);
  }

  Widget scheduleTab() {
    return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _activityDialog();
                },
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10)),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ));
  }

  Widget dietTab() {
    return const SingleChildScrollView();
  }

  Widget tipsTab() {
    return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: const TipList())
            ]));
  }
}
