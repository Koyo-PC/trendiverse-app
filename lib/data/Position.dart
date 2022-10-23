import 'dart:ui';

class Position {
  double x;
  double y;
  double z;

  Position(this.x, this.y, this.z);

  @override
  String toString () {
    return '{ x: $x, y: $y, z: $z }';
  }
}
