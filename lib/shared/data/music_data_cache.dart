class MusicDataCache {
  final _cache = <String, List<dynamic>>{};

  List<T>? get<T>(String key) => contains(key) ? _cache[key] as List<T> : null;

  void set(String key, List<dynamic> data) => _cache[key] = data;

  void remove(String key) => _cache.remove(key);

  void clear() => _cache.clear();

  bool contains(String key) => _cache.containsKey(key);

  int size() => _cache.length;
}
