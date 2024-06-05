import 'dart:io';

import 'package:amplify_api/amplify_api.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/core/enitity/memory.dart';
import 'package:famici/core/offline/local_database/user_photos_db.dart';
import 'package:famici/feature/memories/entities/barrel.dart';
import 'package:famici/repositories/barrel.dart';
import 'package:famici/repositories/memory_repository.dart';
import 'package:famici/shared/crop_rotate_image/crop_rotate_image.dart';
import 'package:famici/shared/fc_confirm_dialog.dart';
import 'package:famici/utils/barrel.dart';

import '../../../../core/router/router_delegate.dart';
import '../../../calander/widgets/error_message_popup.dart';
import '../album_bloc/album_bloc.dart';

part 'memories_event.dart';

part 'memories_state.dart';

class MemoriesBloc extends Bloc<MemoriesEvent, MemoriesState> {
  MemoriesBloc({
    required User me,
  })  : _me = me,
        super(MemoriesState.initial()) {
    on<UploadMultiImage>(_onUploadMultiImage);
    on<ToggleShowPhotos>(_onToggleShowPhotos);
    on<FetchInitialMemories>(_onFetchInitialMemories);
    // on<FetchInitialAlbums>(_onFetchInitialAlbums);
    on<FetchMoreMemories>(_onFetchMoreMemories);
    // on<FetchMoreAlbums>(_onFetchMoreAlbums);
    on<UploadImage>(_onUploadImage);
    on<ToggleSelectMediaToShare>(_onToggleSelectMediaToShare);
    on<SelectMemberToShareMedia>(_onSelectMemberToShareMedia);
    on<CancelMediaToShare>(_onCancelMediaToShare);
    on<MediaSelected>(_onMediaSelectedToggled);
    on<AllMediaSelected>(_onAllMediaSelected);
    on<AllMediaDisSelected>(_onAllMediaDisSelected);
    on<ToggleSelectedMemberToRequestMedia>(
        _onToggleSelectedMemberToRequestMedia);
    on<ResetSelectedMemberToRequestMedia>(_onResetSelectedMemberToRequestMedia);
    on<ResetSelectedMemberToShareMedia>(_onResetSelectedMemberToShareMedia);
    on<RequestMediaFromMember>(_onMediaRequested);
    on<ShareMediaWithMember>(_onShareMediaWithMember);
    on<ShowNextMemory>(_onShowNextMemory);
    on<ShowPreviousMemory>(_onShowPreviousMemory);
    on<EditPhotoMemory>(_onEditPhotoMemory);
    on<SyncMemoryToSlider>(_onSyncMemoryToSlider);
    on<ResetMemorySliderIndex>(_onResetMemorySliderIndex);
    on<FetchMemories>(_onGetMemories);
    on<DeleteMemories>(_onDeleteMemory);
    on<ShareMediaSuccess>(_onMediaShareSuccess);
    on<MoveMemories>(_onMoveMemory);
  }

  final MemoriesRepository _memoriesRepo = MemoriesRepository();
  User _me;
  final MemoryRepository _memoryRepository = MemoryRepository();

  void _onToggleShowPhotos(ToggleShowPhotos event, Emitter emit) {
    bool isShowingPhotos = state.showingPhotos;
    emit(state.copyWith(showingPhotos: !isShowingPhotos));
  }

  Future<bool> _isConnectedToInternet() async {
    return await ConnectivityWrapper.instance.isConnected;
  }

  void _onToggleSelectMediaToShare(
    ToggleSelectMediaToShare event,
    Emitter emit,
  ) {
    bool isSelecting = state.selectMediaToShare;
    List<FamilyMemory> _selected = state.media;
    if (!isSelecting) {
      _selected = state.media.map((media) {
        return media.copyWith(isSelected: false);
      }).toList();
    }
    emit(state.copyWith(selectMediaToShare: !isSelecting, media: _selected));
  }

  void _onCancelMediaToShare(
    CancelMediaToShare event,
    Emitter emit,
  ) {
    bool isSelecting = state.selectMediaToShare;
    List<FamilyMemory> _selected = state.media;
    if (!isSelecting) {
      _selected = state.media.map((media) {
        return media.copyWith(isSelected: false);
      }).toList();
    }
    emit(state.copyWith(selectMediaToShare: false, media: _selected));
  }

  void _onFetchInitialMemories(FetchInitialMemories event, Emitter emit) async {
    List<FamilyMemory> _images = await _memoriesRepo.fetchMemories();
    emit(state.copyWith(media: _images));
  }

  // void _onFetchInitialAlbums(FetchInitialAlbums event, Emitter emit) async {
  //   List<Album> albums = await _memoriesRepo.fetchAlbums();
  //   emit(state.copyWith(albums: albums));
  // }

  void _onFetchMoreMemories(FetchMoreMemories event, Emitter emit) async {
    List<FamilyMemory> _existingPhotos = state.media;
    List<FamilyMemory> _fetchedPhotos = await _memoriesRepo.fetchMemories(
      offset: _existingPhotos.length,
    );
    _existingPhotos.addAll(_fetchedPhotos);
    emit(state.copyWith(media: _existingPhotos));
  }

  // void _onFetchMoreAlbums(FetchMoreAlbums event, Emitter emit) async {
  //   List<Album> _existingAlbums = state.albums;
  //   List<Album> _fetchedAlbums = await _memoriesRepo.fetchAlbums(
  //     offset: _existingAlbums.length,
  //   );
  //   _existingAlbums.addAll(_fetchedAlbums);
  //   emit(state.copyWith(albums: _existingAlbums));
  // }

  void copyImage(String sourcePath, String destinationPath) async {
    File sourceFile = File(sourcePath);

    if (await sourceFile.exists()) {
      List<int> imageData = await sourceFile.readAsBytes();
      File destinationFile = File(destinationPath);
      await destinationFile.writeAsBytes(imageData);
    }
  }

  Future<void> _uploadImagesWhenUserOnline() async {
    final DatabaseHelperForMemories dbFactory = DatabaseHelperForMemories();
    List<String> _images = [];
    List<Map<String, dynamic>> rows =
        await dbFactory.readDataFromTableSendImage();

    for (Map<String, dynamic> row in rows) {
      _images.add(row["imagePath"]);
    }

    try {
      for (String imagePath in _images) {
        try {
          Memory? memory =
              await _memoryRepository.getMediaUploadURL(_me.familyId ?? "");
          await _memoryRepository.uploadPicture(
            imageUrl: imagePath,
            uploadUrl: memory?.metadata?.uploadUrl ?? '',
          );
          dbFactory.sendImageDeleteData(imagePath);
          dbFactory.storeImagePathsInsertData(
              imagePath, memory?.metadata?.mediaId, _me.id, _me.familyId);
        } catch (err) {
          DebugLogger.error(err);
        }
      }
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  Future<void> _deletePhotosWhenUserOnline() async {
    try {
      final DatabaseHelperForMemories dbFactory = DatabaseHelperForMemories();
      List<String> _images = [];
      List<Map<String, dynamic>> rows =
          await dbFactory.readDataFromTableDeleteImage();

      for (Map<String, dynamic> row in rows) {
        _images.add(row["mediaId"]);
      }

      try {
        await _memoryRepository.deleteMemory(_images, _me.id ?? "");
        for (String imagePath in _images) {
          try {
            dbFactory.deleteImageDeleteData(imagePath);
          } catch (err) {
            DebugLogger.error(err);
          }
        }
      } catch (err) {
        DebugLogger.error(err);
      }
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  void _onUploadMultiImage(UploadMultiImage event, Emitter emit) async {
    final DatabaseHelperForMemories dbFactory = DatabaseHelperForMemories();
    if (await _isConnectedToInternet()) {
      try {
        emit(state.copyWith(status: MemoriesStatus.initial));
        emit(state.copyWith(status: MemoriesStatus.loading));
        List<FamilyMemory> _existingPhoto = List.from(state.media);
        print(event.path);
        for (var image in event.path) {
          Memory? memory =
              await _memoryRepository.getMediaUploadURL(_me.familyId ?? "");

          await _memoryRepository.uploadPicture(
            imageUrl: image,
            uploadUrl: memory?.metadata?.uploadUrl ?? '',
          );

          try {
            var imageUrl = image;
            final directory = await getApplicationDocumentsDirectory();
            String fileName = imageUrl.split('/').last;
            final destinationPath = File('${directory.path}/$fileName');
            copyImage(imageUrl, destinationPath.path);

            await dbFactory.storeImagePathsInsertData(
                imageUrl, memory?.metadata?.mediaId, _me.id, _me.familyId);
          } catch (err) {
            DebugLogger.error(err);
          }

          FamilyMemory _newImage = FamilyMemory(
            mediaId: memory?.metadata?.mediaId,
            url: image,
            type: MemoryType.photo,
          );
          _existingPhoto.add(_newImage);
        }
        emit(state.copyWith(
          media: _existingPhoto,
          status: MemoriesStatus.success,
        ));

        emit(state.copyWith(status: MemoriesStatus.success));
      } catch (er) {
        DebugLogger.error("${er.toString()}");
      }
    } else {
      try {
        for (var image in event.path) {
          var imageUrl = image;
          final directory = await getApplicationDocumentsDirectory();
          String fileName = imageUrl.split('/').last;
          final destinationPath = File('${directory.path}/$fileName');
          copyImage(imageUrl, destinationPath.path);

          await dbFactory.sendImageInsertData(
              destinationPath.path, _me.familyId);

          List<FamilyMemory> _existingPhoto = List.from(state.media);

          FamilyMemory _newImage = FamilyMemory(
            mediaId: destinationPath.path,
            url: image,
            type: MemoryType.photo,
          );
          _existingPhoto.add(_newImage);
          emit(state.copyWith(
            media: _existingPhoto,
            status: MemoriesStatus.success,
          ));
        }

        emit(state.copyWith(status: MemoriesStatus.success));
        add(FetchMemories());
        AlbumBloc albumBloc = AlbumBloc(me: _me);
        albumBloc.add(FetchInitialAlbums());
      } catch (err) {
        DebugLogger.error(err);
      }
    }
  }

  void _onUploadImage(UploadImage event, Emitter emit) async {
    final DatabaseHelperForMemories dbFactory = DatabaseHelperForMemories();
    if (await _isConnectedToInternet()) {
      try {
        emit(state.copyWith(status: MemoriesStatus.initial));
        emit(state.copyWith(status: MemoriesStatus.loading));
        List<FamilyMemory> _existingPhoto = List.from(state.media);

        Memory? memory =
            await _memoryRepository.getMediaUploadURL(_me.familyId ?? "");

        await _memoryRepository.uploadPicture(
          imageUrl: event.path,
          uploadUrl: memory?.metadata?.uploadUrl ?? '',
        );

        try {
          var imageUrl = event.path;
          final directory = await getApplicationDocumentsDirectory();
          String fileName = imageUrl.split('/').last;
          final destinationPath = File('${directory.path}/$fileName');
          copyImage(imageUrl, destinationPath.path);

          await dbFactory.storeImagePathsInsertData(
              imageUrl, memory?.metadata?.mediaId, _me.id, _me.familyId);
        } catch (err) {
          DebugLogger.error(err);
        }

        FamilyMemory _newImage = FamilyMemory(
          mediaId: memory?.metadata?.mediaId,
          url: event.path,
          type: MemoryType.photo,
        );
        _existingPhoto.add(_newImage);
        emit(state.copyWith(
          media: _existingPhoto,
          status: MemoriesStatus.success,
        ));

        emit(state.copyWith(status: MemoriesStatus.success));
      } catch (er) {
        DebugLogger.error("${er.toString()}");
      }
    } else {
      try {
        var imageUrl = event.path;
        final directory = await getApplicationDocumentsDirectory();
        String fileName = imageUrl.split('/').last;
        final destinationPath = File('${directory.path}/$fileName');
        copyImage(imageUrl, destinationPath.path);

        await dbFactory.sendImageInsertData(destinationPath.path, _me.familyId);

        List<FamilyMemory> _existingPhoto = List.from(state.media);

        FamilyMemory _newImage = FamilyMemory(
          mediaId: destinationPath.path,
          url: event.path,
          type: MemoryType.photo,
        );
        _existingPhoto.add(_newImage);
        emit(state.copyWith(
          media: _existingPhoto,
          status: MemoriesStatus.success,
        ));

        emit(state.copyWith(status: MemoriesStatus.success));
        add(FetchMemories());
        AlbumBloc albumBloc = AlbumBloc(me: _me);
        albumBloc.add(FetchInitialAlbums());
      } catch (err) {
        DebugLogger.error(err);
      }
    }
  }

  _storePhotosWhenUserOnline(List<FamilyMemory> memories) async {
    final DatabaseHelperForMemories dbFactory = DatabaseHelperForMemories();
    for (var element in memories) {
      try {
        if (await dbFactory.checkMediaIdExists(element.mediaId)) {
          var imageUrl = element.url;
          final directory = await getApplicationDocumentsDirectory();
          String? fileName = imageUrl?.split('/').last;
          final destinationPath = File('${directory.path}/$fileName');
          copyImage(imageUrl!, destinationPath.path);

          await dbFactory.storeImagePathsInsertData(
              imageUrl, element.mediaId, _me.id, _me.familyId);
        }
      } catch (err) {
        DebugLogger.error(err);
      }
    }
  }

  void _onGetMemories(FetchMemories event, Emitter emit) async {
    try {
      emit(state.copyWith(status: MemoriesStatus.initial));
      emit(state.copyWith(status: MemoriesStatus.loading));

      if (await _isConnectedToInternet()) {
        await DatabaseHelperForMemories.initDb(_me.id);
        await _uploadImagesWhenUserOnline();
        await _deletePhotosWhenUserOnline();

        List<FamilyMemory> _memories =
            await _memoryRepository.fetchMemories(familyId: _me.familyId ?? "");

        emit(state.copyWith(
          media: _memories,
          status: MemoriesStatus.success,
        ));

        _storePhotosWhenUserOnline(_memories);
        emit(state.copyWith(status: MemoriesStatus.success));
      } else {
        //User is offline
        await DatabaseHelperForMemories.initDb(_me.id);
        final DatabaseHelperForMemories dbFactory = DatabaseHelperForMemories();
        List<FamilyMemory> _memories = [];
        List<Map<String, dynamic>> rows =
            await dbFactory.readDataFromTableStoreImage();

        List<Map<String, dynamic>> rowsSend =
            await dbFactory.readDataFromTableSendImage();

        for (Map<String, dynamic> row in rows) {
          _memories.add(FamilyMemory(url: row["imagePath"]));
        }
        for (Map<String, dynamic> row in rowsSend) {
          _memories.add(FamilyMemory(url: row["imagePath"]));
        }

        emit(state.copyWith(
          media: _memories,
          status: MemoriesStatus.success,
        ));
        emit(state.copyWith(status: MemoriesStatus.success));
      }
    } catch (er) {
      DebugLogger.error("${er.toString()}");
      emit(state.copyWith(status: MemoriesStatus.failure));
    }
  }

  void _onDeleteMemory(DeleteMemories event, Emitter emit) async {
    try {
      emit(state.copyWith(status: MemoriesStatus.initial));
      emit(state.copyWith(status: MemoriesStatus.loading));
      List<FamilyMemory> _existingPhoto = state.media;

      List<String> mediaIds = [];

      if (await _isConnectedToInternet()) {
        _existingPhoto.map((media) {
          if (media.isSelected) {
            mediaIds.add(media.mediaId ?? "");
          }
        }).toList();
        bool deleteSuccess =
            await _memoryRepository.deleteMemory(mediaIds, _me.id ?? "");
        if (deleteSuccess) {
          final DatabaseHelperForMemories dbFactory =
              DatabaseHelperForMemories();
          for (var id in mediaIds) {
            dbFactory.storeImagePathsDeleteData(id);
          }
          _existingPhoto.removeWhere((element) => element.isSelected);
          emit(state.copyWith(
            media: _existingPhoto,
            status: MemoriesStatus.success,
          ));
          add(FetchMemories());
          AlbumBloc albumBloc = AlbumBloc(me: _me);
          albumBloc.add(FetchInitialAlbums());
        } else {
          emit(state.copyWith(status: MemoriesStatus.failure));
        }
      } else {
        _existingPhoto.map((media) {
          if (media.isSelected) {
            mediaIds.add(media.url ?? "");
          }
        }).toList();

        final DatabaseHelperForMemories dbFactory = DatabaseHelperForMemories();
        for (var id in mediaIds) {
          try {
            List<Map<String, dynamic>> mediaIds =
                await dbFactory.readDataStoreImageWithMediaId(id);
            List<String> _mediaIds = [];
            for (var id in mediaIds) {
              _mediaIds.add(id['mediaId']);
            }
            for (var id in _mediaIds) {
              dbFactory.deleteImageInsertData(id, _me.id);
            }
          } catch (err) {
            DebugLogger.error("media url not found");
          }
          try {
            dbFactory.sendImageDeleteData(id);
          } catch (err) {
            DebugLogger.error("media url not found");
          }
          try {
            dbFactory.storeImagePathsDeleteData(id);
          } catch (err) {
            DebugLogger.error("media url not found");
          }
          try {
            dbFactory.storeImagePathsDeleteDataByPath(id);
          } catch (err) {
            DebugLogger.error("media url not found");
          }
        }
        _existingPhoto.removeWhere((element) => element.isSelected);
        emit(state.copyWith(
          media: _existingPhoto,
          status: MemoriesStatus.success,
        ));
        add(FetchMemories());
        AlbumBloc albumBloc = AlbumBloc(me: _me);
        albumBloc.add(FetchInitialAlbums());
      }
    } catch (er) {
      DebugLogger.error(er.toString());
    }
  }

  void _onMoveMemory(MoveMemories event, Emitter emit) async {
    try {
      emit(state.copyWith(status: MemoriesStatus.initial));
      emit(state.copyWith(status: MemoriesStatus.loading));
      List<FamilyMemory> _existingPhoto = state.media;

      List<String> mediaIds = [];
      _existingPhoto.map((media) {
        if (media.isSelected) {
          mediaIds.add(media.mediaId ?? "");
        }
      }).toList();

      bool moveSuccess =
          await _memoryRepository.moveMemory(mediaIds, event.albumId);
      if (moveSuccess) {
        emit(state.copyWith(
          status: MemoriesStatus.success,
          media:
              _existingPhoto.map((e) => e.copyWith(isSelected: false)).toList(),
          selectMediaToShare: false,
        ));
      } else {
        emit(state.copyWith(status: MemoriesStatus.failure));
      }
    } catch (er) {
      DebugLogger.error("${er.toString()}");
    }
  }

  Future<void> _onAllMediaSelected(
    AllMediaSelected event,
    Emitter emit,
  ) async {
    List<FamilyMemory> _memories = state.media;
    if (await _isConnectedToInternet()) {
      List<FamilyMemory> _selected = _memories.map((media) {
        return media.copyWith(isSelected: true);
      }).toList();
      emit(state.copyWith(media: _selected));
    }
  }

  Future<void> _onAllMediaDisSelected(
    AllMediaDisSelected event,
    Emitter emit,
  ) async {
    List<FamilyMemory> _memories = state.media;
    if (await _isConnectedToInternet()) {
      List<FamilyMemory> _selected = _memories.map((media) {
        return media.copyWith(isSelected: false);
      }).toList();
      emit(state.copyWith(media: _selected));
    }
  }

  Future<void> _onMediaSelectedToggled(
    MediaSelected event,
    Emitter emit,
  ) async {
    List<FamilyMemory> _memories = state.media;
    if (await _isConnectedToInternet()) {
      List<FamilyMemory> _selected = _memories.map((media) {
        if (media.mediaId == event.media.mediaId) {
          return media.copyWith(isSelected: !media.isSelected);
        }
        return media;
      }).toList();
      emit(state.copyWith(media: _selected));
    } else {
      List<FamilyMemory> _selected = _memories.map((media) {
        if (media.url == event.media.url) {
          return media.copyWith(isSelected: !media.isSelected);
        }
        return media;
      }).toList();
      emit(state.copyWith(media: _selected));
    }
  }

  Future<void> _onToggleSelectedMemberToRequestMedia(
    ToggleSelectedMemberToRequestMedia event,
    Emitter emit,
  ) async {
    emit(state.copyWith(status: MemoriesStatus.loading));
    List<User> _selectedList = state.selectedMembersToRequestMedia;
    int index = _selectedList.indexWhere(
      (user) => user.id != null && user.id == event.user.id,
    );
    if (index > -1) {
      _selectedList.removeAt(index);
    } else {
      _selectedList.add(event.user);
    }
    emit(
      state.copyWith(
          selectedMembersToRequestMedia: _selectedList,
          status: MemoriesStatus.success),
    );
  }

  Future<void> _onSelectMemberToShareMedia(
    SelectMemberToShareMedia event,
    Emitter emit,
  ) async {
    emit(state.copyWith(status: MemoriesStatus.loading));
    List<User> _selectedList = state.selectedMembersToShareMedia;
    int index = _selectedList.indexWhere(
      (user) => user.id != null && user.id == event.user.id,
    );

    if (index > -1) {
      _selectedList.removeAt(index);
    } else {
      _selectedList.add(event.user);
    }
    emit(
      state.copyWith(
          selectedMembersToRequestMedia: _selectedList,
          status: MemoriesStatus.success),
    );
  }

  Future<void> _onResetSelectedMemberToRequestMedia(
    ResetSelectedMemberToRequestMedia event,
    Emitter emit,
  ) async {
    emit(state.copyWith(status: MemoriesStatus.loading));
    List<User> _selectedList = state.selectedMembersToRequestMedia;
    _selectedList.clear();
    emit(
      state.copyWith(
        selectedMembersToRequestMedia: _selectedList,
        status: MemoriesStatus.success,
        requestStatus: Status.initial,
      ),
    );
  }

  Future<void> _onResetSelectedMemberToShareMedia(
    ResetSelectedMemberToShareMedia event,
    Emitter emit,
  ) async {
    emit(state.copyWith(status: MemoriesStatus.loading));
    List<User> _selectedList = state.selectedMembersToRequestMedia;
    _selectedList.clear();
    emit(
      state.copyWith(
        selectedMembersToRequestMedia: _selectedList,
        status: MemoriesStatus.success,
        requestStatus: Status.initial,
      ),
    );
  }

  Future<void> _onMediaRequested(
    RequestMediaFromMember event,
    Emitter emit,
  ) async {
    emit(state.copyWith(
      status: MemoriesStatus.loading,
      requestStatus: Status.loading,
    ));

    try {
      List<User> _contacts = List.from(
        state.selectedMembersToRequestMedia,
      );

      bool isRequested = await _memoryRepository.requestPhotos(
        contactIds: _contacts.map<String>((e) => e.id!).toList(),
        note: event.note.isEmpty ? " " : event.note,
        familyId: _me.familyId,
      );
      emit(
        state.copyWith(
          status: MemoriesStatus.success,
          requestStatus: Status.success,
        ),
      );
    } on GraphQLResponseError catch (err) {
      fcRouter.pushWidget(ErrorMessagePopup(message: err.message));
      emit(state.copyWith(
        requestStatus: Status.failure,
      ));
    } catch (e) {
      fcRouter.pushWidget(ErrorMessagePopup(
        message:
            "Something went wrong! \n Please check your network connection.",
      ));
      emit(state.copyWith(
        requestStatus: Status.failure,
      ));
    }
  }

  Future<void> _onShareMediaWithMember(
    ShareMediaWithMember event,
    Emitter emit,
  ) async {
    emit(state.copyWith(
      status: MemoriesStatus.loading,
      requestStatus: Status.loading,
    ));

    List<FamilyMemory> _existingPhoto = state.media;
    List<String> mediaIds = [];
    _existingPhoto.map((media) {
      if (media.isSelected && media.mediaId != null) {
        mediaIds.add(media.mediaId!);
      }
    }).toList();

    List<User> _existingUsers = state.selectedMembersToShareMedia;
    List<String?> contactIds = [];
    _existingUsers.map((user) {
      contactIds.add(user.id);
    }).toList();

    bool shareSuccess = await _memoryRepository.shareMemories(
      memoryIds: mediaIds,
      familyId: _me.familyId,
    );

    if (shareSuccess) {
      emit(
        state.copyWith(
          status: MemoriesStatus.success,
          requestStatus: Status.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: MemoriesStatus.failure,
          requestStatus: Status.failure,
        ),
      );
    }
  }

  Future<void> _onMediaShareSuccess(
    ShareMediaSuccess event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        status: MemoriesStatus.initial,
        requestStatus: Status.initial,
      ),
    );
  }

  Future<void> _onShowNextMemory(
    ShowNextMemory event,
    Emitter emit,
  ) async {
    int current = state.memoryViewSliderIndex;
    List<FamilyMemory> memories = state.media;

    if (memories.length - 1 > current) {
      current = current + 1;
      emit(state.copyWith(memoryViewSliderIndex: current));
    }
  }

  Future<void> _onShowPreviousMemory(
    ShowPreviousMemory event,
    Emitter emit,
  ) async {
    int current = state.memoryViewSliderIndex;

    if (current > 0) {
      current = current - 1;
      emit(state.copyWith(memoryViewSliderIndex: current));
    }
  }

  Future<void> _onEditPhotoMemory(
      EditPhotoMemory event,
      Emitter emit,
      ) async {
    int current = state.memoryViewSliderIndex;

    if (state.media[current].url.toString().isNotEmpty && state.media[current].url != null) {
      File cropRotateImage = await Navigator.of(event.context).push(
          MaterialPageRoute(
              builder: (context) =>
                  CropRotateImage(imageSrc: state.media[current].url.toString())
          )
      ) ?? File("");

      if(cropRotateImage.path.isNotEmpty){
        await showDialog(
            context: event.context,
            builder: (BuildContext context) {
              return FCConfirmDialog(
                height: MediaQuery.of(event.context).size.height * 0.67,
                width: MediaQuery.of(event.context).size.width * 0.67,
                subText:
                    'you can save a copy of edited image or replace the original image',
                submitText: 'Save a Copy',
                cancelText: 'Cancel',
                isThirdButton: true,
                thirdButtonText: 'Replace',
                message: "Do you want to save as a copy?",
              );
            }).then((value) async {
          Navigator.of(event.context).pop();
          if (value != null && value) {
            add(UploadImage(cropRotateImage.path));
          } else if (value != null && !value) {
            try {
              emit(state.copyWith(status: MemoriesStatus.initial));
              emit(state.copyWith(status: MemoriesStatus.loading));
              List<FamilyMemory> existingPhoto = state.media;

              List<String> mediaIds = [];

              if (await _isConnectedToInternet()) {
                mediaIds.add(state.media[current].mediaId ?? "");
                bool deleteSuccess = await _memoryRepository.deleteMemory(
                    mediaIds, _me.id ?? "");
                if (deleteSuccess) {
                  final DatabaseHelperForMemories dbFactory =
                      DatabaseHelperForMemories();
                  for (var id in mediaIds) {
                    dbFactory.storeImagePathsDeleteData(id);
                  }
                  existingPhoto.removeAt(current);
                  emit(state.copyWith(
                    media: existingPhoto,
                    status: MemoriesStatus.success,
                  ));
                  add(const FetchMemories());
                  AlbumBloc albumBloc = AlbumBloc(me: _me);
                  albumBloc.add(FetchInitialAlbums());
                } else {
                  emit(state.copyWith(status: MemoriesStatus.failure));
                }
              } else {
                mediaIds.add(existingPhoto[current].url ?? "");

                final DatabaseHelperForMemories dbFactory =
                    DatabaseHelperForMemories();
                for (var id in mediaIds) {
                  try {
                    List<Map<String, dynamic>> mediaIds =
                        await dbFactory.readDataStoreImageWithMediaId(id);
                    List<String> mediaIds0 = [];
                    for (var id in mediaIds) {
                      mediaIds0.add(id['mediaId']);
                    }
                    for (var id in mediaIds0) {
                      dbFactory.deleteImageInsertData(id, _me.id);
                    }
                  } catch (err) {
                    DebugLogger.error("media url not found");
                  }
                  try {
                    dbFactory.sendImageDeleteData(id);
                  } catch (err) {
                    DebugLogger.error("media url not found");
                  }
                  try {
                    dbFactory.storeImagePathsDeleteData(id);
                  } catch (err) {
                    DebugLogger.error("media url not found");
                  }
                  try {
                    dbFactory.storeImagePathsDeleteDataByPath(id);
                  } catch (err) {
                    DebugLogger.error("media url not found");
                  }
                }
                existingPhoto.removeAt(current);
                emit(state.copyWith(
                  media: existingPhoto,
                  status: MemoriesStatus.success,
                ));
                add(FetchMemories());
                AlbumBloc albumBloc = AlbumBloc(me: _me);
                albumBloc.add(FetchInitialAlbums());
              }
            } catch (er) {
              DebugLogger.error(er.toString());
            }

            add(UploadImage(cropRotateImage.path));
          }
        });
      }
    }
    add(FetchMoreMemories());
  }

  Future<void> _onResetMemorySliderIndex(
    ResetMemorySliderIndex event,
    Emitter emit,
  ) async {
    emit(state.copyWith(memoryViewSliderIndex: 0));
  }

  Future<void> _onSyncMemoryToSlider(
    SyncMemoryToSlider event,
    Emitter emit,
  ) async {
    List<FamilyMemory> _listOfMedia = state.media;
    emit(state.copyWith(memoryViewSliderIndex: event.index));
  }
}
