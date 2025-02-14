enum MSI {
  msi_3(3),
  msi_6(6),
  msi_9(9),
  msi_12(12);

  final int msi;
  const MSI(this.msi);

  static const _mapMsi = {
    3: MSI.msi_3,
    6: MSI.msi_6,
    9: MSI.msi_9,
    12: MSI.msi_12,
  };

  static MSI? fromString(String msi) {
    final msiInt = int.tryParse(msi) ?? 0;
    return _mapMsi[msiInt];
  }

  static List<MSI> fromListString(List<String>? stringList) {
    if (stringList == null) return [];

    final List<MSI> msiList = [];
    for (String msi in stringList) {
      final MSI? current = fromString(msi);
      if (current != null) {
        msiList.add(current);
      }
    }

    return msiList;
  }
}
