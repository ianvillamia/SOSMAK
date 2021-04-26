class BarGraphModel {
  final int value;
  final String valDescription;
  final String valColor;
  BarGraphModel(this.value, this.valDescription, this.valColor);

  BarGraphModel.fromMap(Map<String, dynamic> map)
      : assert(map['value'] != null),
        assert(map['valDescription'] != null),
        assert(map['valColor'] != null),
        value = map['value'],
        valColor = map['valColor'],
        valDescription = map['valDescription'];

  @override
  String toString() => "Record<$value:$valDescription:$valColor>";
}
