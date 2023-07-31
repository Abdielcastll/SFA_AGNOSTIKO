// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';

class ClientPicture extends StatelessWidget {
  const ClientPicture({
    Key? key,
    required this.name,
    required this.documentReferenceId,
  }) : super(key: key);

  final String name;
  final String documentReferenceId;

  @override
  Widget build(BuildContext context) {
    print('documentReferenceId: $documentReferenceId');

    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        FutureBuilder<String>(
          future: storage
              .ref()
              .child('imagenes')
              .child('clientes')
              .child(documentReferenceId)
              .child('1')
              .getDownloadURL()
              .catchError((e) {
            print('ERROR ON GETTING IMAGE IN CLIENT DETAILS');
            print(e);
            return e.message;
          }),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final url = snapshot.data!.toString();
              return SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: url,
                  placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      width: 300,
                      child: const Center(child: CircularProgressIndicator())),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/clientphoto.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/images/clientphoto.jpg',
                  fit: BoxFit.cover,
                ),
              );
            } else {
              return const SizedBox(
                height: 275,
                // width: 140,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
        // Container(
        //   margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
        //   child: Stack(
        //     children: [
        //       SizedBox(
        //           width: MediaQuery.of(context).size.width,
        //           child: Stack(
        //             children: <Widget>[
        //               // Stroked text as border.
        //               Text(
        //                 name,
        //                 style: TextStyle(
        //                   fontSize: 24,
        //                   foreground: Paint()
        //                     ..style = PaintingStyle.stroke
        //                     ..strokeWidth = 3
        //                     ..color =
        //                         myTheme.colorScheme.primary.withOpacity(0.5),
        //                 ),
        //               ),
        //               // Solid text as fill.
        //               Text(
        //                 name,
        //                 style: const TextStyle(
        //                   fontSize: 24,
        //                   color: Colors.white,
        //                 ),
        //               ),
        //             ],
        //           )),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
