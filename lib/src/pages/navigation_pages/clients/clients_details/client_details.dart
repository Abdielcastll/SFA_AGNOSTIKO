// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/clients/clients_details/components/client_header.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/clients/clients_details/components/client_info.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class ClientDetails extends StatefulWidget {
  const ClientDetails(
      {Key? key,
      required this.name,
      required this.address,
      required this.specialContributor,
      required this.phone,
      required this.email,
      required this.clientId,
      this.zone})
      : super(key: key);

  final String name;
  final String address;
  final bool specialContributor;
  final String phone;
  final String email;
  final dynamic clientId;
  final dynamic zone;

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: myTheme.colorScheme.secondary,
        title: Text(
          widget.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color: Colors.grey.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              ClientHeader(),
              ClientInfo(
                name: widget.name,
                address: widget.address,
                specialContributor: widget.specialContributor,
                phone: widget.phone,
                email: widget.email,
                clientId: widget.clientId,
                zone: widget.zone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
