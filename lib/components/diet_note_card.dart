import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/meal_type_map.dart';

class DietNoteCard extends StatefulWidget {
  final int id;
  final String? name;
  final int meal;
  final String? note;
  final VoidCallback editCallback;
  final VoidCallback deleteCallback;

  const DietNoteCard(
      {super.key,
      required this.id,
      this.name,
      required this.meal,
      this.note,
      required this.editCallback,
      required this.deleteCallback});

  @override
  State<DietNoteCard> createState() => _DietNoteCardState();
}

class _DietNoteCardState extends State<DietNoteCard> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return (Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              '${widget.name} - ${MealTypeMap(mealType: widget.meal).getMealLabel()}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(widget.note ?? ""),
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
