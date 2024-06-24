import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityCard extends StatefulWidget {
  final int id;
  final String? description;
  final String? date;
  final VoidCallback editCallback;
  final VoidCallback deleteCallback;

  const ActivityCard(
      {super.key,
      required this.id,
      this.description,
      this.date,
      required this.editCallback,
      required this.deleteCallback});

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return (Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(widget.description ?? ""),
            subtitle: Text(widget.date ?? ""),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: widget.editCallback,
                  child: const Icon(Icons.mode_edit_outlined)),
              TextButton(
                  onPressed: widget.deleteCallback,
                  child: const Icon(Icons.delete_outline)),
            ],
          )
        ],
      ),
    ));
  }
}
