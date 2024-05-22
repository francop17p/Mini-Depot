import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'custom_widgets.dart';
import 'home.dart';
import 'dart:typed_data';
import 'dart:io';
import 'main.dart'; // Asegúrate de importar donde tengas el routeObserver

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> with RouteAware {
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
    _loadCartItemCount();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadCartItemCount();
  }

  //! Carga los datos del usuario desde Firestore
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

  //! Actualiza los datos del usuario en Firestore
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

  //! Selecciona y sube la imagen de perfil a Firebase Storage
  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withReadStream: true, // Ensure this is true
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _isLoading = true;
      });

      User? user = FirebaseAuth.instance.currentUser;
      String fileName = result.files.single.name;
      File file = File(result.files.single.path!);

      try {
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images/${user?.uid}/$fileName');

        UploadTask uploadTask = storageRef.putFile(file);

        final TaskSnapshot downloadUrl = await uploadTask;
        String url = await downloadUrl.ref.getDownloadURL();

        setState(() {
          _profileImageUrl = url;
          _isLoading = false;
        });

        await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(user?.uid)
            .update({
          'profileImageUrl': _profileImageUrl,
        });

        print('Uploaded profile image URL: $_profileImageUrl');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto de perfil actualizada')),
        );
      } catch (e, stackTrace) {
        print('Error al subir la imagen: $e');
        print('Stacktrace: $stackTrace');
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir la imagen: $e')),
        );
      }
    } else {
      print('No image selected or file read error.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No image selected or error in reading file')),
      );
    }
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFedeff0),
      appBar: CustomAppBar(cartItemCount: cartItemCount),
      endDrawer: const CustomDrawer(previousViewName: 'perfil'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
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
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
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
                              backgroundColor: const Color(0xFFedeff0),
                              foregroundColor: const Color(0xFF405357),
                              side: const BorderSide(color: Color(0xFF405357)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
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
                              backgroundColor: const Color(0xFF405357),
                              foregroundColor: const Color(0xFFedeff0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            child: const Text('Actualizar información'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            CustomFooter(), //! Agrega el footer aquí
          ],
        ),
      ),
    );
  }
}
