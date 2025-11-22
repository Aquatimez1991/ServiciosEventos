import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../providers/provider_provider.dart';
import '../providers/auth_provider.dart';
import '../models/service.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _imageController = TextEditingController();
  String _selectedCategory = 'decoration';

  final List<Map<String, String>> _categories = [
    {'id': 'birthday', 'name': 'Cumpleaños', 'icon': '🎂'},
    {'id': 'kids', 'name': 'Infantiles', 'icon': '🧸'},
    {'id': 'decoration', 'name': 'Decoración', 'icon': '🎈'},
    {'id': 'catering', 'name': 'Catering', 'icon': '🍰'},
    {'id': 'entertainment', 'name': 'Animación', 'icon': '🎭'},
    {'id': 'music', 'name': 'Música', 'icon': '🎵'},
    {'id': 'photography', 'name': 'Fotografía', 'icon': '📸'},
    {'id': 'venue', 'name': 'Locales', 'icon': '🏢'},
    {'id': 'services', 'name': 'Servicios', 'icon': '⚙️'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final providerProvider = context.read<ProviderProvider>();

    if (authProvider.authUser?.providerId == null) return;

    final service = Service(
      id: const Uuid().v4(),
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      image: _imageController.text.isEmpty
          ? 'https://images.unsplash.com/photo-1654851364032-ca4d7a47341c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxiaXJ0aGRheSUyMHBhcnR5JTIwZGVjb3JhdGlvbiUyMGJhbGxvb25zfGVufDF8fHx8MTc1NTUzMzM0NXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral'
          : _imageController.text,
      category: _selectedCategory,
      duration: _durationController.text.isEmpty ? null : _durationController.text,
    );

    await providerProvider.addService(
      authProvider.authUser!.providerId!,
      service,
    );

    if (mounted) {
      context.go('/provider-dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/provider-dashboard');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Agregar Nuevo Servicio'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/provider-dashboard');
              }
            },
          ),
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del servicio',
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                ),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Precio (CLP)',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Requerido' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _durationController,
                      decoration: const InputDecoration(
                        labelText: 'Duración',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['id'],
                    child: Text('${category['icon']} ${category['name']}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value!);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'URL de imagen (opcional)',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleSave,
                      child: const Text('Guardar Servicio'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go('/provider-dashboard'),
                      child: const Text('Cancelar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

