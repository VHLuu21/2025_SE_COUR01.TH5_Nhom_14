import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class TrailerScreen extends StatefulWidget {
  final String youtubeKey;
  const TrailerScreen({super.key, required this.youtubeKey});

  @override
  State<TrailerScreen> createState() => _TrailerScreenState();
}

class _TrailerScreenState extends State<TrailerScreen> {
  late YoutubePlayerController _controller;

  // Khởi tạo YoutubePlayerController để phát video từ ytb
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.youtubeKey,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        enableCaption: true,
      ),
    );
  }

  // Đóng tài nguyên
  @override
  void dispose() {
    _controller.close();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(title: const Text("Trailer")),
      body: SafeArea(
        child: YoutubePlayerScaffold(
          controller: _controller,
          builder: (context, player) {
            return Center(
              child: Container(
                color: Colors.black,
                width: double.infinity,
                child: player,
              ),
            );
          },
        ),
      ),
    );
  }
}
