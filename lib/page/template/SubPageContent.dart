import 'package:flutter/material.dart';

abstract class SubPageContent {
  String getTitle();
  Widget build(BuildContext context);
}