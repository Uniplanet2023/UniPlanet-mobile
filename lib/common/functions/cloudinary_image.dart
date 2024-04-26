String cloudinaryTransformImage(String url, {int? width, int? height}) {
  Uri uri = Uri.parse(url);
  List<String> pathSegments = uri.pathSegments.toList();

  // Insert transformation command right after 'upload'
  int uploadIndex = pathSegments.indexOf('upload') + 1;
  if (width == null && height == null) {
    pathSegments.insert(uploadIndex, 'f_auto,q_auto');
  } else if (width != null && height == null) {
    pathSegments.insert(uploadIndex, 'w_$width,f_auto,q_auto');
  } else if (width == null && height != null) {
    pathSegments.insert(uploadIndex, 'h_$height,f_auto,q_auto');
  } else {
    pathSegments.insert(uploadIndex, 'w_$width,h_$height,f_auto,q_auto');
  }

  // Recreate the URL with the new path
  return uri.replace(pathSegments: pathSegments).toString();
}
