import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRPage extends StatefulWidget {
  const ScanQRPage({super.key});

  @override
  State<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  String? _scannedData;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? codeValue = barcodes.first.rawValue;
      if (codeValue != null && codeValue.isNotEmpty) {
        setState(() {
          _scannedData = codeValue;
        });
      }
    }
  }

  void _copyToClipboard() {
    if (_scannedData != null) {
      Clipboard.setData(ClipboardData(text: _scannedData!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Teks berhasil disalin ke clipboard!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          // Flashlight/Torch Toggle Button
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: _controller,
            builder: (context, state, child) {
              final isTorchOn = state.torchState == TorchState.on;
              return IconButton(
                icon: Icon(
                  isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                  color: isTorchOn ? Colors.amber : null,
                ),
                onPressed: () => _controller.toggleTorch(),
                tooltip: 'Toggle Flashlight',
              );
            },
          ),
          // Camera Facing Toggle Button
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: _controller,
            builder: (context, state, child) {
              final isFront = state.cameraDirection == CameraFacing.front;
              return IconButton(
                icon: Icon(
                  isFront ? Icons.camera_front_rounded : Icons.camera_rear_rounded,
                ),
                onPressed: () => _controller.switchCamera(),
                tooltip: 'Switch Camera',
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scanner feed window
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      MobileScanner(
                        controller: _controller,
                        onDetect: _onDetect,
                      ),
                      // Semi-transparent target scanner overlay box
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: colorScheme.primary,
                                  width: 4,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Scanner Result Card View
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Hasil Scan:',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            _scannedData ?? 'Arahkan kamera ke QR Code untuk memindai.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _scannedData != null
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                              fontStyle: _scannedData != null
                                  ? FontStyle.normal
                                  : FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_scannedData != null) ...[
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _copyToClipboard,
                        icon: const Icon(Icons.copy_rounded),
                        label: const Text(
                          'Salin Hasil Scan',
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
