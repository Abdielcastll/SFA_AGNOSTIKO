import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/galleryCamera.dart';

requestFileBottomSheet(BuildContext context, Function(File) onFileSelected) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(
              Icons.camera_alt,
              color: myTheme.colorScheme.onPrimaryContainer,
            ),
            title: Text(
              'Camara',
              style: TextStyle(
                color: myTheme.colorScheme.primary,
                fontFamily: 'Poppins-regular',
              ),
            ),
            onTap: () async {
              Navigator.of(context).pop();
              var pickedFile = await getFromCamera();
              if (pickedFile != null) {
                print('Imagen seleccionada');
                var croppedImage = await cropImage(pickedFile.path);
                if (croppedImage != null) {
                  print('Imagen recortada');
                  final imageFile = File(croppedImage.path);
                  onFileSelected(imageFile);
                } else {
                  print('Error croppeando');
                }
              } else {
                print('error seleccionando');
                return;
              }
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(
              Icons.photo_camera_back_rounded,
              color: myTheme.colorScheme.onPrimaryContainer,
            ),
            title: Text(
              'Galeria',
              style: TextStyle(
                color: myTheme.colorScheme.primary,
                fontFamily: 'Poppins-regular',
              ),
            ),
            onTap: () async {
              Navigator.of(context).pop();
              var pickedFile = await getFromGallery();
              if (pickedFile != null) {
                print('Imagen seleccionada');
                var croppedImage = await cropImage(pickedFile.path);
                if (croppedImage != null) {
                  print('Imagen recortada');
                  final imageFile = File(croppedImage.path);
                  onFileSelected(imageFile);
                } else {
                  print('Error croppeando');
                }
              } else {
                print('error seleccionando');
                return;
              }
            },
          ),
        ],
      );
    },
  );
}
