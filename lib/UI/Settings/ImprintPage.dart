import 'package:donde/UITemplates.dart';
import 'package:flutter/material.dart';
class ImPrintPage extends StatefulWidget {
  const ImPrintPage({Key? key}) : super(key: key);

  @override
  State<ImPrintPage> createState() => _ImPrintPageState();
}

class _ImPrintPageState extends State<ImPrintPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Imprint"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Philipp Eichhorn\nSchillerstr. 10\nKronberg\nGermany\n\ncontact@dondeapp.de",
          style: UITemplates.settingsTextdark,
        ),
      ),
    );
  }
}
