import 'package:vehicle_service_booking/domain/entities/booking_entities.dart';

abstract class BookingRemoteDataSource {
  Future<List<VehicleEntity>> getMyVehicles();
  Future<List<ServiceOptionEntity>> getAvailableServices(String vehicleId);
  Future<List<TimeSlotEntity>> getAvailableTimeSlots(DateTime date);
  Future<VehicleEntity> addTemporaryVehicle(String name, String plate);
  Future<String> createBooking(BookingRequestEntity request);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  @override
  Future<List<VehicleEntity>> getMyVehicles() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      VehicleEntity(id: 'v1', name: 'Honda Vario 150', plate: 'B 4567 ABC', lastService: '2 bulan lalu'),
      VehicleEntity(id: 'v2', name: 'Honda Beat Street', plate: 'B 2210 XYZ', lastService: '5 bulan lalu'),
      VehicleEntity(id: 'v3', name: 'Honda PCX 160', plate: 'B 8890 DEF', lastService: '1 minggu lalu'),
    ];
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
    await Future.delayed(const Duration(seconds: 1));
    return 'BOOK-${DateTime.now().millisecondsSinceEpoch}';
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
