import 'package:flutter/material.dart';
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/router/router_delegate.dart';

class UpdatePopUp {
  static tryOtaUpdate(
    PackageInfo update,
    void Function(OtaEvent event) updateCallback,
  ) async {
    try {
      OtaUpdate()
          .execute(
            update.buildSignature,
            destinationFilename: 'MobEx health Hub.apk',
            // sha256checksum: 'd6da28451a1e15cf7a75f2c3f151befad3b80ad0bb232ab15c20897e54f21478',
          )
          .listen(updateCallback);
    } catch (e) {
      print('Failed to make OTA update. Details: $e');
    }
  }

  static showUpdateDialog(
      BuildContext context, PackageInfo update, bool mandatory, String notes) {
    bool clickedOk = false;
    OtaEvent? currentEvent;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext contextAlert) {
        return StatefulBuilder(builder: (context, setState) {
          double progress = 0;
          try {
            progress = double.parse(currentEvent?.value ?? "0") / 100;
          } catch (err) {
            print(err);
          }
          if (progress == 1) {
            Navigator.of(contextAlert).pop();
          }
          return clickedOk
              ? AlertDialog(
                  title: Text("Downloading  ${(progress * 100).round()}%"),
                  content: DownloadIndicator(
                    progress: progress,
                  ),
                )
              : AlertDialog(
                  title: const Text("Update available"),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Text(notes),
                  ),
                  actions: [
                    if (!mandatory)
                      GestureDetector(
                        child: const Text("Later"),
                        onTap: () {
                          Navigator.of(contextAlert).pop();
                        },
                      ),
                    GestureDetector(
                      child: const Text("Update Now"),
                      onTap: () async {
                        await tryOtaUpdate(update, (event) {
                          print("entered with data");
                          print(event.status);
                          if (event.status == OtaStatus.ALREADY_RUNNING_ERROR ||
                              event.status == OtaStatus.DOWNLOAD_ERROR ||
                              event.status == OtaStatus.CHECKSUM_ERROR ||
                              event.status == OtaStatus.INTERNAL_ERROR ||
                              event.status ==
                                  OtaStatus.PERMISSION_NOT_GRANTED_ERROR) {
                            Navigator.of(contextAlert).pop();
                            currentEvent = null;
                          }
                          setState(() {
                            currentEvent = event;
                          });
                        });
                        setState(() {
                          clickedOk = true;
                        });
                      },
                    )
                  ],
                );
        });
      },
    );
  }

  static Future<OverlayEntry?> showUpdate(
      PackageInfo update, bool mandatory, String notes) async {
    if (fcRouter.navigatorKey.currentContext == null) {
      return null;
    }
    return await showUpdateDialog(
        fcRouter.navigatorKey.currentContext!, update, mandatory, notes);
  }
}

class DownloadIndicator extends StatelessWidget {
  final double progress;

  const DownloadIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress, // Progress value between 0.0 and 1.0
      backgroundColor: Colors.grey[300],
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }
}
