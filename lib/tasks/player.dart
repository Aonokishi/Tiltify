import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:id3/id3.dart';

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerState();
  }
}

class _PlayerState extends State<Player> {
  final AssetsAudioPlayer player = AssetsAudioPlayer();
  List<FileSystemEntity>? songs;

  @override
  void initState() {
    super.initState();
    songs = listSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Player")),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    if (songs == null) {
      return const CircularProgressIndicator();
    }

    return ListView.separated(
      itemCount: songs!.length,
      itemBuilder: (context, index) {
        String songPath = songs![index].path;

        List<int> mp3Bytes = File(songPath).readAsBytesSync();
        MP3Instance mp3instance = new MP3Instance(mp3Bytes);
        mp3instance.parseTagsSync();
        var metadata = mp3instance.getMetaTags();

        Audio song = Audio.file(
          songPath,
          metas: Metas(
            title: metadata?["Title"],
            artist: metadata?["Artist"],
            album: metadata?["Album"],
          ),
        );

        String fallbackName = song.path.split("/").last;

        return ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.music_note),
          ),
          title: Text(song.metas.title ?? fallbackName),
          subtitle: Text(song.metas.artist ?? "Unknown"),
          onTap: () {
            playAudio(song);
          },
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }

  List<FileSystemEntity> listSongs() {
    Directory dir = Directory('/storage/emulated/0/Music');
    List<FileSystemEntity> files =
        dir.listSync(recursive: true, followLinks: false);
    List<FileSystemEntity> songs = [];

    for (FileSystemEntity file in files) {
      if (file.path.toLowerCase().endsWith('.mp3')) {
        songs.add(file);
      }
    }

    return songs;
  }

  void playAudio(Audio audio) async {
    await player.open(
      audio,
      autoStart: true,
      showNotification: true,
    );
  }
}
