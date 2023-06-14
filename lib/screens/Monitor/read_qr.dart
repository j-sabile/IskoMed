import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import '../../providers/monitor_provider.dart';
import '../../models/log.dart';

class ReadQRPage extends StatefulWidget {
  const ReadQRPage({super.key});

  @override
  State<ReadQRPage> createState() => _ReadQRPageState();
}

class _ReadQRPageState extends State<ReadQRPage> {
  String lastQRScanned = "";
  Log? templastScanned;
  Log? lastScanned;
  bool canScan = true;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) controller!.pauseCamera();
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Code")),
      body: Column(
        children: [
          Expanded(flex: 1, child: _buildQrView(context)),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 15),
                  child: (lastScanned != null) ? Text("Scanned: ${lastScanned!.studentNumber}") : const Text("Scanning...")),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async => await controller?.toggleFlash(),
                      child: const Icon(Icons.flash_on),
                    ),
                    ElevatedButton(
                      onPressed: () async => await controller?.flipCamera(),
                      child: const Icon(Icons.flip_camera_ios),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay:
          QrScannerOverlayShape(borderColor: const Color(0xFF6B6BBF), borderRadius: 10, borderLength: 30, borderWidth: 5),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((scanData) async {
      if (lastQRScanned != scanData.code && canScan) {
        canScan = false;
        templastScanned = await context.read<MonitorProvider>().addLog(scanData.code!);
        setState(() => lastScanned = templastScanned);
        lastQRScanned = scanData.code!;
        scannedAlert(templastScanned!);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No Permission!")));
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void scannedAlert(Log log) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF3EEEE),
          shape: const RoundedRectangleBorder(
            side: BorderSide(width: 4, color: Color(0xFF6B6BBF)),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: const Center(child: Text("Scanned", style: TextStyle(fontWeight: FontWeight.bold))),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Student Number: ${log.studentNumber}"),
                Text("Date: ${log.date}"),
                Text("Status: ${log.status}"),
              ],
            ),
          ),
          actions: <Widget>[
            CloseButton(
              color: const Color(0xFF6B6BBF),
              onPressed: () {
                setState(() => canScan = true);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
