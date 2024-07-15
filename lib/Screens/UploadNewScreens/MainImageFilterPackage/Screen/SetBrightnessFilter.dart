import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_image_editor/flutter_image_editor.dart';
import 'package:tymoff/Screens/UploadNewScreens/MainImageFilterPackage/Model/FilterImageMeta.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/Strings.dart';

///The PhotoFilterCustomSelector Widget for apply filter from a selected set of filters
class SetBrightnessFilter extends StatefulWidget {
  static final String KEY_RESPONSE_FILTERED_IMAGES_BRIGHTNESS = "image_filtered_Brightness";
  final FilterImageMeta filterImageMeta;
  final List<int> bytesOfImage;

  SetBrightnessFilter(this.filterImageMeta, this.bytesOfImage);

  @override
  State<StatefulWidget> createState() =>
      new _MultiplePhotoFilterCustomSelectorState(filterImageMeta, bytesOfImage);
}

class _MultiplePhotoFilterCustomSelectorState
    extends State<SetBrightnessFilter> {
  double _minSliderVal = 0.0;
  double _maxSliderVal = 100.0;
  double _sliderInitialState = 0.0;

  FilterImageMeta filterImageMeta;
  List<int> bytesOfImage;

  _MultiplePhotoFilterCustomSelectorState(FilterImageMeta filterImageMeta, List<int> bytesOfImage) {
    this.filterImageMeta = filterImageMeta;
    this.bytesOfImage = bytesOfImage;
    //_sliderInitialState = filterImageMeta.brightness;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
              icon: Icon(
                Icons.clear,
                color: ColorUtils.greyColor,
                size: 24.0,
              ),
          onPressed: () {
            Navigator.pop(context);
          },

        ),
        backgroundColor: Colors.black,
        title: Text(
          Strings.brightness,
          style: TextStyle(color: ColorUtils.greyColor),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
              color: ColorUtils.greyColor,
              size: 24.0,
            ),
            onPressed: () async {

              Navigator.pop(context, {
                    SetBrightnessFilter.KEY_RESPONSE_FILTERED_IMAGES_BRIGHTNESS: bytesOfImage
                  });
            },
          )
        ],
      ),
      body: buildImageMainPagerUI(),
    );
  }

  Widget buildImageMainPagerUI() {
    return Column(
      children: <Widget>[
       SizedBox(
         height: 30.0,
       ),
        Expanded(
          child: Container(
            //padding: EdgeInsets.only(top : 40.0),
            child: Image.memory(
              bytesOfImage,
              fit: BoxFit.contain,
            ),
          ),
          flex: 3,
        ),
         Expanded(
           child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Slider.adaptive(
                      activeColor: ColorUtils.primaryColor,
                      inactiveColor: ColorUtils.primaryColor.withOpacity(0.3),
                      min: _minSliderVal,
                      max: _maxSliderVal,
                      divisions: 20,
                      label: _sliderInitialState.toString(),
                      value: _sliderInitialState,
                      onChanged: (_value) {
                        _sliderInitialState = _value;
                        _refreshState();
                        print("Munish Thakur -> Value Changed -> $_value");
                        _handleBrightness(_value);
                      }),
                ),
              ),
            ),
           flex: 1,
         ),
      ],
    );
  }

  void _handleBrightness(double _value) async {
    widget.filterImageMeta.brightness = _value;

    bytesOfImage = await _updatePicutre(
        widget.bytesOfImage, widget.filterImageMeta.contrast, widget.filterImageMeta.brightness);

    _refreshState();
  }

  Future<List<int>> _updatePicutre(List<int> imageBytes, double contrast, double brightness) async {
    return await PictureEditor.editImage(imageBytes, contrast, brightness);
  }

  void _refreshState() {
    setState(() {});
  }
}
