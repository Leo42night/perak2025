import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secure USB Reader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalAuthentication auth = LocalAuthentication();
  List<FileSystemEntity> _files = [];
  bool _isLoading = false;
  String _statusMessage = 'Pilih file dari USB/OTG';
  bool _isBiometricAvailable = false;
  
  // Platform channel untuk vibration
  static const platform = MethodChannel('com.example.hardware/vibration');

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  // Cek ketersediaan biometric
  Future<void> _checkBiometric() async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();
      
      setState(() {
        _isBiometricAvailable = canAuthenticate;
      });

      if (!canAuthenticate) {
        _showSnackBar('Perangkat tidak mendukung autentikasi biometrik', Colors.orange);
      }
    } catch (e) {
      setState(() {
        _isBiometricAvailable = false;
      });
    }
  }

  // Autentikasi fingerprint
  Future<bool> _authenticateWithFingerprint() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Scan fingerprint untuk membuka dokumen',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (didAuthenticate) {
        await _vibrateSuccess();
        _showSnackBar('Autentikasi berhasil!', Colors.green);
      } else {
        await _vibrateError();
        _showSnackBar('Autentikasi gagal!', Colors.red);
      }

      return didAuthenticate;
    } on PlatformException catch (e) {
      await _vibrateError();
      _showSnackBar('Error: ${e.message}', Colors.red);
      return false;
    }
  }

  // Getaran sukses (pola: short-short) menggunakan native vibration
  Future<void> _vibrateSuccess() async {
    try {
      await platform.invokeMethod('vibrate', {'duration': 100});
      await Future.delayed(const Duration(milliseconds: 150));
      await platform.invokeMethod('vibrate', {'duration': 100});
    } catch (e) {
      // Fallback ke HapticFeedback
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.mediumImpact();
    }
  }

  // Getaran error (pola: long) menggunakan native vibration
  Future<void> _vibrateError() async {
    try {
      await platform.invokeMethod('vibrate', {'duration': 500});
    } catch (e) {
      // Fallback ke HapticFeedback
      await HapticFeedback.heavyImpact();
    }
  }

  // Getaran dokumen loaded (pola: triple short)
  Future<void> _vibrateDocumentLoaded() async {
    try {
      for (int i = 0; i < 3; i++) {
        await platform.invokeMethod('vibrate', {'duration': 80});
        if (i < 2) await Future.delayed(const Duration(milliseconds: 100));
      }
    } catch (e) {
      // Fallback ke HapticFeedback
      for (int i = 0; i < 3; i++) {
        await HapticFeedback.lightImpact();
        if (i < 2) await Future.delayed(const Duration(milliseconds: 80));
      }
    }
  }

  // Baca file dari USB/OTG menggunakan Storage Access Framework
  Future<void> _pickFileFromUSB() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Memilih file...';
    });

    try {
      // Request storage permission untuk Android 13+
      if (Platform.isAndroid) {
        final androidInfo = await _getAndroidVersion();
        
        if (androidInfo >= 33) {
          // Android 13+ menggunakan granular permissions
          var photoStatus = await Permission.photos.status;
          var videoStatus = await Permission.videos.status;
          
          if (!photoStatus.isGranted || !videoStatus.isGranted) {
            await [Permission.photos, Permission.videos].request();
          }
        } else {
          // Android 12 dan dibawah
          var status = await Permission.storage.status;
          if (!status.isGranted) {
            status = await Permission.storage.request();
          }
        }
      }

      // Simulasi pembacaan file dari USB
      // Pada implementasi nyata, gunakan platform channels untuk SAF
      await _showFilePickerDialog();
      
    } catch (e) {
      _showSnackBar('Error: $e', Colors.red);
      setState(() {
        _statusMessage = 'Error membaca file';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Get Android version
  Future<int> _getAndroidVersion() async {
    try {
      final version = await MethodChannel('android_version')
          .invokeMethod<int>('getVersion');
      return version ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Dialog untuk memilih file simulasi
  Future<void> _showFilePickerDialog() async {
    final directory = await getExternalStorageDirectory();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih File dari USB/OTG'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('Dokumen_Penting.pdf'),
              subtitle: const Text('1.2 MB'),
              onTap: () {
                Navigator.pop(context);
                _simulateFileAccess('Dokumen_Penting.pdf', 'pdf');
              },
            ),
            ListTile(
              leading: const Icon(Icons.description, color: Colors.blue),
              title: const Text('Laporan.docx'),
              subtitle: const Text('856 KB'),
              onTap: () {
                Navigator.pop(context);
                _simulateFileAccess('Laporan.docx', 'docx');
              },
            ),
            ListTile(
              leading: const Icon(Icons.image, color: Colors.green),
              title: const Text('Foto_KTP.jpg'),
              subtitle: const Text('2.4 MB'),
              onTap: () {
                Navigator.pop(context);
                _simulateFileAccess('Foto_KTP.jpg', 'jpg');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  // Simulasi akses file
  Future<void> _simulateFileAccess(String fileName, String extension) async {
    setState(() {
      _statusMessage = 'File ditemukan: $fileName';
    });

    // Buat file dummy untuk simulasi
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    
    // Buat file dummy jika belum ada
    if (!await file.exists()) {
      await file.create();
      await file.writeAsString('Ini adalah konten simulasi untuk file: $fileName\n\n'
          'File ini dibuat untuk demonstrasi aplikasi USB/OTG Reader.\n'
          'Dalam implementasi nyata, file akan dibaca dari perangkat USB/OTG.');
    }
    
    // Autentikasi sebelum membuka
    await _openFileWithAuth(file, fileName);
  }

  // Buka file dengan autentikasi
  Future<void> _openFileWithAuth(File file, String fileName) async {
    if (!_isBiometricAvailable) {
      _showSnackBar(
        'Biometric tidak tersedia. File tetap dibuka tanpa autentikasi.',
        Colors.orange,
      );
      await _openDocument(file, fileName);
      return;
    }

    final bool authenticated = await _authenticateWithFingerprint();

    if (authenticated) {
      await _openDocument(file, fileName);
    } else {
      setState(() {
        _statusMessage = 'Akses ditolak - Autentikasi gagal';
      });
    }
  }

  // Buka dan tampilkan dokumen
  Future<void> _openDocument(File file, String fileName) async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Memuat dokumen...';
    });

    try {
      // Pastikan file ada
      if (!await file.exists()) {
        await file.create();
        await file.writeAsString('Konten dokumen simulasi: $fileName');
      }
      
      final fileSize = await file.length();
      final lastModified = await file.lastModified();
      final fileContent = await file.readAsString();

      await Future.delayed(const Duration(milliseconds: 500)); // Simulasi loading

      // Vibrate saat dokumen berhasil dimuat
      await _vibrateDocumentLoaded();

      setState(() {
        _statusMessage = 'Dokumen berhasil dimuat!';
      });

      // Tampilkan dialog info file
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 28),
                const SizedBox(width: 10),
                const Expanded(child: Text('Dokumen Terbuka')),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Nama File:', fileName),
                  const SizedBox(height: 8),
                  _buildInfoRow('Ukuran:', '${(fileSize / 1024).toStringAsFixed(2)} KB'),
                  const SizedBox(height: 8),
                  _buildInfoRow('Terakhir Diubah:', 
                    '${lastModified.day}/${lastModified.month}/${lastModified.year}'),
                  const SizedBox(height: 8),
                  _buildInfoRow('Path:', file.path),
                  const Divider(height: 24),
                  const Text(
                    'Preview Konten:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      fileContent.length > 200 
                        ? '${fileContent.substring(0, 200)}...' 
                        : fileContent,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.vibration, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Getaran konfirmasi telah diaktifkan',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      _showSnackBar('Error membuka dokumen: $e', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure USB Reader'),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(
              _isBiometricAvailable ? Icons.fingerprint : Icons.fingerprint_outlined,
              color: _isBiometricAvailable ? Colors.green : Colors.grey,
            ),
            onPressed: _checkBiometric,
            tooltip: _isBiometricAvailable 
              ? 'Biometric tersedia' 
              : 'Biometric tidak tersedia',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Status Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        _isLoading 
                          ? Icons.hourglass_empty 
                          : Icons.usb,
                        size: 64,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _statusMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (_isLoading) ...[
                        const SizedBox(height: 16),
                        const CircularProgressIndicator(),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Instruksi
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Cara Penggunaan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInstructionStep('1', 'Hubungkan USB/OTG ke perangkat'),
                    _buildInstructionStep('2', 'Tekan tombol "Buka File dari USB"'),
                    _buildInstructionStep('3', 'Pilih file yang ingin dibuka'),
                    _buildInstructionStep('4', 'Scan fingerprint untuk autentikasi'),
                    _buildInstructionStep('5', 'Rasakan getaran konfirmasi'),
                  ],
                ),
              ),
              const Spacer(),

              // Tombol aksi
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _pickFileFromUSB,
                  icon: const Icon(Icons.folder_open, size: 24),
                  label: const Text(
                    'Buka File dari USB',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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

  Widget _buildInstructionStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}