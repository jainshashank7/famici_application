part of 'add_album_bloc.dart';

enum AddAlbumStatus {
  initial,
  selectingPhotos,
  submitting,
  loading,
  failure,
  success
}

class AddAlbumState extends Equatable {
  const AddAlbumState({
    required this.title,
    required this.status,
    required this.selectedMedia,
    required this.album,
  });

  final AlbumTitleInput title;
  final AddAlbumStatus status;
  final List<FamilyMemory> selectedMedia;
  final Album album;

  factory AddAlbumState.initial({Album? album}) {
    return AddAlbumState(
      title: album != null
          ? AlbumTitleInput.dirty(value: album.title ?? '')
          : AlbumTitleInput.pure(),
      status: AddAlbumStatus.initial,
      selectedMedia: [],
      album: album ?? Album(),
    );
  }

  AddAlbumState copyWith({
    AlbumTitleInput? title,
    AddAlbumStatus? status,
    List<FamilyMemory>? selectedMedia,
    Album? album,
  }) {
    return AddAlbumState(
      title: title ?? this.title,
      status: status ?? this.status,
      selectedMedia: selectedMedia ?? this.selectedMedia,
      album: album ?? this.album,
    );
  }

  @override
  List<Object> get props => [title, status, selectedMedia, album];
}
