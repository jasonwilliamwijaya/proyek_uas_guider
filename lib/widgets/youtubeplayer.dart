// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, TODO

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:proyek_uas_guider/widgets/ytfullscreen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YtPlayer extends StatefulWidget {
  final String Youtube_link;
  final Duration currPos;
  const YtPlayer({Key? key, required this.Youtube_link, required this.currPos})
      : super(key: key);

  @override
  State<YtPlayer> createState() => _YtPlayerState();
}

bool check = false;

class _YtPlayerState extends State<YtPlayer> {
  late YoutubePlayerController _youtubePlayerController;

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _youtubePlayerController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _youtubePlayerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.Youtube_link)!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: true,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
    _youtubePlayerController.seekTo(widget.currPos, allowSeekAhead: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Stack(
          children: [
            YoutubePlayer(
              aspectRatio: 16 / 9,
              bottomActions: [
                CurrentPosition(
                  controller: _youtubePlayerController,
                ),
                ProgressBar(
                  controller: _youtubePlayerController,
                  isExpanded: true,
                ),
                RemainingDuration(
                  controller: _youtubePlayerController,
                ),
                PlaybackSpeedButton(
                  controller: _youtubePlayerController,
                ),
              ],
              controller: _youtubePlayerController,
            ),
            Positioned(
              right: 10,
              top: 10,
              child: GestureDetector(
                onTap: () {
                  if (!check) {
                    check = true;
                    SystemChrome.setEnabledSystemUIMode(
                        SystemUiMode.immersiveSticky);
                    SystemChrome.setPreferredOrientations(
                      [
                        DeviceOrientation.landscapeLeft,
                        DeviceOrientation.landscapeRight
                      ],
                    );

                    deactivate();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => YtFullScreen(
                          ytLink: widget.Youtube_link,
                          currPos: _youtubePlayerController.value.position,
                        ),
                      ),
                    );
                  } else {
                    check = false;
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                        overlays: SystemUiOverlay.values);
                    SystemChrome.setPreferredOrientations(
                      [
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.portraitDown
                      ],
                    );

                    Navigator.pop(context);
                  }
                },
                child: Icon(
                  !check ? LineIcons.expand : LineIcons.expand,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}