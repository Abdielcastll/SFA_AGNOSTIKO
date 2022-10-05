// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/examples/clients_example.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/details.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class ProductsInCart extends StatefulWidget {
  const ProductsInCart({
    Key? key,
    // required this.products,
    required this.client,
  }) : super(key: key);

  // final List<Product> products;
  final CLientsExample client;

  @override
  State<ProductsInCart> createState() => _ProductsInCartState();
}

class _ProductsInCartState extends State<ProductsInCart> {
  @override
  Widget build(BuildContext context) {
    isDiscountActive(promotionDiscount, promotion) {
      if (promotion == true) {
        return '- $promotionDiscount%';
      } else {
        return '';
      }
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 325,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
      ),
      // child: Scrollbar(
      //   thumbVisibility: true,
      // child: ListView.builder(
      //   physics: BouncingScrollPhysics(),
      //   itemCount: widget.products.length,
      //   itemBuilder: (context, index) {
      //     final product = widget.products[index];
      //     return Container(
      //       height: 80,
      //       decoration: BoxDecoration(
      //         color: Colors.white,
      //         borderRadius: BorderRadius.circular(16),
      //         border: Border.all(
      //           color: Colors.white,
      //         ),
      //       ),
      //       margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           ClipRRect(
      //             borderRadius: BorderRadius.only(
      //               topLeft: Radius.circular(20),
      //               bottomLeft: Radius.circular(20),
      //             ),
      //             child: FadeInImage(
      //               placeholder: AssetImage('assets/images/loading.gif'),
      //               image: NetworkImage(
      //                 product.urlImg,
      //               ),
      //             ),
      //           ),
      //           Column(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Row(
      //                 children: [
      //                   Container(
      //                     margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
      //                     width: 190,
      //                     height: 40,
      //                     color: Colors.transparent,
      //                     child: Text(
      //                       product.productName,
      //                       maxLines: 2,
      //                       overflow: TextOverflow.ellipsis,
      //                       style: TextStyle(
      //                         fontSize: 12,
      //                         fontFamily: 'Poppins-regular',
      //                       ),
      //                     ),
      //                   ),
      //                   IconButton(
      //                     onPressed: () {
      //                       // Bottom Menus for changing details
      //                       showModalBottomSheet(
      //                         elevation: 0,
      //                         backgroundColor: Colors.grey.shade200,
      //                         barrierColor: myTheme.colorScheme.secondary
      //                             .withOpacity(0.5),
      //                         isScrollControlled: true,
      //                         context: context,
      //                         shape: RoundedRectangleBorder(
      //                           borderRadius: BorderRadius.vertical(
      //                             top: Radius.circular(20),
      //                           ),
      //                         ),
      //                         builder: (context) {
      //                           return SafeArea(
      //                             child: Container(
      //                               padding: EdgeInsets.symmetric(
      //                                   vertical: 20, horizontal: 20),
      //                               child: SettingsForm(
      //                                 productName: product.productName,
      //                                 productPrice: product.unitPrice,
      //                                 productUnits: product.productUnits,
      //                                 productImg: product.urlImg,
      //                               ),
      //                             ),
      //                           );
      //                         },
      //                       );
      //                     },
      //                     icon: Icon(
      //                       Feather.more_vertical,
      //                       size: 15,
      //                     ),
      //                     splashRadius: 1,
      //                     splashColor: Colors.transparent,
      //                   ),
      //                 ],
      //               ),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                 children: [
      //                   Container(
      //                     margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      //                     child: Text(
      //                       'U: ${product.productUnits}',
      //                       style: TextStyle(
      //                         color: Colors.grey,
      //                         fontFamily: 'Poppins-regular',
      //                         fontSize: 12,
      //                       ),
      //                     ),
      //                   ),
      //                   Container(
      //                     margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      //                     child: Text(
      //                       'P/U: ${product.unitPrice.toStringAsFixed(2)}',
      //                       style: TextStyle(
      //                         color: Colors.grey,
      //                         fontFamily: 'Poppins-regular',
      //                         fontSize: 12,
      //                       ),
      //                     ),
      //                   ),
      //                   Container(
      //                     margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      //                     child: Text(
      //                       'Total: ${product.totalPrice.toStringAsFixed(2)}',
      //                       style: TextStyle(
      //                         color: Colors.purple.shade600,
      //                         fontFamily: 'Poppins-regular',
      //                         fontSize: 12,
      //                       ),
      //                     ),
      //                   ),
      //                   // Container(
      //                   //   margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      //                   //   child: Text(
      //                   //     isDiscountActive(
      //                   //         product.promotionDiscount, product.promotion),
      //                   //     style: TextStyle(
      //                   //       color: Colors.purple.shade600,
      //                   //       fontFamily: 'Poppins-regular',
      //                   //       fontSize: 12,
      //                   //     ),
      //                   //   ),
      //                   // ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // ),
      // ),
    );
  }
}
