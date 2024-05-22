import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'custom_widgets.dart';

class ContactPage extends StatefulWidget {
  final String previousViewName;

  const ContactPage({super.key, required this.previousViewName});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final ValueNotifier<int> cartItemCount = ValueNotifier<int>(0);

  Future<void> _loadCartItemCount() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('Usuarios').doc(user.uid);
      DocumentSnapshot userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        cartItemCount.value = userSnapshot.get('cartCount') ?? 0;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCartItemCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(cartItemCount: cartItemCount),
      endDrawer: CustomDrawer(previousViewName: 'Contacto'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.chevron_left,
                          size: MediaQuery.of(context).size.width * 0.04,
                        ),
                        Text(
                          'volver',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Contacto',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '1-800-000-0000\ninfo@misitio.com',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Párrafo. Haz clic para agregar tu propio texto y editarlo. '
                    'Es fácil. Haz clic en "Editar texto" o doble clic aquí para '
                    'agregar contenido y cambiar la fuente. Puedes arrastrar y '
                    'soltar este texto donde quieras en la página. En este espacio, '
                    'puedes contar tu historia y permitir a los usuarios saber más '
                    'sobre ti.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration:
                              const InputDecoration(labelText: 'Nombre'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu nombre';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _subjectController,
                          decoration:
                              const InputDecoration(labelText: 'Asunto'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa el asunto';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            labelText: 'Mensaje',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu mensaje';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Acción al enviar el formulario
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFF607D82),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                            ),
                            child: const Text('Enviar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            CustomFooter(), // Footer movido aquí
          ],
        ),
      ),
    );
  }
}
