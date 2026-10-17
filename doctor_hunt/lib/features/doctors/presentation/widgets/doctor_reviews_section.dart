import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/models/review_model.dart';
import '../../../../core/services/appointment_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../../../i18n/strings.g.dart';

/// Rating summary plus the most recent patient reviews for a doctor.
class DoctorReviewsSection extends StatelessWidget {
  const DoctorReviewsSection({
    super.key,
    required this.doctorId,
    required this.rating,
    required this.reviewsCount,
  });

  final String doctorId;
  final double rating;
  final int reviewsCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.doctorDetails.reviewsTitle, style: context.bold18.textPrimary),
        12.verticalSpace,
        _RatingSummary(rating: rating, reviewsCount: reviewsCount),
        12.verticalSpace,
        StreamBuilder<List<ReviewModel>>(
          stream: sl<AppointmentService>().streamReviewsForDoctor(doctorId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const _ReviewsShimmer();
            }
            final reviews = snapshot.data ?? const <ReviewModel>[];
            if (snapshot.hasError || reviews.isEmpty) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  t.doctorDetails.noReviews,
                  style: context.regular14.textSecondary,
                ),
              );
            }
            return Column(
              children: [
                for (final review in reviews) ...[
                  _ReviewTile(review: review),
                  12.verticalSpace,
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _RatingSummary extends StatelessWidget {
  const _RatingSummary({required this.rating, required this.reviewsCount});

  final double rating;
  final int reviewsCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 12.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: context.bold28.textPrimary,
          ),
          12.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RatingStars(rating: rating, size: 18),
              4.verticalSpace,
              Text(
                t.doctorDetails.reviewsCount(count: reviewsCount),
                style: context.regular12.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    final name = StringUtils.maskName(review.patientName ?? '');
    final date = review.createdAt != null
        ? DateFormat('d MMM yyyy').format(review.createdAt!)
        : '';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name.isEmpty ? t.doctorDetails.patient : name,
                  style: context.semiBold14.textPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (date.isNotEmpty)
                Text(date, style: context.regular11.textHint),
            ],
          ),
          6.verticalSpace,
          RatingStars(rating: review.rating, size: 14),
          if (review.comment.trim().isNotEmpty) ...[
            8.verticalSpace,
            Text(review.comment, style: context.regular12.textSecondary),
          ],
        ],
      ),
    );
  }
}

class _ReviewsShimmer extends StatelessWidget {
  const _ReviewsShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.surface,
      child: Column(
        children: [
          for (var i = 0; i < 2; i++) ...[
            Container(
              height: 80.h,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            12.verticalSpace,
          ],
        ],
      ),
    );
  }
}
