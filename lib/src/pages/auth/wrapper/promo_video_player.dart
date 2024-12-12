import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
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
    final orderActive = Provider.of<OrderProvider>(context, listen: false);
    if (orderActive.orderActive!) {
      Navigator.pop(context);
    } else {
      _fetchVideoLink();
    }
  }

  Future<void> _fetchVideoLink() async {
    try {
      int videoNumber = globalRemoteConfig.promoVideoNumber!;
      final videoRef =
          FirebaseStorage.instanceFor(app: multitenantConfig.tenantApp!)
              .ref('promo_vids/$videoNumber.mp4');
      _videoUrl = await videoRef.getDownloadURL();

      final file = await DefaultCacheManager().getSingleFile(_videoUrl!);

      _initializeVideoPlayer(file.path);
    } catch (e) {
      print('Error fetching or caching video: $e');
      setState(() {
        _videoUrl = null;
      });
    }
  }

  void _initializeVideoPlayer(String filePath) {
    try {
      _videoController = VideoPlayerController.file(File(filePath))
        ..initialize().then((_) {
          setState(() {});

          if (globalRemoteConfig.promoVideoDisponible!) {
            _videoController!.play();
          }

          _videoController!.addListener(() {
            if (_videoController!.value.position >=
                _videoController!.value.duration) {
              _videoController!.seekTo(Duration.zero);
              _videoController!.play();
            }
          });
        }).catchError((e) {
          print('Error initializing video player: $e');
        });
    } catch (e) {
      print('Error setting up video player: $e');
    }
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
