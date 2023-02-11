class Message<T> {
  String type;
  T data;

  Message({
    required this.type,
    required this.data
  });

  Map<String, Object?> toJson() => {
    'type': type,
    'data': data
  };
}