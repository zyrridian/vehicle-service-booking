import '../entities/booking_entities.dart';

abstract class BookingRepository {
  Future<List<VehicleEntity>> getMyVehicles();
  Future<List<ServiceOptionEntity>> getAvailableServices(String vehicleId);
  Future<List<TimeSlotEntity>> getAvailableTimeSlots(DateTime date);
  Future<VehicleEntity> addTemporaryVehicle(String name, String plate);
  Future<String> createBooking(BookingRequestEntity request);
}
