import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:famici/core/blocs/auth_bloc/auth_bloc.dart';
import 'package:famici/core/enitity/user.dart';
import 'package:famici/feature/memories/entities/barrel.dart';
import 'package:famici/feature/memories/models/album_title_input.dart';
import 'package:famici/repositories/barrel.dart';

part 'add_album_event.dart';
part 'add_album_state.dart';

class AddAlbumBloc extends Bloc<AddAlbumEvent, AddAlbumState> {
  AddAlbumBloc({
    required User me,
    Album? album,
  })  : _me = me,
        super(AddAlbumState.initial(album: album)) {
    on<ShowSelectPhotos>(_mapShowSelectPhotos);
    on<ShowAddAlbumTitle>(_mapShowAddAlbumTitle);
    on<ValidateAlbumTitle>(_mapValidateAlbumTitle);
    on<ToggleSelectedStatusAlbumMemories>(
        _mapToggleSelectedStatusAlbumMemories);
    on<SaveAlbum>(_mapSaveAlbum);
    on<SaveEditedAlbumTitle>(_onSaveEditedAlbumTitle);
    on<FetchSelectedMediaFromCreateOption>(
        _onFetchSelectedMediaFromCreateOption);
  }

  final MemoriesRepository _memoRepo = MemoriesRepository();
  User? _me;

  void _mapShowSelectPhotos(ShowSelectPhotos event, emit) {
    if (state.title.pure || state.title.invalid) {
      add(ValidateAlbumTitle(state.title.value));
    } else {
      emit(state.copyWith(status: AddAlbumStatus.selectingPhotos));
    }
  }

  Future<void> _onSaveEditedAlbumTitle(SaveEditedAlbumTitle event, emit) async {
    if (state.title.pure || state.title.invalid) {
      add(ValidateAlbumTitle(state.title.value));
    } else {
      emit(state.copyWith(status: AddAlbumStatus.loading));
      bool isEditedTitleSaved = await _memoRepo.saveEditedAlbumTitle(
          title: state.title.value, albumId: event.selectedAlbum.albumId ?? "");
      if (isEditedTitleSaved) {
        emit(state.copyWith(status: AddAlbumStatus.success));
      } else {
        emit(state.copyWith(status: AddAlbumStatus.failure));
      }
    }
  }

  void _mapShowAddAlbumTitle(ShowAddAlbumTitle event, emit) {
    emit(state.copyWith(status: AddAlbumStatus.initial));
  }

  void _mapValidateAlbumTitle(ValidateAlbumTitle event, emit) {
    emit(state.copyWith(title: AlbumTitleInput.dirty(value: event.title)));
  }

  void _mapToggleSelectedStatusAlbumMemories(
      ToggleSelectedStatusAlbumMemories event, emit) {
    List<FamilyMemory> _existingList = state.selectedMedia;
    int index = _existingList
        .indexWhere((media) => media.mediaId == event.memory.mediaId);
    if (index > -1) {
      _existingList.removeAt(index);
    } else {
      _existingList.add(event.memory);
    }
    emit(state.copyWith(selectedMedia: _existingList));
  }

  void _mapSaveAlbum(SaveAlbum event, emit) async {
    emit(state.copyWith(status: AddAlbumStatus.loading));
    List<String?> selectedIds = [];
    state.selectedMedia.map((media) {
      selectedIds.add(media.mediaId);
    }).toList();

    Album? savedAlbum = await _memoRepo.saveAlbum(
      title: state.title.value,
      familyId: _me?.familyId ?? "",
      mediaIds: selectedIds,
    );

    Album _createdAlbum = state.album.copyWith(
      albumId: savedAlbum?.albumId,
      title: state.title.value,
      memories: state.selectedMedia,
    );
    emit(state.copyWith(status: AddAlbumStatus.success, album: _createdAlbum));
  }

  void _onFetchSelectedMediaFromCreateOption(
      FetchSelectedMediaFromCreateOption event, emit) async {
    List<FamilyMemory> selectedMedia = [];

    for (FamilyMemory memory in event.selectedMemories) {
      if (memory.isSelected) {
        selectedMedia.add(memory);
      }
    }
    emit(state.copyWith(selectedMedia: selectedMedia));
  }
}
