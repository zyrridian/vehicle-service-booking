import 'package:vehicle_service_booking/data/datasources/remote/invoice_remote_datasource.dart';
import 'package:vehicle_service_booking/domain/entities/invoice_entity.dart';
import 'package:vehicle_service_booking/domain/repositories/invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource _remoteDataSource;

  InvoiceRepositoryImpl(this._remoteDataSource);

  @override
  Future<InvoiceEntity> getInvoice(String bookingId) {
    return _remoteDataSource.getInvoice(bookingId);
  }
}
