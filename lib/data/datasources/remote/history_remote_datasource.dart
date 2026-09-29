import '../../../domain/entities/history_entity.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_client.dart';
import '../../datasources/local/auth_local_datasource.dart';

abstract class HistoryRemoteDataSource {
  Future<List<HistoryBookingEntity>> getHistoryBookings();
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final NetworkClient _client;
  final AuthLocalDataSource _authLocal;

  HistoryRemoteDataSourceImpl(this._client, this._authLocal);

  @override
  Future<List<HistoryBookingEntity>> getHistoryBookings() async {
    final session = await _authLocal.getSession();
    final userId = session?.id;
    if (userId == null) throw Exception('User not logged in');

    final response = await _client.get(
      ApiEndpoints.history,
      queryParameters: {'userId': userId},
    );

    final List<dynamic> data = response;
    final List<HistoryBookingEntity> bookings = data.map((json) => HistoryBookingEntity(
      bookingId: json['bookingId'] ?? '',
      workshopId: json['workshopId'] ?? '00000000-0000-0000-0000-000000000000',
      vehicleName: json['vehicleName'] ?? '',
      serviceType: json['serviceType'] ?? '',
      dateTime: json['dateTime'] ?? '',
      location: json['location'] ?? '',
      total: json['total'] ?? 'Rp 0',
      status: json['status'] ?? '',
      imageUrl: json['imageUrl'] ?? 'https://images.unsplash.com/photo-1590362891991-f776e747a588?auto=format&fit=crop&q=80&w=200',
      isActive: _isActiveStatus(json['status'] ?? ''),
    )).toList();

    // Add a dummy completed booking for testing the rate and invoice screens
    bookings.add(HistoryBookingEntity(
      bookingId: 'BKG-DUMMY-1234',
      workshopId: '00000000-0000-0000-0000-000000000000',
      vehicleName: 'Honda PCX 160',
      serviceType: 'CVT Cleaning & Oil Change',
      dateTime: '15 Aug 2026, 14:00',
      location: 'AHASS Bintang Motor Bandung',
      total: 'Rp 185.000',
      status: 'Completed',
      imageUrl: 'https://images.unsplash.com/photo-1590362891991-f776e747a588?auto=format&fit=crop&q=80&w=200',
      isActive: false,
    ));

    return bookings;
  }

  bool _isActiveStatus(String status) {
    final s = status.toLowerCase();
    return s == 'in progress' || s == 'scheduled' || s == 'waiting' || s == 'pending';
  }
}
