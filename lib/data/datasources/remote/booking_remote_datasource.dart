import 'package:vehicle_service_booking/domain/entities/booking_entities.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_client.dart';
import '../local/auth_local_datasource.dart';

abstract class BookingRemoteDataSource {
  Future<List<VehicleEntity>> getMyVehicles();
  Future<List<ServiceOptionEntity>> getAvailableServices(String vehicleId);
  Future<List<TimeSlotEntity>> getAvailableTimeSlots(DateTime date);
  Future<VehicleEntity> addTemporaryVehicle(String name, String plate);
  Future<String> createBooking(BookingRequestEntity request);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final NetworkClient _client;
  final AuthLocalDataSource _authLocalDataSource;

  BookingRemoteDataSourceImpl(this._client, this._authLocalDataSource);

  @override
  Future<List<VehicleEntity>> getMyVehicles() async {
    final session = await _authLocalDataSource.getSession();
    final userId = session?.id;
    if (userId == null) throw Exception('User not logged in');

    final response = await _client.get(
      ApiEndpoints.garageVehicles,
      queryParameters: {'userId': userId},
    );

    final List<dynamic> data = response as List<dynamic>;
    return data.map((json) {
      return VehicleEntity(
        id: json['id'] as String,
        name: json['name'] as String,
        plate: json['plate'] as String,
        lastService: json['lastService'] as String? ?? 'Belum pernah servis',
      );
    }).toList();
  }

  @override
  Future<List<ServiceOptionEntity>> getAvailableServices(String vehicleId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ServiceOptionEntity(id: 's1', name: 'Servis Ringan + Ganti Oli', price: 150000, durationMinutes: 45),
      ServiceOptionEntity(id: 's2', name: 'Servis CVT', price: 85000, durationMinutes: 30),
      ServiceOptionEntity(id: 's3', name: 'Ganti Kampas Rem', price: 65000, durationMinutes: 20),
    ];
  }

  @override
  Future<List<TimeSlotEntity>> getAvailableTimeSlots(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      TimeSlotEntity(time: '09:00', isAvailable: false),
      TimeSlotEntity(time: '09:30', isAvailable: true),
      TimeSlotEntity(time: '10:00', isAvailable: true),
      TimeSlotEntity(time: '10:30', isAvailable: true),
      TimeSlotEntity(time: '11:00', isAvailable: true),
      TimeSlotEntity(time: '13:00', isAvailable: true),
      TimeSlotEntity(time: '14:00', isAvailable: false),
    ];
  }

  @override
  Future<String> createBooking(BookingRequestEntity request) async {
    final session = await _authLocalDataSource.getSession();
    final userId = session?.id;
    if (userId == null) throw Exception('User not logged in');

    String? lastBookingId;
    
    final timeParts = request.timeSlot.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final combinedDateTime = DateTime.utc(
      request.date.year,
      request.date.month,
      request.date.day,
      hour,
      minute,
    );

    for (final vehicleId in request.vehicleIds) {
      final selectedServices = request.selectedServices[vehicleId] ?? [];
      final serviceNames = selectedServices.isEmpty ? 'Servis Ringan + Ganti Oli' : 'Multiple Services'; 
      
      final response = await _client.post(
        ApiEndpoints.bookings,
        data: {
          'userId': userId,
          'vehicleId': vehicleId,
          'workshopId': request.workshopId,
          'serviceType': 'Servis Ringan + Ganti Oli',
          'notes': request.notes,
          'totalAmount': 150000,
          'dateTime': combinedDateTime.toIso8601String(), 
        },
      );
      
      lastBookingId = response['bookingId'] as String? ?? 'BOOK-${DateTime.now().millisecondsSinceEpoch}';
    }

    return lastBookingId ?? 'BOOK-${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<VehicleEntity> addTemporaryVehicle(String name, String plate) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return VehicleEntity(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      plate: plate,
      lastService: 'Belum pernah servis',
    );
  }
}
