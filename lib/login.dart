import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_movil/Managers.dart';
import 'package:proyecto_movil/registro.dart';
import 'package:proyecto_movil/passRecovery.dart';
import 'package:proyecto_movil/home.dart';
import 'package:proyecto_movil/registroHelper.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, dynamic>? usuario;

  void loadCurrentUser() async {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Usuarios')
          .doc(currentUser.uid)
          .get();
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      if (userData != null) {
        AuthManager().currentUser = userData;
        print(AuthManager().currentUser!['name']);
        print(AuthManager().currentUser!['email']);
      }
    } else {
      print('No hay usuario logueado');
    }
  }

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
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return const Home();
                          },
                        ));
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Iniciar sesión',
                  style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14.0),
                const Text(
                  '¿Eres nuevo en la aplicación?',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Registro()),
                    );
                  },
                  child: const Text(
                    'Regístrate',
                    style: TextStyle(fontSize: 18, color: Color(0xFF607d82)),
                  ),
                ),
                const SizedBox(height: 16.0),
                //!Email
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce un email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                //!Contraseña
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce una contraseña';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                const SizedBox(height: 50.0),

                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PassRecovery()),
                      );
                    },
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                //!Iniciar sesión
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        try {
                          User? userCredential =
                              await AuthService().signInWithEmailAndPassword(
                            _email,
                            _password,
                          );
                          //!Inicio de sesion exitoso
                          if (userCredential != null) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Inicio de sesión exitoso'),
                                  content: const Text('¡Bienvenido! '),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              loadCurrentUser();
                                              return const Home();
                                            },
                                          ),
                                        );
                                      },
                                      child: const Text('Aceptar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          print('Ocurrió un error: ${e.code}');

                          if (e.code == 'invalid-email') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Error en la sintaxis del correo'),
                              ),
                            );
                          } else if (e.code == 'invalid-credential') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Credenciales Incorrectas'),
                              ),
                            );
                          }
                        } catch (e) {
                          // ignore: avoid_print
                          print('Ocurrió una excepción: $e');
                        }
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
                      'Iniciar sesión',
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
