import 'package:donde/BackendFunctions/ReviewFunctions.dart';
import 'package:donde/BackendFunctions/SpotFunctions.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Classes/Spot.dart';
import 'package:donde/Store.dart';
import 'package:donde/UI/MainViews/SpotView.dart';
import 'package:donde/UI/ReviewFlow/AddReview.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/material.dart';

class PostCheck extends StatefulWidget {
  final Spot spot;
  final Review review;
  const PostCheck({Key? key, required this.spot, required this.review}) : super(key: key);
  @override
  State<PostCheck> createState() => _PostCheckState();
}

class _PostCheckState extends State<PostCheck> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 50,
                child: Container(
                    height: 700,
                    width: MediaQuery.of(context).size.width,
                    child: SpotView(widget.spot, (){}))),
            Positioned(
              bottom: 80,
              child: Container(
                width: MediaQuery.of(context).size.width*.8,
                height: 50,
                child: ElevatedButton(
                  onPressed: ()async {
                   if(!isLoading){
                     isLoading = true;
                     if(await save()){
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AddReview()));
                       setState(() {
                         Store.pers_controller!.index = 0;
                       });
                     }else{
                       UITemplates.showErrorMessage(context, "Please, try again");
                     }
                   }
                    isLoading = false;
                  },
                  child: Text("Post!", style: UITemplates.buttonTextStyle,),
                  style: UITemplates.buttonStyle,
                ),
              ),
            ),
          ],
        ),
      )
    );
  }


  Future<bool> save()async{
    bool spotWorked = await SpotFunctions.saveSpot(widget.spot);
    widget.review.spot = widget.spot;
    bool reviewWorked = await ReviewFunctions.saveReview(widget.review);
    if(spotWorked&&reviewWorked){
      return true;
    }
    return false;
  }
}
