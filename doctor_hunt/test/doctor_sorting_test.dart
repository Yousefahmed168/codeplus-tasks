import 'package:doctor_hunt/core/enums/doctor_sort.dart';
import 'package:doctor_hunt/core/models/doctor.dart';
import 'package:doctor_hunt/core/utils/doctor_sorting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Doctor doctor(String name, {double? rating, int reviews = 0}) =>
      Doctor(name: name, rating: rating, reviewsCount: reviews);

  group('sortDoctors', () {
    test('popular orders by reviews, then rating, then name', () {
      final result = sortDoctors([
        doctor('C', rating: 4.0, reviews: 2),
        doctor('A', rating: 5.0, reviews: 9),
        doctor('B', rating: 4.9, reviews: 2),
        doctor('D', rating: null, reviews: 2),
      ], DoctorSort.popular);

      expect(result.map((d) => d.name), ['A', 'B', 'C', 'D']);
    });

    test('top rated orders by rating, then reviews, then name', () {
      final result = sortDoctors([
        doctor('C', rating: 4.0, reviews: 10),
        doctor('B', rating: 5.0, reviews: 2),
        doctor('A', rating: 5.0, reviews: 7),
        doctor('D', rating: null, reviews: 20),
      ], DoctorSort.topRated);

      expect(result.map((d) => d.name), ['A', 'B', 'C', 'D']);
    });

    test('treats a missing rating as zero', () {
      final result = sortDoctors([
        doctor('none'),
        doctor('rated', rating: 1),
      ], DoctorSort.topRated);

      expect(result.map((d) => d.name), ['rated', 'none']);
    });

    test('does not mutate the input list', () {
      final input = [doctor('A', reviews: 1), doctor('B', reviews: 2)];

      final result = sortDoctors(input, DoctorSort.popular);

      expect(input.map((d) => d.name), ['A', 'B']);
      expect(result, isNot(same(input)));
    });
  });
}
