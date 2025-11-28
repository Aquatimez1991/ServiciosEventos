// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/service_provider.dart';
import '../providers/auth_provider.dart'; // Importa AuthProvider para el saludo
import '../models/provider.dart' as model_provider;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController? _tabController;

  void _onTabChanged() {
    setState(() {});
  }

  void _setupTabControllerIfNeeded(List<model_provider.Provider> providers) {
    final requiredLength = providers.length + 1;
    if (_tabController == null || _tabController!.length != requiredLength) {
      _tabController?.removeListener(_onTabChanged);
      _tabController?.dispose();

      _tabController = TabController(length: requiredLength, vsync: this);
      _tabController!.addListener(_onTabChanged);
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = context.watch<ServiceProvider>();
    // Obtenemos el usuario para el saludo
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.authUser;
    final userName = user?.name.split(' ')[0] ?? 'Invitado';

    final allProviders = serviceProvider.providers;

    if (!serviceProvider.isLoading) {
      _setupTabControllerIfNeeded(allProviders);
    }

    final List<model_provider.Provider> filteredProviders;
    if (serviceProvider.isLoading || _tabController == null) {
      filteredProviders = [];
    } else if (_tabController!.index == 0) {
      filteredProviders = allProviders;
    } else {
      final providerIndex = _tabController!.index - 1;
      if (providerIndex >= 0 && providerIndex < allProviders.length) {
        filteredProviders = [allProviders[providerIndex]];
      } else {
        filteredProviders = [];
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[50], // Fondo ligeramente gris para contraste
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70, // Un poco más alto para el saludo
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ubicación actual',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFFFF6B35), size: 18),
                const SizedBox(width: 4),
                const Text(
                  'Lima, Perú',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const Spacer(),
                // Avatar pequeño o saludo
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    userName[0].toUpperCase(),
                    style: const TextStyle(
                        color: Color(0xFFFF6B35), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),

        // DISEÑO MODERNO DE LA BARRA DE CATEGORÍAS
        bottom: (serviceProvider.isLoading || _tabController == null)
            ? null
            : PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            height: 60,
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: _tabController!,
              isScrollable: true,
              // ESTO ARREGLA QUE SE VEA "MUY A LA DERECHA":
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              labelPadding: const EdgeInsets.only(right: 12),

              // Estilo de "Chip" seleccionado
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xFFFF6B35), // Naranja activo
              ),
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.transparent, // Quita la línea de abajo

              // Colores de texto
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],

              // Opcional: overlay color al presionar
              overlayColor: MaterialStateProperty.all(Colors.transparent),

              tabs: [
                _buildTab('🎉 Todos', _tabController!.index == 0),
                ...allProviders.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final p = entry.value;
                  return _buildTab(
                    '${p.icon} ${p.name}',
                    _tabController!.index == index,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      body: serviceProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: filteredProviders.isEmpty
            ? _EmptyState() // Widget opcional si no hay resultados
            : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75, // Ajustado para que quepa mejor el contenido
          ),
          itemCount: filteredProviders.length,
          itemBuilder: (context, index) {
            final provider = filteredProviders[index];
            return _ProviderCard(provider: provider);
          },
        ),
      ),
    );
  }

  // Helper para construir el diseño de cada Tab
  Widget _buildTab(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.grey[300]!,
          width: 1,
        ),
        color: isSelected ? const Color(0xFFFF6B35) : Colors.white,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            // El color lo maneja el TabBar (labelColor vs unselectedLabelColor),
            // pero aquí forzamos la herencia
          ),
        ),
      ),
    );
  }
}

// Widget simple para cuando no hay resultados
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("No se encontraron servicios", style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }
}

// ... Mantén tu clase _ProviderCard igual que antes,
// solo sugiero cambiar el childAspectRatio del GridView a 0.75 (línea 147)
// para evitar errores de overflow en pantallas pequeñas.
class _ProviderCard extends StatelessWidget {
  final model_provider.Provider provider;

  const _ProviderCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/category/${provider.id}');
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2, // Bajamos la elevación para un look más moderno
        shadowColor: Colors.black12,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: provider.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey[100]),
                    errorWidget: (context, url, error) => const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 48),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            provider.rating.toStringAsFixed(1),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          provider.location,
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFF0E6), // Naranja muy claro
                          foregroundColor: const Color(0xFFFF6B35), // Texto naranja
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                      ),
                      onPressed: () {
                        context.push('/category/${provider.id}');
                      },
                      child: const Text('Ver servicios', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}