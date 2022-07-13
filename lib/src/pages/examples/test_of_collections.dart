import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';
import 'package:pwa_sales2go_flutter/src/services/database.dart';

class CollectionsExample extends StatefulWidget {
  CollectionsExample({Key? key}) : super(key: key);

  @override
  State<CollectionsExample> createState() => _CollectionsExampleState();
}

class _CollectionsExampleState extends State<CollectionsExample> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<ProductModel>?>.value(
      initialData: null,
      value: DatabaseService().products,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Products test'),
          backgroundColor: Colors.brown.shade400,
          elevation: 0.0,
          actions: [
            ElevatedButton.icon(
              onPressed: () async {
                // sign out
                await _auth.signOut();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.brown.shade400,
                elevation: 0.0,
                shadowColor: Colors.transparent,
              ),
              icon: Icon(Icons.person),
              label: Text('Logout'),
            ),
          ],
        ),
        body: CollectionListExample(),
      ),
    );
  }
}

class CollectionListExample extends StatefulWidget {
  const CollectionListExample({
    Key? key,
  }) : super(key: key);

  @override
  State<CollectionListExample> createState() => _CollectionListExampleState();
}

class _CollectionListExampleState extends State<CollectionListExample> {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<ProductModel>?>(context) ?? [];
    final stock = Provider.of<List<StockModel>?>(context) ?? [];

    // Check if there is data inside the streams
    for (var stock in stock) {
      print(stock.stock);
    }

    // if (products != null) {
    //   for (var product in products) {
    //     // print(product.name);
    //     // print(product.id);
    //     print(product.brand);
    //   }
    // }
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return CollectionTile(
          product: products[index],
        );
      },
    );
  }
}

class CollectionTile extends StatefulWidget {
  const CollectionTile({
    Key? key,
    this.product,
  }) : super(key: key);

  final ProductModel? product;

  @override
  State<CollectionTile> createState() => _CollectionTileState();
}

class _CollectionTileState extends State<CollectionTile> {
  @override
  Widget build(BuildContext context) {
    print('//////// datos que llegan para las tiles ////////');
    print(widget.product?.name);
    print(widget.product?.id);
    print(widget.product?.quality);
    print('//////////////////////////////////');
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.only(top: 8),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.brown[300],
          ),
          title: Text(widget.product!.name),
          subtitle: Text(
              'ID ${widget.product!.id} and Quality ${widget.product!.quality}'),
        ),
      ),
    );
  }
}
