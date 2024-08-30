import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:pwa_sales2go_flutter/src/utils/multitenant-config.dart';

class PromoVideoPlayer extends StatefulWidget {
  const PromoVideoPlayer({Key? key}) : super(key: key);

  @override
  _PromoVideoPlayerState createState() => _PromoVideoPlayerState();
}

class _PromoVideoPlayerState extends State<PromoVideoPlayer> {
  VideoPlayerController? _videoController;
  String? _videoUrl;

  @override
  void initState() {
    super.initState();
    _fetchVideoLink();
  }

  Future<void> _fetchVideoLink() async {
    // Get the video URL from Firebase Storage
    int videoNumber = globalRemoteConfig.promoVideoNumber!;
    print('promo_vids/$videoNumber.mp4');
    final videoRef =
        FirebaseStorage.instanceFor(app: multitenantConfig.tenantApp!)
            .ref('promo_vids/$videoNumber.mp4');
    _videoUrl = await videoRef.getDownloadURL();
    print(_videoUrl);

    // Initialize the video player with the fetched URL
    _initializeVideoPlayer(_videoUrl!);
  }

  void _initializeVideoPlayer(String url) {
    print('init video player');

    _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        setState(() {});

        if (globalRemoteConfig.promoVideoDisponible!) {
          _videoController!.play();
        }

        // Add listener to restart the video when it finishes
        _videoController!.addListener(() {
          if (_videoController!.value.position >=
              _videoController!.value.duration) {
            _videoController!.seekTo(Duration.zero);
            _videoController!.play();
          }
        });
      });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: _videoController != null && _videoController!.value.isInitialized
            ? Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                ),
              )
            : Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: globalRemoteConfig.promoVideoDisponible!
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Video no disponible",
                          style: TextStyle(color: Colors.black),
                        ),
                ),
              ),
      ),
    );
  }
}
