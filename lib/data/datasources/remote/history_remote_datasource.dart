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
    return data.map((json) => HistoryBookingEntity(
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
  }

  bool _isActiveStatus(String status) {
    final s = status.toLowerCase();
    return s == 'in progress' || s == 'scheduled' || s == 'waiting' || s == 'pending';
  }
}
