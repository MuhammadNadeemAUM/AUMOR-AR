import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ar_location_view/ar_location_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'models/AnnotationsModel.dart';
import 'annotation_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Annotation> annotations = [];
	
  Future<List<AnnotationsModel>> getAnnotations() async {
    try {
		print('READING READING');
      var url = "https://raw.githubusercontent.com/MuhammadNadeemAUM/ARapp/main/Pdfdocuments/annotations.json";
      http.Response response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body.toString());
	  print('READING READING READING');
      if (response.statusCode == 200) {
        log(data.toString());
        List<AnnotationsModel> fetchedAnnotations = [];
        for (var item in data) {
          fetchedAnnotations.add(AnnotationsModel.fromJson(item));
        }
        return fetchedAnnotations;
      } else {
        // Handle error response
        throw Exception('Failed to load annotations');
      }
    } catch (e) {
      // Handle exceptions
      rethrow;
    }
  }

  callAnnotationAPI() async {
    var fetchedAnnotations = await getAnnotations();
    setState(() {
      annotations = fetchedAnnotations.map((model) => Annotation(
        uid: model.name ?? '',
        position: Position(
          latitude: model.latitude?.toDouble() ?? 0.0,
          longitude: model.longitude?.toDouble() ?? 0.0,
          timestamp: DateTime.now(),
          accuracy: 1,
          altitude: 1,
          heading: 1,
          speed: 1,
          speedAccuracy: 1,
          altitudeAccuracy: 1,
          headingAccuracy: 1,
        ),
        type: annotationTypeFromString(model.name ?? ''),
        video: model.video_link ?? '',
        pdf: model.pdf_link ?? '',
      )).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    callAnnotationAPI();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: ArLocationWidget(
            annotations: annotations,
            showDebugInfoSensor: false,
            maxVisibleDistance: 3000,
            annotationViewBuilder: (context, annotation) {
              return AnnotationView(
                key: ValueKey(annotation.uid),
                annotation: annotation as Annotation, // Cast annotation to Annotation type
              );
            },
            onLocationChange: (Position newPosition) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  // Update annotations based on the new position
                  annotations.forEach((annotation) {
                    double distanceInMeters = Geolocator.distanceBetween(
                      newPosition.latitude,
                      newPosition.longitude,
                      annotation.position.latitude,
                      annotation.position.longitude,
                    );
        
                    // For example, let's update the visibility of annotations based on distance
                    if (distanceInMeters <= 3000) {
                      annotation.isVisible = true; // Show annotation if within 1000 meters
                    } else {
                      annotation.isVisible = false; // Hide annotation if further away
                    }
                  });
                });
              });
            },
        
          ),
        ),
      ),
    );
  }

  AnnotationType annotationTypeFromString(String name) {
	
    switch (name) {
      case 'Library':
        return AnnotationType.Library;
		print('Libray');
      case 'Cafeteria':
        return AnnotationType.Cafeteria;
      case 'Admin':
        return AnnotationType.Admin;
		print('MYHOME');
      default:
        return AnnotationType.Library;
    }
  }
}
enum AnnotationType { Library, Admin, Cafeteria }
class Annotation extends ArAnnotation {
  final AnnotationType type;
  final String? video;
  final String? pdf;
  Annotation({required super.uid, required super.position, required this.type, required this.pdf, required this.video});
}
