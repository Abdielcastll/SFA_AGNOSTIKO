 
 
 T? safeCallback<T, R>(R? value, T Function(R) fallback) {
  return value == null ? null : fallback(value);
}