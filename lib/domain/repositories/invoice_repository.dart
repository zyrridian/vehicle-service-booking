import '../entities/invoice_entity.dart';

abstract class InvoiceRepository {
  Future<InvoiceEntity> getInvoice(String bookingId);
}
