import 'dart:async';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyVideoPlayerController extends GetxController implements GetxService {
  BetterPlayerController? _betterPlayerController;
  List<BetterPlayerEvent> events = [];
  bool saveProgressCalled = false;
  final StreamController<DateTime> _eventStreamController =
      StreamController.broadcast();
  BetterPlayerController? get betterPlayerController => _betterPlayerController;

  void playVideo(String url, {bool isOnline = true}) async {
    // await stopPlayer();
    BetterPlayerConfiguration betterPlayerConfiguration =
        const BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      //placeholder: Image.asset('',fit: BoxFit.fill,),
      controlsConfiguration: BetterPlayerControlsConfiguration(
        enableFullscreen: true,
        enableMute: true,
        enableOverflowMenu: true,
        enableSubtitles: true,
        enableSkips: false,
        enableProgressBarDrag: true,
        enableProgressBar: true,
        enableProgressText: true,
        enableRetry: false,
        enablePlayPause: true,
      ),
    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      isOnline
          ? BetterPlayerDataSourceType.network
          : BetterPlayerDataSourceType.file,
      url,
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController?.setupDataSource(dataSource);
    _betterPlayerController?.addEventsListener(_handleEvent);
    // _betterPlayerController?.play();
    if (!saveProgressCalled) {
      _betterPlayerController?.addEventsListener((event) => {
            if (event.betterPlayerEventType == BetterPlayerEventType.finished)
              {
                // print(event.parameters!['progress'].inSeconds.toString())
                // print(event.parameters!['duration'].inSeconds.toString())
                // Get.find<ClassroomController>().saveCourseProgress( id, lessonId,  sectionId, event.parameters!['progress'].inSeconds.toString(), event.parameters!['duration'].inSeconds.toString())
              },
          });
    }
    update();
  }

  void _handleEvent(BetterPlayerEvent event) {
    events.insert(0, event);

    ///Used to refresh only list of events
    _eventStreamController.add(DateTime.now());
  }

  Future<void> stopPlayer() async {
    saveProgressCalled = false;
    if (betterPlayerController != null &&
        betterPlayerController?.isPlaying() == true) {
      _eventStreamController.close();
      _betterPlayerController?.removeEventsListener(_handleEvent);
      _betterPlayerController?.dispose();
    }

    update();
  }

  @override
  void dispose() {
    stopPlayer();
    super.dispose();
  }
}
