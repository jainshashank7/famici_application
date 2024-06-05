
import 'Attendee.dart';

class Attendees
{
  final List<ChimeAttendee> _attendees = List<ChimeAttendee>.empty(growable: true);

  get length
  => _attendees.length;

  ChimeAttendee operator [](int index)
  => _attendees[index];

  void add(ChimeAttendee attendee)
  => _attendees.add(attendee);

  void remove(ChimeAttendee attendee)
  => _attendees.remove(attendee);

  List<ChimeAttendee> list(){
    return _attendees;
  }

  ChimeAttendee? getByTileId(int tileId)
  {
    for (int i = 0; i < _attendees.length; i++)
      if (_attendees[i].tileId == tileId)
        return _attendees[i];

    return null;
  }

}
