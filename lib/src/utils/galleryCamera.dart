import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future getFromGallery() async {
  try {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile;
    } else {
      return;
    }
  } on PlatformException catch (e) {
    print('ERROR ESCOGIENDO IMAGEN');
    print(e);
  }
}

Future cropImage(String filePath) async {
  CroppedFile? croppedImage = await ImageCropper().cropImage(
    sourcePath: filePath,
    maxHeight: 1080,
    maxWidth: 1080,
  );
  if (croppedImage != null) {
    return croppedImage;
  }
}

Future getFromCamera() async {
  try {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return pickedFile;
    } else {
      return;
    }
  } on PlatformException catch (e) {
    print('ERROR ESCOGIENDO IMAGEN');
    print(e);
  }
}
