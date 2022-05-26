import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/auth/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar_widgets/appbar_widget.dart';
import 'package:pwa_sales2go_flutter/test/test_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  var _user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: AppBarWidget(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),
          const Center(
            child: Text(
              'Bienvenido a Sales2Go!',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text('Ingresa tus datos para iniciar sesión:'),
          const SizedBox(height: 30),
          SingleChildScrollView(
            child: Container(
              height: 355,
              width: 425,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: emailController,
                        cursorColor: Colors.purple,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          suffixIcon: Icon(
                            Icons.email,
                            size: 17,
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Email invalido'
                                : null,
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: passwordController,
                        cursorColor: Colors.purple,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          suffixIconColor: Colors.purple,
                          labelText: 'Contraseña',
                          suffixIcon: Icon(
                            Icons.lock,
                            size: 17,
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (password) => password != null &&
                                password.length < 6
                            ? 'La contraseña debe tener al menos 6 caracteres'
                            : null,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Mostrara una barra de progreso mientras se esta cargando el usuario
                        _isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: 150,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.lock_open, size: 20),
                                  label: const Text('Ingresar',
                                      style: TextStyle(fontSize: 15)),
                                  onPressed: () async {
                                    try {
                                      setState(() => _isLoading = true);
                                      final user = await AuthHelper.signIn(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        context: context,
                                      );
                                      if (user != null) {
                                        print('Login exitoso');
                                      }
                                    } catch (e) {
                                      print(e);
                                      setState(() => _isLoading = false);
                                    }
                                  },
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    // Botones de Prueba para re-dirigir a la página de productos y clientes
                    const TestWidgets(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
