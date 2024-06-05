import 'package:bloc/bloc.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:famici/core/blocs/auth_bloc/auth_bloc.dart';
import 'package:famici/core/enitity/user.dart';
import 'package:famici/feature/memories/entities/album.dart';
import 'package:famici/feature/memories/entities/family_memory.dart';
import 'package:famici/repositories/memories_repository.dart';
import 'package:famici/utils/constants/enums.dart';

part 'album_event.dart';
part 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  AlbumBloc({
    required User me,
  })  : _me = me,
        super(AlbumState.initial()) {
    on<FetchInitialAlbums>(_onFetchInitialAlbums);
    on<FetchMoreAlbums>(_onFetchMoreAlbums);
    on<SyncSelectedAlbum>(_onSyncSelectedAlbum);
    on<FetchSelectedAlbumMedia>(_onFetchSelectedAlbumMedia);
    on<FetchSelectedAlbumMoreMedia>(_onFetchSelectedAlbumMoreMedia);
    on<ShowNextAlbumMemory>(_onShowNextAlbumMemory);
    on<ShowPreviousAlbumMemory>(_onShowPreviousAlbumMemory);
    on<ResetCurrentShowingAlbumMemory>(_onResetCurrentShowingAlbumMemory);
    on<SyncAlbumMemoryToShow>(_onSyncAlbumMemoryToShow);
    on<ToggleSelectAlbumForOptions>(_onToggleSelectAlbumForOptions);
    on<CancelAlbumToOptions>(_onCancelAlbumToOptions);
    on<AlbumSelected>(_onAlbumSelectedToggled);
    on<DeleteAlbum>(_onDeleteAlbum);
  }

  final MemoriesRepository _memoriesRepository = MemoriesRepository();
  User? _me;

  Future<void> _onFetchInitialAlbums(
    FetchInitialAlbums event,
    Emitter emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    List<Album>? _albums =
        await _memoriesRepository.fetchAlbums(familyId: _me?.familyId ?? "");
    emit(state.copyWith(albums: _albums, status: Status.success));
  }

  Future<void> _onFetchMoreAlbums(
    FetchMoreAlbums event,
    Emitter emit,
  ) async {
    List<Album> _existing = state.albums;
    List<Album> _fetchedAlbums = [
      Album(albumId: UniqueKey().toString(), title: "The Garden"),
      Album(albumId: UniqueKey().toString(), title: "Cookies"),
      Album(albumId: UniqueKey().toString(), title: "Beach Day"),
    ];

    _existing.addAll(_fetchedAlbums);
    emit(state.copyWith(albums: _existing));
  }

  Future<void> _onSyncSelectedAlbum(
    SyncSelectedAlbum event,
    Emitter emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    Album? getAlbum =
        await _memoriesRepository.getAlbum(albumId: event.album.albumId ?? "");
    emit(state.copyWith(selectedAlbum: getAlbum, status: Status.success));
  }

  Future<void> _onFetchSelectedAlbumMedia(
    FetchSelectedAlbumMedia event,
    Emitter emit,
  ) async {
    Album _selected = state.selectedAlbum;

    emit(state.copyWith(selectedAlbum: _selected));
  }

  Future<void> _onFetchSelectedAlbumMoreMedia(
    FetchSelectedAlbumMoreMedia event,
    Emitter emit,
  ) async {
    Album _selected = state.selectedAlbum;
    List<FamilyMemory> _existingMemories = _selected.memories;
    List<FamilyMemory> _fetched = [];
    _existingMemories.addAll(_fetched);
    Album _memoriesFetched = _selected.copyWith(memories: _existingMemories);
    emit(state.copyWith(selectedAlbum: _memoriesFetched));
  }

  Future<void> _onShowNextAlbumMemory(
    ShowNextAlbumMemory event,
    Emitter emit,
  ) async {
    int current = state.currentMemory;
    List<FamilyMemory> memories = state.selectedAlbum.memories;

    if (memories.length - 1 > current) {
      current = current + 1;
      emit(state.copyWith(currentMemory: current));
    }
  }

  Future<void> _onShowPreviousAlbumMemory(
    ShowPreviousAlbumMemory event,
    Emitter emit,
  ) async {
    int current = state.currentMemory;

    if (current > 0) {
      current = current - 1;
      emit(state.copyWith(currentMemory: current));
    }
  }

  Future<void> _onResetCurrentShowingAlbumMemory(
    ResetCurrentShowingAlbumMemory event,
    Emitter emit,
  ) async {}

  Future<void> _onSyncAlbumMemoryToShow(
    SyncAlbumMemoryToShow event,
    Emitter emit,
  ) async {
    emit(state.copyWith(currentMemory: event.index));
  }

  void _onToggleSelectAlbumForOptions(
    ToggleSelectAlbumForOptions event,
    Emitter emit,
  ) {
    bool isSelecting = state.selectingAlbumForOptions;
    List<Album> _selected = List.from(state.albums);
    if (!isSelecting) {
      _selected = List<Album>.from(state.albums).map((album) {
        return album.copyWith(isSelected: false);
      }).toList();
    }
    emit(state.copyWith(
      selectingAlbumForOptions: !isSelecting,
      albums: _selected,
    ));
  }

  void _onCancelAlbumToOptions(
    CancelAlbumToOptions event,
    Emitter emit,
  ) {
    bool isSelecting = state.selectingAlbumForOptions;
    List<Album> _selected = List.from(state.albums);
    if (!isSelecting) {
      _selected = List<Album>.from(state.albums).map((album) {
        return album.copyWith(isSelected: false);
      }).toList();
    }
    emit(state.copyWith(selectingAlbumForOptions: false, albums: _selected));
  }

  void _onAlbumSelectedToggled(
    AlbumSelected event,
    Emitter emit,
  ) {
    List<Album> _albums = List.from(state.albums);
    List<Album> _selected = _albums.map((album) {
      if (album.albumId == event.album.albumId) {
        return album.copyWith(isSelected: !album.isSelected);
      }
      return album.copyWith(isSelected: false);
      //return album.copyWith(isSelected: !album.isSelected);;
    }).toList();
    emit(state.copyWith(albums: _selected, selectedAlbum: event.album));
  }

  void _onDeleteAlbum(DeleteAlbum event, Emitter emit) async {
    try {
      emit(state.copyWith(status: Status.initial));
      emit(state.copyWith(status: Status.loading));
      List<Album> _existingAlbums = List.from(state.albums);

      String? selectedAlbumId;
      _existingAlbums.map((album) {
        if (album.isSelected) {
          selectedAlbumId = album.albumId;
        }
      }).toList();

      bool deleteSuccess =
          await _memoriesRepository.deleteAlbum(selectedAlbumId, _me?.id ?? "");
      if (deleteSuccess) {
        _existingAlbums.removeWhere((element) => element.isSelected);
        emit(state.copyWith(
          albums: _existingAlbums,
          status: Status.success,
        ));
      } else {
        emit(state.copyWith(status: Status.failure));
      }
    } catch (er) {
      DebugLogger.error("${er.toString()}");
    }
  }
}
