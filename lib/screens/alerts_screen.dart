import 'package:flutter/material.dart';
import 'package:hawa_mobile/theme/app_theme.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contextual Subheader & Filter Pill Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alerts',
                      style: AppTheme.font(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryDark,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'Recent Changes',
                      style: AppTheme.font(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.tune, color: AppTheme.primary, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Filter (4)',
                            style: AppTheme.font(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Live Pulse Status Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryDark.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
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
                      Text(
                        'Attention Needed',
                        style: AppTheme.font(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.primaryDark),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.errorContainer.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '2 UNRESOLVED',
                      style: AppTheme.font(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.error, letterSpacing: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Ambient Illustration Banner
            Container(
              width: double.infinity,
              height: 96,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD3EEDF), Color(0xFFE5F7ED)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quiet Air Defense',
                          style: AppTheme.font(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Sensing high-density aerosols',
                          style: AppTheme.font(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.eco_rounded, size: 52, color: AppTheme.primary.withValues(alpha: 0.18)),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Alerts Stream Cards
            _AlertCard(
              zone: 'Zone 02 · Taman Bunga Hortensia',
              description: 'PM2.5 rising • 2m ago',
              value: '42',
              unit: 'PM2.5',
              icon: Icons.trending_up,
              color: AppTheme.secondary,
              bgColor: AppTheme.surfaceContainerHigh,
            ),
            const SizedBox(height: 12),
            _AlertCard(
              zone: 'Zone 03 · Sawang Alam Cafe',
              description: 'Rapid spike • 15m ago',
              value: '58',
              unit: 'PM2.5',
              icon: Icons.priority_high,
              color: AppTheme.error,
              bgColor: AppTheme.errorContainer,
            ),
            const SizedBox(height: 12),
            _AlertCard(
              zone: 'Zone 01 · Area TPS3R',
              description: 'Back to normal • 1h ago',
              value: '18',
              unit: 'PM2.5',
              icon: Icons.check_circle,
              color: AppTheme.primaryContainer,
              bgColor: AppTheme.surfaceContainerHigh,
            ),
            const SizedBox(height: 16),

            // Adaptive Summary Footer Pill (Fixed width overflow)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sync, color: AppTheme.primary, size: 16),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Adaptive cadence active • 1 zone accelerated',
                        style: AppTheme.font(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryDark),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderLight),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryDark.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Left: icon + text (takes all remaining space)
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(color: widget.bgColor, shape: BoxShape.circle),
                        child: Icon(widget.icon, color: widget.color, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.zone,
                                    style: AppTheme.font(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primaryDark),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.description,
                              style: AppTheme.font(fontSize: 12, color: AppTheme.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Right: fixed-width value — always visible, never pushed out
                SizedBox(
                  width: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.value,
                        style: AppTheme.font(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: widget.color,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.unit,
                        style: AppTheme.font(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.textMuted, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
