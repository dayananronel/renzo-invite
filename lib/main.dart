import 'dart:html';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

const Color kSkyLight = Color(0xFFCCE5FF);
const Color kSkyDark = Color(0xFF99CCFF);
const Color kAccentBlue = Color(0xFF4FC3F7);
const Color kAccentYellow = Color(0xFFFFF176);
const Color kNavy = Color(0xFF0D47A1);
const Color kPurpleAccent = Color(0xFF7E57C2);

void main() => runApp(InviteApp());

class InviteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Christening Invitation',
      theme: ThemeData(
        primaryColor: kNavy,
        scaffoldBackgroundColor: kSkyLight,
        textTheme: GoogleFonts.comicNeueTextTheme().copyWith(
          headlineLarge: GoogleFonts.playfairDisplay(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: kNavy,
          ),
          headlineMedium: GoogleFonts.playfairDisplay(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: kAccentBlue,
          ),
          bodyLarge: TextStyle(color: kNavy, fontSize: 18),
        ),
      ),
      home: InvitationFlow(),
    );
  }
}

class InvitationFlow extends StatefulWidget {
  @override
  _InvitationFlowState createState() => _InvitationFlowState();
}

class _InvitationFlowState extends State<InvitationFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const int _pageCount = 6;

  void _nextPage() {
    if (_currentPage < _pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: kNavy,
          title: Text('Thank You!', style: TextStyle(color: Colors.white)),
          content: Text(
            'We appreciate you and look forward to seeing you.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: BouncingScrollPhysics(),
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            children: [
              CoverPage(),
              GreetingPage(),
              AskGodparentsPage(),
              DatePage(),
              LocationPage(),
              GratitudePage(),
            ],
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentBlue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: StadiumBorder(),
                  elevation: 8,
                  shadowColor: kNavy.withOpacity(0.3),
                ),
                icon: Icon(Icons.navigate_next, color: Colors.white),
                label: Text(
                  _currentPage < _pageCount - 1 ? 'Next' : 'Done',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

abstract class AnimatedPage extends StatefulWidget {}

abstract class AnimatedPageState<T extends AnimatedPage> extends State<T>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> fade;
  late final Animation<double> scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    scale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildDecorated({required Widget child}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/confetti_overlay.jpeg', fit: BoxFit.cover, color: Colors.white.withOpacity(0.1), colorBlendMode: BlendMode.srcOver),
        Positioned(top: 0, left: 0, right: 0, child: Image.asset('assets/images/ribbon.png', fit: BoxFit.fitWidth, height: 60)),
        Positioned(bottom: 0, left: 0, right: 0, child: Image.asset('assets/images/ribbon.png', fit: BoxFit.fitWidth, height: 60)),
        FadeTransition(
          opacity: fade,
          child: ScaleTransition(scale: scale, child: child),
        ),
      ],
    );
  }
}

// 🎀 COVER PAGE
class CoverPage extends AnimatedPage {
  @override
  _CoverPageState createState() => _CoverPageState();
}

class _CoverPageState extends AnimatedPageState<CoverPage> {
  @override
  Widget build(BuildContext context) {
    return buildDecorated(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kAccentYellow, width: 4),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: Text('Baptism of Renzo', style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

// 🎀 GREETING PAGE
class GreetingPage extends AnimatedPage {
  @override
  _GreetingPageState createState() => _GreetingPageState();
}

class _GreetingPageState extends AnimatedPageState<GreetingPage> {
  @override
  Widget build(BuildContext context) {
    return buildDecorated(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: kAccentBlue, width: 4),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset('assets/images/renzo_design.png', height: 400, width: 400, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 20),
            Text('See you on my special day!', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// 🎀 ASK GODPARENTS PAGE
class AskGodparentsPage extends AnimatedPage {
  @override
  _AskGodparentsPageState createState() => _AskGodparentsPageState();
}

class _AskGodparentsPageState extends AnimatedPageState<AskGodparentsPage> {
  void _handleResponse(bool accepted) {
    if (accepted) {
      final pageController = context.findAncestorStateOfType<_InvitationFlowState>()?._pageController;
      pageController?.nextPage(duration: Duration(milliseconds: 600), curve: Curves.easeInOut);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          title: Text('Oh no!', style: TextStyle(color: kAccentBlue)),
          content: Text('We’ll miss you, but thank you for your love and support!', style: TextStyle(color: kNavy)),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Close', style: TextStyle(color: kAccentBlue)))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildDecorated(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kAccentYellow, width: 3),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cake, size: 64, color: kAccentBlue),
              SizedBox(height: 16),
              Text('Will you be our Ninong / Ninang?', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _handleResponse(true),
                    style: ElevatedButton.styleFrom(backgroundColor: kAccentBlue, shape: StadiumBorder(), padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                    icon: Icon(Icons.check, color: Colors.white),
                    label: Text('Yes', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => _handleResponse(false),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade400, shape: StadiumBorder(), padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                    icon: Icon(Icons.close, color: Colors.white),
                    label: Text('No', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class DatePage extends AnimatedPage {
  @override
  _DatePageState createState() => _DatePageState();
}

class _DatePageState extends AnimatedPageState<DatePage> {
  final DateTime _eventDate = DateTime(2025, 1, 19);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: buildDecorated(
        child: 
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Event Date', style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: TableCalendar(
                firstDay: DateTime.utc(_eventDate.year, _eventDate.month, 1),
                lastDay: DateTime.utc(_eventDate.year, _eventDate.month + 1, 0),
                focusedDay: _eventDate,
                headerVisible: false,
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, _) {
                    bool isEvent = day.day == _eventDate.day;
                    return Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isEvent ? kAccentBlue : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: isEvent ? Colors.white : kNavy,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time, color: kNavy),
                SizedBox(width: 8),
                Text('10:30 AM',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class LocationPage extends AnimatedPage {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends AnimatedPageState<LocationPage> {
  _LocationPageState() {
    // Register the church map iframe
    platformViewRegistry.registerViewFactory(
      'church-map-iframe',
      (int viewId) => IFrameElement()
        ..width = '100%'
        ..height = '300'
        ..src = 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3929.6696123606675!2d124.02170237503069!3d9.961421990142036!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x33aa2433e9b4e71f%3A0x6d8779d2a4899168!2sSt.%20Michael%20the%20Archangel%20Parish!5e0!3m2!1sen!2sph!4v1746454023239!5m2!1sen!2sph'
        ..style.border = '0',
    );
    // Register the venue map iframe (use a different URL if needed)
    platformViewRegistry.registerViewFactory(
      'venue-map-iframe',
      (int viewId) => IFrameElement()
        ..width = '100%'
        ..height = '300'
        ..src = 'https://www.google.com/maps/embed?pb=!1m17!1m12!1m3!1d1964.937044523132!2d124.00359221249418!3d9.944432846329365!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m2!1m1!2zOcKwNTYnNDAuMCJOIDEyNMKwMDAnMTMuMiJF!5e0!3m2!1sen!2sph!4v1746454257038!5m2!1sen!2sph');
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location Guide', style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 24),
            _locationItem(Icons.church, 'Ceremony: St. Michael the Archangel Parish', 'church-map-iframe'),
            Divider(height: 32, thickness: 1, color: Colors.grey.shade300),
            _locationItem(Icons.house, 'Venue: Venue Name Here', 'venue-map-iframe'),
          ],
        ),
      );
  }

  Widget _locationItem(IconData icon, String label, String iframeId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: kAccentBlue, size: 28),
            SizedBox(width: 12),
            Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyLarge)),
          ],
        ),
        SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 300,
            width: double.infinity,
            child: HtmlElementView(viewType: iframeId),
          ),
        ),
      ],
    );
  }
}
// 6. Gratitude Page
class GratitudePage extends AnimatedPage {
  @override
  _GratitudePageState createState() => _GratitudePageState();
}

class _GratitudePageState extends AnimatedPageState<GratitudePage> {
  @override
  Widget build(BuildContext context) {
    return buildDecorated(
      child: Center(
        child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kAccentYellow, width: 4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite, size: 64, color: kAccentBlue),
                SizedBox(height: 16),
                Text('Thank you for being with us!',
                    textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 8),
                Text('Your love and support mean the world.',
                    textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
      ),
    );
  }
}