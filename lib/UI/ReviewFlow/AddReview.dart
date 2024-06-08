import 'dart:io';

import 'package:camera/camera.dart';
import 'package:donde/BackendFunctions/ReviewFunctions.dart';
import 'package:donde/Classes/Review.dart';
import 'package:donde/UI/ReviewFlow/DoesSpotExistView.dart';
import 'package:donde/UI/MainViews/HomePage.dart';
import 'package:donde/UI/MainViews/SpotView.dart';
import 'package:donde/Store.dart';

import 'package:donde/UI/ReviewFlow/ReviewDetailsView.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:io' as Io;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:volume_controller/volume_controller.dart';

import '../../Classes/Spot.dart';

class AddReview extends StatefulWidget {
  final Spot? spot;

  const AddReview({this.spot});

  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  CameraDescription? camera;
  CameraController? camController;
  File? pic;
  Future? _future;
  late FocusNode myFocusNode;
  bool flashOff = true;

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  late var size;
  late var deviceRatio;
  late var scale;
  @override
  initState() {
    super.initState();
    _future = cameraSetUp();
    myFocusNode = FocusNode();


    VolumeController().listener((p0) async{
    if(Store.pers_controller!= null && Store.pers_controller!.index == 1){
      if(pic == null){
        await takePictureandResize();
        setState(() {
          pic = pic;
        });
      }
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        //     backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 70,
              ),
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Text("Make a picture of the spot you want to rate", style: UITemplates.descriptionStyle,),
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder<void>(
                future: _future,
                builder: (context, snapshot) {
                  if (camController != null &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Center(
                      child: Container(
                        alignment: Alignment.topLeft,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width*450/350,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Container(
                            child: Stack(
                              fit: StackFit.expand,
                            //  alignment: Alignment.center,
                              children: [
                                if (pic == null)
                                  Positioned(
                                    top:0,
                                    left:0,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.width*450/350,
                                      child: Transform.scale(
                                        scale: camController!.value.previewSize!.width/350/2/4,
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          child: SizedBox(
                                            height: camController!.value.previewSize!.height,
                                            width: camController!.value.previewSize!.width,
                                            child: Center(
                                              child: CameraPreview(camController!),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (pic != null)
                                  Image.file(File(pic!.path),
                                      fit: BoxFit.fitWidth,width: 350,),
                                if(pic != null)
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: TextButton(
                                    style:  TextButton.styleFrom(
                                      splashFactory: NoSplash.splashFactory,
                                      foregroundColor: Colors.transparent,
                                    ),
                                    onPressed: ()  {
                                      setState(() {
                                        pic = null;
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 35,
                                      grade: 100,
                                      semanticLabel: "Delete",
                                      weight: 100,
                                    ),
                                  ),
                                ),
                                if(pic == null)
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: TextButton(
                                      style:  TextButton.styleFrom(
                                        splashFactory: NoSplash.splashFactory,
                                        foregroundColor: Colors.transparent,
                                        backgroundColor: Colors.grey[700],
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed: ()  {
                                        setState(() {
                                          camController!.setFlashMode(flashOff?FlashMode.always:FlashMode.off);
                                          flashOff = !flashOff;
                                        });
                                      },
                                      child: Icon(
                                        flashOff?Icons.flash_off:Icons.flash_on,
                                        color: Colors.white,
                                        size: 25,
                                        grade: 100,
                                        semanticLabel: "flash",
                                        weight: 100,
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
                  return Text("");
                },
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                child: ElevatedButton(

                  style:  ElevatedButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    foregroundColor: Colors.transparent,
                    backgroundColor: Colors.black,
                    elevation: 5
                  ),
                  onPressed: () async {
                    File? xfile =
                    await picImageFromLibrary();
                    setState(() {
                      if (xfile != null) {
                        pic = File(xfile.path);
                      }
                    });
                  },
                  child: Text("Pick photo from library", style: UITemplates.settingsTextStyle,textAlign: TextAlign.start),
                ),
              ),
              if(pic==null)
              Container(
                alignment: Alignment.center,

                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TextButton(

                    onPressed: () async {
                        await takePictureandResize();
                        setState(() {
                          pic = pic;
                        });
                    },
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      foregroundColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                    ),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: Colors.white,
                          width: 6
                        )
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              if (pic != null)
              Container(
                height: 50,
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width*.9,
                child: TextButton.icon(
                  onPressed: () async{
                    if(pic == null){
                      UITemplates.showErrorMessage(context, "Add a picture");
                    }else{

                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => ReviewDetailsView(pic: pic!,),
                        ),
                      );
                    }

                  },
                  icon: Icon(Icons.arrow_forward_ios, color: Colors.white38,size: 30,),
                  label: Text("Use it", style: UITemplates.buttonTextStyle),),
              ),
              SizedBox(height: 56,)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> takePictureandResize() async {

    XFile xTemp = await camController!.takePicture();
    File compressedFile = await FlutterNativeImage.compressImage(
      xTemp.path,
      quality: 2,
    );

    pic = compressedFile;
  }

  Future<bool> cameraSetUp() async {
    if (camera != null) {
      return true;
    }
    List<CameraDescription> cameras = await availableCameras();
    if (cameras.length > 0) {
      camera = cameras[0];
      camController = CameraController(
        camera!,
        enableAudio: false,
        ResolutionPreset.max,
        imageFormatGroup: ImageFormatGroup.bgra8888,

      );

      await camController!.initialize();
      camController!.setFlashMode(FlashMode.off);
      size = MediaQuery.of(context).size;
      deviceRatio = size.width / size.height;
      setState(() {
        scale = camController!.value.aspectRatio / size;
      });
      return true;
    }
    return false;
  }



  Future<File?> picImageFromLibrary() async {
    final ImagePicker picker = ImagePicker();
    XFile? temp;
    try {
      temp =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 1);
    }catch(e){
      UITemplates.showErrorMessage(context, "You disabled library access");
      return null;
    }
    if (temp == null) {
      return null;
    } else {
      File compressedFile = await FlutterNativeImage.compressImage(
        temp.path,
        quality: 2,
      );
      return compressedFile;
    }

// Pick an image.
  }
}
