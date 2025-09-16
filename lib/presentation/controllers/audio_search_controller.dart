import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class AudioSearchController extends GetxController {
  final SpeechToText _speech = SpeechToText();

  final RxBool isListening = false.obs;
  final RxBool isAvailable = false.obs;
  final RxString recognizedText = ''.obs;
  final RxString partialText = ''.obs;
  final RxDouble confidence = 0.0.obs;
  final RxString localeId = ''.obs;
  final RxDouble soundLevel = 0.0.obs;
  final RxString lastError = ''.obs;
  final RxString lastStatus = ''.obs;

  // Callback function to handle search results
  Function(String)? onSearchTextReceived;

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      isAvailable.value = await _speech.initialize(
        onError: _errorListener,
        onStatus: _statusListener,
        debugLogging: true,
      );

      if (isAvailable.value) {
        final locales = await _speech.locales();
        // Try to find French locale, fallback to system default
        final frenchLocale =
            locales
                .where(
                  (locale) =>
                      locale.localeId.startsWith('fr') ||
                      locale.localeId.startsWith('fr_'),
                )
                .firstOrNull;

        localeId.value = frenchLocale?.localeId ?? locales.first.localeId;
      }
    } catch (e) {
      debugPrint('Error initializing speech recognition: $e');
      isAvailable.value = false;
    }
  }

  Future<void> startListening() async {
    if (!isAvailable.value) {
      await _initSpeech();
      if (!isAvailable.value) {
        Get.snackbar(
          'Erreur',
          'La reconnaissance vocale n\'est pas disponible',
        );
        return;
      }
    }

    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) {
      Get.snackbar('Erreur', 'Permission microphone requise');
      return;
    }

    try {
      recognizedText.value = '';
      partialText.value = '';
      confidence.value = 0.0;
      lastError.value = '';
      lastStatus.value = '';

      await _speech.listen(
        onResult: _resultListener,
        onSoundLevelChange: _soundLevelListener,
        localeId: localeId.value,
        listenFor: const Duration(seconds: 60),
        pauseFor: const Duration(seconds: 3),
        listenOptions: SpeechListenOptions(
          partialResults: true,
          cancelOnError: false,
          onDevice: false,
          autoPunctuation: true,
          enableHapticFeedback: true,
        ),
      );

      isListening.value = true;
    } catch (e) {
      debugPrint('Error starting speech recognition: $e');
      Get.snackbar('Erreur', 'Échec du démarrage de la reconnaissance vocale');
    }
  }

  void _resultListener(SpeechRecognitionResult result) {
    debugPrint(
      'Speech recognition result: ${result.recognizedWords} - final: ${result.finalResult}',
    );

    if (result.finalResult) {
      recognizedText.value = result.recognizedWords;
      partialText.value = '';
      confidence.value = result.confidence;

      // Call the callback function with the recognized text
      if (onSearchTextReceived != null) {
        onSearchTextReceived!(result.recognizedWords);
      }
    } else {
      partialText.value = result.recognizedWords;
    }
  }

  void _soundLevelListener(double level) {
    debugPrint('Sound level: $level');
    // Normalize the sound level to make it more visible
    // The level ranges from -2 to 10, so we'll map it to 0-1
    double normalizedLevel = ((level + 2) / 12).clamp(0.0, 1.0);
    soundLevel.value = normalizedLevel;
  }

  void _errorListener(SpeechRecognitionError error) {
    debugPrint('Speech recognition error: ${error.errorMsg}');
    lastError.value = '${error.errorMsg} - ${error.permanent}';
    isListening.value = false;

    // Close bottom sheet on error
    Future.delayed(const Duration(milliseconds: 500), () {
      if (Get.isBottomSheetOpen == true) {
        Get.back();
      }
    });
  }

  void _statusListener(String status) {
    debugPrint('Speech recognition status: $status');
    lastStatus.value = status;

    if (status == 'done' ||
        status == 'notListening' ||
        status == 'doneNoResult') {
      isListening.value = false;
      debugPrint('Speech recognition finished with status: $status');
      debugPrint('Final recognized text: ${recognizedText.value}');
    }
  }

  Future<void> stopListening() async {
    try {
      await _speech.stop();
      isListening.value = false;
      soundLevel.value = 0.0;
    } catch (e) {
      debugPrint('Error stopping speech recognition: $e');
    }
  }

  Future<void> cancelListening() async {
    try {
      await _speech.cancel();
      isListening.value = false;
      soundLevel.value = 0.0;
      recognizedText.value = '';
      partialText.value = '';
    } catch (e) {
      debugPrint('Error canceling speech recognition: $e');
    }
  }

  String getCurrentText() {
    return partialText.value.isNotEmpty
        ? partialText.value
        : recognizedText.value;
  }

  void clearText() {
    recognizedText.value = '';
    partialText.value = '';
    confidence.value = 0.0;
    lastError.value = '';
    lastStatus.value = '';
  }

  void setSearchCallback(Function(String) callback) {
    onSearchTextReceived = callback;
  }

  @override
  void onClose() {
    _speech.cancel();
    super.onClose();
  }
}
