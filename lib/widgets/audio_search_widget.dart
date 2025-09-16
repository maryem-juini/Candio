// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../presentation/controllers/audio_search_controller.dart';

class AudioSearchWidget extends StatelessWidget {
  final Function(String) onSearchTextReceived;
  final String hintText;
  final TextEditingController? textController;
  final bool showTextField;

  const AudioSearchWidget({
    super.key,
    required this.onSearchTextReceived,
    this.hintText = 'Rechercher...',
    this.textController,
    this.showTextField = true,
  });

  @override
  Widget build(BuildContext context) {
    final audioController = Get.put(AudioSearchController());

    // Set the callback for search results
    audioController.setSearchCallback(onSearchTextReceived);

    return Column(
      children: [
        if (showTextField) ...[
          // Search Text Field with Microphone Button
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: onSearchTextReceived,
                  ),
                ),
                // Microphone Button
                Obx(
                  () => IconButton(
                    onPressed:
                        () => _showVoiceSearchBottomSheet(
                          context,
                          audioController,
                        ),
                    icon: Icon(
                      Icons.mic,
                      color:
                          audioController.isListening.value
                              ? Theme.of(context).primaryColor
                              : Colors.grey[600],
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ] else ...[
          // Standalone Microphone Button
          Obx(
            () => GestureDetector(
              onTap:
                  () => _showVoiceSearchBottomSheet(context, audioController),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color:
                      audioController.isListening.value
                          ? Theme.of(context).primaryColor
                          : Colors.grey[200],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.mic,
                  color:
                      audioController.isListening.value
                          ? Colors.white
                          : Colors.grey[600],
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showVoiceSearchBottomSheet(
    BuildContext context,
    AudioSearchController audioController,
  ) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                "Recherche vocale",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // Microphone Icon with Animation
              Obx(() => _buildMicrophoneAnimation(audioController)),
              const SizedBox(height: 20),

              // Status Text
              Obx(() => _buildStatusText(audioController)),
              const SizedBox(height: 20),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      audioController.cancelListening();
                    },
                    child: const Text("Annuler"),
                  ),
                  Obx(
                    () => ElevatedButton(
                      onPressed:
                          audioController.isListening.value
                              ? () async {
                                final navigatorContext = context;
                                await audioController.stopListening();
                                if (navigatorContext.mounted) {
                                  Navigator.pop(navigatorContext);
                                }
                              }
                              : () async {
                                await audioController.startListening();
                              },
                      child: Text(
                        audioController.isListening.value
                            ? "Arrêter"
                            : "Commencer",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMicrophoneAnimation(AudioSearchController audioController) {
    return Builder(
      builder:
          (context) => SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (audioController.isListening.value) ...[
                  // Animated circles
                  Obx(
                    () => AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeOut,
                      width: 80 + (audioController.soundLevel.value * 60),
                      height: 80 + (audioController.soundLevel.value * 60),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor.withOpacity(
                          audioController.soundLevel.value * 0.2,
                        ),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                ],
                // Center microphone icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color:
                        audioController.isListening.value
                            ? Theme.of(context).primaryColor
                            : Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mic,
                    color:
                        audioController.isListening.value
                            ? Colors.white
                            : Colors.grey[600],
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildStatusText(AudioSearchController audioController) {
    return Builder(
      builder: (context) {
        String statusText;
        Color statusColor = Theme.of(context).primaryColor;

        if (audioController.isListening.value) {
          statusText = "Parlez maintenant...";
        } else if (audioController.recognizedText.value.isNotEmpty) {
          statusText = "Texte reconnu: ${audioController.recognizedText.value}";
          statusColor = Colors.green;
        } else if (audioController.lastError.value.isNotEmpty) {
          statusText = "Erreur: ${audioController.lastError.value}";
          statusColor = Colors.red;
        } else {
          statusText = "Appuyez sur Commencer pour parler";
        }

        return Text(
          statusText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: statusColor,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
