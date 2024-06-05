class SensitiveTimerState{
  St st;

  SensitiveTimerState({required this.st});

  factory SensitiveTimerState.initial() {
    return SensitiveTimerState(st: St.initial);
  }
}

enum St {initial, reset, add, stop}
