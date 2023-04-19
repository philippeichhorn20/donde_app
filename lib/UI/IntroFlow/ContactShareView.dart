import 'package:donde/BackendFunctions/ContactFunctions.dart';
import 'package:donde/Classes/MyUser.dart';
import 'package:donde/UI/BasicUIElements/ListTiles.dart';
import 'package:donde/UI/IntroFlow/UserMatch.dart';
import 'package:donde/UI/MainViews/Skeleton.dart';
import 'package:donde/UITemplates.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactShareView extends StatefulWidget {
  const ContactShareView({Key? key}) : super(key: key);

  @override
  State<ContactShareView> createState() => _ContactShareViewState();
}

class _ContactShareViewState extends State<ContactShareView> {
  bool isChecked = false;
  List<MyUser> users = [];
  GlobalKey<AnimatedListState> animListKey = GlobalKey();
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 100,
                child: Column(
                  children: [
                    if (users.isEmpty)
                       Container(
                         width: MediaQuery.of(context).size.width*.7,
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Padding(
                               padding: const EdgeInsets.all(30.0),
                               child: Icon(Icons.contacts, size: 40,),
                             ),
                             Text("Sync Contacts", style: UITemplates.buttonTextStyle,
                             textAlign: TextAlign.center,
                             ),
                             SizedBox(height: 30,),
                             RichText(
                               textAlign: TextAlign.center,
                               text: TextSpan(
                                 children:  <TextSpan>[
                                   TextSpan(text:  "This is a ",
                                     style: UITemplates.clickableText,

                                   ),
                                   TextSpan(text: "one-time",
                                     style: UITemplates.clickableTextButBold,
                                   ),
                                   TextSpan(text:  " check. We ",
                                     style: UITemplates.clickableText,
                                   ),
                                   TextSpan(text:  "do not store",
                                     style: UITemplates.clickableTextButBold,
                                   ),
                                   TextSpan(text:  " any contact information outside of your device",
                                     style: UITemplates.clickableText,
                                   ),
                                 ],
                               ),
                             ),
                           ],
                         ),
                       ),
                    if(isLoading)
                      SizedBox(height: 100,),
                    if(isLoading)
                      Center(child: UITemplates.loadingAnimation,),
                    if (users.isNotEmpty && isChecked)
                      Container(
                        height: MediaQuery.of(context).size.height * .8,
                        width: MediaQuery.of(context).size.width,
                        child: AnimatedList(
                          key: animListKey,
                          initialItemCount: users.length,
                          itemBuilder: (context, index, animation) {
                            MyUser user = users[index];
                            return ListTiles.userListTile(user, context,);
                          },
                        ),
                      ),

                  ],
                )),
           if(!isChecked)
            Positioned(
                top: 50,
                right:10,
                child: TextButton(
                  style:  TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    foregroundColor: Colors.transparent,
                  ),
              child: Text("Skip", style: UITemplates.clickableText,),
              onPressed: (){
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => UserMatch(),
                  ),
                );
              },
            )),
            Positioned(
                bottom: 50,
                child: Container(
                  width: MediaQuery.of(context).size.width * .7,
                  height: 50,
                  child: TextButton(

                    onPressed: ()async {
                      if(!isChecked){
                        return await getContacts();
                      }
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (context) => UserMatch(),
                        ),
                      );
                      //Todo nach invite friends
                    },
                    child: Text(isChecked?"Next":"Check", style: UITemplates.buttonTextStyle),
                    style: UITemplates.buttonStyle,
                  ),
                )),
          ],
        )) ;
  }


  Future<void> getContacts()async{
    setState(() {
      isLoading = true;
    });
    bool allowed = await FlutterContacts.requestPermission(readonly: true);
    if(allowed){
      users = await ContactFunctions.getContacts();
      setState(() {
        isChecked = true;
        users = users;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
