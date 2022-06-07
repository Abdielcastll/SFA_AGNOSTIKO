//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//Flutter
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
//Widgets
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_login.dart';
import 'package:pwa_sales2go_flutter/src/widgets/custom_text_field/custom_text_field_widget.dart';
import 'package:pwa_sales2go_flutter/src/widgets/loading_dialog/loading_dialog_widget.dart';

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

  validateForm() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      // Allow user to login
      loginNow();
    } else {
      Fluttertoast.showToast(msg: 'Por favor ingrese su correo y contraseña');
    }
  }

  loginNow() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (c) {
        return const LoadingDialogWidget(
          message: 'Revisando credenciales',
        );
      },
    );

    User? currentUser;
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((errorMessage) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Usuario o Contraseñas invalidos');
    });
    if (currentUser != null) {
      checkIfUserRecordExists(currentUser!);
    }
  }

  checkIfUserRecordExists(User currentUser) async {
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(currentUser.uid)
        .get()
        .then((record) async {
      // Comprobar si se obtiene informacion de la coleccion
      if (record.exists) {
        // En caso de que el registro exista
        try {
          // Verificar si el usuario esta activo
          if (record.data()!['activo'] == true) {
            // Proceder a cuadra la información en variable global
            await sharedPreferences!.setString('uid', currentUser.uid);
            await sharedPreferences!.setString('email', currentUser.email!);
            await sharedPreferences!
                .setString('nombre', record.data()!['nombre']);

            await sharedPreferences!
                .setInt('nro_cedula', record.data()!['nro_cedula']);

            // Obtener lista del indice
            List<String> indice = record.data()!['indice'].cast<String>();
            await sharedPreferences!.setStringList('indice', indice);

            // Revisar si es gerente
            if (record.data()!['esGerente'] == false) {
              // Si no es gerente, verificar si es vendedor
              if (record.data()!['esVendedor'] == false) {
                // Si no es vendedor, entonces se le asigna cargo = cobrador
                await sharedPreferences!.setString('cargo', 'Cobrador');
              } else {
                // Si es vendedor, asignar cargo = vendedor
                await sharedPreferences!.setString('cargo', 'Vendedor');
              }
            } else {
              // Si es gerente, almacenar que cargo = gerente
              await sharedPreferences!.setString('cargo', 'Gerente');
            }
            Navigator.pushNamed(context, 'splashscreen');
          } else {
            Navigator.pop(context);
            Fluttertoast.showToast(msg: 'Usuario no activo o bloqueado');
          }
        } catch (e) {
          Fluttertoast.showToast(msg: 'Error en la petición');
        }
      } else {
        // En caso de que el registro no exista
        FirebaseAuth.instance.signOut();
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: 'Este usuario no existe dentro de la base de datos');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use of Appbaroffline Widget
      appBar: const AppBarLogin(
        title: 'Login',
        backgroundColor: Color(0xFF4f42ed),
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
            const SizedBox(height: 20),
            const Text(
              'Bienvenido a Sales2Go!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset('assets/images/logo.png'),
            const SizedBox(height: 20),
            const Text(
              'Ingresa tus datos para iniciar sesión:',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
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
                  const SizedBox(height: 30),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Login
                validateForm();
              },
              icon: const Icon(Icons.login_rounded),
              label: const Text(
                'Iniciar Sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF009B77),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
