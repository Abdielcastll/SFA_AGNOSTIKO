import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/galleryCamera.dart';

requestFileBottomSheet(BuildContext context, Function(File) onFileSelected) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(
              Icons.camera_alt,
              color: themeProvider.myTheme.colorScheme.onPrimaryContainer,
            ),
            title: Text(
              'Camara',
              style: TextStyle(
                color: themeProvider.myTheme.colorScheme.primary,
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
              color: themeProvider.myTheme.colorScheme.onPrimaryContainer,
            ),
            title: Text(
              'Galeria',
              style: TextStyle(
                color: themeProvider.myTheme.colorScheme.primary,
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
