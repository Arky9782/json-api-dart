import 'package:json_api_document/src/attributes.dart';
import 'package:json_api_document/src/identifier.dart';
import 'package:json_api_document/src/link.dart';
import 'package:json_api_document/src/meta.dart';
import 'package:json_api_document/src/naming.dart';
import 'package:json_api_document/src/relationship.dart';

class Resource {
  final String type;
  final String id;
  final Attributes attributes;
  final Link self;
  final Meta meta;
  final Map<String, Relationship> _relationships;

  Resource(String this.type, String this.id,
      {Map<String, dynamic> attributes,
      Link this.self,
      Map<String, dynamic> meta,
      Map<String, Relationship> relationships = const {}})
      : meta = Meta.fromJson(meta),
        attributes = Attributes.fromJson(attributes),
        _relationships = relationships {
    if (id != null && id.isEmpty) throw ArgumentError();
    (const Naming()).enforce(type);
  }

  toJson() {
    final Map<String, dynamic> j = {'type': type};
    if (id != null) j['id'] = id;
    if (attributes != null) j['attributes'] = attributes;
    if (meta != null) j['meta'] = meta;
    if (self != null) j['links'] = {'self': self};
    if (_relationships.isNotEmpty) j['relationships'] = _relationships;

    return j;
  }

  bool identifies(Resource resource) =>
      _relationships.values.any((rel) => rel.identifies(resource));

  bool isIdentifiedBy(Identifier identifier) => identifier.identifies(this);
}
