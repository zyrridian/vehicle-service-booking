import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../injection.dart';
import '../bloc/invoice_bloc.dart';

final _currencyFmt = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

final Map<String, dynamic> _mockInvoice = {
  'invoiceId': 'INV-20260928-0042',
  'bookingDate': '28 September 2026',
  'isPaid': true,
  'vehicleName': 'Honda Vario 150',
  'plate': 'B 4567 ABC',
  'workshopName': 'AHASS Bintang Motor Bandung',
  'paymentMethod': 'Transfer Bank BCA',
  'lineItems': [
    {
      'type': 'Layanan',
      'items': [
        {'name': 'Tune Up Mesin', 'qty': 1, 'price': 150000},
        {'name': 'Ganti Filter Udara', 'qty': 1, 'price': 45000},
      ],
    },
    {
      'type': 'Suku Cadang',
      'items': [
        {'name': 'Busi NGK Iridium', 'qty': 4, 'price': 55000},
        {'name': 'Filter Bahan Bakar', 'qty': 1, 'price': 75000},
      ],
    },
    {
      'type': 'Oli',
      'items': [
        {'name': 'Oli Mesin Shell Helix 10W-40', 'qty': 4, 'price': 65000},
        {'name': 'Oli Transmisi Automatic', 'qty': 1, 'price': 120000},
      ],
    },
  ],
};

class InvoiceDetailPage extends StatelessWidget {
  final String bookingId;

  const InvoiceDetailPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injection.provideInvoiceBloc()
        ..add(LoadInvoiceEvent(bookingId: bookingId)),
      child: _InvoiceDetailView(bookingId: bookingId),
    );
  }
}

class _InvoiceDetailView extends StatelessWidget {
  final String bookingId;

  const _InvoiceDetailView({required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: _buildAppBar(context),
      body: BlocBuilder<InvoiceBloc, InvoiceState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.brand),
            );
          }
          if (state.errorMessage != null) {
            return _buildError(context, state.errorMessage!);
          }
          return _buildBody(context);
        },
      ),
      bottomNavigationBar: _buildDownloadBar(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(LucideIcons.chevronLeft, color: AppColors.ink),
      ),
      title: const Text(
        'Detail Invoice',
        style: TextStyle(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
          fontSize: 17,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final invoice = _mockInvoice;
    final isPaid = invoice['isPaid'] as bool;
    final lineItems =
        (invoice['lineItems'] as List).cast<Map<String, dynamic>>();

    int subtotal = 0;
    for (final group in lineItems) {
      for (final item
          in (group['items'] as List).cast<Map<String, dynamic>>()) {
        subtotal += (item['qty'] as int) * (item['price'] as int);
      }
    }
    final tax = (subtotal * 0.11).round();
    final total = subtotal + tax;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHeaderCard(invoice, isPaid),
          const SizedBox(height: 12),

          _buildVehicleCard(invoice),
          const SizedBox(height: 12),

          _buildLineItemsCard(lineItems),
          const SizedBox(height: 12),

          _buildTotalsCard(subtotal, tax, total),
          const SizedBox(height: 12),

          _buildPaymentCard(invoice),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(Map<String, dynamic> invoice, bool isPaid) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.brand.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(LucideIcons.fileText,
                color: AppColors.brand, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice['invoiceId'] as String,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  invoice['bookingDate'] as String,
                  style: TextStyle(
                    color: AppColors.ink.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isPaid
                  ? AppColors.good.withValues(alpha: 0.12)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isPaid ? 'Lunas' : 'Belum Lunas',
              style: TextStyle(
                color: isPaid ? AppColors.good : Colors.red,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> invoice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Kendaraan',
            style: TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          _infoRow(LucideIcons.car, 'Kendaraan',
              invoice['vehicleName'] as String),
          const Divider(height: 16, color: AppColors.line),
          _infoRow(LucideIcons.hash, 'Plat Nomor',
              invoice['plate'] as String),
          const Divider(height: 16, color: AppColors.line),
          _infoRow(LucideIcons.warehouse, 'Bengkel',
              invoice['workshopName'] as String),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.brand),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: AppColors.ink.withValues(alpha: 0.5),
            fontSize: 13,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildLineItemsCard(List<Map<String, dynamic>> groups) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Biaya',
            style: TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          ...groups.map((group) {
            final items =
                (group['items'] as List).cast<Map<String, dynamic>>();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    group['type'] as String,
                    style: const TextStyle(
                      color: AppColors.brand,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ...items.map((item) {
                  final qty = item['qty'] as int;
                  final price = item['price'] as int;
                  final itemTotal = qty * price;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            item['name'] as String,
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: Text(
                            '$qty × ${_currencyFmt.format(price)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.ink.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            _currencyFmt.format(itemTotal),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(color: AppColors.line),
                const SizedBox(height: 4),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTotalsCard(int subtotal, int tax, int total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          _totalRow('Subtotal', _currencyFmt.format(subtotal),
              isBold: false),
          const SizedBox(height: 8),
          _totalRow('PPN 11%', _currencyFmt.format(tax), isBold: false),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: AppColors.line),
          ),
          _totalRow('Total', _currencyFmt.format(total), isBold: true),
        ],
      ),
    );
  }

  Widget _totalRow(String label, String value, {required bool isBold}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold
                ? AppColors.ink
                : AppColors.ink.withValues(alpha: 0.5),
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            fontSize: isBold ? 15 : 13,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: isBold ? AppColors.brand : AppColors.ink,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            fontSize: isBold ? 16 : 13,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentCard(Map<String, dynamic> invoice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.creditCard,
              size: 18, color: AppColors.brand),
          const SizedBox(width: 10),
          const Text(
            'Metode Pembayaran',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          Text(
            invoice['paymentMethod'] as String,
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brand,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 0,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mengunduh invoice...'),
                backgroundColor: AppColors.brand,
              ),
            );
          },
          icon: const Icon(LucideIcons.download,
              color: Colors.white, size: 18),
          label: const Text(
            'Unduh Invoice',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.alertCircle, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brand,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                elevation: 0,
              ),
              onPressed: () => context
                  .read<InvoiceBloc>()
                  .add(LoadInvoiceEvent(bookingId: bookingId)),
              child: const Text('Coba Lagi',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
