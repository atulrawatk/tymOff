import 'dart:async';

import 'package:flutter/material.dart';

class DatePickerDialog {

  static  Future<DateTime> selectDate(BuildContext context)async{
    var selectedDate;
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(2000),
        lastDate: new DateTime(2020));
    if(pickedDate!= null){
      selectedDate = pickedDate;
    }else{
      selectedDate = DateTime.now();
    }
    return selectedDate;
  }

  static  Future<String> selectTime(BuildContext context)async{
    var selectedTime;
    final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now());
    if(pickedTime!= null){
      selectedTime = pickedTime.format(context).toString();
    }else{
    selectedTime = TimeOfDay.now().format(context).toString();
    }
    return selectedTime;
  }
}