import 'package:flutter/material.dart';

Future<String?> showAddEditDialog(BuildContext context, {String? initialValue, required String title, required String label}) async {
  final controller = TextEditingController(text: initialValue);
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: label),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Ne retourne rien (null)
            },
          ),
          TextButton(
            child: Text('Add'), // Ou 'Save' si initialValue n'est pas null
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                Navigator.of(context).pop(text); // Retourne le texte entré
              } else {
                // Optionnel : Afficher un message d'erreur si le champ est vide
                 ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text('Name cannot be empty')),
                 );
              }
            },
          ),
        ],
      );
    },
  );
}