// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/examples/clients_example.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class SelectedClient extends StatelessWidget {
  const SelectedClient({
    Key? key,
    required this.client,
    required this.isEditable,
  }) : super(key: key);

  final Clients? client;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(16, 10, 16, 5),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white,
            ),
          ),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 250,
                    margin: EdgeInsets.fromLTRB(14, 8, 0, 0),
                    child: Text(
                      client?.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(14, 0, 0, 10),
                    height: 30,
                    width: 180,
                    child: Text(
                      client?.fiscalAdress,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
              ),
              isEditable
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        child: IconButton(
                          splashRadius: 30,
                          splashColor:
                              myTheme.colorScheme.secondary.withOpacity(0.7),
                          highlightColor:
                              myTheme.colorScheme.secondary.withOpacity(0.3),
                          onPressed: () {
                            // Regresar y elegir otro cliente
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Feather.edit,
                            color: myTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Divider(
                thickness: 2,
                height: 10,
                color: myTheme.colorScheme.secondary.withOpacity(0.2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
