import 'package:example/main.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:ui' as ui show Image;

class PaintImageDemo extends StatefulWidget {
  @override
  _PaintImageDemoState createState() => _PaintImageDemoState();
}

class _PaintImageDemoState extends State<PaintImageDemo> {
  BoxShape boxShape;

  @override
  void initState() {
    boxShape = BoxShape.circle;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var url = imageTestUrl;
    return Material(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("ImageDemo"),
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                child: Text("BoxShape.circle"),
                onPressed: () {
                  setState(() {
                    boxShape = BoxShape.circle;
                  });
                },
              ),
              Expanded(
                child: Container(),
              ),
              RaisedButton(
                child: Text("BoxShape.rectangle"),
                onPressed: () {
                  setState(() {
                    boxShape = BoxShape.rectangle;
                  });
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                child: Text("clear all cache"),
                onPressed: () {
                  clearDiskCachedImages().then((bool done) {
                    showToast(done ? "clear succeed" : "clear failed",
                        position: ToastPosition(align: Alignment.topCenter));
                  });
                },
              ),
              Expanded(
                child: Container(),
              ),
              RaisedButton(
                child: Text("save network image to photo"),
                onPressed: () {
                  saveNetworkImageToPhoto(url).then((bool done) {
                    showToast(done ? "save succeed" : "save failed",
                        position: ToastPosition(align: Alignment.topCenter));
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: Align(
              child: ExtendedImage.network(
                url,
                width: ScreenUtil.instance.setWidth(400),
                height: ScreenUtil.instance.setWidth(400),
                fit: BoxFit.fill,
                cache: true,
                beforePaintImage: (
                    {@required Canvas canvas,
                    @required Rect rect,
                    @required ui.Image image}) {},
                afterPaintImage: (
                    {@required Canvas canvas,
                    @required Rect rect,
                    @required ui.Image image}) {
                  canvas.drawLine(rect.topLeft, rect.bottomRight,
                      Paint()..color = Colors.red);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
