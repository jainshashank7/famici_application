part of 'album_bloc.dart';

class AlbumState extends Equatable {
  const AlbumState({
    required this.status,
    required this.albums,
    required this.selectedAlbum,
    required this.selectingAlbumForOptions,
    required this.currentMemory,
  });

  final Status status;
  final List<Album> albums;
  final Album selectedAlbum;
  final bool selectingAlbumForOptions;
  final int currentMemory;

  factory AlbumState.initial() {
    return AlbumState(
      status: Status.initial,
      albums: [],
      selectedAlbum: Album(),
      selectingAlbumForOptions:false,
      currentMemory: 0,
    );
  }

  AlbumState copyWith({
    Status? status,
    List<Album>? albums,
    Album? selectedAlbum,
    bool? selectingAlbumForOptions,
    int? currentMemory,
  }) {
    return AlbumState(
      status: status ?? this.status,
      albums: albums ?? this.albums,
      selectedAlbum: selectedAlbum ?? this.selectedAlbum,
      selectingAlbumForOptions:selectingAlbumForOptions??this.selectingAlbumForOptions,
      currentMemory: currentMemory ?? this.currentMemory,
    );
  }

  @override
  List<Object> get props => [
        status,
        albums,
        selectedAlbum,
    selectingAlbumForOptions,
        currentMemory,
      ];
  @override
  String toString() {
    return ''' AlbumState : {
      albums          : ${albums.length},
      selectedAlbum   : ${selectedAlbum.albumId}
      selectingAlbumForOptions : ${selectingAlbumForOptions.toString()}
      status          : ${status.toString()}
      currentMemory   : ${currentMemory.toString()}
    }''';
  }
}
