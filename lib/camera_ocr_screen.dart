import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_saas_mlkit/ocr_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saas_mlkit/saas_mlkit.dart';

class CameraOCRScreen extends StatefulWidget {
  final bool testMode;
  final Function(String? textDetected)? callback;
  final Function(String? mapping)? callbackKTPMapping;
  final Function(String? image)? callbackImage;
  final Function(String? image)? callbackImageCard;

  const CameraOCRScreen({
    super.key,
    this.callback,
    this.callbackKTPMapping,
    this.callbackImage,
    this.callbackImageCard,
    this.testMode = false,
  });

  @override
  State<CameraOCRScreen> createState() => _CameraOCRScreenState();
}

class _CameraOCRScreenState extends State<CameraOCRScreen> {
  CameraController? cameraController;
  bool isLoadingScreen = false;

  // @override
  // void dispose() {
  //   // cameraController!.dispose();
  //   // cameraController = null;
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.testMode ? "Flutter Test OCR Camera Test Mode" : "Flutter Test OCR Camera",
          style: GoogleFonts.mukta(),
        ),
      ),
      body: (widget.testMode)
          ? Stack(
              children: [
                SaasOCRCamera(
                  captureButton: Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.bottomCenter,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(6.81),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF6F6F6F),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  onControllerCreated: (controller) {
                    cameraController = controller;
                  },
                  onTakePict: (String base64Image) {
                    // debugPrint('data base64Image $base64Image');
                    widget.callbackImageCard?.call(base64Image);
                  },
                  croppedFaceCard: (String? base64Image) {
                    widget.callbackImage?.call(base64Image);
                  },
                  onTextDetected: (RecognizedText recognizedText) async {
                    KTPData? handler = await compute(
                      OCRHandler().recognizedText,
                      recognizedText,
                    );
                    debugPrint('data recognizedText ${handler?.toJson()}');
                    widget.callback?.call(handler!.toJson().toString());
                    Navigator.pop(context);

                    // widget.callback?.call(recognizedText.text);
                    // // debugPrint('data recognizedText ${recognizedText.text}');
                    // Navigator.pop(context);
                  },
                  onKTPDetected: (KTPData ktpData) {
                    debugPrint('data ktpData ${ktpData.toJson()}');
                    widget.callbackKTPMapping?.call(ktpData.toJson().toString());
                  },
                  onSIMDetected: (SIMData simData) {
                    debugPrint('data simData ${simData.toJson()}');
                  },
                  onPassportDetected: (UserDataFromPassportModel passportData) {
                    debugPrint('data passportData ${passportData.toJson()}');
                  },
                  onLoading: (bool isLoading) {
                    debugPrint('isLoading now $isLoading');
                    setState(() {
                      isLoadingScreen = isLoading;
                    });
                  },
                ),
                if (isLoadingScreen)
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Proses Sedang Berlangsung',
                          style: GoogleFonts.mukta(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            )
          : Stack(
              children: [
                SaasOCRCamera(
                  onControllerCreated: (controller) {
                    cameraController = controller;
                  },
                  onTakePict: (String base64Image) {
                    debugPrint('data base64Image $base64Image');
                  },
                  onTextDetected: (RecognizedText recognizedText) {
                    debugPrint('data recognizedText ${recognizedText.text}');
                  },
                ),
              ],
            ),
    );
  }
}
