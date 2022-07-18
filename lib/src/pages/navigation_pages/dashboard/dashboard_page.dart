// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/dashboard/widgets/client_listview.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/dashboard/widgets/dashboard_search_buttons.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/dashboard/widgets/summary_data.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_home.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Usuario conectado:');
    print(sharedPreferences!.getString('uid'));
    print('pantalla dasghboard activa');

    return Scaffold(
      appBar: AppBarHome(),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            DashboardHeaderButtons(),
            SummaryData(),
            Container(
              padding: EdgeInsets.only(top: 16),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[200],
              child: Container(
                margin: EdgeInsets.only(left: 16),
                child: Text(
                  'Clientes Frecuentes',
                  style: TextStyle(
                    color: myTheme.colorScheme.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            ClientListView(),
            // _ListCategories(),
            // SizedBox(height: 10.0),
            // PromotionSwiper(),
            // SizedBox(height: 20.0),

            // SizedBox(height: 10.0),
            // _PendingOrders(
            //   title: 'Pedidos pendientes',
            //   quantity: 0,
            // ),
            // SizedBox(height: 10.0),
            // _PendingOrders(
            //   title: 'Visitas pendientes',
            //   quantity: 0,
            // ),
            // SizedBox(height: 10.0),
            // _PendingOrders(
            //   title: 'Facturas pendientes',
            //   quantity: 0,
            // ),
            // SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}

// class _ListCategories extends StatelessWidget {
//   const _ListCategories({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final _categories = [
//       'Acceso rapido',
//       'Acceso rapido',
//       'Acceso rapido',
//       'Nuevo pedido',
//     ];
//     final icons = [
//       Icons.expand_more,
//       Icons.expand_more,
//       Icons.expand_more,
//       Icons.add_shopping_cart_rounded,
//     ];

//     return Container(
//       padding: EdgeInsets.only(top: 10.0, left: 8.0),
//       width: double.infinity,
//       height: 90.0,
//       child: ListView.builder(
//         physics: BouncingScrollPhysics(),
//         scrollDirection: Axis.horizontal,
//         itemCount: _categories.length,
//         itemBuilder: (BuildContext context, int i) {
//           final cName = _categories[i];
//           final cIcon = icons[i];
//           return Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 _CategoryButton(
//                   iconCategory: cIcon,
//                 ),
//                 SizedBox(height: 8.0),
//                 Text(
//                   cName,
//                   style: TextStyle(
//                     fontSize: 11.0,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class _CategoryButton extends StatelessWidget {
//   const _CategoryButton({
//     Key? key,
//     required this.iconCategory,
//   }) : super(key: key);

//   final IconData iconCategory;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 40.0,
//       height: 40.0,
//       margin: EdgeInsets.symmetric(horizontal: 10.0),
//       decoration: BoxDecoration(
//         color: myTheme.colorScheme.secondary,
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 5.0,
//             spreadRadius: 1.0,
//           ),
//         ],
//       ),
//       child: Icon(
//         iconCategory,
//         color: Colors.white,
//       ),
//     );
//   }
// }


// class _PendingOrders extends StatelessWidget {
//   const _PendingOrders({
//     Key? key,
//     required this.quantity,
//     required this.title,
//   }) : super(key: key);

//   final int quantity;
//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         print('Redireccionar a su lista respectiva');
//       },
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 20.0),
//         height: 35.0,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10.0),
//           color: Colors.grey.shade100,
//           border: Border.all(
//             color: myTheme.colorScheme.secondary.withOpacity(0.3),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             SizedBox(
//               width: 150.0,
//               child: Text(title, textWidthBasis: TextWidthBasis.longestLine),
//             ),
//             SizedBox(width: 30.0),
//             Container(
//               width: 25.0,
//               height: 25.0,
//               // margin: EdgeInsets.only(right: 1.0),
//               decoration: BoxDecoration(
//                 color: myTheme.colorScheme.secondary,
//                 shape: BoxShape.circle,
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 5.0,
//                     spreadRadius: 1.0,
//                   ),
//                 ],
//               ),
//               child: Center(
//                 child: Text(
//                   '$quantity',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
