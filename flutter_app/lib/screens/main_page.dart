import 'package:flutter/material.dart';
import 'menu.dart';
import 'drone_status.dart';
import 'control_center.dart';
import 'media_library.dart';
import 'flight_logs.dart';
import 'iphone_frame.dart';
import 'mock_camera_page.dart'  ;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int selectedIndex = 4;

  void _onItemTapped(int index) {
    if (index != selectedIndex) {
      Widget nextPage;
      switch (index) {
        case 0:
          nextPage = const iPhoneFrame(child: FlightLogsPage());
          break;
        case 1:
          nextPage = const iPhoneFrame(child: ControlCenterPage());
          break;
        case 2:
          nextPage = const iPhoneFrame(child: DroneStatusPage());
          break;
        case 3:
          nextPage = const iPhoneFrame(child: MediaLibraryPage());
          break;
        case 4:
          nextPage = const iPhoneFrame(child: MainPage());
          break;
        default:
          return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return iPhoneFrame(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
        drawer: const AppMenu(),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 12),
              child: Text(
                'Amin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => iPhoneFrame(child: MockCameraPage())),
                );
              },
              child: Container(
                height: 180,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/bak.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                      ),
                      child: const Text(
                        'Drone Mock Camera',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
              child: Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final items = [
                    {"title": "Flight Logs", "imagePath": "assets/flight_logs.png", "route": const FlightLogsPage()},
                    {"title": "Drone Status", "imagePath": "assets/ddrone_status.jpg", "route": const DroneStatusPage()},
                    {"title": "Media Library", "imagePath": "assets/med.png", "route": const MediaLibraryPage()},
                    {"title": "Control Center", "imagePath": "assets/control_center.png", "route": const ControlCenterPage()},
                  ];
                  return _buildDashboardCard(
                    context,
                    title: items[index]["title"] as String,
                    imagePath: items[index]["imagePath"] as String,
                    route: items[index]["route"] as Widget,
                  );
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

  Widget _buildDashboardCard(BuildContext context, {required String title, required String imagePath, required Widget route}) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => iPhoneFrame(child: route)));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5, spreadRadius: 2),
          ],
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
