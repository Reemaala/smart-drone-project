import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'menu.dart';
import 'control_center.dart';
import 'drone_status.dart';
import 'main_page.dart';
import 'iphone_frame.dart';
import 'flight_logs.dart';
import 'media_library.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});
  @override
  WeatherPageState createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  int _selectedIndex = 1;
  String city = "Makkah";
  double temperature = 0;
  String weatherDescription = "";
  String highTemp = "";
  String lowTemp = "";
  List<dynamic> dailyForecast = [];
  bool isLoading = true;
  bool isDay = true;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/night.mp4')
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.play();
        setState(() {});
      });
    fetchWeatherData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchWeatherData() async {
    final latitude = 21.3891;
    final longitude = 39.8579;
    final url =
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,is_day,weather_code&daily=temperature_2m_max,temperature_2m_min,weather_code&timezone=auto';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            temperature = data['current']['temperature_2m'];
            weatherDescription =
                getWeatherDescription(data['current']['weather_code']);
            highTemp =
                data['daily']['temperature_2m_max'][0].toStringAsFixed(1);
            lowTemp =
                data['daily']['temperature_2m_min'][0].toStringAsFixed(1);
            isDay = data['current']['is_day'] == 1;
            dailyForecast = List.generate(
              data['daily']['temperature_2m_max'].length,
              (index) => {
                'max': data['daily']['temperature_2m_max'][index],
                'min': data['daily']['temperature_2m_min'][index],
                'code': data['daily']['weather_code'][index],
              },
            );
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  String getWeatherDescription(int code) {
    switch (code) {
      case 0:
        return "Clear sky";
      case 1:
      case 2:
      case 3:
        return "Partly cloudy";
      case 45:
      case 48:
        return "Foggy";
      case 51:
      case 53:
      case 55:
        return "Drizzle";
      case 61:
      case 63:
      case 65:
        return "Rain";
      case 71:
      case 73:
      case 75:
        return "Snow";
      default:
        return "Unknown";
    }
  }

  Color getTemperatureColor(double temp) {
    if (temp >= 43) return Colors.redAccent;
    if (temp >= 38) return Colors.orange;
    if (temp >= 30) return Colors.yellow;
    return Colors.lightBlueAccent;
  }

  IconData getWeatherIcon(int code) {
    switch (code) {
      case 0:
        return Icons.wb_sunny;
      case 1:
      case 2:
      case 3:
        return Icons.wb_cloudy;
      case 45:
      case 48:
        return Icons.blur_on;
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
        return Icons.grain;
      default:
        return Icons.help_outline;
    }
  }

  String getBackgroundImage() {
    if (weatherDescription.toLowerCase().contains("clear")) {
      return "assets/night_clear.jpg";
    } else if (weatherDescription.toLowerCase().contains("cloud")) {
      return "assets/cloudy_night.jpg";
    } else {
      return "assets/default.jpg";
    }
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
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
          context, MaterialPageRoute(builder: (context) => nextPage));
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
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ControlCenterPage()),
              );
            },
          ),
        ),
        drawer: const AppMenu(),
        body: Stack(
          children: [
            if (!isDay && _controller.value.isInitialized)
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
            else
              Positioned.fill(
                child: Image.asset(
                  getBackgroundImage(),
                  fit: BoxFit.cover,
                ),
              ),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(city, style: GoogleFonts.lato(fontSize: 35, color: Colors.white, shadows: [Shadow(blurRadius: 4, color: Colors.black)])),
                      Text("${temperature.toStringAsFixed(1)}°",
                          style: GoogleFonts.lato(fontSize: 80, color: Colors.white, shadows: [Shadow(blurRadius: 4, color: Colors.black)])),
                      Text(weatherDescription,
                          style: GoogleFonts.lato(fontSize: 22, color: Colors.white70)),
                      Text("H:$highTemp°  L:$lowTemp°",
                          style: GoogleFonts.lato(fontSize: 16, color: Colors.white54)),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: dailyForecast.asMap().entries.map((entry) {
                              int index = entry.key;
                              final day = entry.value;
                              final date = DateTime.now().add(Duration(days: index));
                              final dayName = DateFormat.EEEE().format(date);
                              final min = day['min'];
                              final max = day['max'];
                              final icon = getWeatherIcon(day['code']);
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(dayName, style: const TextStyle(color: Colors.white)),
                                  Text(
                                    "${min.toStringAsFixed(1)}° - ${max.toStringAsFixed(1)}°",
                                    style: TextStyle(color: getTemperatureColor(max)),
                                  ),
                                  Icon(icon, color: Colors.white70, size: 20),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
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
}
