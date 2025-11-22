import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/auth_provider.dart';
import '../providers/provider_provider.dart';
import '../providers/cart_provider.dart';
import '../models/provider_model.dart';
import '../utils/formatters.dart';
import '../widgets/provider_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'all';

  final List<Map<String, String>> _categories = [
    {'id': 'all', 'name': 'Todos', 'icon': '🎉'},
    {'id': 'birthday', 'name': 'Cumpleaños', 'icon': '🎂'},
    {'id': 'kids', 'name': 'Infantil', 'icon': '🧸'},
    {'id': 'decoration', 'name': 'Decoración', 'icon': '🎈'},
    {'id': 'catering', 'name': 'Catering', 'icon': '🍰'},
    {'id': 'entertainment', 'name': 'Animación', 'icon': '🎭'},
    {'id': 'music', 'name': 'Música', 'icon': '🎵'},
    {'id': 'photography', 'name': 'Fotografía', 'icon': '📸'},
    {'id': 'venue', 'name': 'Local', 'icon': '🏢'},
    {'id': 'services', 'name': 'Servicios', 'icon': '⚙️'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtrar proveedores según categoría y búsqueda
  List<ProviderModel> _getFilteredProviders(ProviderProvider providerProvider) {
    final searchQuery = _searchController.text.toLowerCase();
    
    return providerProvider.providers.where((provider) {
      // Filtrar por búsqueda
      if (searchQuery.isNotEmpty) {
        final matchesSearch = provider.name.toLowerCase().contains(searchQuery) ||
            provider.location.toLowerCase().contains(searchQuery);
        if (!matchesSearch) return false;
      }
      
      // Filtrar por categoría
      if (_selectedCategory != 'all') {
        final hasServiceInCategory = provider.services.any(
          (service) => service.category == _selectedCategory,
        );
        if (!hasServiceInCategory) return false;
      }
      
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final providerProvider = context.watch<ProviderProvider>();
    final cartProvider = context.watch<CartProvider>();
    
    final filteredProviders = _getFilteredProviders(providerProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFF8C5A).withOpacity(0.2),
              const Color(0xFFFFE066).withOpacity(0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PartyApp',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF6B35),
                              ),
                            ),
                            Text(
                              'Bienvenido ${authProvider.authUser?.name ?? ''}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Stack(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.shopping_cart),
                                  onPressed: () => context.go('/cart'),
                                ),
                                if (cartProvider.itemCount > 0)
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFFD23F),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${cartProvider.itemCount}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Search
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar proveedores...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              // Categories
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category['id'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text('${category['icon']} ${category['name']}'),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? category['id']! : 'all';
                          });
                        },
                        selectedColor: const Color(0xFFFF6B35),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Providers Grid
              Expanded(
                child: filteredProviders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No se encontraron proveedores',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _selectedCategory != 'all'
                                  ? 'Intenta con otra categoría'
                                  : 'Intenta con otra búsqueda',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: filteredProviders.length,
                        itemBuilder: (context, index) {
                          final provider = filteredProviders[index];
                          return ProviderCard(provider: provider);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

