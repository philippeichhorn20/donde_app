import 'package:donde/BackendFunctions/SignUpFunctions.dart';
import 'package:donde/Store.dart';
import 'package:donde/UI/IntroFlow/Welcome.dart';
import 'package:donde/UI/MainViews/HomePage.dart';
import 'package:donde/UI/MainViews/Skeleton.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoConnectionView extends StatefulWidget {
  const NoConnectionView({Key? key}) : super(key: key);

  @override
  State<NoConnectionView> createState() => _NoConnectionViewState();
}

class _NoConnectionViewState extends State<NoConnectionView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child:Stack(
          alignment: Alignment.center,
          children: [
            Positioned(child: isLoading ? UITemplates.loadingAnimation:Icon(Icons.error_outlined, size:100, color: Colors.white24,),
            top: MediaQuery.of(context).size.height*.3,),
            Positioned(child: Container(
                width: MediaQuery.of(context).size.width*.6,
                child: Text("You need an internet connection to access this app.", style: UITemplates.descriptionStyle,textAlign: TextAlign.center,)),
              top: MediaQuery.of(context).size.height*.6,),
            Positioned(
              child: ElevatedButton(
                  style: UITemplates.buttonStyle,
                  onPressed: ()async{
                if(!isLoading){
                  setState(() {
                    isLoading = true;
                  });
                  await retryConnection();
                  setState(() {
                    isLoading = false;
                  });
                }
              }, child: Text("Try again")),
              bottom: 100,
            )
          ],
        ),
      ),
    );
  }

  Future<void> retryConnection() async{
    LogInState isLoggedIn = await SignUpFunctions.logInFromStorage();
   print(isLoggedIn);
try {
  if (isLoggedIn == LogInState.LOGGED_IN) {
    await Store.initLoc();
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => Skeleton(),
      ),
    );
  } else if (isLoggedIn == LogInState.LOGGED_OUT) {
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => Welcome(),
      ),
    );
  }
}catch(e){

}
  }
}
