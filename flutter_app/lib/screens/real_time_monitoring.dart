import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'menu.dart'; 
import 'main_page.dart'; 
import 'control_center.dart';
import 'drone_status.dart'; 
import 'flight_logs.dart';
import 'media_library.dart'; 
import 'iphone_frame.dart'; 

class RealTimeMonitoringPage extends StatefulWidget {
  const RealTimeMonitoringPage({super.key});

  @override
  RealTimeMonitoringPageState createState() => RealTimeMonitoringPageState();
}

class RealTimeMonitoringPageState extends State<RealTimeMonitoringPage> {
  int selectedIndex = 1; 
  late YoutubePlayerController _ytController;

  @override
  void initState() {
    super.initState();
    
 
    String? videoId = YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=tko4c06NJeA");
    
   
    if (videoId == null) {
      print("Error: Unable to extract video ID");
      return;
    }

    _ytController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        isLive: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _ytController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != selectedIndex) {
      Widget nextPage;
      switch (index) {
        case 0:
          nextPage = const FlightLogsPage(); 
          break;
        case 1:
          nextPage = const ControlCenterPage(); 
          break;
        case 2:
          nextPage = const DroneStatusPage();
          break;
        case 3:
          nextPage = const MediaLibraryPage(); 
          break;
        case 4:
          nextPage = const MainPage(); 
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
             
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ControlCenterPage()),
              );
            },
          ),
        ),
        drawer: const AppMenu(), 

        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Live Video",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),

          
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white54),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: YoutubePlayer(controller: _ytController),
                ),
              ),
              const SizedBox(height: 15),


              Row(
                children: [
                  Expanded(child: _buildDroneStatusCard()),
                  const SizedBox(width: 10),
                  Expanded(child: _buildCrowdStatusCard()),
                ],
              ),
              const SizedBox(height: 15),


              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white54),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset("assets/crowd_graph.png", fit: BoxFit.cover),
                ),
              ),
            ],
          ),
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

  Widget _buildDroneStatusCard() {
    return Container(
      height: 305,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white54),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("Drone Status",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center),
          const Icon(Icons.wifi, color: Colors.white, size: 50),
          const Text("Connected", style: TextStyle(fontSize: 16, color: Colors.white)),
          const Text("58 m", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
          const Text("Drone Height", style: TextStyle(fontSize: 14, color: Colors.white70)),
          const Icon(Icons.battery_full, color: Colors.white, size: 50),
          const Text("Battery Level", style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildCrowdStatusCard() {
    return Container(
      height: 305,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white54),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("Crowd Status",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset("assets/crowd_status_graph.png", fit: BoxFit.cover, height: 120),
          ),
          const Text("Numeric Display: 872,994", style: TextStyle(fontSize: 14, color: Colors.white)),
          const Text("Density Level: High", style: TextStyle(fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }
}
