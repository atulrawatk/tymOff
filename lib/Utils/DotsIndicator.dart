import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

import 'PrintUtils.dart';

/// An indicator showing the currently selected page of a PageController
class DotsIndicator extends AnimatedWidget {
  DotsIndicator(
      BuildContext context, {
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.selectedColor: Colors.white,
    this.unSelectedColor: Colors.white,
  }) : super(listenable: controller) {
    screenWidth = MediaQuery.of(context).size.width;
    initSizes();
  }

  double screenWidth;

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The Selected color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color selectedColor;

  /// The un-Selected color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color unSelectedColor;

  // The base size of the dots
  double _kDotSize = 3.0;

  // The increase in the size of the selected dot
  double _kMaxZoom = 3.0;

  // The distance between the center of each dot
  double _kDotSpacing = 18.0;


  Widget _buildDot(int index) {
    double selectedness = Curves.easeOutSine.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 2.0 + (_kMaxZoom - 1.0) * selectedness;

    Color color;
    if(controller.page == index) {
      color = selectedColor;
      print("Index: $index is selected");
    } else {
      color = unSelectedColor;
    }

    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * 4.0,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }


  Widget build(BuildContext context) {
    return Center(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: new List<Widget>.generate(itemCount, _buildDot),
      ),
    );
  }

  void initSizes() {
    double widthDotsWillTake = ( _kDotSize + _kDotSpacing) * itemCount;
    //PrintUtils.printLog("widthDotsWillTake: $widthDotsWillTake, screenWidth: $screenWidth");
    if(widthDotsWillTake > screenWidth) {
      _kDotSize = _kDotSize - 0.2;
      _kDotSpacing = _kDotSpacing - 1.5;
      if(_kDotSize > 1 && _kDotSpacing >= 1) {

        initSizes();
      } else {
      }
    }
  }
}

