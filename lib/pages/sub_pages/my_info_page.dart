import 'package:flutter/material.dart';
import 'package:health_tracker/components/custom_snackbar.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MyInfoPage extends StatefulWidget {
  final String accMail;
  const MyInfoPage({super.key, required this.accMail});

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  final db = FirebaseFirestore.instance;
  String? _type = 'asian';
  String? _gender = 'male';
  final _dateController = TextEditingController();
  final _nameController = TextEditingController();

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2002),
        firstDate: DateTime(1920),
        lastDate: DateTime(2024),
        locale: const Locale('vi', 'VI'));
    if (picked != null) {
      _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  Future<void> _submitGeneralInfo() async {
    context.loaderOverlay.show();

    await db.doc('users/${widget.accMail}').set({
      'birthday': _dateController.text,
      'name': _nameController.text,
      'bodyType': _type,
      'gender': _gender,
    }, SetOptions(merge: true)).then((value) {
      CustomSnackbar().success("Your infomation is updated :)", context);
      if (context.mounted) {
        context.loaderOverlay.hide();
      }
    }).catchError((err) {
      CustomSnackbar().error("Error : $err", context);
      if (context.mounted) {
        context.loaderOverlay.hide();
      }
    });
  }

  getUserGeneralData() async {
    var userDocSnapshot = await db.doc('users/${widget.accMail}').get();
    if (userDocSnapshot.exists) {
      Map<String, dynamic>? userData = userDocSnapshot.data();
      _dateController.text = userData?['birthday'];
      _nameController.text = userData?['name'];
      setState(() {
        _type = userData?['bodyType'];
        _gender = userData?['gender'];
      });
    }
  }

  @override
  void initState() {
    getUserGeneralData();
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
          title: const Text('Thông tin của tôi'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(40, 80, 40, 200),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
            width: double.infinity,
            height: 550,
            decoration: const BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Tên',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Ngày sinh',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Thời gian',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  readOnly: true,
                  onTap: () {
                    _selectDate();
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Nhóm cơ thể',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                Wrap(children: <Widget>[
                  SizedBox(
                    width: 100,
                    child: Row(children: [
                      Radio<String>(
                        value: 'asian',
                        groupValue: _type,
                        onChanged: (String? value) {
                          setState(() {
                            _type = value;
                          });
                        },
                      ),
                      const Text('Châu Á'),
                    ]),
                  ),
                  SizedBox(
                    width: 140,
                    child: Row(children: [
                      Radio<String>(
                        value: 'others',
                        groupValue: _type,
                        onChanged: (String? value) {
                          setState(() {
                            _type = value;
                          });
                        },
                      ),
                      const Text('Nhóm khác'),
                    ]),
                  ),
                ]),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Giới tính',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                Wrap(children: <Widget>[
                  SizedBox(
                    width: 100,
                    child: Row(children: [
                      Radio<String>(
                        value: 'male',
                        groupValue: _gender,
                        onChanged: (String? value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                      const Text('Nam'),
                    ]),
                  ),
                  SizedBox(
                    width: 100,
                    child: Row(children: [
                      Radio<String>(
                        value: 'female',
                        groupValue: _gender,
                        onChanged: (String? value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                      const Text('Nữ'),
                    ]),
                  ),
                ]),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: FilledButton(
                        onPressed: () async {
                          _submitGeneralInfo();
                        },
                        child: const Text('Cập nhật thông tin')),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
