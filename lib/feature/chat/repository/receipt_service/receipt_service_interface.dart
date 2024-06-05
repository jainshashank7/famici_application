import '../../entities/message.dart';

abstract class IReceiptService {
  Future<void> send(Message message);
  Stream<Message> subscribe(Message message);
}
