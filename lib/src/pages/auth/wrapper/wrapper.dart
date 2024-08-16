// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/auth/login/login_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation/navigation.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/utils/multitenant-config.dart';
import 'package:video_player/video_player.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    final orderActive = Provider.of<OrderProvider>(context);
    if (user == null) {
      return LoginPage();
    } else {
      if (orderActive.orderActive == false) {
        objectBox.delelteAllShoppingCart();
      }

      return StreamProvider<CurrentUserInfo?>.value(
        value: usersCollection.doc(user.uid).snapshots().map(
              AuthService().userDataFromsnapshot,
            ),
        initialData: CurrentUserInfo(
          name: '',
          dni: '',
          zone: '',
          zoneDocument: '',
          email: '',
          role: '',
          uid: '',
        ),
        catchError: (context, error) {
          print(error);
          return;
        },
        // builder: (context, child) {

        //   return NavigationPages();
        // });
        child: LifecycleWatcher(),
      );
    }
  }
}

class LifecycleWatcher extends StatefulWidget {
  const LifecycleWatcher({super.key});

  @override
  State<LifecycleWatcher> createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher>
    with WidgetsBindingObserver {
  Timer? _inactivityTimer;
  bool showVideo = false;
  VideoPlayerController? _videoController;
  String? _videoUrl;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(minutes: 1), () {
      setState(() {
        _fetchVideoLink();
      });
    });
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startInactivityTimer();
    } else if (state == AppLifecycleState.paused) {
      _cancelInactivityTimer();
    }
  }

  void _initializeVideoPlayer(String url) {
    _videoController = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {});
        if (showVideo) {
          _videoController!.play();
        }
      });
  }

  void _startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(minutes: 2), () {
      setState(() {
        showVideo = true;
        _videoController?.play();
      });
    });
  }

  void _cancelInactivityTimer() {
    if (_inactivityTimer?.isActive ?? false) {
      _inactivityTimer!.cancel();
    }
    setState(() {
      showVideo = false;
      _videoController?.pause();
    });
  }

  void _resetInactivityTimer() {
    _startInactivityTimer();
    setState(() {
      showVideo = false;
      _videoController?.pause();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _resetInactivityTimer,
      onPanUpdate: (_) => _resetInactivityTimer(),
      child: Stack(
        children: [
          NavigationPages(),
          if (_videoController != null &&
              _videoController!.value.isInitialized &&
              showVideo)
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            ),
        ],
      ),
    );
  }
}
