import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hawa_mobile/screens/login_screen.dart';
import 'package:hawa_mobile/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _hazardAlerts = true;
  bool _audioAlarms = false;
  bool _autoRefresh = true;

  void _showLogoutDialog() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout_rounded, color: AppTheme.error, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Keluar Akun?',
                style: AppTheme.font(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryDark,
                ),
              ),
            ],
          ),
          content: Text(
            'Anda harus masuk kembali menggunakan email dan kata sandi untuk mengakses pemantauan sensor HAWA.',
            style: AppTheme.font(
              fontSize: 13,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                'Batal',
                style: AppTheme.font(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              ),
              onPressed: () {
                Navigator.pop(dialogCtx);
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 350),
                    pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                  (route) => false,
                );
              },
              child: Text(
                'Ya, Keluar',
                style: AppTheme.font(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditProfileSheet() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetCtx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Ubah Data Profil',
                style: AppTheme.font(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(height: 16),
              _buildModalTextField('Nama Lengkap', 'Ahmad Fauzan'),
              const SizedBox(height: 12),
              _buildModalTextField('Jabatan', 'Kepala Operasional TPS3R Brakseng'),
              const SizedBox(height: 12),
              _buildModalTextField('No. WhatsApp', '+62 812-3456-7890'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryDark,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pop(sheetCtx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Profil berhasil diperbarui',
                          style: AppTheme.font(fontSize: 13, color: Colors.white),
                        ),
                        backgroundColor: AppTheme.primaryDark,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  child: Text(
                    'Simpan Perubahan',
                    style: AppTheme.font(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalTextField(String label, String initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.font(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          style: AppTheme.font(fontSize: 13, color: AppTheme.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.surfaceContainerLow,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8F5EE), // Soft mint
              Color(0xFFF7FAF8), // Off-white
              Color(0xFFEDF7F2), // Light sage
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── Header Bar ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryDark.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: AppTheme.primaryDark,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Profil Pengguna',
                      style: AppTheme.font(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: _showEditProfileSheet,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryDark.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.edit_outlined,
                            color: AppTheme.primaryDark,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Content List ────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Profile Card ──────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryDark.withValues(alpha: 0.05),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppTheme.primaryDark,
                                        Color(0xFF1B4938),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppTheme.accentGreen, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primaryDark.withValues(alpha: 0.15),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.person_rounded,
                                      color: Colors.white,
                                      size: 42,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppTheme.success,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Ahmad Fauzan',
                              style: AppTheme.font(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Kepala Operasional Monitoring',
                              style: AppTheme.font(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.mintContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    color: AppTheme.primaryDark,
                                    size: 13,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'TPS3R Brakseng · Batu, Jatim',
                                    style: AppTheme.font(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Stats Counter Row
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatItem('3', 'Zona Pantau'),
                                  _buildStatDivider(),
                                  _buildStatItem('12', 'Sensor IoT'),
                                  _buildStatDivider(),
                                  _buildStatItem('99.8%', 'Uptime'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Section 1: Data Akun ──────────────────────
                      _buildSectionHeader('INFORMASI AKUN'),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryDark.withValues(alpha: 0.04),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildInfoTile(
                              icon: Icons.badge_outlined,
                              title: 'ID Operator',
                              value: 'HW-OP-0248',
                            ),
                            _buildTileDivider(),
                            _buildInfoTile(
                              icon: Icons.alternate_email_rounded,
                              title: 'Email',
                              value: 'operator@hawa.eco.id',
                            ),
                            _buildTileDivider(),
                            _buildInfoTile(
                              icon: Icons.phone_outlined,
                              title: 'No. Handphone',
                              value: '+62 812-3456-7890',
                            ),
                            _buildTileDivider(),
                            _buildInfoTile(
                              icon: Icons.domain_rounded,
                              title: 'Instansi / Unit',
                              value: 'Dinas Lingkungan Hidup',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Section 2: Preferensi Monitoring ──────────
                      _buildSectionHeader('PREFERENSI SISTEM'),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryDark.withValues(alpha: 0.04),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildSwitchTile(
                              icon: Icons.warning_amber_rounded,
                              title: 'Peringatan Bahaya Udara',
                              subtitle: 'Notifikasi saat PM2.5 > 35 µg/m³',
                              value: _hazardAlerts,
                              onChanged: (val) => setState(() => _hazardAlerts = val),
                            ),
                            _buildTileDivider(),
                            _buildSwitchTile(
                              icon: Icons.volume_up_outlined,
                              title: 'Suara Alarm Kritis',
                              subtitle: 'Bunyikan alarm saat zona bahaya',
                              value: _audioAlarms,
                              onChanged: (val) => setState(() => _audioAlarms = val),
                            ),
                            _buildTileDivider(),
                            _buildSwitchTile(
                              icon: Icons.sync_rounded,
                              title: 'Auto-Sync Data Real-time',
                              subtitle: 'Tarik telemetri via MQTT & HTTP',
                              value: _autoRefresh,
                              onChanged: (val) => setState(() => _autoRefresh = val),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Section 3: Status Jaringan IoT ────────────
                      _buildSectionHeader('JARINGAN & TELEMETRI'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryDark.withValues(alpha: 0.04),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: AppTheme.surfaceContainerLow,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.wifi_tethering_rounded,
                                        color: AppTheme.primaryDark,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Broker MQTT EMQX',
                                          style: AppTheme.font(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.primaryDark,
                                          ),
                                        ),
                                        Text(
                                          'broker.emqx.io · Port 8083',
                                          style: AppTheme.font(
                                            fontSize: 11,
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.successContainer,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: AppTheme.success,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Online',
                                        style: AppTheme.font(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.success,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Versi Aplikasi HAWA Mobile',
                                    style: AppTheme.font(fontSize: 12, color: AppTheme.textSecondary),
                                  ),
                                  Text(
                                    'v1.0.0 (Build 2026)',
                                    style: AppTheme.font(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ── Logout Action Button ──────────────────────
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: _showLogoutDialog,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppTheme.errorContainer,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.error.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.logout_rounded,
                                  color: AppTheme.error,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Keluar dari Aplikasi',
                                  style: AppTheme.font(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: AppTheme.font(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.textSecondary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildStatItem(String val, String label) {
    return Column(
      children: [
        Text(
          val,
          style: AppTheme.font(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTheme.font(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 24,
      color: AppTheme.textSecondary.withValues(alpha: 0.15),
    );
  }

  Widget _buildTileDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppTheme.surfaceContainerLow,
      indent: 52,
      endIndent: 16,
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primaryDark, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.font(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: AppTheme.font(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primaryDark, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.font(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryDark,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTheme.font(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppTheme.primaryDark,
            activeTrackColor: AppTheme.accentGreen,
            inactiveThumbColor: AppTheme.textMuted,
            inactiveTrackColor: AppTheme.surfaceContainer,
            onChanged: (newVal) {
              HapticFeedback.selectionClick();
              onChanged(newVal);
            },
          ),
        ],
      ),
    );
  }
}
