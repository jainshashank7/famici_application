part of 'memories_bloc.dart';

abstract class MemoriesEvent extends Equatable {
  const MemoriesEvent();

  @override
  List<Object> get props => [];
}

class ToggleShowPhotos extends MemoriesEvent {
  @override
  String toString() {
    return "toggle Show photos event";
  }
}

class FetchInitialMemories extends MemoriesEvent {
  @override
  String toString() {
    return "FetchInitialPhotos";
  }
}

// class FetchInitialAlbums extends MemoriesEvent {
//   @override
//   String toString() {
//     return "FetchInitialPhotos";
//   }
// }

class FetchMoreMemories extends MemoriesEvent {
  @override
  String toString() {
    return "FetchMorePhotos";
  }
}

// class FetchMoreAlbums extends MemoriesEvent {
//   @override
//   String toString() {
//     return "FetchMorePhotos";
//   }
// }

class SyncUploadedImage extends MemoriesEvent {
  @override
  String toString() {
    return "FetchMorePhotos";
  }
}

class UploadImage extends MemoriesEvent {
  final String path;

  const UploadImage(this.path);
  @override
  String toString() {
    return "UploadedImage";
  }
}

class UploadMultiImage extends MemoriesEvent {
  final List<String> path;

  const UploadMultiImage(this.path);
  @override
  String toString() {
    return "UploadedImage";
  }
}

class FetchMemories extends MemoriesEvent {
  const FetchMemories();
  @override
  String toString() {
    return "FetchMemories";
  }
}

class DeleteMemories extends MemoriesEvent {
  const DeleteMemories();
  @override
  String toString() {
    return "DeleteMemories";
  }
}

class MoveMemories extends MemoriesEvent {
  final String albumId;
  const MoveMemories(this.albumId);
  @override
  String toString() {
    return "MoveMemories";
  }
}

class ToggleSelectMediaToShare extends MemoriesEvent {
  @override
  String toString() {
    return "ToggleSelectMediaToShare";
  }
}

class CancelMediaToShare extends MemoriesEvent {
  const CancelMediaToShare();
  @override
  String toString() {
    return "CancelMediaToShare";
  }
}

class MediaSelected extends MemoriesEvent {
  final FamilyMemory media;

  const MediaSelected(this.media);
  @override
  String toString() {
    return "MediaSelected";
  }
}

class AllMediaSelected extends MemoriesEvent {
  const AllMediaSelected();
  @override
  String toString() {
    return "AllMediaSelected";
  }
}

class AllMediaDisSelected extends MemoriesEvent {
  const AllMediaDisSelected();
  @override
  String toString() {
    return "AllMediaDisSelected";
  }
}

class ToggleSelectedMemberToRequestMedia extends MemoriesEvent {
  final User user;

  const ToggleSelectedMemberToRequestMedia(this.user);
  @override
  String toString() {
    return "ToggleSelectedMemberToRequestMedia";
  }
}

class SelectMemberToShareMedia extends MemoriesEvent {
  final User user;

  const SelectMemberToShareMedia(this.user);
  @override
  String toString() {
    return "SelectMemberToShareMedia";
  }
}

class ResetSelectedMemberToRequestMedia extends MemoriesEvent {
  @override
  String toString() {
    return "ResetSelectedMemberToRequestMedia";
  }
}

class ResetSelectedMemberToShareMedia extends MemoriesEvent {
  @override
  String toString() {
    return "ResetSelectedMemberToShareMedia";
  }
}

class RequestMediaFromMember extends MemoriesEvent {
  final String note;

  const RequestMediaFromMember(this.note);
  @override
  String toString() {
    return "RequestMedia";
  }
}

class ShareMediaWithMember extends MemoriesEvent {
  @override
  String toString() {
    return "ShareMediaWithMember";
  }
}

class ShareMediaSuccess extends MemoriesEvent {
  @override
  String toString() {
    return "ShareMediaSuccess";
  }
}

class ShowNextMemory extends MemoriesEvent {
  @override
  String toString() {
    return "ShowNextMemory";
  }
}

class ShowPreviousMemory extends MemoriesEvent {
  @override
  String toString() {
    return "ShowPreviousMemory";
  }
}

class EditPhotoMemory extends MemoriesEvent {
  final BuildContext context;

  const EditPhotoMemory(this.context);

  @override
  String toString() {
    return "EditPhotoMemory";
  }
}

class SyncMemoryToSlider extends MemoriesEvent {
  final int index;

  const SyncMemoryToSlider(this.index);
  @override
  String toString() {
    return "SyncMemoryToSlider";
  }
}

class ResetMemorySliderIndex extends MemoriesEvent {
  @override
  String toString() {
    return "ResetMemorySliderIndex";
  }
}

class ResetMemoryStatus extends MemoriesEvent {
  @override
  String toString() {
    return "ResetMemorySliderIndex";
  }
}
