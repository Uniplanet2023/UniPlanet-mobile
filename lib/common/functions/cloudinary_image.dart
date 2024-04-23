String cloudinaryTransformImage(String url,
    {int width = 150, int height = 150}) {
  Uri uri = Uri.parse(url);
  List<String> pathSegments = uri.pathSegments.toList();

  // Insert transformation command right after 'upload'
  int uploadIndex = pathSegments.indexOf('upload') + 1;
  pathSegments.insert(uploadIndex, 'f_auto,q_auto,c_fill,w_$width,h_$height');

  // Recreate the URL with the new path
  return uri.replace(pathSegments: pathSegments).toString();
}
