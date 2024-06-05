part of 'album_bloc.dart';

abstract class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object> get props => [];
}

class FetchInitialAlbums extends AlbumEvent {}

class FetchMoreAlbums extends AlbumEvent {}

class SyncSelectedAlbum extends AlbumEvent {
  final Album album;

  const SyncSelectedAlbum(this.album);
}

class FetchSelectedAlbumMedia extends AlbumEvent {}

class FetchSelectedAlbumMoreMedia extends AlbumEvent {}

class ShowNextAlbumMemory extends AlbumEvent {}

class ShowPreviousAlbumMemory extends AlbumEvent {}

class SyncAlbumMemoryToShow extends AlbumEvent {
  final int index;

  const SyncAlbumMemoryToShow(this.index);
}

class ResetCurrentShowingAlbumMemory extends AlbumEvent {}

class ToggleSelectAlbumForOptions extends AlbumEvent {
  @override
  String toString() {
    return "ToggleSelectAlbumToOptions";
  }
}
class CancelAlbumToOptions extends AlbumEvent {
  const CancelAlbumToOptions();
  @override
  String toString() {
    return "CancelMediaToShare";
  }
}
class AlbumSelected extends AlbumEvent {
  final Album album;

  const AlbumSelected(this.album);
  @override
  String toString() {
    return "AlbumSelected";
  }
}
class DeleteAlbum extends AlbumEvent {

  const DeleteAlbum();
  @override
  String toString() {
    return "DeleteAlbum";
  }
}

