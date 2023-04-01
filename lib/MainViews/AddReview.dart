import 'dart:io';

import 'package:camera/camera.dart';
import 'package:donde/BackendFunctions/ReviewFunctions.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/MainViews/HomePage.dart';
import 'package:donde/MainViews/SpotView.dart';
import 'package:donde/Store.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' as Io;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

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
  late FocusNode myFocusNode;


  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }


  @override
  initState() {
    super.initState();
    _future = cameraSetUp();
    myFocusNode = FocusNode();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              FutureBuilder<void>(
                future: _future,
                builder: (context, snapshot) {
                  if (camController != null &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Center(
                      child: Container(
                        alignment: Alignment.topLeft,
                        width: 350,
                        height: 500,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Container(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (pic == null) CameraPreview(camController!),
                                if (pic != null)
                                  Image.file(File(pic!.path), fit: BoxFit.cover),
                                if (pic != null)
                                  Positioned(
                                    bottom: 0,
                                    child: SizedBox(
                                      width: 300,
                                      child: TextField(
                                        maxLines: null,
                                        minLines: 1,
                                        expands: false,
                                        maxLength: 150,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny("\n")
                                        ],
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.text,
                                        controller: textControl,
                                        style: TextStyle(
                                          fontSize: 30,
                                            fontWeight: FontWeight.w700,
                                            color: Color.fromARGB(
                                                255,
                                                (valueSlider * 255).toInt(),
                                                (valueSlider * 255).toInt(),
                                                (valueSlider * 255).toInt())),
                                        decoration: InputDecoration.collapsed(
                                            hintText: "Your experience"),
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  top:10,
                                  right:10,
                                  child: Container(
                                    decoration: BoxDecoration(

                                        borderRadius: BorderRadius.all(Radius.circular(200)),
                                        color: valueSlider == 1 ? Colors.black: Colors.white
                                    ),
                                    child: TextButton(
                                        onPressed: (){
                                          setState(() {
                                            valueSlider = valueSlider ==1?0:1;
                                          });
                                        },

                                        child: Icon(Icons.text_format, color: valueSlider == 1 ? Colors.white: Colors.black,size: 40,)),
                                  ),
                                ),
                                Positioned(
                                  bottom:20,
                                  right:10,
                                  child: Container(

                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        color: Colors.white
                                    ),
                                    child: TextButton(

                                        onPressed: ()async{
                                          XFile? xfile = await picImageFromLibrary();
                                          setState(() {
                                            pic = xfile;
                                          });
                                        },
                                        child: Icon(Icons.photo_library,color: Colors.black,size: 25,),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return Text("Fuck");
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top:12.0),
                child: TextButton(
                  onPressed: () async {
                    if (pic == null) {
                    await takePictureandResize();
                     print(pic == null);
                      setState(() {
                        pic = pic;
                      });
                    } else {
                      setState(() {
                        pic = null;
                      });
                    }
                  },
                  style: UITemplates.buttonStyle,

                  child: Icon(pic == null ? Icons.camera_alt : Icons.close_rounded, size: 35,color: Colors.white),
                ),
              ),
              SizedBox(height: 100,),
              Container(
                width: MediaQuery.of(context).size.width*.8,
                height: 50,
                child: TextButton(
                    onPressed: () async {
                      Review? review = await addReview();
                      if (review != null) {
                        Navigator.of(context).pushReplacement(
                          CupertinoPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      }
                    },
                    style: UITemplates.buttonStyle,
                    child: Text("save",style: UITemplates.buttonTextStyle,)),
              )
            ],
          ),
        ),
      ),
    );
  }


  Future<void> takePictureandResize()async{
    pic = await camController!.takePicture();
  }



  Future<bool> cameraSetUp() async {
    if (camera != null) {
      return true;
    }
    List<CameraDescription> cameras = await availableCameras();
    if (cameras.length > 0) {
      camera = cameras.first;
      camController = CameraController(
        camera!,
        ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      await camController!.initialize();

      return true;
    }
    return false;
  }

  Future<Review?> addReview() async {
    Review review = Review(
        textControl.text, Store.me, widget.spot, liked == 1 ? true : false);
    review.textColor = valueSlider;
    review.image = pic;
    return await ReviewFunctions.saveReview(review) ? review : null;
  }

  Future<XFile?> picImageFromLibrary()async{
    final ImagePicker picker = ImagePicker();

// Pick an image.
    return await picker.pickImage(source: ImageSource.gallery, imageQuality: 1);
  }
}
