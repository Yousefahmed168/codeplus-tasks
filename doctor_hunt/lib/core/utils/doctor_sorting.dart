import '../enums/doctor_sort.dart';
import '../models/doctor.dart';

/// Returns a sorted copy of [doctors] for the given [sort] order.
///
/// Popularity is driven by review count, top-rated by rating. Ties are broken
/// deterministically so the lists stay stable between rebuilds.
List<Doctor> sortDoctors(Iterable<Doctor> doctors, DoctorSort sort) {
  final sorted = [...doctors];

  switch (sort) {
    case DoctorSort.popular:
      sorted.sort((a, b) {
        final byReviews = b.reviewsCount.compareTo(a.reviewsCount);
        if (byReviews != 0) return byReviews;

        final byRating = _ratingOf(b).compareTo(_ratingOf(a));
        if (byRating != 0) return byRating;

        return _nameOf(a).compareTo(_nameOf(b));
      });
    case DoctorSort.topRated:
      sorted.sort((a, b) {
        final byRating = _ratingOf(b).compareTo(_ratingOf(a));
        if (byRating != 0) return byRating;

        final byReviews = b.reviewsCount.compareTo(a.reviewsCount);
        if (byReviews != 0) return byReviews;

        return _nameOf(a).compareTo(_nameOf(b));
      });
  }

  return sorted;
}

double _ratingOf(Doctor doctor) => doctor.rating ?? 0;

String _nameOf(Doctor doctor) => (doctor.name ?? '').toLowerCase();
