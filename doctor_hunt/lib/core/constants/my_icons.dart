import 'package:flutter/material.dart';

/// Centralized icon registry to prevent hardcoded Icons usage.
class MyIcons {
  MyIcons._();

  static const IconData back = Icons.arrow_back_ios_new_rounded;
  static const IconData email = Icons.mail_outline_rounded;
  static const IconData verified = Icons.check_circle_outline_rounded;
  static const IconData check = Icons.check_rounded;
  static const IconData calendar = Icons.calendar_today_outlined;
  static const IconData clock = Icons.access_time_rounded;
  static const IconData fee = Icons.attach_money_rounded;
  static const IconData location = Icons.location_on_outlined;
}
