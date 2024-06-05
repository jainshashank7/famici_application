import 'package:famici/feature/chat/entities/message.dart';
import 'package:famici/feature/chat/repository/receipt_service/receipt_service_interface.dart';

class ReceiptService implements IReceiptService {
  @override
  Future<void> send(Message message) {
    // TODO: implement send
    throw UnimplementedError();
  }

  @override
  Stream<Message> subscribe(Message message) {
    // TODO: implement subscribe
    throw UnimplementedError();
  }
}
