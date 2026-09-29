import 'package:vehicle_service_booking/domain/entities/invoice_entity.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_client.dart';

abstract class InvoiceRemoteDataSource {
  Future<InvoiceEntity> getInvoice(String bookingId);
}

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  final NetworkClient _client;

  InvoiceRemoteDataSourceImpl(this._client);

  @override
  Future<InvoiceEntity> getInvoice(String bookingId) async {
    final response = await _client.get('${ApiEndpoints.invoices}/$bookingId');
    final data = response as Map<String, dynamic>;

    return InvoiceEntity(
      invoiceId: data['invoiceId'] ?? 'INV-UNKNOWN',
      bookingId: bookingId,
      vehicleName: data['vehicleName'] ?? '',
      plate: data['plate'] ?? '',
      workshopName: data['workshopName'] ?? '',
      dateTime: data['dateTime'] != null ? DateTime.parse(data['dateTime']) : DateTime.now(),
      lineItems: (data['lineItems'] as List<dynamic>?)
              ?.map((item) => InvoiceLineItemEntity(
                    name: item['name'] ?? '',
                    qty: item['qty'] ?? 1,
                    unitPrice: (item['unitPrice'] ?? 0).toDouble(),
                    total: (item['total'] ?? 0).toDouble(),
                    type: item['type'] ?? 'service',
                  ))
              .toList() ??
          [],
      subtotal: (data['subtotal'] ?? 0).toDouble(),
      taxAmount: (data['taxAmount'] ?? 0).toDouble(),
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      paymentMethod: data['paymentMethod'] ?? 'Cash',
      isPaid: data['isPaid'] ?? true,
    );
  }
}
