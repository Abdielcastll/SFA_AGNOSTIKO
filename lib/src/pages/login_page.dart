// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/auth/auth.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar_widgets/appbar_offline.dart';
import 'package:pwa_sales2go_flutter/src/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use of Appbaroffline Widget
      appBar: AppBarOffline(
        title: 'Login',
        // backgroundColor: Color(0xFF4f42ed),
      ),
      // Body of the Login
      body: _loginBody(context),
    );
  }

  Widget _loginBody(context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Bienvenido a Sales2Go!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Image.asset('assets/images/logo.png'),
            SizedBox(height: 20),
            Text(
              'Ingresa tus datos para iniciar sesión:',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30),
            // Inputs form Fields
            Form(
              key: formKey,
              child: Column(
                children: [
                  // Para el email
                  CustomTextField(
                    textEditingController: emailController,
                    iconData: Icons.email_rounded,
                    hintText: 'Email',
                    isObsecure: false,
                    enabled: true,
                  ),

                  // Para la contraseña
                  CustomTextField(
                    textEditingController: passwordController,
                    iconData: Icons.lock_rounded,
                    hintText: 'Contraseña',
                    isObsecure: true,
                    enabled: true,
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.login_rounded),
              label: Text(
                'Iniciar Sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF009B77),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget _loginBody(BuildContext context) {
//   return SingleChildScrollView(
//     child: Column(
//       children: [
//         const SizedBox(height: 25),
//         const Center(
//           child: Text(
//             'Bienvenido a Sales2Go!',
//             style: TextStyle(
//               fontSize: 25,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//         ),
//         const SizedBox(height: 30),
//         const Text('Ingresa tus datos para iniciar sesión:'),
//         const SizedBox(height: 30),
//         SingleChildScrollView(
//           child: Container(
//             height: 355,
//             width: 425,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 10,
//                   offset: Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 30),
//                   SizedBox(
//                     width: 300,
//                     child: TextFormField(
//                       controller: emailController,
//                       cursorColor: Colors.purple,
//                       textInputAction: TextInputAction.next,
//                       decoration: const InputDecoration(
//                         labelText: 'Email',
//                         suffixIcon: Icon(
//                           Icons.email,
//                           size: 17,
//                         ),
//                       ),
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       validator: (email) =>
//                           email != null && !EmailValidator.validate(email)
//                               ? 'Email invalido'
//                               : null,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   SizedBox(
//                     width: 300,
//                     child: TextFormField(
//                       controller: passwordController,
//                       cursorColor: Colors.purple,
//                       textInputAction: TextInputAction.next,
//                       decoration: const InputDecoration(
//                         suffixIconColor: Colors.purple,
//                         labelText: 'Contraseña',
//                         suffixIcon: Icon(
//                           Icons.lock,
//                           size: 17,
//                         ),
//                       ),
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       validator: (password) => password != null &&
//                               password.length < 6
//                           ? 'La contraseña debe tener al menos 6 caracteres'
//                           : null,
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       SizedBox(
//                         width: 150,
//                         child: ElevatedButton.icon(
//                           icon: Icon(Icons.lock_open, size: 20),
//                           label: Text('Ingresar',
//                               style: TextStyle(fontSize: 15)),
//                           onPressed: () => {
//                             AuthHelper().signIn(
//                                 email: emailController,
//                                 password: passwordController,
//                                 context: context),
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 50),
//                   // Botones de Prueba para re-dirigir a la página de productos y clientes
//                   // const TestWidgets(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
