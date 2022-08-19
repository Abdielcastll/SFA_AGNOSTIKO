// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      appBar: AppBarPlaceOrder(),
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
  List<Client> clients = allClients;

  identifyStatus(String status) {
    if (status == 'active') {
      return Colors.green;
    } else if (status == 'unactive') {
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
    print(clients);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: myTheme.colorScheme.secondary,
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
                      color: myTheme.colorScheme.secondary,
                      fontFamily: 'Poppins-regular',
                    ),
                    hintText: 'Busca un Cliente...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: myTheme.colorScheme.secondary),
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
                        color: myTheme.colorScheme.secondary,
                      ),
                    ),
                    title: Text(
                      client.name,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                      ),
                    ),
                    subtitle: Text(
                      client.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(
                      Icons.person,
                      color: identifyStatus(client.status),
                      size: 40,
                    ),
                    onTap: () {
                      if (client.status == 'unactive') {
                        Fluttertoast.showToast(
                          msg:
                              'El cliente que desea seleccionar no esta disponible',
                          backgroundColor: myTheme.colorScheme.secondary,
                          textColor: Colors.white,
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderPage(
                              clientName: client.name,
                              clientAddress: client.address,
                              clientStatus: client.status,
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
