import 'dart:convert' as convert;
import 'dart:io';

enum TestRessourcesData {
  pokeApi._('poke_api.json');

  final String fileName;

  const TestRessourcesData._(this.fileName);

  String get path =>
      '${Directory.current.path}/test/test_ressources/data/$fileName';

  Future<dynamic> jsonDecode() async {
    final json = await File(path).readAsString();
    return convert.jsonDecode(json);
  }
}
