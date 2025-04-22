import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? suggestion;

  const EmptyStateWidget({
    Key? key,
    required this.icon,
    required this.message,
    this.suggestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 80.0,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.0),
          Text(
            message,
            style: TextStyle(fontSize: 18.0, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          if (suggestion != null) ...[
            SizedBox(height: 8.0),
            Text(
              suggestion!,
              style: TextStyle(fontSize: 14.0, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ]
        ],
      ),
    );
  }
}