import 'dart:io';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:esense_flutter/esense.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:id3/id3.dart';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';

enum HeadPositions {
  up,
  down,
  left,
  right,
  normal,
  upsideDown,
  unknown,
}

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerState();
  }
}

class _PlayerState extends State<Player> {
  final String _eSenseName = "eSense-0569";
  final AssetsAudioPlayer player = AssetsAudioPlayer();

  late final List<Audio> songs;

  @override
  void initState() {
    super.initState();
    _connectToESense();
    songs = listSongs();
    player.open(
      Playlist(audios: songs),
      loopMode: LoopMode.playlist,
      showNotification: true,
      autoStart: false,
    );
    sensorControl();
  }

  Future<void> _connectToESense() async {
    await ESenseManager().disconnect();
    bool hasSuccessfulConnected = await ESenseManager().connect(_eSenseName);
    if (hasSuccessfulConnected) {
      print("hasSuccessfulConneted: $hasSuccessfulConnected");
    }
  }

  void sensorControl() async {
    ESenseManager().connectionEvents.listen((event) {
      if (event.type == ConnectionType.connected) {
        final stream = ESenseManager()
            .sensorEvents
            .throttleTime(
              const Duration(seconds: 2),
              trailing: false,
              leading: true,
            )
            .map(mapToHeadPosition);

        final stream2 = stream.bufferCount(1, 1);

        stream2.where(detectRewind).listen((_) {
          debugPrint("REWIND TIME");
          player.previous();
          notify();
        });

        stream2.where(detectSkip).listen((_) {
          debugPrint("SKIP TIME");
          var rng = Random().nextInt(songs.length - 1);
          player.playlistPlayAtIndex(rng);
          notify();
        });

        stream2.where(detectVolumeUp).listen((_) {
          debugPrint("VOL UP TIME");
          player.setVolume(min(player.volume.value + 0.1, 1));
        });

        stream2.where(detectVolumeDown).listen((_) {
          debugPrint("VOL DOWN TIME");
          player.setVolume(max(player.volume.value - 0.1, 0));
        });

        stream2.where(detectStartStop).listen((_) {
          debugPrint("START/STOP TIME");
          player.playOrPause();
          notify();
        });
      }
    });
  }

  HeadPositions mapToHeadPosition(SensorEvent event) {
    if (event.accel == null) {
      return HeadPositions.unknown;
    }

    int x = event.accel![0];
    int y = event.accel![1];
    int z = event.accel![2];

    if (x.abs() > max(y.abs(), z.abs())) {
      return x.isNegative ? HeadPositions.normal : HeadPositions.upsideDown;
    } else if (y.abs() > z.abs()) {
      return y.isNegative ? HeadPositions.up : HeadPositions.down;
    } else {
      return z.isNegative ? HeadPositions.left : HeadPositions.right;
    }
  }

  bool detectRewind(List<HeadPositions> lastThreeHeadPositions) {
    const List<HeadPositions> rewindGesture = [
      HeadPositions.left,
    ];
    return const IterableEquality<HeadPositions>()
        .equals(lastThreeHeadPositions, rewindGesture);
  }

  bool detectSkip(List<HeadPositions> lastThreeHeadPositions) {
    const List<HeadPositions> rewindGesture = [
      HeadPositions.right,
    ];
    return const IterableEquality<HeadPositions>()
        .equals(lastThreeHeadPositions, rewindGesture);
  }

  bool detectVolumeUp(List<HeadPositions> lastThreeHeadPositions) {
    const List<HeadPositions> rewindGesture = [
      HeadPositions.up,
    ];
    return const IterableEquality<HeadPositions>()
        .equals(lastThreeHeadPositions, rewindGesture);
  }

  bool detectVolumeDown(List<HeadPositions> lastThreeHeadPositions) {
    const List<HeadPositions> rewindGesture = [
      HeadPositions.down,
    ];
    return const IterableEquality<HeadPositions>()
        .equals(lastThreeHeadPositions, rewindGesture);
  }

  bool detectStartStop(List<HeadPositions> lastThreeHeadPositions) {
    const List<HeadPositions> rewindGesture = [
      HeadPositions.upsideDown,
    ];
    return const IterableEquality<HeadPositions>()
        .equals(lastThreeHeadPositions, rewindGesture);
  }

  void notify() {
    AssetsAudioPlayer.newPlayer().open(
      Audio("assets/blubb.mp3"),
      autoStart: true,
      showNotification: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Player")),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView.separated(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        String fallbackName = song.path.split("/").last;

        return ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.music_note),
          ),
          title: Text(song.metas.title ?? fallbackName),
          subtitle: Text(song.metas.artist ?? "Unknown"),
          onTap: () {
            player.playlistPlayAtIndex(index);
          },
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }

  List<Audio> listSongs() {
    Directory dir = Directory('/storage/emulated/0/Music');
    List<FileSystemEntity> files =
        dir.listSync(recursive: true, followLinks: false);
    List<Audio> songs = [];

    for (FileSystemEntity file in files) {
      if (file.path.toLowerCase().endsWith('.mp3')) {
        List<int> mp3Bytes = File(file.path).readAsBytesSync();
        MP3Instance mp3instance = MP3Instance(mp3Bytes);
        mp3instance.parseTagsSync();
        var metadata = mp3instance.getMetaTags();

        //Image picture = createPicture(metadata!.values.toString().split("base64: ").last);

        Audio song = Audio.file(
          file.path,
          metas: Metas(
            title: metadata?["Title"],
            artist: metadata?["Artist"],
            album: metadata?["Album"],
          ),
        );
        songs.add(song);
      }
    }

    return songs;
  }

  Image createPicture(String base64String) {
    return Image.memory((base64Decode(base64String)));
  }
}
