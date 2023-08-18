import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_saas_mlkit/camera_liveness_screen.dart';
import 'package:flutter_test_saas_mlkit/camera_ocr_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saas_mlkit/saas_mlkit.dart';

class HomeScreen extends StatefulWidget {
  final int motionCount;
  final Function(String)? onSuccess;
  final Function(String)? onFailed;

  const HomeScreen({
    super.key,
    required this.motionCount,
    this.onSuccess,
    this.onFailed,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CameraController? cameraController;
  bool faceFound = false;
  List<List<dynamic>>? selectedMotion;
  int motionProgress = 0;

  String? dataOcr;

  String? dataGambar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Flutter Test Liveness",
          style: GoogleFonts.mukta(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              (dataGambar != null)
                  ? Container(
                      height: 100,
                      width: 100,
                      color: Colors.blue,
                      child: Image.memory(
                        base64Decode(dataGambar!),
                      ),
                    )
                  : const SizedBox(),
              (dataOcr != null)
                  ? Text(
                      "dataOcr $dataOcr",
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * .35,
                    ),
              Text(
                "Flutter Test Liveness",
                style: GoogleFonts.mukta(),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const SaasOCRCameraMLKitVer();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Test OCR ML Kit",
                      style: GoogleFonts.mukta(),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const CameraOCRScreen(
                              testMode: false,
                            );
                            // return const QoinSaasOCRCameraMLKitVer();
                            // return CameraScreenTest();
                            // return Test2Widget();
                            // return const CameraScreen(
                            //   testMode: false,
                            // );
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Test OCR",
                      style: GoogleFonts.mukta(),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        dataOcr = null;
                        dataGambar = null;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CameraOCRScreen(
                              testMode: true,
                              callback: (String? textDetected) {
                                setState(() {
                                  dataOcr = textDetected;
                                });
                              },
                              callbackImage: (String? image) {
                                if (image == null || image == "") {
                                  // 
                                } else {
                                  setState(() {
                                    dataGambar = image;
                                  });
                                }
                              },
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Test OCR Test Mode",
                      style: GoogleFonts.mukta(),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        dataGambar = null;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CameraLivenessScreen(
                              testMode: false,
                              callback: (String image) {
                                setState(() {
                                  dataGambar = image;
                                });
                              },
                            );
                            // return const TextRecognizerView();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Test Liveness (Face Recognition)",
                      style: GoogleFonts.mukta(),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        dataGambar = null;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CameraLivenessScreen(
                              testMode: true,
                              callback: (String image) {
                                setState(() {
                                  dataGambar = image;
                                });
                              },
                            );
                            // return const TextRecognizerView();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Test Liveness (Face Recognition) Test Mode",
                      style: GoogleFonts.mukta(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
