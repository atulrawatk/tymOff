import 'dart:collection';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:tymoff/BLOC/BlocProvider/ApplicationBlocProvider.dart';
import 'package:tymoff/BLOC/Blocs/AccountBloc.dart';
import 'package:tymoff/EventBus/EventBusUtils.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Network/Response/ActionContentListResponse.dart';
import 'package:tymoff/Utils/AnalyticsUtils.dart';
import 'package:tymoff/Utils/AppPermissionUtils.dart';
import 'package:tymoff/Utils/AppUtils.dart';
import 'package:tymoff/Utils/ColorUtils.dart';
import 'package:tymoff/Utils/ContentTypeUtils.dart';
import 'package:tymoff/Utils/CustomWidget.dart';
import 'package:tymoff/Utils/PrintUtils.dart';
import 'package:tymoff/Utils/StorageUtils.dart';
import 'package:tymoff/Utils/Strings.dart';
import 'package:tymoff/Utils/ToastUtils.dart';
import 'package:open_file/open_file.dart';
import 'package:progress_indicators/progress_indicators.dart';

class DownloadWidget extends StatefulWidget {
  final int contentId;
  final ContentUrlData contentUrl;
  final AppContentType contentType;

  DownloadWidget(this.contentUrl, {this.contentId, this.contentType});

  @override
  _DownloadWidgetState createState() => _DownloadWidgetState();
}

class _DownloadWidgetState extends State<DownloadWidget> {
  AccountBloc accountBloc;

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    _initDownloadImpl();

    super.initState();
  }

  void fireEventDetailCardDoNotChange() {
    if (widget?.contentId != null) {
      EventBusUtils.eventDetailCardDoNotChange(
          widget.contentId.toString());
    }
  }

  @override
  void didChangeDependencies() {
    accountBloc = ApplicationBlocProvider.ofAccountBloc(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  int downloadProgress = 0;

  bool _isDownloaded() {
    return downloadProgress > 99;
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      print('UI Isolate Callback: $data');
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (mounted) {
        setState(() {
          downloadProgress = progress;
        });
      }

      if (status == DownloadTaskStatus.complete) {
        PrintUtils.printLog("Munish -> Download Completed -> id: $id");
        setState(() {
          _progress = false;
        });
        _loadAllDownloadedTask();
      } else if (status == DownloadTaskStatus.running) {
        setState(() {
          _progress = true;
        });
        PrintUtils.printLog(
            "Munish -> Download Running -> id: $id, Progress: $progress");
      } else if ((status == DownloadTaskStatus.failed) ||
          (status == DownloadTaskStatus.undefined)) {
        ToastUtils.show("Downloaded Failed -> ${status.toString()}");
      }
      /*
      final task = _tasks?.firstWhere((task) => task.taskId == id);
      if (task != null) {
        setState(() {
          task.status = status;
          task.progress = progress;
        });
      }*/
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  void _initDownloadImpl() {
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _loadAllDownloadedTask();
    //_setDownloadCallback();
  }

  /// Download Content functionality...
  final _downloadTasks = HashMap<String, DownloadTask>();

  void _requestDownloadTymoffFolder() async {
    try {
      var url = _getContentUrl();
      var _localPath = await StorageUtils.findLocalTymoffPath(context);

      final savedDir = Directory(_localPath);
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }

      var headers = await ApiHandler.getHeaders();
      await FlutterDownloader.enqueue(
          url: url,
          //fileName: fileName,
          savedDir: _localPath,
          showNotification: true,
          openFileFromNotification: true,
          headers: headers);
    } catch (e) {
      print("Munish Thakur -> _requestDownloadTymoffFolder() -> ${e.toString()}");
    }
  }


  void _eventDownloadTriggered() async {
    var isInternetAvailable = await AppUtils.isInternetAvailable();
    if(isInternetAvailable) {
      _requestDownloadTymoffFolder();

      final platform = Theme.of(context).platform;
      if(platform == TargetPlatform.android) {
        _requestDownloadDownloadFolder();
      }
    } else {
      ToastUtils.show(Strings.errorDownloadInternetNotConnected);
    }
  }

  void _requestDownloadDownloadFolder() async {
    try {
      var url = _getContentUrl();
      var _localPath = await StorageUtils.findLocalDownloadPath(context);

      final savedDir = Directory(_localPath);
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }

      var headers = await ApiHandler.getHeaders();
      await FlutterDownloader.enqueue(
          url: url,
          //fileName: fileName,
          savedDir: _localPath,
          showNotification: false,
          openFileFromNotification: false,
          headers: headers);
    } catch (e) {
      print("Munish Thakur -> _requestDownloadDownloadFolder() -> ${e.toString()}");
    }
  }

  void _loadAllDownloadedTask() {
    FlutterDownloader.loadTasks().then((downloadList) {
      var _downloadTasks = HashMap<String, DownloadTask>();
      downloadList?.forEach((downloadTask) {
        _downloadTasks[downloadTask.url] = downloadTask;
      });

      setState(() {
        this._downloadTasks.clear();
        this._downloadTasks.addAll(_downloadTasks);
      });
    });
  }

  bool _isTaskAlreadyInDownloadList() {
    if (widget.contentUrl == null) {
      return false;
    }
    return _downloadTasks.containsKey(_getContentUrl());
  }

  DownloadTask _getDownloadTask() {
    if (_isTaskAlreadyInDownloadList()) {
      return _downloadTasks[_getContentUrl()];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var downloadText = (_isTaskAlreadyInDownloadList() || _isDownloaded())
        ? "Open"
        : "Download";

    return Container(
      child: StreamBuilder<StateOfAccount>(
          initialData: accountBloc.getAccountState(),
          stream: accountBloc.accountStateObservable,
          builder: (context, snapshot) {
            return GestureDetector(
              child: Container(
                padding: EdgeInsets.only(left: 8.0, top: 4.0, bottom: 4.0),
                color: Colors.transparent,
                // height: 50.0,
                width: 50.0,
                child: Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        _progress ? GlowingProgressIndicator(
                          child: Image.asset(
                            "assets/download.png",
                            scale: 3.0,
                            color: isDownloadable()
                                ? Theme.of(context).unselectedWidgetColor
                                : ColorUtils.textDetailScreenColor
                                    .withOpacity(0.6),
                          ),
                        ) :  Image.asset(
                                "assets/download.png",
                                scale: 3.0,
                                color: isDownloadable()
                                    ? Theme.of(context).unselectedWidgetColor
                                    : ColorUtils.textDetailScreenColor
                                    .withOpacity(0.6),
                              ),
                       /* Positioned(
                          top: 0.0,
                          right: 0.0,
                          bottom: 0.0,
                          left: 0.0,
                          child: _progress
                              ? Container(
                                  color: Colors.transparent,
                                  child: CircularProgressIndicator(
                                    value: downloadProgress.toDouble(),
                                    backgroundColor: ColorUtils.primaryColor,
                                    strokeWidth: 1.2,
                                  ),
                                )
                              : Container(),
                        ),*/
                      /*  Positioned(
                          top: 0.0,
                          right: 0.0,
                          bottom: 0.0,
                          left: 0.0,
                          child: _progress
                              ? Container(
                                  color: Colors.transparent,
                                  child: CircularProgressIndicator(
                                    backgroundColor:
                                        Theme.of(context).unselectedWidgetColor,
                                    strokeWidth: 1.2,
                                  ),
                                )
                              : Container(),
                        ),*/
                      ],
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    CustomWidget.getText(downloadText,
                        style: Theme.of(context).textTheme.display1.copyWith(
                            color: isDownloadable()
                                ? ColorUtils.textDetailScreenColor
                                : ColorUtils.textDetailScreenColor
                                    .withOpacity(0.6),
                            fontSize: 14.0)),
                  ],
                ),
              ),
              onTap: () {
                if (widget.contentType != null) {
                  if (isDownloadable()) {
                    downloadContent(context);
                  }
                  fireEventDetailCardDoNotChange();
                  /*else {
                    SnackBarUtil.showSnackBar(
                        context, "Not supported format to download");
                  }*/
                }
              },
            );
          }),
    );
  }

  bool isDownloadable() {
    if (widget.contentType == AppContentType.image ||
        widget.contentType == AppContentType.video ||
        widget.contentType == AppContentType.gif) {
      return true;
    }
    return false;
  }

  bool _progress = false;
  bool _isShowCircularProgressBar = true;

  void downloadContent(BuildContext context) {
    AppPermissionUtils.checkStoragePermission(context).then((isGranted) {
      if (_isTaskAlreadyInDownloadList()) {
        var downloadTask = _getDownloadTask();
        if (downloadTask != null) {
          var fileAbsolutePath =
              downloadTask.savedDir + "/" + downloadTask.filename;
          var url = downloadTask.url;
          print(
              "Munish Thakur -> downloadContent() -> '$fileAbsolutePath' from '$url'");
          OpenFile.open(fileAbsolutePath);

          //openFile(downloadTask.taskId);
        }
      } else {
        if (isGranted) {
          print("Permission granted");
          _eventDownloadTriggered();
        } else {
          print("Permission not granted");
        }
      }
    });

    AnalyticsUtils?.analyticsUtils?.eventDownloadButtonClicked();
  }

  String _getContentUrl() {
    return "https://server-end.tymoff.com:8443/aintertain/api/v1/data/action/download/content/${widget.contentId}/url/${widget.contentUrl.id}";
    //return widget.contentUrl.url;
  }

  void openFile(String taskId) {
    _openDownloadedFile(taskId).then((success) {
      if (!success) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Cannot open this file')));
      }
    });
  }

  Future<bool> _openDownloadedFile(String taskId) {
    return FlutterDownloader.open(taskId: taskId);
  }
}
