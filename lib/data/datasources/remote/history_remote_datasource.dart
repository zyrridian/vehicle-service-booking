import '../../../domain/entities/history_entity.dart';

abstract class HistoryRemoteDataSource {
  Future<List<HistoryBookingEntity>> getHistoryBookings();
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  @override
  Future<List<HistoryBookingEntity>> getHistoryBookings() async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    return [
      HistoryBookingEntity(
        bookingId: 'BK-1204',
        vehicleName: 'Honda Civic 2020',
        serviceType: 'Full Service',
        dateTime: 'Oct 24, 10:00 AM',
        location: 'AutoFix Workshop',
        total: '\$150',
        status: 'In Progress',
        imageUrl: 'https://images.unsplash.com/photo-1590362891991-f776e747a588?auto=format&fit=crop&q=80&w=200',
        isActive: true,
      ),
      HistoryBookingEntity(
        bookingId: 'BK-1205',
        vehicleName: 'Toyota Camry 2019',
        serviceType: 'Oil Change',
        dateTime: 'Oct 25, 14:00 PM',
        location: 'QuickLube Center',
        total: '\$45',
        status: 'Scheduled',
        imageUrl: 'https://images.unsplash.com/photo-1590362891991-f776e747a588?auto=format&fit=crop&q=80&w=200',
        isActive: true,
      ),
      HistoryBookingEntity(
        bookingId: 'BK-1102',
        vehicleName: 'Honda Civic 2020',
        serviceType: 'Brake Inspection',
        dateTime: 'Sep 15, 09:30 AM',
        location: 'AutoFix Workshop',
        total: '\$85',
        status: 'Completed',
        imageUrl: 'https://images.unsplash.com/photo-1590362891991-f776e747a588?auto=format&fit=crop&q=80&w=200',
        isActive: false,
      ),
      HistoryBookingEntity(
        bookingId: 'BK-1054',
        vehicleName: 'Honda Civic 2020',
        serviceType: 'Tire Rotation',
        dateTime: 'Aug 02, 11:00 AM',
        location: 'TireMasters',
        total: '\$40',
        status: 'Cancelled',
        imageUrl: 'https://images.unsplash.com/photo-1590362891991-f776e747a588?auto=format&fit=crop&q=80&w=200',
        isActive: false,
      ),
    ];
  }
}
