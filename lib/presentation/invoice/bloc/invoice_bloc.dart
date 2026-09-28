import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/invoice_entity.dart';
import '../../../domain/usecases/invoice_usecases.dart';

abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object?> get props => [];
}

class LoadInvoiceEvent extends InvoiceEvent {
  final String bookingId;

  const LoadInvoiceEvent({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

class InvoiceState extends Equatable {
  final bool isLoading;
  final InvoiceEntity? invoice;
  final String? errorMessage;

  const InvoiceState({
    this.isLoading = false,
    this.invoice,
    this.errorMessage,
  });

  InvoiceState copyWith({
    bool? isLoading,
    InvoiceEntity? invoice,
    String? errorMessage,
  }) {
    return InvoiceState(
      isLoading: isLoading ?? this.isLoading,
      invoice: invoice ?? this.invoice,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, invoice, errorMessage];
}

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final GetInvoiceUseCase getInvoiceUseCase;

  InvoiceBloc({required this.getInvoiceUseCase})
      : super(const InvoiceState()) {
    on<LoadInvoiceEvent>(_onLoadInvoice);
  }

  Future<void> _onLoadInvoice(
    LoadInvoiceEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final invoice = await getInvoiceUseCase(event.bookingId);
      emit(state.copyWith(isLoading: false, invoice: invoice));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat invoice: ${e.toString()}',
      ));
    }
  }
}
