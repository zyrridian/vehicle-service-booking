class VehicleEntity {
  final String id;
  final String name;
  final String plate;
  final String lastService;

  VehicleEntity({required this.id, required this.name, required this.plate, required this.lastService});
}

class ServiceOptionEntity {
  final String id;
  final String name;
  final double price;
  final int durationMinutes;

  ServiceOptionEntity({required this.id, required this.name, required this.price, required this.durationMinutes});
}

class TimeSlotEntity {
  final String time;
  final bool isAvailable;

  TimeSlotEntity({required this.time, required this.isAvailable});
}

class BookingRequestEntity {
  final List<String> vehicleIds;
  final Map<String, List<String>> selectedServices; 
  final DateTime date;
  final String timeSlot;
  final String notes;
  final String workshopId;

  BookingRequestEntity({
    required this.vehicleIds,
    required this.selectedServices,
    required this.date,
    required this.timeSlot,
    required this.notes,
    required this.workshopId,
  });
}
