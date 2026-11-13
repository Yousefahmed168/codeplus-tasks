/// Sort orders used by the patient-facing doctor lists.
enum DoctorSort {
  /// Most reviewed first (Home "Popular Doctors").
  popular('popular'),

  /// Highest rated first (Home "Top Rated Doctors").
  topRated('topRated');

  const DoctorSort(this.queryValue);

  /// Value carried by the `sort` query parameter of the search route.
  final String queryValue;

  static DoctorSort? fromQuery(String? value) {
    for (final sort in DoctorSort.values) {
      if (sort.queryValue == value) return sort;
    }
    return null;
  }
}
