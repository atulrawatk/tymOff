import 'dart:async';
import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/EventBus/EventModels/EventTakeABreak.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/Constant.dart';
import 'package:video_player/video_player.dart';
import 'package:tymoff/Utils/PrintUtils.dart';
import 'package:screen/screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'CommonDetailCard.dart';

class CommonDetailCardUI_Youtube extends StatefulWidget {
  final ActionContentData cardDetailData;

  const CommonDetailCardUI_Youtube(this.cardDetailData,
      {Key key})
      : super(key: key);

  @override
  _CommonDetailCardUI_YoutubeState createState() =>
      _CommonDetailCardUI_YoutubeState();
}

class _CommonDetailCardUI_YoutubeState extends State<CommonDetailCardUI_Youtube> {
  YoutubePlayerController _controller;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  String videoUrl;
  String videoId;

  @override
  void initState() {
    //_videoController?.play();
    super.initState();

    initScreenMeta();
    initYouTubePlayer();
  }

  void initScreenMeta() {
    try {
      videoUrl = widget.cardDetailData?.contentUrl[0].url;
     // videoUrl = "https://www.youtube.com/watch?v=hMy5za-m5Ew";
      videoId = YoutubePlayer.convertUrlToId(videoUrl);
    } catch(e) {}
  }

  void initYouTubePlayer() {
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        controlsVisibleAtStart: true,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHideAnnotation: true,
      ),
    )..addListener(listener);
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Listener(
      key: new Key(widget.cardDetailData.id.toString() + "_youtube_video_Listener"),
      onPointerMove: _ListenerOnPointerMove,
      onPointerUp: _ListenerOnPointerUp,
      onPointerDown: _ListenerOnPointerDown,
      child: _getYouTubeVideoWidget(),
    );
  }

  Widget _getYouTubeVideoWidget() {

    return YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        liveUIColor: ColorUtils.redColor,
        progressIndicatorColor: ColorUtils.primaryColor,
        progressColors: ProgressBarColors(
          bufferedColor: ColorUtils.whiteColor,
          playedColor: ColorUtils.primaryColor,
          backgroundColor: ColorUtils.greyColor,
        ),
        topActions: <Widget>[
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          /*IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: () {
              _showSnackBar('Settings Tapped!');
            },
          ),*/
        ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (id) {
          if (!_isCardChangeEventTriggered) {
            AppUtils.screenKeepOn(false);
            _setTimerForNextCard();
          }

          //_controller.load(_ids[count++]);
          //_showSnackBar('Next Video Started!');
        },
      );
  }


  void _ListenerOnPointerMove(PointerMoveEvent event) {
    setAngleSkew();
  }

  void _ListenerOnPointerUp(PointerUpEvent cancel) {
    setAngleSkew();
    isSeakBarEnable = false;
  }

  void _ListenerOnPointerDown(PointerDownEvent cancel) {
    setAngleSkew();
    isSeakBarEnable = true;
  }

  void setAngleSkew() {
    if (mounted) {
      setState(() {
        angleSkew = 0;
      });
    }
  }

  bool _isCardChangeEventTriggered = false;
  Timer timerNextCard;

  void _setTimerForNextCard() {
    _isCardChangeEventTriggered = true;
    timerNextCard = Timer.periodic(Duration(seconds: Constant.CARD_SCROLL_AFTER_CONTENT_CONSUMPTION_TIME), (_) {
      EventBusUtils.eventDetailCardChange(widget.cardDetailData.id.toString());
      timerNextCard?.cancel();
    });
  }

}