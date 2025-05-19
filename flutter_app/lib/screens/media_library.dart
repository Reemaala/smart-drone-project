import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'menu.dart';
import 'main_page.dart';
import 'control_center.dart';
import 'drone_status.dart';
import 'flight_logs.dart';
import 'iphone_frame.dart';
import 'media_storage.dart';




class MediaLibraryPage extends StatefulWidget {
  const MediaLibraryPage({super.key});

  @override
  MediaLibraryPageState createState() => MediaLibraryPageState();
}

class MediaLibraryPageState extends State<MediaLibraryPage> {
  int selectedIndex = 3;
  String selectedFilter = "All";
  List<Map<String, dynamic>> savedMedia = [];

  final List<Map<String, String>> staticMediaItems = [
    {"type": "image", "path": "assets/image1.jpg"},
    {"type": "video", "path": "assets/video1.MP4", "thumbnail": "assets/video2_thumbnail.2.jpg"},
    {"type": "video", "path": "assets/video2.MP4", "thumbnail": "assets/video1_thumbnail1.jpg"},
    {"type": "video", "path": "assets/video3.MP4", "thumbnail": "assets/video3_thumbnail3.jpg"},
    {"type": "image", "path": "assets/image2.jpg"},
    {"type": "image", "path": "assets/image3.jpg"},
    {"type": "image", "path": "assets/c20.png"},
    {"type": "image", "path": "assets/c1.png"},
    {"type": "image", "path": "assets/c2.png"},
    {"type": "image", "path": "assets/c3.png"},
    {"type": "image", "path": "assets/c4.png"},
    {"type": "image", "path": "assets/c5.png"},
    {"type": "image", "path": "assets/c6.png"},
    {"type": "image", "path": "assets/c7.png"},
    {"type": "image", "path": "assets/c8.png"},
    {"type": "image", "path": "assets/c9.png"},
    {"type": "image", "path": "assets/c10.png"},
    {"type": "image", "path": "assets/c11.png"},
    {"type": "image", "path": "assets/c12.png"},
    {"type": "image", "path": "assets/c13.png"},
    {"type": "image", "path": "assets/c14.png"},
    {"type": "image", "path": "assets/c15.png"},
    {"type": "image", "path": "assets/c16.png"},
    {"type": "image", "path": "assets/c17.png"},
    {"type": "image", "path": "assets/c18.png"},
    {"type": "image", "path": "assets/c19.png"},
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedMedia();
  }

  Future<void> _loadSavedMedia() async {
    final loaded = await MediaStorage.loadImagePaths();
    setState(() {
      savedMedia = loaded;
    });
  }

  bool isImage(String path) {
    return path.toLowerCase().endsWith(".jpg") ||
        path.toLowerCase().endsWith(".jpeg") ||
        path.toLowerCase().endsWith(".png");
  }

  bool isVideo(String path) {
    return path.toLowerCase().endsWith(".mp4") ||
        path.toLowerCase().endsWith(".mov") ||
        path.toLowerCase().endsWith(".avi");
  }

  @override
  Widget build(BuildContext context) {
    final enrichedMedia = savedMedia.map((item) {
      final path = item["path"] ?? "";
      final lat = item["lat"];
      final lon = item["lon"];
      final place = item["place"];
      final thumbnail = item["thumbnail"];
      final type = item["type"] ?? (isImage(path) ? "image" : "video");

      return {
        "type": type,
        "path": path,
        "lat": lat,
        "lon": lon,
        "place": place,
        "thumbnail": thumbnail,
        "isUser": true,
      };
    }).toList();

    final enrichedStatic = staticMediaItems.map((item) => {
      ...item,
      "isUser": false,
    }).toList();

    final allMedia = [...enrichedMedia, ...enrichedStatic];

    final filteredMedia = allMedia.where((item) {
      return selectedFilter == "All" ||
          item["type"]!.toLowerCase() == selectedFilter.toLowerCase();
    }).toList();

    return iPhoneFrame(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: const AppMenu(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFilterButton("All"),
                  _buildFilterButton("Image"),
                  _buildFilterButton("Video"),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: filteredMedia.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  return _buildMediaItem(filteredMedia[index]);
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          currentIndex: selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Flight Logs"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Control"),
            BottomNavigationBarItem(icon: Icon(Icons.airplanemode_active), label: "Drone"),
            BottomNavigationBarItem(icon: Icon(Icons.photo_library), label: "Media"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index != selectedIndex) {
      Widget nextPage;
      switch (index) {
        case 0: nextPage = const FlightLogsPage(); break;
        case 1: nextPage = const ControlCenterPage(); break;
        case 2: nextPage = const DroneStatusPage(); break;
        case 3: nextPage = const MediaLibraryPage(); break;
        case 4: nextPage = const MainPage(); break;
        default: return;
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => nextPage));
    }
  }

  Widget _buildFilterButton(String label) {
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: selectedFilter == label ? Colors.blueAccent : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildMediaItem(Map<String, dynamic> media) {
    final path = media["path"] ?? "";
    final type = media["type"];
    final lat = media["lat"];
    final lon = media["lon"];
    final place = media["place"];
    final thumbnail = media["thumbnail"];
    final isAsset = path.toString().startsWith("assets/");
    final isUser = media["isUser"] == true;

    Widget imageWidget;
    if (type == "video") {
      final hasCustomThumb = thumbnail != null && File(thumbnail).existsSync();
      imageWidget = hasCustomThumb
          ? Image.file(File(thumbnail), fit: BoxFit.cover)
          : isAsset && thumbnail != null
              ? Image.asset(thumbnail, fit: BoxFit.cover)
              : Container(color: Colors.grey[800], child: const Icon(Icons.videocam, size: 50, color: Colors.white));
    } else {
      imageWidget = isAsset
          ? Image.asset(path, fit: BoxFit.cover)
          : Image.file(File(path), fit: BoxFit.cover);
    }

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (type == "video") {
              Navigator.push(context, MaterialPageRoute(builder: (_) => VideoPlayerScreen(videoPath: path)));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ImagePreviewScreen(imagePath: path, isAsset: isAsset)));
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: imageWidget,
          ),
        ),
        if (lat != null && lon != null)
          Positioned(
            bottom: 4,
            left: 4,
            right: 4,
            child: Container(
              color: Colors.black.withOpacity(0.6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Text(
                place != null && place.toString().isNotEmpty ? "📍 $place" : "📍 $lat, $lon",
                style: const TextStyle(fontSize: 10, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        if (isUser)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () async {
                await MediaStorage.removeMediaPath(path);
                _loadSavedMedia();
              },
              child: Container(
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.delete, color: Colors.red, size: 18),
              ),
            ),
          ),
        if (type == "video")
          const Center(
            child: Icon(Icons.play_circle_fill, size: 40, color: Colors.white),
          ),
      ],
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;
  const VideoPlayerScreen({super.key, required this.videoPath});

  @override
  VideoPlayerScreenState createState() => VideoPlayerScreenState();
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.videoPath.startsWith("assets/")
        ? VideoPlayerController.asset(widget.videoPath)
        : VideoPlayerController.file(File(widget.videoPath));
    _controller.initialize().then((_) {
      setState(() {});
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: const Text("Video Player")),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller))
            : const CircularProgressIndicator(),
      ),
    );
  }
}

class ImagePreviewScreen extends StatelessWidget {
  final String imagePath;
  final bool isAsset;

  const ImagePreviewScreen({super.key, required this.imagePath, required this.isAsset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: isAsset
            ? Image.asset(imagePath, fit: BoxFit.contain)
            : Image.file(File(imagePath), fit: BoxFit.contain),
      ),
    );
  }
}

