import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled1/events.dart';
import 'package:untitled1/states.dart';

class TextRecognitionBloc extends Bloc<TextRecognitionEvent, TextRecognitionState> {
  final ImagePicker _imagePicker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();

  TextRecognitionBloc() : super(TextRecognitionInitial()) {
    on<PickImageEvent>((event, emit) async {
      try{
        emit(TextRecognitionLoading());
        final XFile? pickedFile = await _imagePicker.pickImage(
            source: event.source,
        );

        if(pickedFile != null) {
          final File imageFile = File(pickedFile.path);
          final InputImage inputImage = InputImage.fromFile(imageFile);

          final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
          emit(TextRecognitionSuccess(imageFile, recognizedText.text));
        }else {
          emit(TextRecognitionInitial());
        }
      }catch(e) {
        emit(TextRecognitionError(e.toString()));
      }
    });

    on<ClearImageEvent>((event, emit) {
      emit(TextRecognitionInitial());
    });
  }

}