import 'package:flutter/material.dart';
import 'package:snow_widget/storybook/storybook_app.dart';

void main() async {
  /// Run initialization right after startup
  WidgetsFlutterBinding.ensureInitialized();
  runApp(StoryBookApp());
}
