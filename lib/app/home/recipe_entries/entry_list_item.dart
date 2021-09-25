import 'package:flutter/material.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/entry.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/recipes.dart';

class EntryListItem extends StatelessWidget {
  const EntryListItem({
    required this.entry,
    required this.recipe,
    this.onTap,
  });

  final Entry entry;
  final Recipe recipe;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildContents(context),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final calories = entry.calories.toString();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            Text(entry.foodName + ":   ",
                style: const TextStyle(fontSize: 18.0)),
            const SizedBox(height: 8.0),
            Text(calories + "Cal", style: const TextStyle(fontSize: 18.0)),
          ])
        ]);
  }
}

class DismissibleEntryListItem extends StatelessWidget {
  const DismissibleEntryListItem({
    required this.dismissibleKey,
    required this.entry,
    required this.recipe,
    this.onDismissed,
    this.onTap,
  });

  final Key dismissibleKey;
  final Entry entry;
  final Recipe recipe;
  final VoidCallback? onDismissed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: dismissibleKey,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed?.call(),
      child: EntryListItem(
        entry: entry,
        recipe: recipe,
        onTap: onTap,
      ),
    );
  }
}
