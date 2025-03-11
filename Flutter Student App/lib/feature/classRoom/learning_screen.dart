import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_app_bar.dart';
import 'package:opencentric_lms/components/custom_button.dart';
import 'package:opencentric_lms/components/error_dialog.dart';
import 'package:opencentric_lms/components/loading_dialog.dart';
import 'package:opencentric_lms/components/loading_indicator.dart';
import 'package:opencentric_lms/controller/classroom_controller.dart';
import 'package:opencentric_lms/controller/course_detail_controller.dart';
import 'package:opencentric_lms/data/model/common/lesson.dart';

import 'package:opencentric_lms/feature/myCourse/widgets/video_web_view.dart';
import 'package:opencentric_lms/feature/quiz/quiz_detail_page.dart';
import 'package:opencentric_lms/utils/app_constants.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';
import 'package:opencentric_lms/utils/styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../controller/quiz_controller.dart';
import '../../controller/user_controller.dart';
import '../../controller/video_player_controller.dart';
import '../../data/model/common/section.dart';
import 'package:http_server/http_server.dart' as http_server;

import '../../data/model/quiz/quiz.dart';
import '../../main.dart';
import '../myCourse/widgets/scorm_view.dart';
import '../quiz/item_quiz.dart';
import '../zoom/services/zoom_api.dart';
import '../zoom/jwt.dart';
import '../zoom/zoom_functions.dart';
import 'widget/video_player.dart';
import 'package:path/path.dart' as path;

class LearningScreen extends StatefulWidget {
  final String courseTitle;
  final String courseID;
  final Lesson lesson;
  final bool isOnline;
  const LearningScreen(
      {super.key,
      required this.courseTitle,
      required this.courseID,
      required this.lesson,
      required this.isOnline});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  YoutubePlayerController? _controller;
  bool isShow = true;
  @override
  void initState() {
    if (widget.lesson.isCompleted == false) {
      Get.find<CourseDetailController>().lmsUpdateStatusLesson(
          (widget.lesson.id).toString(), widget.courseID);
    }
    if (widget.lesson.urlVideoYoutube.isNotEmpty && widget.isOnline) {
      final videoId =
          YoutubePlayer.convertUrlToId(widget.lesson.urlVideoYoutube) ?? "";
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(mute: false, autoPlay: false),
      );
    }
    if (widget.lesson.urlVideo.isNotEmpty) {
      Get.put(MyVideoPlayerController())
          .playVideo(widget.lesson.urlVideo, isOnline: widget.isOnline);
    }
    Get.find<QuizController>()
        .getQuizDataByLessonId(widget.lesson.id.toString());
    super.initState();
  }

  Future<void> _startLocalServer(String path) async {
    try {
      // Stop the server if it is already running
      if (server != null) {
        await server?.close(force: true);
        server = null;
      }

      final scormPath = Directory(path);
      if (kDebugMode) {
        print('samdn: $scormPath');
      }
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080,
          shared: true);
      final virDir = http_server.VirtualDirectory(scormPath.path)
        ..allowDirectoryListing = true
        ..jailRoot = false
        ..followLinks = true
        ..errorPageHandler = (HttpRequest request) {
          request.response
            ..statusCode = HttpStatus.notFound
            ..write('Not Found')
            ..close();
        };

      server?.listen((HttpRequest request) {
        virDir.serveRequest(request);
      });
    } catch (e) {
      ErrorDialog.show(Get.context, () {
        _startLocalServer(path);
      });
    }
  }

  Future<void> _startLocalServerAssets() async {
    await Permission.storage.request();
    await copyInteractiveContent();
    final externalStorageFolder = await getExternalStorageDirectory();

    final path =
        '/data/user/0/com.spagreen.faculty/app_flutter/74/courses/64/lessons';
    try {
      // Stop the server if it is already running
      if (server != null) {
        await server?.close(force: true);
        server = null;
      }

      // Get path on download folder device storage

      final scormPath = Directory(path);
      if (kDebugMode) {
        print('samdn: $scormPath');
      }
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080,
          shared: true);
      final virDir = http_server.VirtualDirectory(scormPath?.path ?? "")
        ..allowDirectoryListing = true
        ..jailRoot = false
        ..followLinks = true
        ..errorPageHandler = (HttpRequest request) {
          request.response
            ..statusCode = HttpStatus.notFound
            ..write('Not Found')
            ..close();
        };

      server?.listen((HttpRequest request) {
        virDir.serveRequest(request);
      });
    } catch (e) {
      ErrorDialog.show(Get.context, () {
        _startLocalServer(path);
      });
    }
  }

  Future<void> copyFolder(String sourcePath, String destinationPath) async {
    final sourceDir = Directory(sourcePath);
    final destinationDir = Directory(destinationPath);

    if (!await destinationDir.exists()) {
      await destinationDir.create(recursive: true);
    }

    await for (var entity in sourceDir.list(recursive: false)) {
      if (entity is Directory) {
        var newDirectory = Directory(
            path.join(destinationDir.path, path.basename(entity.path)));
        await copyFolder(entity.path, newDirectory.path);
      } else if (entity is File) {
        var newFile =
            File(path.join(destinationDir.path, path.basename(entity.path)));
        await entity.copy(newFile.path);
      }
    }
  }

  Future<void> copyInteractiveContent() async {
    final sourcePath = '/storage/emulated/0/Download/interactive-content-16';
    final destinationPath =
        '/data/user/0/com.spagreen.faculty/app_flutter/74/courses/64/lessons';

    try {
      await copyFolder(sourcePath, destinationPath);
      print('Folder copied successfully');
    } catch (e) {
      print('Error copying folder: $e');
    }
  }

  void goToH5pVideo(String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => VideoWebView(url: url, isOnline: widget.isOnline)),
    );
  }

  Future<void> goToScorm(LessonScorm scorm, String urlScorm) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final uid = sharedPreferences.getString(AppConstants.uid) ?? "";
    if (widget.lesson.lessonFolderPath.isNotEmpty) {
      // await _startLocalServerAssets();
      await _startLocalServer(widget.lesson.lessonFolderPath);
      final Directory folder = Directory(widget.lesson.lessonFolderPath);
      if (await folder.exists()) {
        // Đọc tệp imsmanifest.xml
        final manifestPath =
            '${widget.lesson.lessonFolderPath}/imsmanifest.xml';
        final manifestFile = File(manifestPath);
        final document = XmlDocument.parse(manifestFile.readAsStringSync());
        // Tìm tệp SCO (scormType="sco")
        XmlElement scoItem = document.findAllElements('resource').firstWhere(
              (element) =>
                  element.getAttribute('adlcp:scormType') == 'sco' &&
                  element.getAttribute('href') != null,
            );

        //Tìm id
        final url = '${scoItem.getAttribute('href')}';
        Navigator.of(context)
            .push(
          MaterialPageRoute(
              builder: (_) =>
                  ScormViewer(scormContentPath: 'http://127.0.0.1:8080/$url')),
        )
            .then((value) async {
          final server = await HttpServer.bind(
              InternetAddress.loopbackIPv4, 8080,
              shared: true);
          await server.close(force: true);
          if (kDebugMode) {
            print('Local server stopped');
          }
        });
      }
    } else {
      if (urlScorm.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ScormViewer(
                  scormContentPath: urlScorm,
                  uid: uid,
                )));
      }
    }
  }

  @override
  void dispose() {
    Get.put(MyVideoPlayerController()).stopPlayer();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isShow) {
      return const Scaffold();
    }
    if (_controller == null) {
      return body(context);
    }
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
        onReady: () {
          // _controller?.addListener(listener);
        },
      ),
      builder: (contextVideo, player) {
        return body(context, player: player);
      },
    );
  }

  Scaffold body(BuildContext context, {Widget? player}) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.courseTitle,
        onBackPressed: () {
          setState(() {
            isShow = false;
          });
          Get.back();
        },
      ),
      body: GetBuilder<ClassroomController>(builder: (controller) {
        return controller.isLoading
            ? const LoadingIndicator()
            : mainUI(context, controller.sectionList, controller,
                player: player);
      }),
    );
  }

  Widget mainUI(BuildContext context, List<Section> sectionList,
      ClassroomController controller,
      {Widget? player}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: Text(
                    widget.courseTitle,
                    style: robotoSemiBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault),
                  child: GetBuilder<QuizController>(
                    init: Get.find<QuizController>(),
                    builder: (controller) {
                      if (controller.isDataLoading) {
                        return Container();
                      }

                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.quizModel?.data.length ?? 0,
                          itemBuilder: (context, index) {
                            final quiz = controller.quizModel?.data[index];
                            if (quiz != null) {
                              return ItemQuiz(quiz: quiz);
                            } else {
                              return Container(); // or handle the null case appropriately
                            }
                          });
                    },
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                // Video upload
                if (widget.lesson.urlVideo.isNotEmpty)
                  Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.orange.withOpacity(0.2),
                      child: CourseVideoPlayer(
                        videoUrl: widget.lesson.urlVideo,
                      )),
                // Scorm
                if (widget.lesson.listScorm.isNotEmpty)
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.lesson.listScorm.length,
                      itemBuilder: (context, index) {
                        return _item(context, widget.lesson.listScorm[index],
                            widget.lesson.urlScorm);
                      }),
                // Video upload
                if (widget.lesson.urlVideoH5p.isNotEmpty)
                  _itemH5p(context, widget.lesson.urlVideoH5p),
                const SizedBox(
                  height: 10,
                ),
                // Video youtube
                Builder(builder: (context) {
                  if (_controller != null) {
                    return player!;
                  }
                  if (widget.lesson.urlVideoYoutube.isNotEmpty &&
                      !widget.isOnline) {
                    return Center(
                      child: Text(
                        'Youtube video is only available in online mode',
                        style: robotoRegular.copyWith(fontSize: 14),
                      ),
                    );
                  }
                  return Container();
                }),
                // Zoom item
                if (widget.lesson.zoomClassData != null) zoomItem(widget.lesson)
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
        ],
      ),
    );
  }

  Widget zoomItem(Lesson lesson) {
    if (!widget.isOnline) {
      return Center(
        child: Text(
          'Zoom is only available in online mode',
          style: robotoRegular.copyWith(fontSize: 14),
        ),
      );
    }
    return InkWell(
      onTap: () async {
        LoadingDialog.show(context);
        try {
          final user = Get.find<UserController>().userData;

          final classData = lesson.zoomClassData;

          if (classData != null) {
            if (user?.roles == AppConstants.student) {
              var responseToken = await generateZoomAccessToken();
              String zoomAccessToken = responseToken['access_token'];
              LoadingDialog.hide(context);
              joinMeeting(
                  meetingId: classData.id.toString(),
                  zoomAccessToken: zoomAccessToken,
                  displayName: "123",
                  password: classData.password);
            } else if (user?.roles == AppConstants.teacher) {
              var responseToken = await generateZoomAccessToken();
              String zoomAccessToken = responseToken['access_token'];
              final uid = getUid(zoomAccessToken);
              var responseZak = await getZak(zoomAccessToken, uid);
              LoadingDialog.hide(context);
              startMeeting(
                meetingId: classData.id.toString(),
                displayName: user?.name ?? "",
                zoomAccessToken: responseZak['token'],
              );
            } else {
              var responseToken = await generateZoomAccessToken();
              String zoomAccessToken = responseToken['access_token'];
              final uid = getUid(zoomAccessToken);
              var responseZak = await getZak(zoomAccessToken, uid);
              LoadingDialog.hide(context);
              startMeeting(
                meetingId: classData.id.toString(),
                displayName: user?.name ?? "",
                zoomAccessToken: responseZak['token'],
              );
            }
          }
        } catch (e) {
          LoadingDialog.hide(context);
        }
      },
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Row(
          children: [
            SvgPicture.asset(
              Images.meeting,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 10),
            Text("Zoom link",
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 1,
                style: robotoRegular.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.6),
                    fontSize: Dimensions.fontSizeSmall)),
          ],
        ),
      ),
    );
  }

  Widget curriculumItem(BuildContext context, ClassroomController controller,
      Section section, int courseID) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color:
              Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),
          width: 1,
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius:
            const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        title: Text(
          section.title ?? '',
          style: robotoMedium.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: Dimensions.fontSizeDefault),
        ),
        children: [
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color:
                Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: section.lessons != null || section.quizes != null
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: section.lessons?.length == null
                        ? 0
                        : (section.lessons!.length + section.quizes!.length),
                    itemBuilder: (context, index) {
                      return quizButton(
                          section.quizes![index - section.lessons!.length]);
                    },
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget quizButton(Quiz quiz) => CustomButton(
      onPressed: () {
        // return Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => QuizDetailScreen(quiz: quiz),
        // ));
      },
      height: 25,
      buttonText: "Quiz");

  Widget _item(
    BuildContext context,
    LessonScorm scorm,
    String urlScorm,
  ) {
    return InkWell(
      onTap: () async {
        goToScorm(scorm, urlScorm);
      },
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              Images.document,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor, BlendMode.srcIn),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 120,
              child: Text("Scorm",
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 1,
                  style: robotoRegular.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.6),
                      fontSize: Dimensions.fontSizeSmall)),
            ),
            Text("Free",
                style: robotoMedium.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: Dimensions.fontSizeExtraSmall)),
          ],
        ),
      ),
    );
  }

  Widget _itemH5p(
    BuildContext context,
    String url,
  ) {
    return InkWell(
      onTap: () async {
        goToH5pVideo(url);
      },
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              Images.document,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor, BlendMode.srcIn),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 120,
              child: Text("File h5p",
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 1,
                  style: robotoRegular.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.6),
                      fontSize: Dimensions.fontSizeSmall)),
            ),
            Text("Free",
                style: robotoMedium.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: Dimensions.fontSizeExtraSmall)),
          ],
        ),
      ),
    );
  }
}
