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
      backgroundColor: Colors.white,
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
          if (state.invoice != null) {
            return _buildBody(context, state.invoice);
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: _buildDownloadBar(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
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

  Widget _buildBody(BuildContext context, dynamic invoice) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHeaderCard(invoice),
          const SizedBox(height: 12),

          _buildVehicleCard(invoice),
          const SizedBox(height: 12),

          _buildLineItemsCard(invoice.lineItems),
          const SizedBox(height: 12),

          _buildTotalsCard(invoice.subtotal, invoice.taxAmount, invoice.totalAmount),
          const SizedBox(height: 12),

          _buildPaymentCard(invoice),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(dynamic invoice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
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
                  invoice.invoiceId,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${invoice.dateTime.day} ${_getMonth(invoice.dateTime.month)} ${invoice.dateTime.year}',
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
              color: invoice.isPaid
                  ? AppColors.good.withValues(alpha: 0.12)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              invoice.isPaid ? 'Lunas' : 'Belum Lunas',
              style: TextStyle(
                color: invoice.isPaid ? AppColors.good : Colors.red,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'];
    return months[month - 1];
  }

  Widget _buildVehicleCard(dynamic invoice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
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
          _infoRow(LucideIcons.car, 'Kendaraan', invoice.vehicleName),
          const Divider(height: 16, color: AppColors.line),
          _infoRow(LucideIcons.hash, 'Plat Nomor', invoice.plate),
          const Divider(height: 16, color: AppColors.line),
          _infoRow(LucideIcons.warehouse, 'Bengkel', invoice.workshopName),
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

  Widget _buildLineItemsCard(List<dynamic> items) {
    final grouped = <String, List<dynamic>>{};
    for (final item in items) {
      final type = item.type as String;
      if (!grouped.containsKey(type)) {
        grouped[type] = [];
      }
      grouped[type]!.add(item);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
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
          if (grouped.isEmpty)
            Text('Tidak ada rincian biaya.', style: TextStyle(color: AppColors.ink.withValues(alpha: 0.5), fontSize: 13)),
          ...grouped.entries.map((entry) {
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
                    entry.key.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.brand,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ...entry.value.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            item.name,
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
                            '${item.qty} × ${_currencyFmt.format(item.unitPrice)}',
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
                            _currencyFmt.format(item.total),
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

  Widget _buildTotalsCard(double subtotal, double tax, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
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

  Widget _buildPaymentCard(dynamic invoice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
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
            invoice.paymentMethod,
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
