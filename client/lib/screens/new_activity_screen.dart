import 'package:client/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class NewActivityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MapTogetherAppBar(title: 'New Activity'),
    );
  }
}
