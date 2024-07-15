import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color postitiveColor = new Color(0xFFEF0078);
  Color negetiveColor = new Color(0xFFFFFFFF);
  double percentage = 0.0;

  double initial = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'CUSTOM SLIDER',
          style: TextStyle(color: postitiveColor),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              percentage.round().toString() + ' %',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 70.0,
                color: postitiveColor,
              ),
            ),
            GestureDetector(
              onPanStart: (DragStartDetails details) {
                initial = details.globalPosition.dx;
              },
              onPanUpdate: (DragUpdateDetails details) {
                double distance = details.globalPosition.dx - initial;
                double percentageAddition = distance / 200;

                print('distance ' + distance.toString());
                setState(() {
                  print('percentage ' +
                      (percentage + percentageAddition)
                          .clamp(0.0, 100.0)
                          .toString());
                  percentage =
                      (percentage + percentageAddition).clamp(0.0, 100.0);
                });
              },
              onPanEnd: (DragEndDetails details) {
                initial = 0.0;
              },
              child: CustomSlider(
                percentage: this.percentage,
                positiveColor: postitiveColor,
                negetiveColor: negetiveColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomSlider extends StatelessWidget {
  double totalWidth = 200.0;
  double percentage;
  Color positiveColor;
  Color negetiveColor;

  CustomSlider({this.percentage, this.positiveColor, this.negetiveColor});

  @override
  Widget build(BuildContext context) {
    print((percentage / 100) * totalWidth);
    print((1 - percentage / 100) * totalWidth);
    return Container(
      width: totalWidth + 4.0,
      height: 30.0,
      decoration: BoxDecoration(
          color: negetiveColor,
          border: Border.all(color: Colors.black, width: 2.0)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            color: positiveColor,
            width: (percentage / 100) * totalWidth,
          ),
        ],
      ),
    );
  }
}