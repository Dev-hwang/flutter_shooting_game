import 'dart:ui';

enum ItemType {
  health,
  energy,
}

class ItemSpec {
  const ItemSpec({
    required this.imageSrc,
    required this.size,
    required this.speed,
    required this.type,
  });

  final String imageSrc;
  final Size size;
  final double speed;
  final ItemType type;
}
