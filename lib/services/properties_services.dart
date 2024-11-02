enum PropertyType { villa, duplex, studio, sleepingEntrance, apartment }

extension PropertyTypeExtension on PropertyType {
  String get displayName {
    switch (this) {
      case PropertyType.villa:
        return 'Villa';
      case PropertyType.duplex:
        return 'Duplex';
      case PropertyType.studio:
        return 'Studio';
      case PropertyType.sleepingEntrance:
        return 'Entrée à coucher';
      case PropertyType.apartment:
        return 'Apartment';
    }
  }

  bool get requiresBedroomCount {
    return this == PropertyType.villa ||
        this == PropertyType.duplex ||
        this == PropertyType.apartment;
  }
}
