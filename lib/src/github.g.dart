// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssueRequest _$IssueRequestFromJson(Map<String, dynamic> json) => IssueRequest(
      title: json['title'] as String,
      body: json['body'] as String?,
      assignee: json['assignee'] as String?,
      milestone: json['milestone'] as int?,
      labels:
          (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList(),
      assignees: (json['assignees'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$IssueRequestToJson(IssueRequest instance) {
  final val = <String, dynamic>{
    'title': instance.title,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('body', instance.body);
  writeNotNull('assignee', instance.assignee);
  writeNotNull('milestone', instance.milestone);
  writeNotNull('labels', instance.labels);
  writeNotNull('assignees', instance.assignees);
  return val;
}

Label _$LabelFromJson(Map<String, dynamic> json) => Label(
      id: json['id'] as int,
      nodeId: json['node_id'] as String,
      url: json['url'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      color: json['color'] as String,
    );

Map<String, dynamic> _$LabelToJson(Label instance) => <String, dynamic>{
      'id': instance.id,
      'node_id': instance.nodeId,
      'url': instance.url,
      'name': instance.name,
      'description': instance.description,
      'color': instance.color,
    };
