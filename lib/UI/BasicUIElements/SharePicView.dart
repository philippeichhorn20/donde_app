
import 'package:donde/Classes/Review.dart';
import 'package:donde/UITemplates.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class SharePicView extends StatefulWidget {
  final Review review;
  const SharePicView({Key? key, required Review this.review}) : super(key: key);

  @override
  State<SharePicView> createState() => _SharePicViewState();
}

class _SharePicViewState extends State<SharePicView> {


  Uint8List? picData;

  @override
  void initState() {
    // TODO: implement initState
    transformImage(widget.review);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: MediaQuery.of(context).size.height*.5,
      child: Column(
        children: [
          if(picData != null)
            Expanded(child: Image.memory(picData!)),
          if(picData != null)
            Center(child: UITemplates.loadingAnimation,)
        ],
      ),
    );
  }


  Future<void> transformImage(Review review) async {
    final ui.Codec codec = await ui.instantiateImageCodec(review.pic!);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;

    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint()..color = Colors.white;
    final textStyle = UITemplates.reviewExperienceStyle;

    canvas.drawImage(image, Offset(0,80), Paint(), );
    canvas.drawRect(Rect.fromLTRB(20,  image.height.toDouble()+0, image.width.toDouble()-20, image.height.toDouble()+70), paint, );
    final backgroundTextPainter = TextPainter(
      text: TextSpan(text: review.text, style: textStyle),
      textDirection: TextDirection.ltr,
    );
    backgroundTextPainter.layout();
    backgroundTextPainter.paint(canvas, Offset(30,   image.height.toDouble()+30,));

    final bottomTextPainter = TextPainter(
      text: TextSpan(
        children:  <TextSpan>[
          TextSpan(text: review.spot!.name+"\n",
            style: UITemplates.nameStyle,),
          TextSpan(text:  review.spot!.type.name,
            style: UITemplates.clickableText,
          ),
          TextSpan(text:  "\n" + review.spot!.adress,
            style: UITemplates.descriptionStyle,
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    );
    bottomTextPainter.layout();
    bottomTextPainter.paint(canvas, Offset(0, 0));

    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(350*2, 450*2);
    final data = await img.toByteData(format: ui.ImageByteFormat.png, );
setState(() {
  picData =  data?.buffer.asUint8List();
});
  }
  }
