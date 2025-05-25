import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  final _pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  File? imagePath = File(_pickedImage!.path);
  if (imagePath == null) {
    return null;
  }
  return imagePath!;
}

Future<String> ImageToString(File image) async {
  List<int> convertasbyt = await image.readAsBytes();
  return base64Encode(convertasbyt);
}

Uint8List StringToImage(String imageString) {
  Uint8List convertedImage = base64Decode(imageString);
  return convertedImage;
}
