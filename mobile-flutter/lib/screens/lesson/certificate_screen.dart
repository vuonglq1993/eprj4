import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../../core/theme.dart';
import '../../core/app_widgets.dart';

class CertificateScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const CertificateScreen({super.key, required this.data});

  String get _userName     => data['userName']     as String? ?? '';
  String get _courseTitle  => data['courseTitle']  as String? ?? '';
  String get _languageName => data['languageName'] as String? ?? '';
  String get _cefrLevel    => data['cefrLevel']    as String? ?? '';
  String get _certCode     => data['certificateCode'] as String? ?? '';
  double get _score        => (data['finalScore']  as num?)?.toDouble() ?? 0;

  String get _completedDate {
    final raw = data['completedAt'] as String?;
    if (raw == null) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0A1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Chứng chỉ', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_rounded, color: Colors.white70, size: 20),
            tooltip: 'Sao chép mã chứng chỉ',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _certCode));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã sao chép mã chứng chỉ'), duration: Duration(seconds: 2)),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              _buildCertificateCard(),
              const SizedBox(height: 28),
              _buildShareRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCertificateCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C3DE8).withValues(alpha: 0.45),
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A0A3E), Color(0xFF2D1265), Color(0xFF1A0A3E)],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Decorative corner patterns
              Positioned(top: -20, left: -20, child: _corner(120)),
              Positioned(bottom: -20, right: -20, child: Transform.rotate(angle: math.pi, child: _corner(120))),
              // Gold border
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.5), width: 1.5),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
                child: Column(
                  children: [
                    // Logo + app name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)]),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.language_rounded, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 10),
                        const Text('LinguaNext', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Divider gold
                    _goldDivider(),
                    const SizedBox(height: 18),
                    const Text('CHỨNG CHỈ HOÀN THÀNH', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 3)),
                    const SizedBox(height: 18),
                    const Text('Chứng nhận rằng', style: TextStyle(color: Colors.white60, fontSize: 13)),
                    const SizedBox(height: 10),
                    // Student name
                    Text(
                      _userName,
                      style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    const Text('đã hoàn thành khoá học', style: TextStyle(color: Colors.white60, fontSize: 13)),
                    const SizedBox(height: 10),
                    // Course title
                    Text(
                      _courseTitle,
                      style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _languageName,
                      style: const TextStyle(color: Color(0xFFB39DDB), fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    // CEFR + Score row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_cefrLevel.isNotEmpty) ...[
                          _badge(_cefrLevel, const Color(0xFF6C3DE8), const Color(0xFF9C6FFF)),
                          const SizedBox(width: 12),
                        ],
                        _badge('${_score.toStringAsFixed(0)}%', const Color(0xFF1A6E3E), const Color(0xFF34D399)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _goldDivider(),
                    const SizedBox(height: 16),
                    // Date + code
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Ngày cấp', style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 0.5)),
                            Text(_completedDate, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Mã chứng chỉ', style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 0.5)),
                            Text(_certCode, style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _goldDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, Color(0xFFD4AF37)])))),
        Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFFD4AF37), shape: BoxShape.circle)),
        Expanded(child: Container(height: 1, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFD4AF37), Colors.transparent])))),
      ],
    );
  }

  Widget _badge(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: 0.5)),
      ),
      child: Text(text, style: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 1)),
    );
  }

  Widget _corner(double size) {
    return Opacity(
      opacity: 0.08,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFD4AF37), width: 2),
        ),
      ),
    );
  }

  Widget _buildShareRow(BuildContext context) {
    return TappableScale(
      onTap: () {
        Clipboard.setData(ClipboardData(text: _certCode));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã sao chép mã chứng chỉ'), duration: Duration(seconds: 2)),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF6C3DE8), Color(0xFF4F46E5)]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: const Color(0xFF6C3DE8).withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.copy_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Sao chép mã chứng chỉ', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
