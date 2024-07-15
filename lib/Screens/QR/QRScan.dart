import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:tymoff/Network/Api/ApiHandler.dart';
import 'package:tymoff/Screens/AppBar/CustomAppBar.dart';
import 'package:tymoff/Utils/Strings.dart';
import 'package:tymoff/Utils/ToastUtils.dart';


const flash_on = "FLASH ON";
const flash_off = "FLASH OFF";
const front_camera = "FRONT CAMERA";
const back_camera = "BACK CAMERA";

class QRScan extends StatefulWidget {

  const QRScan({
    Key key,
  }) : super(key: key);

  @override
  _QRScanState createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  var qrText = "";
  var flashState = flash_on;
  var cameraState = front_camera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR_tymoff');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().getAppBar(
        context: context,
        title: Strings.scanQR,
        leadingIcon: Icons.arrow_back_ios,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  _isFlashOn(String current) {
    return flash_on == current;
  }

  _isBackCamera(String current) {
    return back_camera == current;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {

      controller.pauseCamera();

      String barcode = scanData;
      ApiHandler.verifyQrCode(barcode, context: context).then((_qrScanData) {

        controller.resumeCamera();
        if(_qrScanData?.success != null && _qrScanData.success) {
          ToastUtils.show(_qrScanData?.message ?? "Scan successful");
          Navigator.pop(context);
        } else if((_qrScanData?.statusCode ?? 0) == 200) {
          ToastUtils.show(_qrScanData?.message ?? "Scan successful");
          Navigator.pop(context);
        }

        //ToastUtils.show(_qrScanData?.message ?? "Scan not successful");
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
