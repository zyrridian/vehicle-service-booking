import 'package:vehicle_service_booking/domain/entities/invoice_entity.dart';

abstract class InvoiceRemoteDataSource {
  Future<InvoiceEntity> getInvoice(String bookingId);
}

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  @override
  Future<InvoiceEntity> getInvoice(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 450));

    final lineItems = [
      InvoiceLineItemEntity(
        name: 'Full Tune-Up Service',
        qty: 1,
        unitPrice: 350000,
        total: 350000,
        type: 'service',
      ),
      InvoiceLineItemEntity(
        name: 'Brake Pad Replacement (Front)',
        qty: 1,
        unitPrice: 275000,
        total: 275000,
        type: 'service',
      ),
      InvoiceLineItemEntity(
        name: 'Air Filter',
        qty: 1,
        unitPrice: 85000,
        total: 85000,
        type: 'part',
      ),
      InvoiceLineItemEntity(
        name: 'Spark Plug (Set of 4)',
        qty: 1,
        unitPrice: 120000,
        total: 120000,
        type: 'part',
      ),
      InvoiceLineItemEntity(
        name: 'Castrol GTX 10W-40 (4L)',
        qty: 1,
        unitPrice: 160000,
        total: 160000,
        type: 'oil',
      ),
      InvoiceLineItemEntity(
        name: 'Oil Filter',
        qty: 1,
        unitPrice: 45000,
        total: 45000,
        type: 'part',
      ),
    ];

    const subtotal = 1035000.0;
    const taxRate = 0.11;
    const taxAmount = subtotal * taxRate;
    const totalAmount = subtotal + taxAmount;

    return InvoiceEntity(
      invoiceId: 'INV-${bookingId.toUpperCase()}-001',
      bookingId: bookingId,
      vehicleName: 'Toyota Avanza 2021',
      plate: 'B 1234 XYZ',
      workshopName: 'AutoCare Pro Workshop',
      dateTime: DateTime(2026, 9, 28, 9, 0),
      lineItems: lineItems,
      subtotal: subtotal,
      taxAmount: taxAmount,
      totalAmount: totalAmount,
      paymentMethod: 'GoPay',
      isPaid: true,
    );
  }
}
