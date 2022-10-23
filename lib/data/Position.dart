import 'dart:ui';

class Position {
  double x;
  double y;

  Position(this.x, this.y);

  Position.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'];

  @override
  String toString() {
    return '{ x: $x, y: $y }';
  }

  Map<String, dynamic> toJson() => {"x": x, "y": y};
}
