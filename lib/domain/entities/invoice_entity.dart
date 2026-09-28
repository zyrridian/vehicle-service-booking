/// Type of line item: 'service' | 'part' | 'oil'
typedef LineItemType = String;

class InvoiceLineItemEntity {
  final String name;
  final int qty;
  final double unitPrice;
  final double total;

  /// One of: 'service', 'part', 'oil'
  final LineItemType type;

  InvoiceLineItemEntity({
    required this.name,
    required this.qty,
    required this.unitPrice,
    required this.total,
    required this.type,
  });
}

class InvoiceEntity {
  final String invoiceId;
  final String bookingId;
  final String vehicleName;
  final String plate;
  final String workshopName;
  final DateTime dateTime;
  final List<InvoiceLineItemEntity> lineItems;
  final double subtotal;
  final double taxAmount;
  final double totalAmount;
  final String paymentMethod;
  final bool isPaid;

  InvoiceEntity({
    required this.invoiceId,
    required this.bookingId,
    required this.vehicleName,
    required this.plate,
    required this.workshopName,
    required this.dateTime,
    required this.lineItems,
    required this.subtotal,
    required this.taxAmount,
    required this.totalAmount,
    required this.paymentMethod,
    required this.isPaid,
  });
}
