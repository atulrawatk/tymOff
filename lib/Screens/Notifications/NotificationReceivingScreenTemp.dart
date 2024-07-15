import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationReceivingScreenTemp extends StatefulWidget {
  final String payload;
  NotificationReceivingScreenTemp(this.payload);
  @override
  State<StatefulWidget> createState() => NotificationReceivingScreenTempState();
}

class NotificationReceivingScreenTempState extends State<NotificationReceivingScreenTemp> {
  String _payload;
  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification Screen with payload: " + _payload),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}