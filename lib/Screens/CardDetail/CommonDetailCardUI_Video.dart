import 'dart:async';
import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/EventBus/EventModels/EventTakeABreak.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Screens/CardDetail/ContentBottomTextUI.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/Constant.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:video_player/video_player.dart';

import 'CommonDetailCard.dart';

enum PlayerType { HOME_CARD_CONTROLL, DETAIL_CARD_CONTROLL }

HashMap<int, VideoPlayerController> hmVideoController = HashMap();
bool isMute = true;
double _sliderValue = 1.0;

class CommonDetailCardUI_Video extends StatefulWidget {

  final PlayerType playerType;
  final ActionContentData cardDetailData;

  const CommonDetailCardUI_Video(this.cardDetailData, this.playerType,
      {Key key})
      : super(key: key);

  @override
  _CommonDetailCardUI_VideoState createState() =>
      _CommonDetailCardUI_VideoState();
}

class _CommonDetailCardUI_VideoState extends State<CommonDetailCardUI_Video> {

  bool _isVideoLooping = false;
  VideoPlayerController _videoController;
  Future<void> _initializeVideoPlayerFuture;

  String _getVideoThumbnail() {
    if ((widget?.cardDetailData?.contentUrl?.length ?? 0) > 0) {
      return widget.cardDetailData.contentUrl[0].thumbnailImage;
    }

    return null;
  }

  String _getVideoContentUrl() {
    if ((widget?.cardDetailData?.contentUrl?.length ?? 0) > 0) {
      return widget.cardDetailData.contentUrl[0].url;
    }

    return null;
  }

  Duration _totalVideoDuration;
  Duration _currentVideoPlayingPosition;
  bool _isVideoPlaying = false;
  bool _isVideoPlayerUIVisible = false;
  bool _isVideoPlayerUIForceHide = true;
  bool _isEnd = false;
  bool _isPlayerControllsVisible = false;
  bool _isPlayerMuteVisible = true;
  bool _isCardChangeEventTriggered = false;

  @override
  void initState() {
    //_videoController?.play();
    super.initState();
    _setTimerForMuteUnmuteOpacity();

    switch (widget.playerType) {
      case PlayerType.HOME_CARD_CONTROLL:
        break;
      case PlayerType.DETAIL_CARD_CONTROLL:
        _initVideoPlayer();
        triggerObservers();
        break;
    }
  }

  void _initVideoPlayer() {
    int contentId = widget.cardDetailData.id;
/*
    hmVideoController.forEach((id, videoController) {
      videoController?.pause();
    });*/

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.

    _videoController = VideoPlayerController.network(
      //'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      _getVideoContentUrl(),
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _videoController?.initialize();

    _initializeVideoPlayerFuture.then((_) {
      handlePlayerAsPerScreenType();
    });

    // Use the controller to loop the video.
    _videoController?.setLooping(_isVideoLooping);

    hmVideoController[contentId] = _videoController;
  }

  void triggerObservers() {
    setTakeBreakTriggerObserver();
  }

  void setTakeBreakTriggerObserver() {
    eventBus.on<EventTakeABreak>().listen((event) {
      if (event.eventStatus == TAKE_A_BREAK_STATUS.BREAK) {
        _videoController?.pause();
      } else if (event.eventStatus == TAKE_A_BREAK_STATUS.RESUME) {
        _videoController?.play();
      }
    });
  }

  void handlePlayerAsPerScreenType() {
    //commonPlayerCode();

    switch (widget.playerType) {
      case PlayerType.HOME_CARD_CONTROLL:
        handleHomeCardPlayer();
        break;
      case PlayerType.DETAIL_CARD_CONTROLL:
        commonPlayerCode();
        handleDetailCardPlayer();
        break;
    }
  }

  void commonPlayerCode() {
    _videoController?.play();

    _videoController?.addListener(videoCallback);
  }

  void handleHomeCardPlayer() {
    /* _isVideoPlayerUIForceHide = true;
    _videoController?.setVolume(0);
    var videoDuration = _totalVideoDuration?.inSeconds ?? 0;
    if ((videoDuration ?? 0) > 0) {
      var seekTo = videoDuration ~/ 2;
      var durationSeekTo = Duration(seconds: seekTo);
      _videoController?.seekTo(durationSeekTo);
      _initializeTimer();
      print("videoDuration / 2 -> $seekTo");
    }*/
  }

  void handleDetailCardPlayer() {
    _isVideoPlayerUIForceHide = false;
    setVolumeManual();
  }

  void videoCallback() {
    if (mounted) {
      setState(() {
        _totalVideoDuration = _videoController?.value?.duration;
        _currentVideoPlayingPosition = _videoController?.value?.position;

        //PrintUtils.printLog("Munih Thakur -> Video callback -> Current Postion: $_currentVideoPlayingPosition, Total: $_totalVideoDuration");

        try {
          if ((_totalVideoDuration.inSeconds -
                  _currentVideoPlayingPosition.inSeconds) <=
              0) {
            _isEnd = true;
            //PrintUtils.printLog("(initStreamListeners)-> Listener removed -> (videoId: $videoId)");
          } else {
            //isCardChangeEventTriggered = false;
            _isEnd = false;
          }
        } catch (e) {}

        _isVideoPlaying =
            !_isEnd && (_videoController?.value?.isPlaying ?? false);
        //PrintUtils.printLog("(initStreamListeners)-> Video (_isEnd: true) -> _isVideoPlaying: $_isVideoPlaying -> (videoId: $videoId)");
        if (_isEnd) {

          if(_isVideoLooping) {
              // Do not do anything
          } else {
            toggleVideoPlayerControlUI(forceShow: true);
            //PrintUtils.printLog("(initStreamListeners)-> Video (_isEnd: true) -> _isVideoPlaying: $_isVideoPlaying -> (videoId: $videoId)");
            if (!_isCardChangeEventTriggered) {
              //PrintUtils.printLog("(initStreamListeners)-> Munish Thakur -> Card Change event triggered -> ${widget.cardDetailData.id} -> (videoId: $videoId)");
              AppUtils.screenKeepOn(false);
              _setTimerForNextCard();
            }
          }
        } else {
          AppUtils.screenKeepOn(true);
          //PrintUtils.printLog("(initStreamListeners)-> Video (_isEnd: false) -> _isVideoPlaying: $_isVideoPlaying -> (videoId: $videoId)");
        }
      });
    }
  }

  Timer timerNextCard;
  Timer timerMuteUnmuteCard;

  void _setTimerForNextCard() {
    _isCardChangeEventTriggered = true;
    timerNextCard = Timer.periodic(
        Duration(seconds: Constant.CARD_SCROLL_AFTER_CONTENT_CONSUMPTION_TIME),
        (_) {
      EventBusUtils.eventDetailCardChange(widget.cardDetailData.id.toString());
      timerNextCard?.cancel();
    });
  }

  void _setTimerForMuteUnmuteOpacity() {
    timerMuteUnmuteCard = Timer.periodic(Duration(seconds: 3), (_) {
      if (mounted) {
        setState(() {
          _isPlayerMuteVisible = false;
        });
      }
      timerMuteUnmuteCard?.cancel();
    });
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    print(
        "Munish -> CommonDetailCardUI_Video -> dispose() -> ID: ${widget.cardDetailData.id}");
    _videoController?.dispose();

    hmVideoController.remove(widget.cardDetailData.id);

    super.dispose();
  }

  _timerWorkCompleted() {
    if (_videoController?.value?.isPlaying ?? true) {
      _videoController?.pause();
    }
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

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    //return videoMainUI();

    Widget _videoMainBuildUI = Container();

    switch (widget.playerType) {
      case PlayerType.HOME_CARD_CONTROLL:
        _videoMainBuildUI = videoThumbnailWidget();
        break;
      case PlayerType.DETAIL_CARD_CONTROLL:
        _videoMainBuildUI = videoMainUI();
        break;
    }

    return Listener(
      key: new Key(widget.cardDetailData.id.toString() + "_video_Listener"),
      onPointerMove: _ListenerOnPointerMove,
      onPointerUp: _ListenerOnPointerUp,
      onPointerDown: _ListenerOnPointerDown,
      child: _videoMainBuildUI,
    );
  }

  Widget urlNotValidUI() {
    return Container(
      child: Text("Video Not Available (Not a Valid URL)"),
    );
  }

  bool isBottomTextVisibility = false;

  FutureBuilder<void> videoMainUI() {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (_getVideoContentUrl() == null) {
          return urlNotValidUI();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the video.
          return Column(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () {
                    toggleVideoPlayerControlUI();
                    setState(() {
                      isBottomTextVisibility = true;
                    });
                  },
                  child: Stack(
                    children: <Widget>[
                      videoWidget(widget.cardDetailData.contentUrl),

                      Center(
                        child: Container(
                          child: AspectRatio(
                            aspectRatio: _videoController?.value?.aspectRatio,
                            // Use the VideoPlayer widget to display the video.
                            child: _getVideoControllerUI(),
                          ),
                        ),
                      ),

                      //_getVideoControllerUI(),
                    ],
                  ),
                ),
                flex: 8,
              ),
              Visibility(
                visible: isBottomTextVisibility,
                child:  !(widget.cardDetailData.contentValue == null ||
                    widget.cardDetailData.contentValue == "") ?
                Expanded(
                  child : ContentBottomTextUI(widget.cardDetailData),
                  flex: 1,
                ): Container(height: 0.0,width: 0.0,),
              ),
            ],
          );

        } else {
          Widget widgetContentNotLoaded = Container();
          switch (widget.playerType) {
            case PlayerType.HOME_CARD_CONTROLL:
              widgetContentNotLoaded = playArrowWidget();
              break;
            case PlayerType.DETAIL_CARD_CONTROLL:
              // If the VideoPlayerController is still initializing, show a
              // loading spinner.
              widgetContentNotLoaded = Center(
                  child: CircularProgressIndicator(
                strokeWidth: 1.0,
              ));
              break;
          }

          return widgetContentNotLoaded;
        }
      },
    );
  }

  Widget playArrowWidget() {
    Widget widgetPlay = Align(
      alignment: Alignment(0.0, 0.0),
      child: Image.asset(
        "assets/play.png",
        scale: 2.0,
        color: ColorUtils.whiteColor,
      ),
    );

    return widgetPlay;
  }

  void toggleMute() async {
    if (mounted) {
      setState(() {
        isMute = !isMute;

        setVolumeManual();
      });
    }
  }

  void setVolumeManual() {
    if (isMute) {
      _videoController.setVolume(0.0);
    } else {
      _videoController.setVolume(_sliderValue);
    }
  }

  Widget volumeControlWidget() {
    return AnimatedOpacity(
      opacity: (_isPlayerControllsVisible || _isPlayerMuteVisible) ? 1.0 : 0.0,
      duration: Duration(milliseconds: 200),
      child: Container(
          child: isMute
              ? Container()
              : Container(
                  child: Slider(
                    activeColor: ColorUtils.whiteColor,
                    inactiveColor: ColorUtils.whiteColor.withOpacity(0.6),
                    min: 0.0,
                    max: 1.0,
                    onChanged: (newRating) {
                      _sliderValue = newRating;
                      setVolumeManual();
                    },
                    value: _sliderValue,
                  ),
                )),
    );
  }

  Widget muteUnMuteWidget() {
    return AnimatedOpacity(
      opacity: (_isPlayerControllsVisible || _isPlayerMuteVisible) ? 1.0 : 0.0,
      duration: Duration(milliseconds: 200),
      child: GestureDetector(
        child: Container(
          alignment: Alignment.center,
          child: (isMute)
              ? Image.asset(
                  "assets/mute.png",
                  scale: 3.0,
                )
              : Image.asset("assets/unmute.png", scale: 3.0),
        ),
        onTap: () {
          playerControlCommonEventPerformed();
          toggleMute();
        },
      ),
    );
  }

  Widget videoPlayLoopWidget() {
    return Positioned(
        bottom: 60.0,
        left: 5.0,
        child: AnimatedOpacity(
          opacity: (_isPlayerControllsVisible) ? 1.0 : 0.0,
          duration: Duration(milliseconds: 200),
          child: GestureDetector(
            child: Container(
              margin: EdgeInsetsDirectional.only(start: 8.0),
              alignment: Alignment.center,
              padding: EdgeInsets.all(4.0),
              height: 30.0,
              width: 30.0,
              decoration: BoxDecoration(
                color: Color(0xFF3A3A3A).withOpacity(0.3),
                borderRadius: BorderRadius.circular(24.0),
                shape: BoxShape.rectangle,
                //border: Border.all(color: Color(0xFFFEEBF1),width: 1.0 )
              ),
              /*decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(4.0),
                      color: Color(0xFF3A3A3A).withOpacity(0.5)),*/
              child: Image.asset(
                "assets/video_replay_icon.png",
                scale: 6.0,
                color: _isVideoLooping ? ColorUtils.primaryColor : ColorUtils.whiteColor,
              ),
            ),
            onTap: () {
              if (mounted) {
                setState(() {
                  _isVideoLooping = !_isVideoLooping;
                  _videoController.setLooping(_isVideoLooping);
                });
              }
            },
          ),
        )
    );
  }

  void detector(Object details) {}

  void toggleVideoPlayerControlUI(
      {bool forceShow = false, bool forceHide = false}) {
    if (mounted) {
      setState(() {
        if (forceShow) {
          _isVideoPlayerUIVisible = forceShow;
        } else if (forceHide) {
          _isVideoPlayerUIVisible = !forceHide;
        } else {
          _isVideoPlayerUIVisible = !_isVideoPlayerUIVisible;
        }

        setVideoControllsVisibility();
      });
    }
  }

  void setVideoControllsVisibility() {
    _isPlayerControllsVisible =
        (_isVideoPlayerUIVisible && !_isVideoPlayerUIForceHide);
    if (_isPlayerControllsVisible) {
      startHideVideoControllsVisibilityTimer();
    }
  }

  Timer _timerHideVideoControlls;

  void startHideVideoControllsVisibilityTimer() {
    _timerHideVideoControlls?.cancel();
    _timerHideVideoControlls = Timer.periodic(const Duration(seconds: 3),
        (_) => toggleVideoPlayerControlUI(forceHide: true));
  }

  Widget videoWidget(List<ContentUrlData> contentUrls) {
    if (contentUrls == null) {
      return Container();
    }
    if ((contentUrls?.length ?? 0) <= 0) {
      return Container();
    }

    Widget videoPlayerWidget;
    Widget playArrowButtonWidget = Container();
    if (widget.playerType == PlayerType.HOME_CARD_CONTROLL) {
      playArrowButtonWidget = playArrowWidget();
    }

    videoPlayerWidget = AspectRatio(
      aspectRatio: _videoController?.value?.aspectRatio,
      // Use the VideoPlayer widget to display the video.
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            VideoPlayer(_videoController),
            playArrowButtonWidget,
          ],
        ),
      ),
    );

    if (widget.playerType == PlayerType.HOME_CARD_CONTROLL) {
      return Center(
        child: videoPlayerWidget,
      );
    } else if (widget.playerType == PlayerType.DETAIL_CARD_CONTROLL) {
      return Center(
        child: Container(
          child: videoPlayerWidget,
        ),
      );
    }

    return Container();
  }

  Widget videoThumbnailWidget() {
    Widget _playArrowButtonWidget = Container();
    if (widget.playerType == PlayerType.HOME_CARD_CONTROLL) {
      _playArrowButtonWidget = playArrowWidget();
    }

    Widget _videoImageThumbnailWidget = Container();
    if (_getVideoThumbnail() != null) {
      _videoImageThumbnailWidget = Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        height: 180.0,
        child: CachedNetworkImage(
          imageUrl: _getVideoThumbnail(),
          placeholder: (context, url) => Container(),
          errorWidget: (context, url, error) => new Icon(Icons.error),
        ),
      );
    } else {
      _videoImageThumbnailWidget = Image.asset("assets/video");
    }

    return Container(
      child: Stack(
        children: <Widget>[
          _videoImageThumbnailWidget,
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: _playArrowButtonWidget,
          )
        ],
      ),
    );
  }

  Widget _getVideoControllerUI() {
    Widget _widgetVideoController = Container(
      // padding: EdgeInsets.only(top: 165.0),
      child: Stack(
        children: <Widget>[
          AnimatedOpacity(
            opacity: _isPlayerControllsVisible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 200),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ///Privious Play Forward
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                          child: Image.asset(
                            "assets/reverse.png",
                            scale: 3.2,
                            color: ColorUtils.whiteColor,
                          ),
                          onTap: () {
                            playerControlCommonEventPerformed();
                            if (_totalVideoDuration != null &&
                                _currentVideoPlayingPosition != null) {
                              var currentPosition =
                                  _currentVideoPlayingPosition.inSeconds;
                              var seekTo = currentPosition - 5.0;
                              if (seekTo < 0) {
                                seekTo = 0.0;
                              }
                              _videoController
                                  .seekTo(getDurationIntFromDouble(seekTo));
                            }
                          }),
                      _isVideoPlaying
                          ? InkWell(
                              child: Image.asset(
                                "assets/pause.png",
                                scale: 2.0,
                                color: ColorUtils.whiteColor,
                              ),
                              onTap: () {
                                playerControlCommonEventPerformed();
                                _videoController?.pause();
                              },
                            )
                          : InkWell(
                              child: _isEnd
                                  ? Image.asset(
                                      "assets/ic_replay.png",
                                      scale: 2.3,
                                      color: ColorUtils.whiteColor,
                                    )
                                  : Image.asset(
                                      "assets/play.png",
                                      scale: 2.0,
                                      color: ColorUtils.whiteColor,
                                    ),
                              onTap: () {
                                playerControlCommonEventPerformed();
                                if (_isEnd) {
                                  _videoController.seekTo(Duration(seconds: 0));
                                }
                                _videoController?.play();
                              },
                            ),
                      InkWell(
                        child: Image.asset(
                          "assets/forward48.png",
                          scale: 3.2,
                          color: ColorUtils.whiteColor,
                        ),
                        onTap: () {
                          playerControlCommonEventPerformed();
                          if (_totalVideoDuration != null &&
                              _currentVideoPlayingPosition != null) {
                            var currentPosition =
                                _currentVideoPlayingPosition.inSeconds;
                            var durationInSeconds =
                                _totalVideoDuration.inSeconds;
                            var seekTo = currentPosition + 5.0;
                            if (seekTo > durationInSeconds) {
                              seekTo = durationInSeconds - 1.0;
                            }
                            _videoController
                                .seekTo(getDurationIntFromDouble(seekTo));
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            //top: 0.0,
            //left: 0.0,
            right: 5.0,
            bottom: 60.0,
            child: AnimatedOpacity(
              opacity: _isPlayerControllsVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 200),
              child: Container(
                margin: EdgeInsetsDirectional.only(end: 8.0),
                alignment: Alignment.center,
                padding: EdgeInsets.all(8.0),
                height: 30.0,
                //width: 30.0,
                decoration: BoxDecoration(
                  color: Color(0xFF3A3A3A).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(24.0),
                  shape: BoxShape.rectangle,
                  //border: Border.all(color: Color(0xFFFEEBF1),width: 1.0 )
                ),
                child: Row(
                  children: <Widget>[volumeControlWidget(), muteUnMuteWidget()],
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _isPlayerControllsVisible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 200),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[

                  ///Seekbar Temp(Ankit)
                  Container(
                    color: Colors.transparent,
                    height: 30.0,
                    width: MediaQuery.of(context).size.width,
                    //child: customSliderWidget(),
                    child: videoSliderWidget(),
                  ),
                  ///Timer & FullScreen Option
                  Container(
                    color: Colors.transparent,
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(left: 8.0, right: 8.0,bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsetsDirectional.only(start: 8.0),
                          child: Text(
                              _currentVideoPlayingPosition != null
                                  ? getDurationVideo(
                                  _currentVideoPlayingPosition
                                      ?.inSeconds) ??
                                  "NA"
                                  : "NA",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.start),
                        ),
                        CustomWidget.getText("/",style: Theme.of(context).textTheme.subtitle.copyWith(color:Colors.white70)),
                        Container(
                          margin: EdgeInsetsDirectional.only(end: 8.0),
                          child: Text(
                              _totalVideoDuration != null
                                  ? getDurationVideo(
                                  _totalVideoDuration?.inSeconds)
                                  ?.toString() ??
                                  "NA"
                                  : "NA",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.start),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          videoPlayLoopWidget(),
        ],
      ),
    );

    Widget listenerVideoView = Listener(
      key: new Key(widget.cardDetailData.id.toString() + "_video_Listener"),
      onPointerMove: _ListenerOnPointerMove,
      onPointerUp: _ListenerOnPointerUp,
      onPointerDown: _ListenerOnPointerDown,
      child: _widgetVideoController,
    );

    return listenerVideoView;
  }

  Widget videoSliderWidget() {
    return Slider(
      activeColor: ColorUtils.primaryColor,
      inactiveColor: ColorUtils.whiteColor,
      value: getSliderValue(),
      onChanged: (value) {
        setState(() {
          _videoController?.seekTo(getDurationIntFromDouble(value));
        });
      },
      max: _totalVideoDuration?.inSeconds?.roundToDouble() ?? 0.0,
      min: 0,
      //divisions: _totalVideoDuration?.inSeconds ?? 1,
    );
  }

  double getSliderValue() {
    int maxVideoPosition = _totalVideoDuration?.inSeconds;
    int currentVideoPosition = _currentVideoPlayingPosition?.inSeconds ?? 0;
    return ((currentVideoPosition < maxVideoPosition)
            ? currentVideoPosition
            : maxVideoPosition)
        .toDouble();
  }

  Duration getDuration(int valueInSeconds) => Duration(seconds: valueInSeconds);

  Duration getDurationIntFromDouble(double valueInSeconds) {
    if (valueInSeconds == null) {
      valueInSeconds = 0.0;
    }
    return Duration(seconds: valueInSeconds.toInt());
  }

  String getDurationVideo(int seconds) {
    try {
      String durationToShow = "";
      var duration = Duration(seconds: seconds);
      var hour = duration.inHours;
      var minutes = duration.inMinutes;

      if (hour > 0) {
        durationToShow = "$hour:";
      }

      durationToShow = getMinutesToShowInVideoDuration(minutes, durationToShow);
      durationToShow = getSecondsToShowInVideoDuration(seconds, durationToShow);

      return durationToShow;
    } catch (e) {
      return "";
    }
  }

  String getMinutesToShowInVideoDuration(int minutes, String durationToShow) {
    if (minutes >= 60) {
      minutes = minutes ~/ 60;
    }

    String minutesToShow = "";

    if (minutes < 10) {
      minutesToShow = "0$minutes";
    } else {
      minutesToShow = "$minutes";
    }
    durationToShow = "$durationToShow$minutesToShow:";
    return durationToShow;
  }

  String getSecondsToShowInVideoDuration(int seconds, String durationToShow) {
    if (seconds >= 60) {
      seconds = seconds ~/ 60;
    }

    String secondsToShow = "";

    if (seconds < 10) {
      secondsToShow = "0$seconds";
    } else {
      secondsToShow = "$seconds";
    }
    durationToShow = "$durationToShow$secondsToShow";
    return durationToShow;
  }

  void playerControlCommonEventPerformed() {
    if ((timerNextCard?.isActive ?? false)) {
      timerNextCard?.cancel();
    }
  }
}
