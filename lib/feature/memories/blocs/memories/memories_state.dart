part of 'memories_bloc.dart';

enum MemoriesStatus { initial, loading, success, failure }

class MemoriesState extends Equatable {
  const MemoriesState({
    required this.showingPhotos,
    required this.media,
    required this.status,
    required this.selectMediaToShare,
    required this.selectedMembersToRequestMedia,
    required this.selectedMembersToShareMedia,
    required this.requestStatus,
    required this.createOptionStatus,
    required this.memoryViewSliderIndex,
  });
  static int selectedCount = 0;

  final bool showingPhotos;
  final MemoriesStatus status;

  final List<FamilyMemory> media;

  final bool selectMediaToShare;
  final List<User> selectedMembersToRequestMedia;
  final List<User> selectedMembersToShareMedia;

  final Status requestStatus;
  final Status createOptionStatus;

  final int memoryViewSliderIndex;

  factory MemoriesState.initial() {
    return MemoriesState(
        showingPhotos: true,
        media: [],
        status: MemoriesStatus.initial,
        selectMediaToShare: false,
        selectedMembersToRequestMedia: [],
        selectedMembersToShareMedia: [],
        requestStatus: Status.initial,
        memoryViewSliderIndex: 0,
        createOptionStatus: Status.initial);
  }

  MemoriesState copyWith({
    bool? showingPhotos,
    List<FamilyMemory>? media,
    MemoriesStatus? status,
    bool? selectMediaToShare,
    List<User>? selectedMembersToRequestMedia,
    List<User>? selectedMembersToShareMedia,
    Status? requestStatus,
    int? memoryViewSliderIndex,
    Status? createOptionStatus,
  }) {
    var list = MemoriesState(
        showingPhotos: showingPhotos ?? this.showingPhotos,
        media: media ?? this.media,
        status: status ?? this.status,
        selectMediaToShare: selectMediaToShare ?? this.selectMediaToShare,
        selectedMembersToRequestMedia:
            selectedMembersToRequestMedia ?? this.selectedMembersToRequestMedia,
        selectedMembersToShareMedia:
            selectedMembersToShareMedia ?? this.selectedMembersToShareMedia,
        requestStatus: requestStatus ?? this.requestStatus,
        memoryViewSliderIndex:
            memoryViewSliderIndex ?? this.memoryViewSliderIndex,
        createOptionStatus: createOptionStatus ?? this.createOptionStatus);
    // print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    // print(media);

    return list;
  }

  @override
  List<Object> get props => [
        showingPhotos,
        media,
        status,
        selectMediaToShare,
        selectedMembersToRequestMedia,
        selectedMembersToShareMedia,
        requestStatus,
        memoryViewSliderIndex,
        createOptionStatus
      ];

  @override
  String toString() {
    return ''' MemoriesState : {
      showingPhots    : $showingPhotos,
      photos          : ${media.length}
      status          : ${status.toString()}
      selecting media : ${selectMediaToShare.toString()}
      select members  : ${selectedMembersToRequestMedia.length}
      select members to share :${selectedMembersToShareMedia.length}
      hasRequested    : ${requestStatus.toString()}
      createOptionStatus : ${createOptionStatus.toString()}
    }''';
  }
}
