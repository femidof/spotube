import 'package:spotify/spotify.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/extensions/track.dart';

class CurrentPlaylist {
  List<Track>? _tempTrack;
  List<Track> tracks;
  String id;
  String name;
  String thumbnail;
  bool isLocal;

  CurrentPlaylist({
    required this.tracks,
    required this.id,
    required this.name,
    required this.thumbnail,
    this.isLocal = false,
  });

  static CurrentPlaylist fromJson(Map<String, dynamic> map) {
    return CurrentPlaylist(
      id: map["id"],
      tracks: List.castFrom<dynamic, Track>(map["tracks"]
          .map(
            (track) => map["isLocal"] == true
                ? SpotubeTrack.fromJson(track)
                : Track.fromJson(track),
          )
          .toList()),
      name: map["name"],
      thumbnail: map["thumbnail"],
      isLocal: map["isLocal"],
    );
  }

  List<String> get trackIds => tracks.map((e) => e.id!).toList();

  bool shuffle(Track? topTrack) {
    // won't shuffle if already shuffled
    if (_tempTrack == null) {
      _tempTrack = [...tracks];
      tracks.shuffle();
      if (topTrack != null) {
        tracks.remove(topTrack);
        tracks.insert(0, topTrack);
      }
      return true;
    }
    return false;
  }

  bool unshuffle() {
    // without _tempTracks unshuffling can't be done
    if (_tempTrack != null) {
      tracks = [..._tempTrack!];
      _tempTrack = null;
      return true;
    }
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "tracks": tracks
          .map((track) =>
              track is SpotubeTrack ? track.toJson() : track.toJson())
          .toList(),
      "thumbnail": thumbnail,
      "isLocal": isLocal,
    };
  }
}
