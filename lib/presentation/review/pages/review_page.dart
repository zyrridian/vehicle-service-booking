import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../injection.dart';
import '../bloc/review_bloc.dart';

class ReviewPage extends StatelessWidget {
  final String bookingId;
  final String workshopId;
  final String workshopName;
  final String vehicleName;

  const ReviewPage({
    super.key,
    required this.bookingId,
    required this.workshopId,
    required this.workshopName,
    required this.vehicleName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injection.provideReviewBloc(),
      child: _ReviewView(
        bookingId: bookingId,
        workshopId: workshopId,
        workshopName: workshopName,
        vehicleName: vehicleName,
      ),
    );
  }
}

class _ReviewView extends StatefulWidget {
  final String bookingId;
  final String workshopId;
  final String workshopName;
  final String vehicleName;

  const _ReviewView({
    required this.bookingId,
    required this.workshopId,
    required this.workshopName,
    required this.vehicleName,
  });

  @override
  State<_ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<_ReviewView> {
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocus = FocusNode();

  static const List<String> _ratingLabels = [
    '',             // 0 – no selection
    'Sangat Buruk', // 1
    'Buruk',        // 2
    'Cukup',        // 3
    'Baik',         // 4
    'Sangat Baik',  // 5
  ];

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocus.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih rating terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    context.read<ReviewBloc>().add(
          SubmitReviewEvent(
            bookingId: widget.bookingId,
            workshopId: widget.workshopId,
            rating: _selectedRating,
            comment: _commentController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewBloc, ReviewState>(
      listener: (context, state) {
        if (state.submitSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ulasan berhasil dikirim! Terima kasih 🎉'),
              backgroundColor: AppColors.good,
            ),
          );
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(LucideIcons.chevronLeft, color: AppColors.ink),
      ),
      title: const Text(
        'Beri Penilaian',
        style: TextStyle(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
          fontSize: 17,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 16),

            _buildRatingCard(),
            const SizedBox(height: 16),

            _buildCommentCard(),
            const SizedBox(height: 24),

            _buildSubmitButton(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.brand.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(LucideIcons.warehouse,
                color: AppColors.brand, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.workshopName,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(LucideIcons.car,
                        size: 12, color: AppColors.brand),
                    const SizedBox(width: 4),
                    Text(
                      widget.vehicleName,
                      style: TextStyle(
                        color: AppColors.ink.withValues(alpha: 0.5),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text(
            'Bagaimana pengalaman Anda?',
            style: TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isSelected = starIndex <= _selectedRating;
              return GestureDetector(
                onTap: () => setState(() => _selectedRating = starIndex),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    LucideIcons.star,
                    size: isSelected ? 42 : 36,
                    color: isSelected ? Colors.amber : AppColors.line,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              _selectedRating > 0
                  ? _ratingLabels[_selectedRating]
                  : 'Ketuk bintang untuk memberi nilai',
              key: ValueKey(_selectedRating),
              style: TextStyle(
                color: _selectedRating > 0
                    ? AppColors.brand
                    : AppColors.ink.withValues(alpha: 0.4),
                fontWeight: _selectedRating > 0
                    ? FontWeight.w700
                    : FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                const Icon(LucideIcons.messageSquare,
                    size: 16, color: AppColors.brand),
                const SizedBox(width: 8),
                const Text(
                  'Tulis Ulasan',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  '(Opsional)',
                  style: TextStyle(
                    color: AppColors.ink.withValues(alpha: 0.4),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _commentController,
            focusNode: _commentFocus,
            maxLines: 5,
            maxLength: 500,
            decoration: InputDecoration(
              hintText:
                  'Ceritakan pengalaman servis Anda di bengkel ini...',
              hintStyle: TextStyle(
                color: AppColors.ink.withValues(alpha: 0.35),
                fontSize: 13,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              counterStyle: TextStyle(
                color: AppColors.ink.withValues(alpha: 0.4),
                fontSize: 11,
              ),
            ),
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocBuilder<ReviewBloc, ReviewState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brand,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            onPressed:
                state.isSubmitting ? null : () => _onSubmit(context),
            child: state.isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    'Kirim Ulasan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
