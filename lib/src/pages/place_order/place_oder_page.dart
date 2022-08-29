// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/examples/clients_example.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/clients.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_place_order.dart';
import 'package:pwa_sales2go_flutter/src/widgets/bottom_decoratior.dart/bottom_decoration.dart';

class PlaceOrderPage extends StatelessWidget {
  const PlaceOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nuevo Pedido',
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            fontSize: 21,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        backgroundColor: myTheme.colorScheme.primary,
        elevation: 0,
      ),
      bottomNavigationBar: const BottomDecoration(),
      body: SingleChildScrollView(child: PlacerOrderBody()),
    );
  }
}

class PlacerOrderBody extends StatefulWidget {
  const PlacerOrderBody({
    Key? key,
  }) : super(key: key);

  @override
  State<PlacerOrderBody> createState() => _PlacerOrderBodyState();
}

class _PlacerOrderBodyState extends State<PlacerOrderBody> {
  final clientController = TextEditingController();
  List<CLientsExample> clients = allClients;

  identifyStatus(bool status) {
    if (status == true) {
      return Colors.green;
    } else if (status == false) {
      return Colors.red;
    }
  }

  void searchClient(String query) {
    final suggestions = allClients.where((client) {
      final clientName = client.name.toLowerCase();
      final input = query.toLowerCase();
      return clientName.contains(input);
    }).toList();
    setState(() {
      clients = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: myTheme.colorScheme.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                Text(
                  'Selecciona un Cliente',
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: clientController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Feather.search),
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(
                      color: myTheme.colorScheme.primary,
                      fontFamily: 'Poppins-regular',
                    ),
                    hintText: 'Busca un Cliente...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: myTheme.colorScheme.primary),
                    ),
                  ),
                  onChanged: searchClient,
                ),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 16, left: 16, right: 16),
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: clients.length,
              itemBuilder: (context, index) {
                final client = clients[index];
                return Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: myTheme.colorScheme.primary,
                      ),
                    ),
                    title: Text(
                      client.name,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                      ),
                    ),
                    subtitle: Text(
                      client.fiscalAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(
                      Icons.person,
                      color: identifyStatus(client.active),
                      size: 40,
                    ),
                    onTap: () {
                      if (client.active == false) {
                        Fluttertoast.showToast(
                          msg:
                              'El cliente que desea seleccionar no esta disponible',
                          backgroundColor: myTheme.colorScheme.primary,
                          textColor: Colors.white,
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderPage(
                              client: client,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
