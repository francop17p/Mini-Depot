import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_movil/login.dart';
import 'package:firebase_core_web/firebase_core_web.dart';

import 'package:proyecto_movil/registroHelper.dart';

AuthService authService = AuthService();

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFedeff0),
      body: Center(
        // Agregado aquí
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Regístrate',
                  style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14.0),
                const Text(
                  '¿Ya tienes un perfil personal?',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: const Text(
                    'Inicia sesión',
                    style: TextStyle(fontSize: 18, color: Color(0xFF607d82)),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                  ),
                  obscureText: true,
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                //!cambiar por captcha
                CheckboxListTile(
                  title: const Text('No soy un robot'),
                  value: false,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16.0),
                //!cambiar color a gris y ponerlo en verde(actual) cuando el captcha se valide y no falten datos
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        try {
                          User? user =
                              await authService.createUserWithEmailAndPassword(
                                  _email, _password);
                        } on FirebaseException catch (e) {
                          print(e.message); // Imprime el mensaje de error

                          // Aquí puedes manejar el error como mejor te parezca
                          if (e.code == 'email-already-in-use') {
                            // Si el correo electrónico ya está en uso, muestra un mensaje de error
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Este correo electrónico ya está en uso.')),
                            );
                          } else if (e.code == 'weak-password') {
                            // Si la contraseña es débil, muestra un mensaje de error
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'La contraseña es demasiado débil.')),
                            );
                          } else {
                            // Si se produce otro error, muestra un mensaje de error genérico
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Ocurrió un error al crear la cuenta.')),
                            );
                          }
                        } catch (e) {
                          // Imprime cualquier otra excepción que no sea una FirebaseException
                          print('Ocurrió una excepción: $e');
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Por favor, llena todos los campos.')),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF607d82)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Regístrate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
