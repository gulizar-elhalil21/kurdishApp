import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'kurdish_words.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !const bool.fromEnvironment('dart.vm.product'),
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const KurdishMemorizerPage(),
    );
  }
}

class KurdishMemorizerPage extends StatefulWidget {
  const KurdishMemorizerPage({super.key});

  @override
  State<KurdishMemorizerPage> createState() => _KurdishMemorizerPageState();
}

class _KurdishMemorizerPageState extends State<KurdishMemorizerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  final List<Map<String, String>> _kurdishWords = kKurdishWords;

  int _currentIndex = 0;
  bool _isFlipped = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
    if (_isFlipped) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
  }

  void _nextWord() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _kurdishWords.length;
      _isFlipped = false;
      _flipController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final word = _kurdishWords[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Kurdish Words Memorizer'),
        actions: [
          Center(child: Text('Score: $_score')),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _currentIndex = 0;
                _isFlipped = false;
                _score = 0;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Memorize Kurdish Words!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: _flipCard,
                child: AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_flipAnimation.value * 3.1416),
                      child: _isFlipped
                          ? _buildCard(word['english']!, false)
                          : _buildCard(word['kurdish']!, true),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _nextWord,
                    icon: const Icon(Icons.skip_next),
                    label: const Text('Next'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _score++;
                      });
                      _nextWord();
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Correct'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String text, bool isFront) {
    return Container(
      width: 250,
      height: 150,
      decoration: BoxDecoration(
        color: isFront ? Colors.green : Colors.blue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
