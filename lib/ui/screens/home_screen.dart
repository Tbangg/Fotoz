import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fotoz/ui/screens/profile_screen.dart';
import 'package:fotoz/ui/screens/history_screen.dart';
import 'package:fotoz/ui/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  bool _isRearCamera = true;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final selectedCamera = _isRearCamera
        ? cameras.first
        : cameras.length > 1
        ? cameras.last
        : cameras.first;

    _cameraController = CameraController(selectedCamera, ResolutionPreset.high);
    _initializeControllerFuture = _cameraController!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _switchCamera() {
    setState(() {
      _isRearCamera = !_isRearCamera;
    });
    _initCamera();
  }

  Future<void> _captureAndUpload() async {
    try {
      await _initializeControllerFuture;
      final picture = await _cameraController!.takePicture();
      final file = File(picture.path);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bạn cần đăng nhập để chụp ảnh.")),
        );
        return;
      }

      setState(() {
        _isUploading = true;
      });

      // 🔹 Upload lên Firebase Storage
      final ref = FirebaseStorage.instance.ref().child(
        'uploads/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      await ref.putFile(file);
      final url = await ref.getDownloadURL();

      // 🔹 Lưu metadata vào Firestore
      await FirebaseFirestore.instance.collection('photos').add({
        'userId': user.uid,
        'userName': user.displayName ?? 'Người dùng',
        'url': url,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ảnh đã được lưu vào Lịch sử 💛"),
          backgroundColor: AppTheme.darkBlue,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi chụp ảnh: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🔹 Camera Preview
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.55,
                    color: Colors.black,
                    child: (_cameraController != null)
                        ? FutureBuilder(
                            future: _initializeControllerFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return CameraPreview(_cameraController!);
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: AppTheme.darkBlue,
                                  ),
                                );
                              }
                            },
                          )
                        : const Center(child: Text('Đang mở camera...')),
                  ),
                ),
              ),
            ),

            // 🔹 Thanh trên cùng
            Positioned(
              top: 16,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Avatar → Profile
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : const AssetImage('assets/logo.png')
                                as ImageProvider,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.darkBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.group, size: 18, color: AppTheme.darkBlue),
                        SizedBox(width: 6),
                        Text(
                          "25 người bạn",
                          style: TextStyle(
                            color: AppTheme.darkBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.search, size: 26, color: AppTheme.darkBlue),
                ],
              ),
            ),

            // 🔹 Thanh điều khiển dưới cùng
            Positioned(
              bottom: 50,
              child: Column(
                children: [
                  // Hàng 3 nút chính
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Nút mở thư viện
                      IconButton(
                        icon: const Icon(
                          Icons.photo_library_outlined,
                          size: 34,
                          color: AppTheme.darkBlue,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Chức năng chọn ảnh sắp ra mắt!'),
                            ),
                          );
                        },
                      ),

                      const SizedBox(width: 40),

                      // Nút chụp ảnh
                      GestureDetector(
                        onTap: _isUploading ? null : _captureAndUpload,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.beige,
                                border: Border.all(
                                  color: AppTheme.darkBlue,
                                  width: 5,
                                ),
                              ),
                            ),
                            if (_isUploading)
                              const CircularProgressIndicator(
                                color: AppTheme.darkBlue,
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 40),

                      // Nút đổi camera
                      IconButton(
                        icon: const Icon(
                          Icons.cameraswitch_outlined,
                          size: 34,
                          color: AppTheme.darkBlue,
                        ),
                        onPressed: _switchCamera,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Nút “Lịch sử”
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HistoryScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.beige.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.history,
                            size: 20,
                            color: AppTheme.darkBlue,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Lịch sử",
                            style: TextStyle(
                              color: AppTheme.darkBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 22,
                            color: AppTheme.darkBlue,
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
      ),
    );
  }
}
