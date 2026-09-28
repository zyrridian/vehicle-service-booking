import '../entities/invoice_entity.dart';
import '../repositories/invoice_repository.dart';

class GetInvoiceUseCase {
  final InvoiceRepository _repository;

  GetInvoiceUseCase(this._repository);

  Future<InvoiceEntity> call(String bookingId) {
    return _repository.getInvoice(bookingId);
  }
}
