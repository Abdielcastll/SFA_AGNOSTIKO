// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ShowProductPics extends StatelessWidget {
  const ShowProductPics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 328.0,
            height: 328.0,
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: FadeInImage(
                image: NetworkImage(
                  'https://i.pinimg.com/474x/39/0d/cc/390dccf32a0ee4023cf7c56979133283.jpg',

                  // fit: BoxFit.cover,
                ),
                placeholder: AssetImage('assets/images/loading.gif'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
