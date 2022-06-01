import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Paquetes de Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:pwa_sales2go_flutter/firebase_options.dart';
//Test
import 'package:pwa_sales2go_flutter/examples/test_get_info_device.dart';
// Paquete principal de Material
import 'package:flutter/material.dart';
// Paquetes que traen las paginas a redireccionar
import 'package:pwa_sales2go_flutter/src/pages/login_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/products_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/home_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/roles_page.dart';

// Se declara en el main todo el enrutamiento de la aplicación
Future main() async {
  print('Inicializando Firebase...');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Firebase inicializado');
  runApp(TestMyApp());
  print('App inicializado');
}

class TestMyApp extends StatelessWidget {
  const TestMyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Apps2Go',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      // home: TestMainScreen(),
    );
  }
}

// class TestMainScreen extends StatelessWidget {
//   const TestMainScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData && snapshot.data != null) {
//             return StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('usuarios')
//                   .doc(snapshot.data.uid)
//                   .snapshots(),
//               builder: (BuildContext context,
//                   AsyncSnapshot<DocumentSnapshot> snapshot) {
//                 if (snapshot.hasData && snapshot != null) {
//                   final user = snapshot.data.data();
//                   if (user['role'] == 'admin') {
//                     return HomePage();
//                   } else {
//                     return ProductsPage();
//                   }
//                 }
//                 return Material(
//                   child: Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 );
//               },
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         });
//   }
// }
