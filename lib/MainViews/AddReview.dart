
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:donde/BackendFunctions/ReviewFunctions.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/Store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Classes/Spot.dart';

class AddReview extends StatefulWidget {
  final Spot spot;
  const AddReview(this.spot);

  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  CameraDescription? camera;
  CameraController? camController;
  XFile? pic;
  TextEditingController textControl = TextEditingController();
double valueSlider = 0;
Future? _future;
int liked = 0;

  @override
  initState() {
    super.initState();
    _future = cameraSetUp();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 200,),
              FutureBuilder<void>(
                future: _future,
                builder: (context, snapshot) {
                  if (camController!= null && snapshot.connectionState== ConnectionState.done){
                    return Center(
                      child: Container(
                        alignment: Alignment.topLeft,
                        width: 300,
                        height: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),



                          child: Container(

                            child: Stack(
                              fit: StackFit.expand,
                                children: [
                                  if(pic == null)
                                    CameraPreview(camController!,),
                                  if(pic!=null)
                                    Image.file(File(pic!.path), fit: BoxFit.fill),
                                  if(pic!=null)
                                  Positioned(
                                    bottom: 0,
                                    child: SizedBox(
                                      width: 300,
                                      child: TextField(
                                        maxLines: 4,
                                       minLines: 1,
                                       expands: false,
                                       maxLength: 150,
                                       controller: textControl,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                            color: Color.fromARGB(255,(valueSlider*255).toInt(), (valueSlider*255).toInt(), (valueSlider*255).toInt())
                                        ),
                                        decoration: InputDecoration.collapsed(hintText: "Your experience"),
                                      ),
                                    ),
                                  ),
                                ],

                              ),
                          ), ),
                      ),
                    );
                  }
                  return Text("Fuck");
                },
              ),
              TextButton.icon(onPressed: ()async{
                if(pic == null) {
                  pic = await camController!.takePicture();
                  print(pic == null);
                  setState(() {
                    pic = pic;
                  });
                }else{
                  setState(() {
                    pic = null;
                  });
                }
              }, icon: Icon(Icons.circle,
                color: Color.fromARGB((valueSlider*255).toInt(), (valueSlider*255).toInt(), (valueSlider*255).toInt(), (valueSlider*255).toInt())
                ,), label: Text(pic==null?"Capture":"Drop"),),
              TextField(
                controller: textControl,
                onChanged: (value) {
                  textControl;
                },
                decoration: InputDecoration(
                  hintText: "Your expereince"
                ),
              ),
              Slider(value: valueSlider,
                min: 0,
                max: 1,
                divisions: 4,
                onChanged: (value) {
  setState(() {
    valueSlider = value;
  });
              },),
              TextButton(onPressed: ()async{
                await addReview();
              }
              , child: Text("save"))
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> cameraSetUp()async{
    if(camera != null){
      return true;
    }
    List<CameraDescription> cameras = await availableCameras();
    if(cameras.length>0) {

      camera = cameras.first;
      camController = CameraController(camera!, ResolutionPreset.medium,   imageFormatGroup: ImageFormatGroup.yuv420,
      );
      await camController!.initialize();

      return true;
    }
    return false;
  }


  Future<bool> addReview()async{
    Review review = Review(textControl.text, Store.me, widget.spot, liked == 1?true:false);
    review.textColor = valueSlider;
    review.image = pic;
    return await ReviewFunctions.saveReview(review);
  }
}
