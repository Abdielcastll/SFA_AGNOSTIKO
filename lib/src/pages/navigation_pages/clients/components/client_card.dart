import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/clients/clients_details/client_details.dart';

class ClientCard extends StatefulWidget {
  const ClientCard({
    Key? key,
    required this.name,
    required this.phone,
    required this.email,
    required this.active,
    required this.address,
    required this.specialContributor,
    required this.clientId,
    this.zone,
  }) : super(key: key);

  final String name;
  final String phone;
  final String email;
  final bool active;
  final String address;
  final bool specialContributor;
  final dynamic clientId;
  final dynamic zone;

  @override
  State<ClientCard> createState() => _ClientCardState();
}

class _ClientCardState extends State<ClientCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          print('tappeada tarjeta para acceder al cliente');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ClientDetails(
                name: widget.name,
                address: widget.address,
                specialContributor: widget.specialContributor,
                phone: widget.phone,
                email: widget.email,
                clientId: widget.clientId,
                zone: widget.zone,
              ),
            ),
          );
        },
        child: Container(
          width: 360.0,
          height: 68.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10.0, top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Text(
                        widget.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    SizedBox(
                      width: 150,
                      child: Text(
                        widget.email,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey[500]?.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.0),
              Padding(
                padding: EdgeInsets.only(top: 27),
                child: SizedBox(
                  width: 120,
                  height: 50,
                  child: Text(
                    widget.phone,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[500]?.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Icon(Icons.arrow_forward_ios),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    margin: EdgeInsets.only(
                      right: 10,
                    ),
                    child: Text(
                      widget.active ? 'Activo' : 'Inactivo',
                      style: widget.active
                          ? TextStyle(
                              fontSize: 12.0,
                              color: Colors.green[500]?.withOpacity(0.8))
                          : TextStyle(
                              fontSize: 12.0,
                              color: Colors.red[500]?.withOpacity(0.8),
                            ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
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
