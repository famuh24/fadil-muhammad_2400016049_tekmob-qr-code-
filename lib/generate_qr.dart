
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQRPage extends StatefulWidget {
  const GenerateQRPage({super.key});

  @override
  State<GenerateQRPage> createState() => _GenerateQRPageState();
}

class _GenerateQRPageState extends State<GenerateQRPage> {
  final TextEditingController _textController = TextEditingController();
  String _qrData = '';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _generateQR() {
    setState(() {
      _qrData = _textController.text.trim();
    });
    // Dismiss keyboard
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate QR Code'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Card
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Masukkan Teks atau URL',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Contoh: https://google.com atau Halo Dunia',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.link_rounded),
                          filled: true,
                          fillColor: theme.cardColor,
                        ),
                        maxLines: 3,
                        minLines: 1,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _generateQR,
                        icon: const Icon(Icons.qr_code_2_rounded),
                        label: const Text(
                          'Buat QR Code',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // QR Code Output container
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _qrData.isEmpty
                    ? Container(
                        key: const ValueKey('placeholder'),
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.qr_code_2_rounded,
                                size: 64,
                                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'QR Code akan muncul di sini',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Card(
                        key: ValueKey(_qrData),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Text(
                                'Hasil QR Code',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white, // Ensure standard contrast for readability
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: QrImageView(
                                  data: _qrData,
                                  version: QrVersions.auto,
                                  size: 200.0,
                                  gapless: false,
                                  errorStateBuilder: (cxt, err) {
                                    return const Center(
                                      child: Text(
                                        'Terjadi kesalahan saat membuat QR Code.',
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Data QR Code:',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              SelectableText(
                                _qrData,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
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
    );
  }
}
