import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumb;
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

import 'media_storage.dart';
import 'media_library.dart';

class MockCameraPage extends StatefulWidget {
  const MockCameraPage({super.key});

  @override
  State<MockCameraPage> createState() => _MockCameraPageState();
}

class _MockCameraPageState extends State<MockCameraPage> {
  late CameraController _cameraController;
  Future<void>? _initializeControllerFuture;
  late List<CameraDescription> _cameras;
  bool isRecording = false;
  bool isVideoMode = false;
  bool _isDetecting = false;
  int _cameraIndex = 0;
  ObjectDetector? _objectDetector;
  DateTime? _lastDetectionTime;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _initializeMLKit();
    _initializeCamera();
  }

  void _initializeMLKit() {
    final options = ObjectDetectorOptions(
      mode: DetectionMode.stream,
      classifyObjects: true,
      multipleObjects: true,
    );
    _objectDetector = ObjectDetector(options: options);
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _cameraController = CameraController(
        _cameras[_cameraIndex],
        ResolutionPreset.medium,
        enableAudio: true,
      );
      _initializeControllerFuture = _cameraController.initialize();
      await _initializeControllerFuture;
      _cameraController.startImageStream(_processCameraImage);
      setState(() {});
    } catch (e) {
      debugPrint("Camera init error: $e");
    }
  }

  void _switchCamera() async {
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    await _cameraController.dispose();
    _initializeCamera();
  }

  void _processCameraImage(CameraImage image) async {
    if (_isDetecting || _objectDetector == null) return;

    final now = DateTime.now();
    if (_lastDetectionTime != null &&
        now.difference(_lastDetectionTime!).inMilliseconds < 800) {
      return;
    }
    _lastDetectionTime = now;

    _isDetecting = true;

    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }

      final bytes = allBytes.done().buffer.asUint8List();
      final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        inputImageData: InputImageData(
          size: imageSize,
          imageRotation: InputImageRotation.rotation90deg,
          inputImageFormat:
              InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21,
          planeData: image.planes.map((plane) {
            return InputImagePlaneMetadata(
              bytesPerRow: plane.bytesPerRow,
              height: plane.height,
              width: plane.width,
            );
          }).toList(),
        ),
      );

      final objects = await _objectDetector!.processImage(inputImage);

      // 👤 Count people by checking for label index 0
      final people = objects.where((o) {
        return o.labels.isNotEmpty && o.labels.first.index == 0;
      }).length;

      debugPrint("👥 Detected $people people out of ${objects.length} objects");

      if (people >= 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("🚨 Overcrowding detected! ($people people)"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint("MLKit error: $e");
    } finally {
      _isDetecting = false;
    }
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always && permission != LocationPermission.whileInUse) return null;
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _takePicture() async {
    try {
      if (!_cameraController.value.isInitialized) return;
      final image = await _cameraController.takePicture();
      final bytes = await File(image.path).readAsBytes();
      await ImageGallerySaver.saveImage(Uint8List.fromList(bytes));
      final position = await _getCurrentLocation();
      await MediaStorage.addMediaPath(
        type: 'image',
        path: image.path,
        lat: position?.latitude,
        lon: position?.longitude,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("📸 Image saved")));
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MediaLibraryPage()));
    } catch (e) {
      debugPrint("Capture error: $e");
    }
  }

  Future<void> _startVideoRecording() async {
    if (!_cameraController.value.isInitialized) return;
    await _cameraController.startVideoRecording();
    setState(() => isRecording = true);
  }

  Future<void> _stopVideoRecording() async {
    try {
      final video = await _cameraController.stopVideoRecording();
      final position = await _getCurrentLocation();
      final tempDir = await getTemporaryDirectory();
      final thumbFile = await thumb.VideoThumbnail.thumbnailFile(
        video: video.path,
        thumbnailPath: tempDir.path,
        imageFormat: thumb.ImageFormat.PNG,
        maxWidth: 300,
        quality: 75,
      );

      await MediaStorage.addMediaPath(
        type: 'video',
        path: video.path,
        lat: position?.latitude,
        lon: position?.longitude,
        thumbnailPath: thumbFile,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("🎥 Video saved")));
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MediaLibraryPage()));
      setState(() => isRecording = false);
    } catch (e) {
      debugPrint("Stop recording error: $e");
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _objectDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FutureBuilder(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: AspectRatio(
                    aspectRatio: _cameraController.value.aspectRatio,
                    child: CameraPreview(_cameraController),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text("Camera not available", style: TextStyle(color: Colors.white)));
              } else {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }
            },
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cameraswitch, color: Colors.white),
                    onPressed: _switchCamera,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 16,
            right: 16,
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: isRecording
                      ? _stopVideoRecording
                      : isVideoMode
                          ? _startVideoRecording
                          : _takePicture,
                  icon: Icon(isVideoMode
                      ? (isRecording ? Icons.stop : Icons.videocam)
                      : Icons.camera_alt),
                  label: Text(isVideoMode
                      ? (isRecording ? "Stop Recording" : "Start Recording")
                      : "Capture Photo"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRecording ? Colors.red : Colors.white,
                    foregroundColor: isRecording ? Colors.white : Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => setState(() => isVideoMode = !isVideoMode),
                  child: Text(
                    isVideoMode ? "Switch to Photo Mode" : "Switch to Video Mode",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


