// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard(
      {Key? key,
      this.name,
      this.orderId,
      this.date,
      this.total,
      this.salesman,
      required this.completed})
      : super(key: key);

  final name;
  final orderId;
  final date;
  final total;
  final bool completed;
  final salesman;

  identifyColor() {
    if (completed == false) {
      return Colors.amber.shade300;
    } else if (completed == true) {
      return Colors.green;
    }
  }

  identifyStatus() {
    if (completed == false) {
      return 'En proceso';
    } else if (completed == true) {
      return 'Facturado';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Redireccionar a detalles de factura');
        // Redireccionar a detallesd e la factura
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
                  Padding(
                    padding: EdgeInsets.only(left: 14, top: 10),
                    child: Text(
                      salesman,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 100),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      total,
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
                        orderId,
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
                        'Fecha: $date',
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
                        identifyStatus(),
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
