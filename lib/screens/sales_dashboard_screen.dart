import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/order.dart';
import '../utils/formatters.dart';

class SalesDashboardScreen extends StatefulWidget {
  const SalesDashboardScreen({super.key});

  @override
  State<SalesDashboardScreen> createState() => _SalesDashboardScreenState();
}

class _SalesDashboardScreenState extends State<SalesDashboardScreen> {
  bool _isLoading = true;
  List<Order> _allOrders = [];
  List<Order> _filteredOrders = [];
  String _selectedPeriod = '7_dias'; // 7_dias, este_mes, anio

  // Datos para el gráfico
  List<double> _chartValues = [];
  List<String> _chartLabels = [];
  double _maxChartValue = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final api = context.read<ApiService>();
      final orders = await api.getAllOrders(); // Usamos el endpoint existente

      setState(() {
        _allOrders = orders;
        _isLoading = false;
      });

      _applyFilter();
    } catch (e) {
      setState(() => _isLoading = false);
      // Manejar error
    }
  }

  void _applyFilter() {
    final now = DateTime.now();
    DateTime startDate;

    if (_selectedPeriod == '7_dias') {
      startDate = now.subtract(const Duration(days: 7));
    } else if (_selectedPeriod == 'este_mes') {
      startDate = DateTime(now.year, now.month, 1);
    } else {
      // Últimos 12 meses o Todo el año
      startDate = DateTime(now.year, 1, 1);
    }

    // 1. Filtrar órdenes por fecha y estado (solo pagadas/completadas si quisieras)
    _filteredOrders = _allOrders.where((o) => o.createdAt.isAfter(startDate)).toList();

    // 2. Agrupar datos para el gráfico
    _processChartData(startDate);
  }

  void _processChartData(DateTime startDate) {
    Map<String, double> groupedData = {};
    _chartLabels = [];
    _chartValues = [];

    // Inicializar mapa según el periodo
    if (_selectedPeriod == '7_dias') {
      for (int i = 0; i < 7; i++) {
        final date = startDate.add(Duration(days: i + 1));
        final key = DateFormat('dd/MM').format(date);
        groupedData[key] = 0.0;
        _chartLabels.add(key);
      }
    } else if (_selectedPeriod == 'este_mes') {
      // Simplificación: Agrupar por semanas o días
      // Aquí agruparemos por día del mes
      final daysInMonth = DateTime(startDate.year, startDate.month + 1, 0).day;
      for (int i = 1; i <= daysInMonth; i++) {
        final key = i.toString();
        groupedData[key] = 0.0;
        // Solo mostramos labels cada 5 días para no saturar
        if (i % 5 == 0 || i == 1) _chartLabels.add(key);
      }
    }

    // Llenar datos
    for (var order in _filteredOrders) {
      String key;
      if (_selectedPeriod == '7_dias') {
        key = DateFormat('dd/MM').format(order.createdAt);
      } else {
        key = order.createdAt.day.toString();
      }

      if (groupedData.containsKey(key) || _selectedPeriod == 'este_mes') {
        groupedData[key] = (groupedData[key] ?? 0) + order.total;
      }
    }

    // Convertir mapa a listas para el gráfico
    if (_selectedPeriod == '7_dias') {
      _chartValues = groupedData.values.toList();
    } else {
      // Para mes, extraemos valores ordenados
      final daysInMonth = DateTime(startDate.year, startDate.month + 1, 0).day;
      _chartValues = [];
      _chartLabels = []; // Reiniciamos para llenar bien
      for(int i=1; i<=daysInMonth; i++) {
        _chartValues.add(groupedData[i.toString()] ?? 0.0);
        if (i % 5 == 1) _chartLabels.add("$i/${startDate.month}");
      }
    }

    // Calcular máximo para escala del gráfico
    _maxChartValue = _chartValues.fold(0, (prev, elem) => elem > prev ? elem : prev);
    if (_maxChartValue == 0) _maxChartValue = 100; // Evitar división por cero
    _maxChartValue *= 1.2; // Darle un poco de aire arriba
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Calcular totales
    double totalRevenue = _filteredOrders.fold(0, (sum, item) => sum + item.total);
    int totalOrders = _filteredOrders.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Análisis de Ventas'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. FILTRO DE PERIODO ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedPeriod,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: '7_dias', child: Text('Últimos 7 días')),
                    DropdownMenuItem(value: 'este_mes', child: Text('Este Mes')),
                    DropdownMenuItem(value: 'anio', child: Text('Este Año (Resumen)')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPeriod = value;
                        _applyFilter();
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- 2. TARJETAS DE RESUMEN ---
            Row(
              children: [
                Expanded(
                    child: _buildSummaryCard(
                        'Ingresos',
                        Formatters.formatPrice(totalRevenue),
                        Icons.attach_money,
                        Colors.green
                    )
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildSummaryCard(
                        'Ventas',
                        '$totalOrders',
                        Icons.shopping_bag_outlined,
                        Colors.blue
                    )
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- 3. GRÁFICO DE BARRAS ---
            const Text("Tendencia de Ventas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _maxChartValue,
                  // ... dentro de BarChartData ...
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      // CAMBIO AQUÍ: Usamos tooltipBgColor en lugar de getTooltipColor
                      tooltipBgColor: Colors.blueGrey,

                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          'S/ ${rod.toY.toStringAsFixed(2)}',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                  // ...
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < _chartLabels.length) {
                            // Mostrar solo algunos labels si son muchos
                            if (_chartValues.length > 10 && value.toInt() % 5 != 0) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(_chartLabels[value.toInt()], style: const TextStyle(fontSize: 10)),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barGroups: _chartValues.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          color: const Color(0xFFFF6B35),
                          width: _selectedPeriod == 'este_mes' ? 6 : 12,
                          borderRadius: BorderRadius.circular(4),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: _maxChartValue,
                            color: Colors.grey[100],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              // Icon(Icons.arrow_upward, color: Colors.green, size: 16),
              // const Text(" 12%", style: TextStyle(color: Colors.green, fontSize: 12))
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }
}