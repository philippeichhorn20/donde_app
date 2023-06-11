import 'package:donde/BackendFunctions/SignUpFunctions.dart';
import 'package:donde/Store.dart';
import 'package:donde/UI/IntroFlow/Welcome.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeletePage extends StatefulWidget {
  const DeletePage({Key? key}) : super(key: key);

  @override
  State<DeletePage> createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UITemplates.appbar("Delete Account"),
      body: Container(
        margin: EdgeInsets.only(bottom: 20, left: 15, right:15, top:30),
        decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: TextButton(
          style:  TextButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            foregroundColor: Colors.transparent,
          ),
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text("Delete Account", style: UITemplates.settingsTextred,)),
          onPressed: () async{

            return showCupertinoModalPopup(context: context, builder: (context) {
              return CupertinoAlertDialog(
                content: Text("Are your sure you want to delete your account and all your content?"),
                title: Text("Delete Account"),
                actions: [

                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () async{
                      Navigator.pop(context);
                      if(await SignUpFunctions.deleteUser()){
                        Store.pers_controller?.dispose();
                        Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst,
                        );
                      }else{
                        UITemplates.showErrorMessage(context, "Unable to delete Account. Please try again");
                      }
                    },
                    child: const Text('Delete'),
                  ),
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No'),
                  ),
                ],
              );
            },);
          },
        ),
      ),
    );
  }
}
