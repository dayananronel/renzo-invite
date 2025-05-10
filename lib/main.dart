import 'dart:html' as html;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';

const Color kPrimaryBlue = Color(0xFF0D47A1);
const Color kLightBlue = Color(0xFFBBDEFB);
const Color kAccentBlue = Color(0xFF42A5F5);
const Color kBackground = Color(0xFFE3F2FD);
const Color kWhiteOverlay = Color(0xFFF5F9FF);

void main() => runApp(InviteApp());

class InviteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Christening Invitation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kBackground,
        primaryColor: kPrimaryBlue,
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          headlineLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: kPrimaryBlue),
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: kAccentBlue),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kAccentBlue,
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
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
  final PageController _controller = PageController();
  int _pageIndex = 0;

  void _nextPage() {
    if (_pageIndex < 5) {
      _controller.nextPage(duration: Duration(milliseconds: 600), curve: Curves.easeInOut);
    } else {
     showThankYouDialog(context);
    }
  }

void showThankYouDialog(BuildContext context) {
  final confettiController = ConfettiController(duration: const Duration(seconds: 3));
  confettiController.play();

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(top: 60, left: 20, right: 20),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: kPrimaryBlue,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 40),
                Text('Thank You!',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Text(
                  'Looking forward to seeing you!',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
  Navigator.of(context).pop();
  Future.delayed(Duration(milliseconds: 300), () {
    try {
      html.window.close();

      // If tab doesn't close (user opened it manually), redirect instead
      Future.delayed(Duration(milliseconds: 500), () {
        html.window.location.href = '/goodbye'; // Change to your own route/page
      });
    } catch (e) {
      html.window.location.href = '/goodbye'; // fallback
    }
  });
},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: kPrimaryBlue),
                  child: Text('Close'),
                ),
              ],
            ),
          ),
          ConfettiWidget(
            confettiController: confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: [Colors.blue, Colors.white, Colors.lightBlueAccent],
            emissionFrequency: 0.05,
            numberOfParticles: 30,
            gravity: 0.1,
          ),
        ],
      ),
    ),
  );
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) => setState(() => _pageIndex = index),
          children: [
            _buildPage('Baptism of Renzo', icon: Icons.child_care),
            _buildImagePage('assets/images/renzo_edited.png', 'We’d really love to have you join us for this special moment.'),
            _buildGodparentPage(), // This is AskPermission
            _buildDatePage(),
            _buildLocationPage(),
            _buildPage('Thank you for joining us!\nYour presence is a gift.', icon: Icons.favorite),
          ],
        ),
        if (_pageIndex != 2) // index 2 is AskPermission
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.navigate_next, color: Colors.white),
                label: Text(_pageIndex < 5 ? 'Next' : 'Done', style: TextStyle(color: Colors.white)),
                onPressed: _nextPage,
              ),
            ),
          ),
      ],
    ),
  );
}

  Widget _buildPage(String text, {required IconData icon}) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(24),
        padding: EdgeInsets.all(24),
        decoration: _decoratedBox(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: kAccentBlue),
            SizedBox(height: 24),
            Text(text, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePage(String imagePath, String caption) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(imagePath, width: 300, height: 300, fit: BoxFit.cover),
          ),
          SizedBox(height: 24),
          Text(caption, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildGodparentPage() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(24),
        padding: EdgeInsets.all(24),
        decoration: _decoratedBox(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_alt, size: 48, color: kAccentBlue),
            SizedBox(height: 16),
            Text('Will you be our Ninong / Ninang?', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style : ElevatedButton.styleFrom(
        backgroundColor: Colors.green, // background
        foregroundColor: Colors.white, // foreground
    ),
                  onPressed: _nextPage,
                  icon: Icon(Icons.check, color: Colors.white),
                  label: Text('Yes'),
                ),
                SizedBox(width: 20),
                ElevatedButton.icon(
                  style : ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // background
        foregroundColor: Colors.white, // foreground
    ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Oh no!'),
                        content: Text('We’ll miss you, but thank you for your love!'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Close'),
                          )
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.close, color: Colors.white),
                  label: Text('No'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDatePage() {
  final DateTime eventDate = DateTime(2025, 6, 7);
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Container(
      padding: EdgeInsets.all(24),
      decoration: _decoratedBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text('Event Schedule (Month of June 2025)', style: Theme.of(context).textTheme.headlineMedium),
          ),
          SizedBox(height: 12),
          TableCalendar(
            firstDay: DateTime.utc(2025, 6, 1),
            lastDay: DateTime.utc(2025, 6, 31),
            focusedDay: eventDate,
            headerVisible: false,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, _) {
                bool isEvent = day.day == eventDate.day;
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isEvent ? kAccentBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('${day.day}',
                      style: TextStyle(
                          color: isEvent ? Colors.white : Colors.black,
                          fontWeight: isEvent ? FontWeight.bold : FontWeight.normal)),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.event, color: kPrimaryBlue),
              SizedBox(width: 8),
              Text(DateFormat('EEEE, MMMM d, yyyy').format(eventDate),
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          SizedBox(height: 16),
          Text('Important Reminders:',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          BulletPoint(text: 'Be there before 8AM.'),
          BulletPoint(text: 'The seminar starts at 8:00 AM.'),
          BulletPoint(text: 'Ceremony follows right after the seminar.'),
        ],
      ),
    ),
  );
}


 Widget _buildLocationPage() {
  platformViewRegistry.registerViewFactory(
    'map-iframe',
    (int viewId) => html.IFrameElement()
      ..src = 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3929.6696123606675!2d124.02170237503069!3d9.961421990142036!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x33aa2433e9b4e71f%3A0x6d8779d2a4899168!2sSt.%20Michael%20the%20Archangel%20Parish!5e0!3m2!1sen!2sph!4v1746454023239!5m2!1sen!2sph'
      ..style.border = '0'
      ..setAttribute('allowfullscreen', '')
      ..setAttribute('loading', 'lazy')
      ..setAttribute('referrerpolicy', 'no-referrer-when-downgrade')
      ..setAttribute('aria-hidden', 'false')
      ..setAttribute('tabindex', '0')
      ..setAttribute('frameborder', '0')
      ..setAttribute('scrolling', 'no')
      ..style.pointerEvents = 'none'
      ..width = '100%'
      ..height = '200',
  );

  return Padding(
    padding: const EdgeInsets.all(24),
    child: Container(
      padding: EdgeInsets.all(20),
      decoration: _decoratedBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text('Location Guide', style: Theme.of(context).textTheme.headlineMedium),
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.church, color: kAccentBlue, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ceremony Venue:', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
                    Text('St. Michael the Archangel Parish', style: Theme.of(context).textTheme.bodyLarge),
                     Text('Clarin,Bohol', style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: HtmlElementView(viewType: 'map-iframe'),
            ),
          ),
          SizedBox(height: 20),
                    Text(
            'You can tap below to open directions on Google Maps.',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontStyle: FontStyle.italic, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Center(
            child: TextButton.icon(
              onPressed: () {
              final anchor = html.AnchorElement(href: 'https://www.google.com/maps/place/St.+Michael+the+Archangel+Parish/@9.9614273,124.0217024,17z/data=!3m1!4b1!4m6!3m5!1s0x33aa2433e9b4e71f:0x6d8779d2a4899168!8m2!3d9.961422!4d124.0242773!16s%2Fg%2F1tgj6c9_?entry=ttu&g_ep=EgoyMDI1MDUwNy4wIKXMDSoASAFQAw%3D%3D')
                ..target = '_blank';
              html.document.body?.append(anchor);
              anchor.click();
              anchor.remove();
            },
              icon: Icon(Icons.map_outlined, color: kAccentBlue),
              label: Text('View Larger Map', style: TextStyle(color: kAccentBlue)),
            ),
          )
        ],
      ),
    ),
  );
}



  BoxDecoration _decoratedBox() => BoxDecoration(
        color: kWhiteOverlay,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      );
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 18, color: kPrimaryBlue)),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
