import 'dart:math';
import 'package:deadly_timer/components/animated_container_component.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class WaveAnimation extends StatelessWidget {

  final List<double> waveHeight;
  final List<double> waveSpeed;
  final List<double> waveOffset;
  final int numberOfWaves;
  final AlignmentGeometry alignmentGeometry;

  const WaveAnimation({Key key, this.waveHeight, this.waveSpeed, this.waveOffset, this.numberOfWaves = 3, this.alignmentGeometry}) : assert(numberOfWaves != null), super(key: key);

  List<Widget> _buildWaveWidget(){
    List<Widget>  _waveWidgetList = [];
    _waveWidgetList.add(Positioned.fill(child: AnimatedBackground()));
    for(int i = 0; i < numberOfWaves; i++){
      _waveWidgetList.add(
          Positioned.fill(
            child: Align(
              alignment: alignmentGeometry ?? Alignment.bottomCenter,
              child: AnimatedWave(
                height: waveHeight[i],
                speed:  waveSpeed[i],
                offset: waveOffset[i],
              ),
            ),
          )
      );
    }
    return _waveWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _buildWaveWidget() ?? Container(),
    );
  }
}

class AnimatedWave extends StatelessWidget {
  final double height;
  final double speed;
  final double offset;

  AnimatedWave({this.height, this.speed, this.offset = 0.0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: height,
        width: constraints.biggest.width,
        child: LoopAnimation<double>(
            duration: Duration(milliseconds: (5000 / speed).round()),
            tween: Tween(begin: 0.0, end: 2 * pi),
            builder: (context, child, value) {
              return CustomPaint(
                foregroundPainter: CurvePainter(value + offset),
              );
            }),
      );
    });
  }
}


class CurvePainter extends CustomPainter {
  final double value;

  CurvePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.white.withAlpha(60);
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


