import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';

class NewBardcodeScanner extends StatefulWidget {
  const NewBardcodeScanner(
      {super.key, required this.clientPriceList, required this.products});

  final clientPriceList;
  final List<ShoppingCartProduct>? products;

  @override
  State<NewBardcodeScanner> createState() => _NewBardcodeScannerState();
}

class _NewBardcodeScannerState extends State<NewBardcodeScanner> {
  addProductFromBarcodeResult(
      String? scanResult, List<ShoppingCartProduct>? productsInCart) async {
    print('productsInCart: $productsInCart');
    final String? productScanResult = scanResult;
    print('BARCODE SCAN RESULT: ////////////////////////');
    print('ScanResult: $scanResult');
    List<ShoppingCartProduct> scannedProducts = [];
    try {
      final stockProducts = await FirebaseFirestore.instance
          .collection('stock')
          .doc('productos')
          .get()
          .then(
        (value) {
          return value['valores'];
        },
      );
      print(stockProducts);
      final priceProducts = await FirebaseFirestore.instance
          .collection('listas_de_precios')
          .doc(widget.clientPriceList.toString())
          .get()
          .then((value) {
        return value['precios'];
      });
      print(priceProducts);

      await FirebaseFirestore.instance
          .collection('productos')
          .doc(productScanResult)
          .get()
          .then((doc) {
        const stock = 999;
        const productQuantity = 1;
        final code = doc.data().toString().contains('codigo')
            ? doc.get('codigo')
            : 'NaN';
        final pricesList = widget.clientPriceList;
        final name = doc.data().toString().contains('nombre')
            ? doc.get('nombre')
            : 'NaN';
        final catalogue = doc.data().toString().contains('catalogo')
            ? doc.get('catalogo').id
            : 'NaN';
        final productPrice = priceProducts[doc.get('codigo')] ?? '0';
        final productTotalAmount = productPrice * productQuantity;

        print('stock:$stock');
        print('productQuantity:$productQuantity');
        print('code:$code');
        print('pricesList:$pricesList');
        print('name:$name');
        print('catalogue:$catalogue');
        print('productPrice:$productPrice');
        print('productTotalAmount:$productTotalAmount');

        if (productsInCart!.isEmpty) {
          print('Kaede empty');
          final result = ShoppingCartProduct(
            availableStock: stock,
            productQuantity: productQuantity,
            code: code,
            listOfPricesId: pricesList,
            name: name,
            productId: code,
            unitPrice: productPrice.toString(),
            totalAmount: productTotalAmount.toString(),
            urlPicture: catalogue.toString(),
          );
          print(result);
          scannedProducts.add(result);
          objectBox.insertShoppingCartProduct(result);
        } else {
          bool isProductAlreadyInCart = false;
          print('Kaede not empty');
          productsInCart.forEach((element) {
            if (element.code == code) {
              print('Kaede is already in the cart, increasing 1');
              isProductAlreadyInCart = true;

              Fluttertoast.showToast(msg: '${element.code} + 1');
              final result = ShoppingCartProduct(
                id: element.id,
                availableStock: element.availableStock,
                productQuantity: element.productQuantity! + 1,
                code: element.code,
                listOfPricesId: element.listOfPricesId,
                name: element.name,
                productId: code,
                unitPrice: element.unitPrice.toString(),
                totalAmount: element.totalAmount.toString(),
                urlPicture: element.urlPicture.toString(),
              );
              objectBox.insertShoppingCartProduct(result);
            }
          });
          if (isProductAlreadyInCart == false) {
            print('Kaede is not in the order, adding now');

            final result = ShoppingCartProduct(
              availableStock: stock,
              productQuantity: productQuantity,
              code: code,
              listOfPricesId: pricesList,
              name: name,
              productId: code,
              unitPrice: productPrice.toString(),
              totalAmount: productTotalAmount.toString(),
              urlPicture: catalogue.toString(),
            );
            objectBox.insertShoppingCartProduct(result);
          }
        }

        // productsInCart?.forEach((element) {
        //   if (element.code == code) {
        //     print('Kaede 1');
        //   } else {
        //     print('Kaede 2');
        //   }
        // });

        // final result = ShoppingCartProduct(
        //   availableStock: stock,
        //   productQuantity: productQuantity,
        //   code: code,
        //   listOfPricesId: pricesList,
        //   name: name,
        //   productId: code,
        //   unitPrice: productPrice.toString(),
        //   totalAmount: productTotalAmount.toString(),
        //   urlPicture: catalogue.toString(),
        // );
        // print(result);
        // scannedProducts.add(result);
        // objectBox.insertManyShoppingCartProducts(scannedProducts);
      });
    } catch (e) {
      print(e);
    }

    print(scannedProducts);
  }

  late Stream<List<ShoppingCartProduct>> streamShoppingCartProducts;
  MobileScannerController cameraController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    streamShoppingCartProducts = objectBox.getShoppingCartProducts();
  }

  @override
  Widget build(BuildContext context) {
    String? scanResult;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaner de barras'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state as CameraFacing) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        // fit: BoxFit.contain,
        controller: cameraController,

        onDetect: (capture) {
          Future.delayed(const Duration(seconds: 0), () {
            final List<Barcode> barcodes = capture.barcodes;
            final Uint8List? image = capture.image;
            for (final barcode in barcodes) {
              // debugPrint('Barcode found! ${barcode.rawValue}');
              scanResult = barcode.rawValue.toString();
              print(scanResult);
              Fluttertoast.showToast(msg: 'scanResult: $scanResult');
              addProductFromBarcodeResult(
                scanResult,
                widget.products,
              );
            }
            Navigator.pop(context);
          });
        },
      ),
    );
  }
}
