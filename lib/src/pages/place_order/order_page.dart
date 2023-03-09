import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_rol_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/selected_client.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/selected_products.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_orderd.dart';

/* class OrderPage extends StatefulWidget {
  const OrderPage({
    Key? key,
  }) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
} */

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderActive = Provider.of<OrderProvider>(context);
    final currentClientForTheOrder =
        Provider.of<OrderProvider>(context).clientForTheOrder;
    final user = Provider.of<CurrentUserInfo?>(context, listen: true);
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: const AppBarOrder(),
      body: WillPopScope(
        onWillPop: () async {
          orderActive.orderActive == true
              ? Navigator.popUntil(context, (route) => route.isFirst)
              : Navigator.pop(context);
          return false;
        },
        child: FutureProvider<UserRole?>.value(
            value: user?.getUserRole(),
            initialData: null,
            catchError: (context, error) {
              print(error);
              return;
            },
            // builder: (context, child) {

            //   return NavigationPages();
            // });
            child: SingleChildScrollView(
              child: Container(
                // color: Colors.red,
                child: Column(
                  children: [
                    SelectedClient(
                        client: currentClientForTheOrder, isEditable: true),
                    SelectedProducts(client: currentClientForTheOrder),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
