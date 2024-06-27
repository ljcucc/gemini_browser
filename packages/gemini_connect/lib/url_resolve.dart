import 'package:path/path.dart' as p;

/// override URI field if it's empty
Uri uriOverride(
  Uri original,
  Uri overrider, {
  bool forceOverrideQuery = false,
}) {
  return Uri(
    scheme: overrider.scheme.isNotEmpty ? overrider.scheme : original.scheme,
    host: overrider.host.isNotEmpty ? overrider.host : original.host,
    path: overrider.path.isNotEmpty ? overrider.path : original.path,
    query: overrider.query.isNotEmpty || forceOverrideQuery
        ? overrider.query
        : original.query,
  );
}

/// navigate to path based on basePath.
/// basePath is a absolute path.
/// used for links
String navigateToPath(String basePath, String path) {
  if (basePath.isEmpty || p.isAbsolute(path)) {
    return path;
  }

  /// if basePath contains filename
  if (p.extension(basePath).isNotEmpty) {
    var paths = p.split(basePath);
    paths.removeLast();
    basePath = p.joinAll(paths);
  }

  return p.normalize(p.join(basePath, path));
}
