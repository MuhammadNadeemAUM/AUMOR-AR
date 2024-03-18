import 'package:arapp/pdf_viewer.dart';
import 'package:arapp/video_player.dart';
import 'package:flutter/material.dart';
import 'main.dart';
class AnnotationView extends StatefulWidget {
  const AnnotationView({Key? key, required this.annotation,}) : super(key: key);
  final Annotation annotation;

  @override
  State<AnnotationView> createState() => _AnnotationViewState();
}

class _AnnotationViewState extends State<AnnotationView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showMenu(context, widget.annotation.type.toString().substring(15), widget.annotation.video, widget.annotation.pdf);// Pass annotation name
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                child: typeFactory(widget.annotation.type),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.annotation.type.toString().substring(15),
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.annotation.distanceFromUser.toInt()} m',
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget typeFactory(AnnotationType type) {
    IconData iconData = Icons.ac_unit_outlined;
    Color color = Colors.teal;
    switch (type) {
      case AnnotationType.Library:
        iconData = Icons.local_library_outlined;
        color = Colors.red;
        break;
      case AnnotationType.Cafeteria:
        iconData = Icons.food_bank_outlined;
        color = Colors.green;
        break;
      case AnnotationType.Admin:
        iconData = Icons.person_pin_outlined;
        color = Colors.blue;
        break;
    }
    return Icon(
      iconData,
      size: 40,
      color: color,
    );
  }

  void _showMenu(BuildContext context, String annotationName, String? video, String? pdf) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(annotationName), // Use annotation name as title
          content: Text('Choose an action:'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Show video action
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VideoApp(videoLink: video,)),
                );
                // Close dialog
                // Implement logic to show video
                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => VideoScreen()));
              },
              child: Text('Show Video'),
            ),
            TextButton(
              onPressed: () {
                // Show document action
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PDFView(pdfLink: pdf,)),
                ); // Close dialog
                // Implement logic to show document
                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentScreen()));
              },
              child: Text('Show Document'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
