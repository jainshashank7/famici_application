part of 'vitals_and_wellness_bloc.dart';

enum VitalsAndWellnessStatus {
  initial,
  loading,
  success,
  failure,
}

class VitalsAndWellnessState {
  const VitalsAndWellnessState({
    required this.showingVitals,
    required this.status,
    required this.vitalList,
    required this.wellnessList,
  });

  final bool showingVitals;
  final VitalsAndWellnessStatus status;
  final List<Vital> vitalList;
  final List<Vital> wellnessList;

  factory VitalsAndWellnessState.initial() {
    return VitalsAndWellnessState(
      showingVitals: true,
      status: VitalsAndWellnessStatus.initial,
      vitalList: [],
      wellnessList: [],
    );
  }

  VitalsAndWellnessState copyWith({
    bool? showingVitals,
    VitalsAndWellnessStatus? status,
    List<Vital>? vitalList,
    List<Vital>? wellnessList,
  }) {
    // print('%%%%%%%');
    // for(Vital i in vitalList ?? []){
    //   print(i.toJson());
    // }
    return VitalsAndWellnessState(
      showingVitals: showingVitals ?? true,
      status: status ?? this.status,
      vitalList: vitalList ?? this.vitalList,
      wellnessList: wellnessList ?? this.wellnessList,
    );
  }

  factory VitalsAndWellnessState.fromJson(Map<String, dynamic> json) {
    VitalsAndWellnessState _state = VitalsAndWellnessState.initial();

    List<Vital> _vital =
        (json['vitals'] as List).map((e) => Vital.fromJson(e)).toList();
    List<Vital> _wellness =
        (json['wellness'] as List).map((e) => Vital.fromJson(e)).toList();

    return _state.copyWith(vitalList: _vital, wellnessList: _wellness);
  }

  Map<String, dynamic> toJson() {
    return {
      "vitals": vitalList.map((e) => e.toJson()).toList(),
      "wellness": wellnessList.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return ''' MemoriesState : {
      showingVitals    : $showingVitals,
      status          : ${status.toString()}
      vital list : ${vitalList.length}
      wellness List : ${wellnessList.length}
    }''';
  }
}
