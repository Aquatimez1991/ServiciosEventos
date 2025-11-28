// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/service_provider.dart';
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
      appBar: AppBar(
        title: const Text('Servicios para Eventos'),
        // Los actions se han movido al ShellScaffold (barra de navegación inferior)
        bottom: (serviceProvider.isLoading || _tabController == null)
            ? null
            : TabBar(
                controller: _tabController!,
                isScrollable: true,
                tabs: [
                  const Tab(text: '🎉 Todos'),
                  ...allProviders.map(
                      (p) => Tab(text: '${p.icon} ${p.name}')),
                ],
              ),
      ),
      body: serviceProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
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
}


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
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                        Container(color: Colors.grey[200]),
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
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.amber, size: 14),
                          const SizedBox(width: 2),
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          provider.location,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star_border,
                          size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${provider.reviewCount} reseñas',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                           overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${provider.serviceCount} servicios disponibles',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                   context.push('/category/${provider.id}');
                },
                child: const Text('Ver servicios'),
              ),
            )
          ],
        ),
      ),
    );
  }
}