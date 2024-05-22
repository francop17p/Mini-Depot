import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'custom_widgets.dart';
import 'home.dart';
import 'dart:typed_data';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final ValueNotifier<int> cartItemCount = ValueNotifier<int>(0);

  String? _profileImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Usuarios')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            _nameController.text = data['name'] ?? '';
            _emailController.text = user.email ?? '';
            _lastNameController.text = data['lastName'] ?? '';
            _phoneController.text = data['phone'] ?? '';
            _profileImageUrl = data['profileImageUrl'];
          });
          print('Loaded profile image URL: $_profileImageUrl');
        }
      }
    }
  }

  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(user.uid)
            .update({
          'name': _nameController.text,
          'lastName': _lastNameController.text,
          'phone': _phoneController.text,
          'profileImageUrl': _profileImageUrl,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Información actualizada')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          Uint8List? fileBytes = result.files.single.bytes;
          String fileName = result.files.single.name;

          Reference storageRef = FirebaseStorage.instance
              .ref()
              .child('profile_images')
              .child(user.uid)
              .child(fileName);

          UploadTask uploadTask = storageRef.putData(fileBytes!);
          TaskSnapshot taskSnapshot = await uploadTask;
          String downloadUrl = await taskSnapshot.ref.getDownloadURL();

          setState(() {
            _profileImageUrl = downloadUrl;
            _isLoading = false;
          });

          await FirebaseFirestore.instance
              .collection('Usuarios')
              .doc(user.uid)
              .update({
            'profileImageUrl': _profileImageUrl,
          });

          print('Uploaded profile image URL: $_profileImageUrl');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto de perfil actualizada')),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir la imagen: $e')),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFedeff0),
      appBar: CustomAppBar(cartItemCount: cartItemCount),
      endDrawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color(0xFF607D82),
                height: 150,
                width: double.infinity,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Color(0xFFedeff0),
                            backgroundImage: _profileImageUrl != null
                                ? NetworkImage(_profileImageUrl!)
                                : null,
                            child: _profileImageUrl == null
                                ? const Icon(Icons.person,
                                    size: 50, color: Colors.grey)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt,
                                  color: Colors.white),
                              onPressed: _pickImage,
                            ),
                          ),
                          if (_isLoading)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black45,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _nameController.text,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Email de inicio de sesión:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(_emailController.text),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Apellido'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (value.length > 10) {
                      return 'El número no puede tener más de 10 dígitos';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Solo se permiten números';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFedeff0), // Color de fondo
                        foregroundColor:
                            const Color(0xFF405357), // Color de texto
                        side:
                            const BorderSide(color: Color(0xFF405357)), // Borde
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(0), // Bordes cuadrados
                        ),
                      ),
                      child: const Text('Descartar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _updateUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF405357), // Color de fondo
                        foregroundColor:
                            const Color(0xFFedeff0), // Color de texto
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(0), // Bordes cuadrados
                        ),
                      ),
                      child: const Text('Actualizar información'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomFooter(), // Agrega el footer aquí
            ],
          ),
        ),
      ),
    );
  }
}
