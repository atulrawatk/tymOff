import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_image_editor/flutter_image_editor.dart';
import 'package:tymoff/Screens/UploadNewScreens/MainImageFilterPackage/Model/FilterImageMeta.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/Strings.dart';

///The PhotoFilterCustomSelector Widget for apply filter from a selected set of filters
class SetContrastFilter extends StatefulWidget {
  static final String KEY_RESPONSE_FILTERED_IMAGES_CONTRAST =
      "image_filtered_Contrast";
  final FilterImageMeta filterImageMeta;
  final List<int> bytesOfImage;

  SetContrastFilter(this.filterImageMeta, this.bytesOfImage);

  @override
  State<StatefulWidget> createState() =>
      new _MultiplePhotoFilterCustomSelectorState(
          filterImageMeta, bytesOfImage);
}

class _MultiplePhotoFilterCustomSelectorState extends State<SetContrastFilter> {
  double _minContrastSliderVal = 0;
  double _maxContrastSliderVal = 10;
  double _sliderContrastInitialState = 0.0;

  FilterImageMeta filterImageMeta;
  List<int> bytesOfImage;

  _MultiplePhotoFilterCustomSelectorState(
      FilterImageMeta filterImageMeta, List<int> bytesOfImage) {
    this.filterImageMeta = filterImageMeta;
    this.bytesOfImage = bytesOfImage;
   // _sliderContrastInitialState = filterImageMeta.contrast;
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
          Strings.contrast,
          style: TextStyle(color: ColorUtils.greyColor),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
              size: 24.0,
              color: ColorUtils.greyColor,
            ),
            onPressed: () async {
              Navigator.pop(context, {
                SetContrastFilter.KEY_RESPONSE_FILTERED_IMAGES_CONTRAST:
                    bytesOfImage
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
          child:  Container(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Slider.adaptive(
                    activeColor: ColorUtils.primaryColor,
                    inactiveColor: ColorUtils.primaryColor.withOpacity(0.3),
                    min: _minContrastSliderVal,
                    max: _maxContrastSliderVal,
                    divisions: 20,
                    label: _sliderContrastInitialState.toString(),
                    value: _sliderContrastInitialState,
                    onChanged: (_value) {
                      _sliderContrastInitialState = _value;
                      _refreshState();
                      print("Munish Thakur -> Value Changed -> $_value");
                      _handleContrast(_value);
                    }),
              ),
            ),
          ),
          flex: 1,
        ),
      ],
    );
  }

  void _handleContrast(double _value) async {
    widget.filterImageMeta.contrast = _value;

    bytesOfImage = await _updatePicutre(widget.bytesOfImage,
        widget.filterImageMeta.contrast, widget.filterImageMeta.brightness);

    _refreshState();
  }

  Future<List<int>> _updatePicutre(
      List<int> imageBytes, double contrast, double brightness) async {
    return await PictureEditor.editImage(imageBytes, contrast, brightness);
  }

  void _refreshState() {
    setState(() {});
  }
}
