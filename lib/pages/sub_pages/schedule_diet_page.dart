import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../components/tip_list.dart';
import '../../utils/services/noti_service.dart';
import '../../components/activity_card.dart';
import '../../utils/meal_type_map.dart';
import '../../components/diet_note_card.dart';
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
  List<DietNoteCard> dietNoteList = [];

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
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.close)),
                            Text(
                              actiId != null
                                  ? "Update Activity"
                                  : 'Add Activity',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            IconButton(
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
                                icon: const Icon(Icons.check))
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                            minLines: 2,
                            maxLines: 2,
                            controller: actiController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: actiDes != null
                                  ? 'Description'
                                  : 'New Activity',
                            )),
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

  void addDietNote(int id, String? name, String? note, int mealType) {
    setState(() {
      dietNoteList.insert(
          0,
          DietNoteCard(
            id: id,
            name: name ?? "",
            note: note ?? "",
            meal: mealType,
            editCallback: () => {
              _dietNoteDialog(
                  dietNoteId: id,
                  mealType: mealType,
                  name: name ?? "",
                  note: note ?? "")
            },
            deleteCallback: () => {deleteDietNote(id)},
          ));
    });
  }

  void updateDietNote(int id, String? name, String? note, int mealType) {
    int updatedCardIndex =
        dietNoteList.indexWhere((dietNote) => dietNote.id == id);
    if (updatedCardIndex != -1) {
      List<DietNoteCard> temp = dietNoteList;
      temp[updatedCardIndex] = DietNoteCard(
          id: id,
          name: name ?? "",
          note: note ?? "",
          meal: mealType,
          editCallback: () => {
                _dietNoteDialog(
                    dietNoteId: id,
                    mealType: mealType,
                    name: name ?? "",
                    note: note ?? "")
              },
          deleteCallback: () => {deleteDietNote(id)});
      setState(() {
        dietNoteList = temp;
      });
    }
  }

  void deleteDietNote(int id) async {
    await db
        .doc('users/${widget.accMail}/dietNotes/$id')
        .delete()
        .catchError((e) => {});
    setState(() {
      dietNoteList.removeWhere((dietNote) => dietNote.id == id);
    });
  }

  void getDietNotes() async {
    final List<DietNoteCard> tempList = [];
    QuerySnapshot dietNotes = await db
        .collection('users/${widget.accMail}/dietNotes')
        .orderBy('mealType')
        .get();
    if (dietNotes.size > 0) {
      for (var dietNote in dietNotes.docs) {
        tempList.add(DietNoteCard(
            id: dietNote['id'],
            name: dietNote['name'] ?? "",
            note: dietNote['note'] ?? '',
            meal: dietNote['mealType'] ?? 1,
            editCallback: () => {
                  _dietNoteDialog(
                    dietNoteId: dietNote['id'],
                    name: dietNote['name'] ?? "",
                    note: dietNote['note'] ?? '',
                    mealType: dietNote['mealType'] ?? 1,
                  )
                },
            deleteCallback: () => {deleteDietNote(dietNote['id'])}));
      }
    }
    setState(() {
      dietNoteList = tempList;
    });
  }

  void _dietNoteDialog(
      {int? dietNoteId, int? mealType, String? name, String? note}) {
    final nameController = TextEditingController(text: name ?? "");
    final noteController = TextEditingController(text: note ?? "");
    int meal = mealType ?? 1;
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (BuildContext context, setState) => Dialog(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.close)),
                          Text(
                            dietNoteId != null ? "Update Note" : 'Add Note',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          IconButton(
                              onPressed: () async {
                                final id = UniqueKey().hashCode;
                                await db
                                    .doc(
                                        'users/${widget.accMail}/dietNotes/${dietNoteId ?? id}')
                                    .set({
                                  'id': dietNoteId ?? id,
                                  'name': nameController.text,
                                  'note': noteController.text,
                                  'mealType': meal
                                }).then((value) => {
                                          if (dietNoteId == null)
                                            {
                                              addDietNote(
                                                  id,
                                                  nameController.text,
                                                  noteController.text,
                                                  meal)
                                            }
                                          else
                                            {
                                              updateDietNote(
                                                  dietNoteId,
                                                  nameController.text,
                                                  noteController.text,
                                                  meal)
                                            }
                                        });
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              },
                              icon: const Icon(Icons.check)),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 10,
                          children: [
                            SizedBox(
                              width: 120,
                              child: Row(children: [
                                Radio<int>(
                                  value: 1,
                                  groupValue: meal,
                                  onChanged: (int? value) {
                                    setState(() {
                                      meal = value!;
                                    });
                                  },
                                ),
                                Text(MealTypeMap(mealType: 1).getMealLabel()),
                              ]),
                            ),
                            SizedBox(
                              width: 120,
                              child: Row(children: [
                                Radio<int>(
                                  value: 2,
                                  groupValue: meal,
                                  onChanged: (int? value) {
                                    setState(() {
                                      meal = value!;
                                    });
                                  },
                                ),
                                Text(MealTypeMap(mealType: 2).getMealLabel()),
                              ]),
                            ),
                            SizedBox(
                              width: 120,
                              child: Row(children: [
                                Radio<int>(
                                  value: 3,
                                  groupValue: meal,
                                  onChanged: (int? value) {
                                    setState(() {
                                      meal = value!;
                                    });
                                  },
                                ),
                                Text(MealTypeMap(mealType: 3).getMealLabel()),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            labelText: 'Name', border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        maxLines: 3,
                        minLines: 3,
                        controller: noteController,
                        decoration: const InputDecoration(
                            labelText: 'Note', border: OutlineInputBorder()),
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
                  _dietNoteDialog();
                },
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10)),
                child: const Icon(Icons.add),
              ),
              Column(
                children: dietNoteList.map((dietNote) => dietNote).toList(),
              )
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
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: const TipList())
            ]));
  }

  @override
  void initState() {
    getActivities();
    getDietNotes();
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
