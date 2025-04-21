import 'dart:math';
import 'dart:ui' as ui show Image;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Demo(),
    );
  }
}

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  late Size? screenSize;
  late Painter _painter;
  bool _isClick = false;
  bool _isLoading = true;
  double xPos = 100;
  double yPos = 100;
  ui.Image? myImage;

  final bigImageHeight = 600.0;
  final bigImageWidth = 400.0;
  final smallImageDimension = 80.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenSize = MediaQuery.of(context).size;
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    const keyName = 'assets/images/circle.png';
    final data = (await rootBundle.load(keyName));
    final bytes = data.buffer.asUint8List();
    myImage = await decodeImageFromList(bytes);

    _painter = Painter(
      image: myImage!,
      xPosition: xPos,
      yPosition: yPos,
    );
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: SizedBox(
              height: bigImageHeight,
              width: bigImageWidth,
              child: _isLoading
                  ? const Center(
                      child: SizedBox.square(
                        dimension: 12.0,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : GestureDetector(
                      onHorizontalDragDown: (details) {
                        setState(
                          () {
                            if (_painter.isRegion(
                              details.localPosition.dx,
                              details.localPosition.dy,
                            )) {
                              _isClick = true;
                            }
                          },
                        );
                      },
                      onHorizontalDragEnd: (details) {
                        setState(() {
                          _isClick = false;
                        });
                      },
                      onHorizontalDragUpdate: (details) {
                        if (_isClick) {
                          if (details.localPosition.dx <
                                  (bigImageWidth - smallImageDimension / 2) &&
                              details.localPosition.dx >
                                  smallImageDimension / 2) {
                            xPos = details.localPosition.dx;
                          }
                          if (details.localPosition.dy <
                                  (bigImageHeight - smallImageDimension / 2) &&
                              details.localPosition.dy >
                                  smallImageDimension / 2) {
                            yPos = details.localPosition.dy;
                          }
                          _painter = Painter(
                            image: myImage!,
                            xPosition: xPos,
                            yPosition: yPos,
                          );

                          if (mounted) {
                            setState(() {});
                          }
                        }
                      },
                      child: MouseRegion(
                        cursor: _isClick
                            ? SystemMouseCursors.grabbing
                            : SystemMouseCursors.grab,
                        child: RepaintBoundary(
                          key: GlobalKey(),
                          child: Stack(
                            children: [
                              Container(
                                height: bigImageHeight,
                                width: bigImageWidth,
                                decoration: _isClick
                                    ? BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      )
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                    'assets/images/book_1.jpeg',
                                    semanticLabel: 'Big Image',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: smallImageDimension,
                                height: smallImageDimension,
                                child: CustomPaint(
                                  painter: _painter,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          const Text('Text'),
        ],
      ),
    );
  }
}

class ButtonCircle extends StatelessWidget {
  const ButtonCircle({super.key, required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, //width of the base circle
      height: width, //height of the base circle
      color: Colors.grey,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: width / 6,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No Ads Pressed'),
                    duration: Duration(milliseconds: 300),
                  ),
                );
              },
              child: Image.asset(
                "assets/images/circle_left.png",
                fit: BoxFit.contain,
                height: width * 2 / 3,
                width: width / 3,
              ),
            ),
          ),
          Positioned(
            left: width * 2 / 3,
            top: width / 6,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Random Pressed'),
                    duration: Duration(milliseconds: 300),
                  ),
                );
              },
              child: Image.asset(
                "assets/images/circle_right.png",
                fit: BoxFit.contain,
                height: width * 2 / 3,
                width: width / 3,
              ),
            ),
          ),
          Positioned(
            left: width / 6,
            top: 0,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Leaderboard Pressed'),
                    duration: Duration(milliseconds: 300),
                  ),
                );
              },
              child: Image.asset(
                "assets/images/circle_up.png",
                fit: BoxFit.contain,
                height: width / 3,
                width: width * 2 / 3,
              ),
            ),
          ),
          Positioned(
            left: width / 6,
            top: width * 2 / 3,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Info Pressed'),
                    duration: Duration(milliseconds: 300),
                  ),
                );
              },
              child: Image.asset(
                "assets/images/circle_down.png",
                fit: BoxFit.contain,
                height: width / 3,
                width: width * 2 / 3,
              ),
            ),
          ),
          Positioned(
            left: width * 0.3,
            top: width * 0.3,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Play Pressed'),
                    duration: Duration(milliseconds: 300),
                  ),
                );
              },
              child: Image.asset(
                "assets/images/circle.png",
                fit: BoxFit.contain,
                height: width * 0.4,
                width: width * 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  final innerRadius = 80.0;
  final outerRadius = 120.0;

  const MyWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ArcClipper(),
      child: Container(
        height: outerRadius * 2,
        width: outerRadius,
        decoration: const BoxDecoration(
          color: Colors.orange,
        ),
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  final innerRadius = 80.0;
  final outerRadius = 120.0;
  final angle = 40.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, outerRadius);
    path.moveTo(innerRadius * cos((angle * pi / 180)),
        outerRadius - (innerRadius * sin((angle * pi / 180))));
    path.lineTo(outerRadius * cos((angle * pi / 180)),
        outerRadius - (outerRadius * sin((angle * pi / 180))));

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) => false;
}

class Painter extends CustomPainter {
  const Painter({
    required this.image,
    required this.xPosition,
    required this.yPosition,
  });

  final ui.Image image;
  final double xPosition;
  final double yPosition;

  final desiredDimension = 80.0;

  bool isRegion(double checkX, double checkY) {
    //Check inside Square Region
    // if (checkX >= xPosition - desiredDimension / 2 &&
    //     checkX <= xPosition + desiredDimension / 2 &&
    //     checkY >= yPosition - desiredDimension / 2 &&
    //     checkY <= yPosition + desiredDimension / 2)

    //Check inside Circle Region
    if ((pow(xPosition - checkX, 2) + pow(yPosition - checkY, 2)) <=
        pow(desiredDimension / 2, 2)) {
      return true;
    }
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final originalWidth = image.width.toDouble();
    final originalHeight = image.height.toDouble();
    final scale = desiredDimension / originalHeight;
    final scaledWidth = originalWidth * scale;

    final rect = Rect.fromLTWH(
      xPosition - scaledWidth / 2,
      yPosition - desiredDimension / 2,
      scaledWidth,
      desiredDimension,
    );

    paintImage(
      canvas: canvas,
      image: image,
      rect: rect,
      fit: BoxFit.fill,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
