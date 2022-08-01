// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class VisitCard extends StatelessWidget {
  const VisitCard({
    Key? key,
    this.name,
    this.adress,
    this.hour,
    this.date,
    this.status,
  }) : super(key: key);

  final name;
  final adress;
  final hour;
  final date;
  final status;

  identifyColor() {
    if (status == 'On process') {
      return Colors.amber.shade300;
    } else if (status == 'Completed') {
      return Colors.green;
    } else if (status == 'Cancelled') {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(date);
    return GestureDetector(
      onTap: () {
        print('Redireccionar a detalles de visita');
        // Redireccionar a detallesd e la visita
      },
      child: Padding(
        padding: EdgeInsets.only(top: 5, left: 16, right: 16, bottom: 5),
        child: Container(
          width: 360.0,
          height: 63,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 14, top: 10),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 150),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      date,
                      style: TextStyle(
                        color: identifyColor(),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 14),
                    child: Container(
                      height: 13,
                      width: 150,
                      child: Text(
                        adress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      height: 13,
                      width: 95,
                      child: Text(
                        'Hora: $hour',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      height: 13,
                      width: 60,
                      child: Text(
                        status,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: identifyColor(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
