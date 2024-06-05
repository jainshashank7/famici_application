part of 'add_album_bloc.dart';

abstract class AddAlbumEvent extends Equatable {
  const AddAlbumEvent();

  @override
  List<Object> get props => [];
}

class ShowSelectPhotos extends AddAlbumEvent {}

class SaveEditedAlbumTitle extends AddAlbumEvent {
  final Album selectedAlbum;
  const SaveEditedAlbumTitle(this.selectedAlbum);
}

class ShowAddAlbumTitle extends AddAlbumEvent {}

class ValidateAlbumTitle extends AddAlbumEvent {
  final String title;

  const ValidateAlbumTitle(this.title);
}

class ToggleSelectedStatusAlbumMemories extends AddAlbumEvent {
  final FamilyMemory memory;

  const ToggleSelectedStatusAlbumMemories(this.memory);
}

class FetchSelectedMediaFromCreateOption extends AddAlbumEvent {
  final List<FamilyMemory> selectedMemories;

  const FetchSelectedMediaFromCreateOption(this.selectedMemories);
}

class SaveAlbum extends AddAlbumEvent {}
