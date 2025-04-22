import 'package:flutter/material.dart';

Future<bool?> showConfirmDeleteDialog(BuildContext context, {required String itemName}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Confirmation'),
        content: Text('Are you sure you want to delete "$itemName"? This action cannot be undone.'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false); // Retourne false
            },
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop(true); // Retourne true
            },
          ),
        ],
      );
    },
  );
}