// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ClientPicture extends StatelessWidget {
  const ClientPicture({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        SizedBox(
          height: 275,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            'assets/images/clientphoto.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  name,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 24,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
