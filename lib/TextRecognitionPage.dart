import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled1/bloc.dart';
import 'package:untitled1/events.dart';
import 'package:untitled1/states.dart';

class TextRecognitionPage extends StatelessWidget {
  const TextRecognitionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Text Recognition App',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        backgroundColor: Colors.black12,
        centerTitle: true,
      ),
      body: BlocBuilder<TextRecognitionBloc, TextRecognitionState>(
        builder: (context, state) {
          File? imageFile;
          String extractedText = '';

          // Success State
          if (state is TextRecognitionSuccess) {
            imageFile = state.image;
            extractedText = state.recognizedText;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context
                            .read<TextRecognitionBloc>()
                            .add(PickImageEvent(ImageSource.camera)),
                        icon: const Icon(Icons.camera_alt, color: Colors.blue),
                        label: const Text(
                          'Camera',
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.blue, width: 2),
                          backgroundColor: Colors.grey[50],
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context
                            .read<TextRecognitionBloc>()
                            .add(PickImageEvent(ImageSource.gallery)),
                        icon: const Icon(Icons.photo, color: Colors.green),
                        label: const Text(
                          'Gallery',
                          style: TextStyle(fontSize: 20, color: Colors.green),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[50],
                          side: BorderSide(color: Colors.green, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                //Image Box
                Container(
                  height: 320,
                  width: double.infinity,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),

                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),

                  child: state is TextRecognitionLoading
                      // LOADING
                      ? const Center(child: CircularProgressIndicator())
                      // IMAGE WITH X BUTTON
                      : imageFile != null
                      ? Stack(
                          children: [
                            // IMAGE
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),

                              child: SizedBox(
                                width: double.infinity,
                                height: double.infinity,

                                child: Image.file(imageFile, fit: BoxFit.cover),
                              ),
                            ),

                            // X BUTTON
                            Positioned(
                              top: 12,
                              right: 12,

                              child: GestureDetector(
                                onTap: () {
                                  context.read<TextRecognitionBloc>().add(
                                    ClearImageEvent(),
                                  );
                                },

                                child: Container(
                                  padding: const EdgeInsets.all(8),

                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    shape: BoxShape.circle,
                                  ),

                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      // DEFAULT UI
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),

                            const SizedBox(height: 20),

                            Text(
                              'Select an image',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                ),

                const SizedBox(height: 30),

                //Text Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),

                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        'Extracted Text:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ERROR
                      if (state is TextRecognitionError)
                        Text(
                          state.message,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        )
                      // SUCCESS
                      else if (state is TextRecognitionSuccess)
                        Text(
                          extractedText.isNotEmpty
                              ? extractedText
                              : 'No text found',

                          style: const TextStyle(fontSize: 18),
                        )
                      // INITIAL
                      else
                        Text(
                          'Text will appear here after processing',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          );
        },
      ),
    );
  }
}
