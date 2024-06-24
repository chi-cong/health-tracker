import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../components/tip_list.dart';
import '../../utils/services/noti_service.dart';
import '../../components/activity_card.dart';
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
  List<ActivityCard> activityList = [];

  /// *********** Schedule Section ********** */
  void addActivity(int id, String? desc, DateTime? time, bool alarm) {
    setState(() {
      activityList.insert(
          0,
          ActivityCard(
            id: id,
            description: desc ?? "",
            date: time != null ? time.toString() : "",
            editCallback: () => {
              _activityDialog(
                actiId: id,
                actiAlarm: alarm,
                actiDes: desc,
              )
            },
            deleteCallback: () => {deleteActivity(id)},
          ));
    });
  }

  void updateActivity(int id, String? desc, DateTime? time, bool alarm) {
    int updatedCardIndex = activityList.indexWhere((acti) => acti.id == id);
    if (updatedCardIndex != -1) {
      List<ActivityCard> temp = activityList;
      temp[updatedCardIndex] = ActivityCard(
          id: id,
          description: desc,
          date: time != null ? time.toString() : "",
          editCallback: () => {
                _activityDialog(
                  actiId: id,
                  actiAlarm: alarm,
                  actiDes: desc,
                )
              },
          deleteCallback: () => {deleteActivity(id)});
      setState(() {
        activityList = temp;
      });
    }
  }

  void deleteActivity(int id) async {
    await db
        .doc('users/${widget.accMail}/activities/$id')
        .delete()
        .catchError((e) => {});
    setState(() {
      activityList.removeWhere((acti) => acti.id == id);
    });
  }

  void getActivities() async {
    final List<ActivityCard> tempList = [];
    QuerySnapshot activities =
        await db.collection('users/${widget.accMail}/activities').get();
    if (activities.size > 0) {
      for (var activity in activities.docs) {
        tempList.add(ActivityCard(
            id: activity['id'],
            description: activity['description'] ?? "",
            date: activity['time'] ?? '',
            editCallback: () => {
                  _activityDialog(
                    actiId: activity['id'],
                    actiAlarm: activity['alarm'],
                    actiDes: activity['description'],
                  )
                },
            deleteCallback: () => {deleteActivity(activity['id'])}));
      }
    }
    setState(() {
      activityList = tempList;
    });
  }

  void _activityDialog({int? actiId, String? actiDes, bool? actiAlarm}) {
    final actiController = TextEditingController(text: actiDes);
    DateTime? time;
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
                            Text(
                              actiId != null
                                  ? "Update Activity"
                                  : 'Add Activity',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            TextButton(
                                onPressed: () {
                                  final id = UniqueKey().hashCode;
                                  if (alarm && time != null) {
                                    NotificationService().scheduleNotification(
                                        id: id,
                                        scheduledDate: time!,
                                        body: actiController.text,
                                        title:
                                            'It\'s time to do your activity');
                                  }
                                  if (actiId == null) {
                                    addActivity(
                                        id, actiController.text, time, alarm);
                                  } else {
                                    updateActivity(actiId, actiController.text,
                                        time, alarm);
                                  }
                                  db
                                      .doc(
                                          'users/${widget.accMail}/activities/${actiId ?? id}')
                                      .set({
                                    'id': actiId ?? id,
                                    'description': actiController.text,
                                    'time': time != null ? time.toString() : '',
                                    'alarm': alarm
                                  });
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
              Column(
                children: activityList.map((e) => e).toList(),
              )
            ],
          ),
        ));
  }

  /// *****************  Diet section    ************

  void _dietNotDialog() {
    final foodNameController = TextEditingController();
    final noteController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (BuildContext context, setState) => Dialog(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: foodNameController,
                        decoration:
                            const InputDecoration(hintText: 'Food name'),
                      ),
                      TextField(
                        controller: noteController,
                        decoration: const InputDecoration(hintText: 'Note'),
                      ),
                    ],
                  ),
                ))));
  }

  Widget dietTab() {
    return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _dietNotDialog();
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

  @override
  void initState() {
    getActivities();
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
                dietTab(),
                tipsTab()
              ],
            )),
      ),
    ]);
  }
}
