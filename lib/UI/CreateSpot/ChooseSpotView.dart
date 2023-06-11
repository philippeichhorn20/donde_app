import 'package:donde/UITemplates.dart';
import 'package:flutter/material.dart';

class ChooseSpotView extends StatefulWidget {
  const ChooseSpotView({Key? key}) : super(key: key);

  @override
  State<ChooseSpotView> createState() => _ChooseSpotViewState();
}

class _ChooseSpotViewState extends State<ChooseSpotView> {
  TextEditingController inputControl = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: UITemplates.importantTextStyle,
          decoration: InputDecoration(
            hintText: "Search Spot",
            hintStyle: UITemplates.importantTextStyleHint,
            border: UITemplates.inputBorder,
          ),
        ),
      ),
      body: Column(
        children: [],
      ),
    );
  }



}
