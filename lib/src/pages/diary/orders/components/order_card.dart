// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({
    Key? key,
    this.name,
    this.clientId,
    this.orderId,
    this.date,
    this.total,
    this.completed,
    this.failed,
  }) : super(key: key);

  final name;
  final clientId;
  final orderId;
  final date;
  final total;
  final completed;
  final failed;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  identifyStatusColor() {
    if (widget.completed == 'true' && widget.failed == 'false') {
      return Colors.green;
    } else if (widget.completed == 'true' && widget.failed == 'true') {
      return Colors.red;
    } else if (widget.completed == 'false' && widget.failed == 'false') {
      return Colors.amber.shade300;
    }
  }

  identifyStatus() {
    if (widget.completed == 'true' && widget.failed == 'false') {
      return 'Completado';
    } else if (widget.completed == 'true' && widget.failed == 'true') {
      return 'Fallido';
    } else if (widget.completed == 'false' && widget.failed == 'false') {
      return 'En proceso';
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.name);
    print(widget.clientId);
    print(widget.orderId);
    print(widget.date);
    print(widget.total);
    print(widget.completed);
    print(widget.failed);

    return GestureDetector(
      onTap: () {
        // Redireccionar a detalles del pedido
        print('Redireccionar a detalles de pedido');
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
                      widget.name,
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
                      '\$${widget.total}',
                      style: TextStyle(
                        color: identifyStatusColor(),
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
                        widget.orderId,
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
                        'Hora: ${widget.date}',
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
                          color: identifyStatusColor(),
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
