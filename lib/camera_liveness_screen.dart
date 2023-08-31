import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saas_mlkit/saas_mlkit.dart';

class CameraLivenessScreen extends StatefulWidget {
  final bool testMode;
  final Function(String image)? callback;

  const CameraLivenessScreen({
    this.testMode = false,
    super.key,
    this.callback,
  });

  @override
  State<CameraLivenessScreen> createState() => _CameraLivenessScreenState();
}

class _CameraLivenessScreenState extends State<CameraLivenessScreen> {
  String? captured;
  void actionTakePicture(BuildContext context) async {
    if (cameraController != null) {
      XFile? data = await SaasLivenessHelper().takePicture(
        cameraController!,
      );

      if (data != null) {
        debugPrint('data captured $data');
        XFile? imageCaptured;
        imageCaptured = data;
        File tempImage;
        tempImage = File(
          imageCaptured.path, // DISINI ERRORNYA
        );
        var bytes = await tempImage.readAsBytes();
        captured = base64Encode(bytes);
        debugPrint('tempImage ${tempImage.path}');
        widget.callback!.call(captured!);
        // cameraController?.dispose();
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        //
      }
    }
  }

  void actionTakePictureV2(BuildContext context) async {
    if (cameraController != null) {
      String? data = await SaasLivenessHelper().takePictureAsBase64(
        cameraController!,
      );
      if (data != null) {
        captured = data;
        debugPrint('captured $captured');
        widget.callback!.call(captured!);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        //
      }
    }
  }

  String currentAction = "notyet";
  CameraController? cameraController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.testMode) ? "Flutter Test Liveness FR Test Mode" : "Flutter Test Liveness FR",
          style: GoogleFonts.mukta(),
        ),
      ),
      body: (widget.testMode)
          ? Stack(
              children: [
                SaasLivenessCamera(
                  onControllerCreated: (controller) {
                    cameraController = controller;
                  },
                  child: const OvalClip(),
                  onOpenMouthDetected: (face) {
                    setState(() {
                      currentAction = 'onOpenMouthDetected';
                    });
                    debugPrint("onOpenMouthDetected");
                  },
                  onNodDetected: (face) {
                    setState(() {
                      currentAction = 'onNodDetected';
                    });
                    debugPrint("onNodDetected");
                  },
                  onBlinkDetected: (face) {
                    setState(() {
                      currentAction = 'onBlinkDetected';
                    });
                    debugPrint("onBlinkDetected");
                  },
                  onShakeHeadDetected: (face) {
                    setState(() {
                      currentAction = 'onShakeHeadDetected';
                    });
                    debugPrint("onShakeHeadDetected");
                  },
                  onFaceDetected: (face) {
                    debugPrint("onFaceDetected");
                  },
                  onFaceLoss: () {
                    setState(() {
                      currentAction = 'onFaceLoss';
                    });
                    debugPrint("onFaceLoss");
                  },
                  // onMultipleFaceDetected: () {
                  //   debugPrint("onMultipleFaceDetected");
                  // },
                ),
                Center(
                  child: Container(
                    color: Colors.black,
                    child: Text(
                      // "Flutter Test Liveness Camera",
                      currentAction,
                      style: GoogleFonts.mukta(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // actionTakePicture(context);
                          actionTakePictureV2(context);
                        },
                        child: Text(
                          'Take Picture',
                          style: GoogleFonts.mukta(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            )
          : SaasLivenessCamera(
              onControllerCreated: (controller) {
                cameraController = controller;
              },
              child: const OvalClip(),
              onOpenMouthDetected: (face) {
                debugPrint("onOpenMouthDetected");
              },
              onNodDetected: (face) {
                debugPrint("onNodDetected");
              },
              onBlinkDetected: (face) {
                debugPrint("onBlinkDetected");
              },
              onFaceDetected: (face) {
                debugPrint("onFaceDetected");
              },
              onFaceLoss: () {
                debugPrint("onFaceLoss");
              },
              // onMultipleFaceDetected: () {
              //   debugPrint("onMultipleFaceDetected");
              // },
            ),
    );
  }
}
