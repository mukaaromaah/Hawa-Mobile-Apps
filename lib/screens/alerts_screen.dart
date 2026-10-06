import 'package:flutter/material.dart';
import 'package:hawa_mobile/theme/app_theme.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 72, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contextual Subheader & Filter Pill Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alerts',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Recent Changes',
                    style: TextStyle(fontSize: 14, color: Color(0xFF404942)),
                  ),
                ],
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.tune, color: AppTheme.primary, size: 18),
                      const SizedBox(width: 6),
                      const Text(
                        'Filter (4)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.onSurface),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Live Pulse Status Indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppTheme.error.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(color: AppTheme.error, shape: BoxShape.circle),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Attention Needed',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.onSurface),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.errorContainer.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '2 UNRESOLVED',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.error, letterSpacing: 0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Ambient Illustration Banner
          Container(
            width: double.infinity,
            height: 110,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFCFF0DF), Color(0xFFD7F8E8)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quiet Air Defense',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurface,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Sensing high-density aerosols',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF404942), letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.eco_rounded, size: 64, color: AppTheme.primary.withValues(alpha: 0.15)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Alerts Stream Cards
          _AlertCard(
            zone: 'Zone 02',
            description: 'PM2.5 rising • 2m ago',
            value: '42',
            unit: 'PM2.5',
            icon: Icons.trending_up,
            color: AppTheme.secondary,
            bgColor: AppTheme.surfaceContainerHigh,
          ),
          const SizedBox(height: 12),
          _AlertCard(
            zone: 'Zone 03',
            description: 'Rapid spike • 15m ago',
            value: '58',
            unit: 'PM2.5',
            icon: Icons.priority_high,
            color: AppTheme.error,
            bgColor: AppTheme.errorContainer,
          ),
          const SizedBox(height: 12),
          _AlertCard(
            zone: 'Zone 01',
            description: 'Back to normal • 1h ago',
            value: '18',
            unit: 'PM2.5',
            icon: Icons.check_circle,
            color: AppTheme.primaryContainer,
            bgColor: AppTheme.surfaceContainerHigh,
          ),
          const SizedBox(height: 12),
          _AlertCard(
            zone: 'Zone 04',
            description: 'Stable condition • 2h ago',
            value: '14',
            unit: 'PM2.5',
            icon: Icons.nature,
            color: AppTheme.primaryContainer,
            bgColor: AppTheme.surfaceContainerHigh,
          ),
          const SizedBox(height: 16),

          // Adaptive Summary Footer Pill
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sync, color: AppTheme.primaryContainer, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Adaptive cadence active • 1 zone accelerated',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.onSurface),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatefulWidget {
  final String zone;
  final String description;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _AlertCard({
    required this.zone,
    required this.description,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  State<_AlertCard> createState() => _AlertCardState();
}

class _AlertCardState extends State<_AlertCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.zone}: PM2.5 ${widget.value} µg/m³ — ${widget.description}'),
            backgroundColor: AppTheme.primaryContainer,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(color: widget.bgColor, shape: BoxShape.circle),
                      child: Icon(widget.icon, color: widget.color, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.zone,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.onSurface),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
                              ),
                            ],
                          ),
                          Text(
                            widget.description,
                            style: const TextStyle(fontSize: 14, color: Color(0xFF404942)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.value,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.unit,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF404942), letterSpacing: 0.5),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
