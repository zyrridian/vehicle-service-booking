import 'package:vehicle_service_booking/domain/entities/workshop_entity.dart';

abstract class WorkshopRemoteDataSource {
  Future<List<WorkshopEntity>> getWorkshops({String? city, String? service});
  Future<WorkshopEntity> getWorkshopDetail(String id);
}

class WorkshopRemoteDataSourceImpl implements WorkshopRemoteDataSource {
  static final List<WorkshopEntity> _workshops = [
    WorkshopEntity(
      id: 'ws-001',
      name: 'AutoCare Pro Workshop',
      address: 'Jl. Sudirman No. 45',
      city: 'Jakarta',
      rating: 4.8,
      reviewCount: 312,
      distanceKm: 1.2,
      imageUrl: 'https://images.unsplash.com/photo-1625047509248-ec889cbff17f?w=600',
      services: ['Oil Change', 'Tire Rotation', 'Brake Service', 'AC Repair', 'Engine Check'],
      isOpen: true,
      openHours: '08:00 – 20:00',
      phone: '+62 21 5550 0101',
    ),
    WorkshopEntity(
      id: 'ws-002',
      name: 'Speedy Motors Service',
      address: 'Jl. Gatot Subroto No. 12',
      city: 'Jakarta',
      rating: 4.5,
      reviewCount: 178,
      distanceKm: 2.7,
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600',
      services: ['Oil Change', 'Battery Replacement', 'Wheel Alignment', 'Transmission Service'],
      isOpen: true,
      openHours: '07:30 – 18:00',
      phone: '+62 21 5550 0202',
    ),
    WorkshopEntity(
      id: 'ws-003',
      name: 'EliteTech Auto Center',
      address: 'Jl. HR Rasuna Said Kav. 8',
      city: 'Jakarta',
      rating: 4.9,
      reviewCount: 504,
      distanceKm: 4.1,
      imageUrl: 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=600',
      services: [
        'Full Service',
        'Engine Overhaul',
        'AC Repair',
        'Electrical Diagnostics',
        'Body Repair',
        'Painting',
      ],
      isOpen: true,
      openHours: '08:00 – 21:00',
      phone: '+62 21 5550 0303',
    ),
    WorkshopEntity(
      id: 'ws-004',
      name: 'BudgetFix Garage',
      address: 'Jl. Kebon Jeruk No. 77',
      city: 'Jakarta',
      rating: 4.1,
      reviewCount: 89,
      distanceKm: 6.3,
      imageUrl: 'https://images.unsplash.com/photo-1566836610593-62a64888a216?w=600',
      services: ['Oil Change', 'Tire Patch', 'Brake Pad Replacement', 'Battery Replacement'],
      isOpen: false,
      openHours: '09:00 – 17:00',
      phone: '+62 21 5550 0404',
    ),
  ];

  @override
  Future<List<WorkshopEntity>> getWorkshops({
    String? city,
    String? service,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    var result = List<WorkshopEntity>.from(_workshops);

    if (city != null && city.isNotEmpty) {
      result = result
          .where((w) => w.city.toLowerCase().contains(city.toLowerCase()))
          .toList();
    }

    if (service != null && service.isNotEmpty) {
      result = result
          .where(
            (w) => w.services.any(
              (s) => s.toLowerCase().contains(service.toLowerCase()),
            ),
          )
          .toList();
    }

    result.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return result;
  }

  @override
  Future<WorkshopEntity> getWorkshopDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final workshop = _workshops.firstWhere(
      (w) => w.id == id,
      orElse: () => throw Exception('Workshop not found: $id'),
    );
    return workshop;
  }
}
