import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lacarte_dashboard/ui/dashboard_ft/view_models/analytics_view_model.dart';
import 'package:intl/intl.dart';

class AnalyticsSuite extends StatefulWidget {
  const AnalyticsSuite({super.key});

  @override
  State<AnalyticsSuite> createState() => _AnalyticsSuiteState();
}

class _AnalyticsSuiteState extends State<AnalyticsSuite> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsViewModel>().fetchAllAnalytics();
    });
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(symbol: '\$').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyticsViewModel>(
      builder: (context, analyticsVM, child) {
        if (analyticsVM.isLoading && !analyticsVM.isAllDataLoaded) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF728A7C)),
          );
        }

        final revenue = analyticsVM.getTotalRevenue();
        final revenueChange = analyticsVM.getRevenueChange();
        final totalOrders = analyticsVM.getTotalOrders();
        final orderChange = analyticsVM.getOrderChange();
        final averageOrderValue = totalOrders > 0 ? revenue / totalOrders : 0.0;

        final topItems = analyticsVM.getTopMenuItems(limit: 1);
        final bestSellingItemName = topItems.isNotEmpty ? topItems.first.menuItem : 'No Data';
        final bestSellingItemCount = topItems.isNotEmpty ? topItems.first.salesCount : 0;

        final takeaway = analyticsVM.salesTrendData?.orderTypeDistribution.takeaway ?? 0;
        final dineIn = analyticsVM.salesTrendData?.orderTypeDistribution.dineIn ?? 0;
        final totalTypes = takeaway + dineIn;
        final takeawayPct = totalTypes > 0 ? takeaway / totalTypes : 0.0;
        final dineInPct = totalTypes > 0 ? dineIn / totalTypes : 0.0;

    return Padding(
      padding: const EdgeInsets.only(
        top: 32.0,
        right: 32.0,
        bottom: 32.0,
        left: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Analytics Suite',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E231F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Track revenue, top-selling items, and performance metrics.',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 250,
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search orders, items...',
                        hintStyle: const TextStyle(fontSize: 13),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.notifications_none,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=11',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Top Metric Cards Row
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Total Revenue',
                  _formatCurrency(revenue),
                  '${revenueChange >= 0 ? '+' : ''}${revenueChange.toStringAsFixed(1)}% vs yesterday',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Average Order Value',
                  _formatCurrency(averageOrderValue),
                  '--', // No direct API field for AOV trend
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Total Orders',
                  '$totalOrders',
                  '${orderChange >= 0 ? '+' : ''}${orderChange.toStringAsFixed(1)}% vs yesterday',
                ),
              ),
              const SizedBox(width: 16),
              // Best Selling Item Card (Special Sage Green Styling)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2EFE9), // Light Sage Green
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Best Selling Item',
                            style: TextStyle(
                              color: Color(0xFF728A7C),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Colors.white54,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        bestSellingItemName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E231F),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$bestSellingItemCount orders today',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Bottom Charts Row
          Expanded(
            child: Row(
              children: [
                // Revenue Overview (Line Chart)
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Revenue Overview',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F2EE),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  _buildToggleButton('Weekly', true),
                                  _buildToggleButton('Monthly', false),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // Custom Line Chart Area
                        Expanded(
                          child: CustomPaint(
                            size: const Size(double.infinity, double.infinity),
                            painter: SimpleLineChartPainter(
                              data: analyticsVM.salesTrendData?.revenue ?? [],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Category Sales (Donut Chart)
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Type Distribution',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 160,
                                height: 160,
                                child: CircularProgressIndicator(
                                  value: 1.0,
                                  strokeWidth: 20,
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              if (totalTypes > 0)
                                SizedBox(
                                  width: 160,
                                  height: 160,
                                  child: CircularProgressIndicator(
                                    value: takeawayPct + dineInPct,
                                    strokeWidth: 20,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              if (totalTypes > 0)
                                SizedBox(
                                  width: 160,
                                  height: 160,
                                  child: CircularProgressIndicator(
                                    value: dineInPct,
                                    strokeWidth: 20,
                                    color: const Color(0xFF728A7C),
                                  ),
                                ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Total Orders',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '$totalOrders',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        _buildLegendItem(
                          'Dine-In',
                          '${(dineInPct * 100).toStringAsFixed(0)}%',
                          const Color(0xFF728A7C),
                        ),
                        const SizedBox(height: 12),
                        _buildLegendItem(
                          'Takeaway',
                          '${(takeawayPct * 100).toStringAsFixed(0)}%',
                          Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
      },
    );
  }

  Widget _buildMetricCard(String title, String value, String trend) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            trend,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isActive
            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
            : [],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          color: isActive ? const Color(0xFF1E231F) : Colors.grey.shade500,
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, String percentage, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ],
        ),
        Text(
          percentage,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    );
  }
}

// Custom Painter to draw the smooth bezier curve for the Revenue chart
class SimpleLineChartPainter extends CustomPainter {
  final List<double> data;

  SimpleLineChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final linePaint = Paint()
      ..color = const Color(0xFF728A7C)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = const Color(0xFFE2EFE9).withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final path = Path();
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final range = maxVal == 0 ? 1.0 : maxVal;

    final stepX = data.length > 1 ? size.width / (data.length - 1) : size.width;

    // Use bezier curves for smooth lines
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - (data[i] / range) * size.height * 0.8;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = (i - 1) * stepX;
        final prevY = size.height - (data[i - 1] / range) * size.height * 0.8;
        final controlPointX = prevX + (x - prevX) / 2;
        path.cubicTo(controlPointX, prevY, controlPointX, y, x, y);
      }
    }

    // Draw the fill
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fillPath, fillPaint);

    // Draw the line
    canvas.drawPath(path, linePaint);

    // Draw data points (circles)
    final circlePaint = Paint()..color = Colors.white;
    final strokePaint = Paint()
      ..color = const Color(0xFF728A7C)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - (data[i] / range) * size.height * 0.8;
      canvas.drawCircle(Offset(x, y), 6, circlePaint);
      canvas.drawCircle(Offset(x, y), 6, strokePaint);
    }

    // Draw horizontal grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final y = size.height - (size.height / 4 * i);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SimpleLineChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}
