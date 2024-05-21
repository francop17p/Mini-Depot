import 'package:flutter/material.dart';
import 'custom_widgets.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final ValueNotifier<int> cartItemCount = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFedeff0),
      appBar: CustomAppBar(cartItemCount: cartItemCount),
      endDrawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Info',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF203040),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Párrafo. Haz clic para editar y agregar tu propio texto. Es fácil. Haz clic en "Editar texto" o doble clic aquí para agregar tu contenido y cambiar la fuente. Puedes arrastrar y soltar este texto donde quieras en tu página. En este espacio puedes contar tu historia y permitir a los usuarios saber más sobre ti.\n\n'
                'Este es un buen espacio para contar más sobre tu compañía y servicios. Puedes usar este espacio para incorporar más detalles sobre tu empresa. Escribe sobre tu equipo y los servicios que ofreces. Cuéntales a los visitantes la historia sobre cómo se te ocurrió la idea de tu negocio y qué diferencia de tus competidores. Haz que tu empresa se destaque y muestra a los visitantes quién eres.',
                style: TextStyle(fontSize: 16, color: Color(0xFF405357)),
              ),
              const SizedBox(height: 16),
              Center(
                child: Image.asset(
                  'images/Macetas.jpg',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'FAQ',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF203040),
                ),
              ),
              const SizedBox(height: 16),
              _buildFaqItem('¿Ofrecen envíos internacionales?'),
              const SizedBox(height: 16),
              _buildFaqItem('¿Cómo rastreo mi pedido?'),
              const SizedBox(height: 16),
              _buildFaqItem('¿Cómo devuelvo un artículo?'),
              const SizedBox(height: 16),
              _buildFaqItem('¿Cómo contacto a los mensajeros?'),
              const SizedBox(height: 16),
              _buildFaqItem('¿Cuál es tu política de devoluciones?'),
              const SizedBox(height: 16),
              _buildFaqItem('¿Cuáles son tus opciones de entrega?'),
              const SizedBox(height: 20),
              CustomFooter(), // footer
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF203040),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Párrafo. Haz clic aquí para agregar tu propio texto y editarlo. Es fácil. Haz clic en "Editar texto" o doble clic aquí para agregar tu contenido y cambiar la fuente. En este espacio puedes contar tu historia y permitir que los usuarios sepan más sobre ti.',
          style: TextStyle(fontSize: 16, color: Color(0xFF405357)),
        ),
      ],
    );
  }
}
