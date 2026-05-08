// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PagesTable extends Pages with TableInfo<$PagesTable, Page> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentJsonMeta =
      const VerificationMeta('contentJson');
  @override
  late final GeneratedColumn<String> contentJson = GeneratedColumn<String>(
      'content_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, projectId, parentId, title, contentJson, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pages';
  @override
  VerificationContext validateIntegrity(Insertable<Page> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content_json')) {
      context.handle(
          _contentJsonMeta,
          contentJson.isAcceptableOrUnknown(
              data['content_json']!, _contentJsonMeta));
    } else if (isInserting) {
      context.missing(_contentJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Page map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Page(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      contentJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_json'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PagesTable createAlias(String alias) {
    return $PagesTable(attachedDatabase, alias);
  }
}

class Page extends DataClass implements Insertable<Page> {
  final String id;
  final String projectId;
  final String? parentId;
  final String title;
  final String contentJson;
  final DateTime updatedAt;
  const Page(
      {required this.id,
      required this.projectId,
      this.parentId,
      required this.title,
      required this.contentJson,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['title'] = Variable<String>(title);
    map['content_json'] = Variable<String>(contentJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PagesCompanion toCompanion(bool nullToAbsent) {
    return PagesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      title: Value(title),
      contentJson: Value(contentJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory Page.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Page(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      title: serializer.fromJson<String>(json['title']),
      contentJson: serializer.fromJson<String>(json['contentJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'parentId': serializer.toJson<String?>(parentId),
      'title': serializer.toJson<String>(title),
      'contentJson': serializer.toJson<String>(contentJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Page copyWith(
          {String? id,
          String? projectId,
          Value<String?> parentId = const Value.absent(),
          String? title,
          String? contentJson,
          DateTime? updatedAt}) =>
      Page(
        id: id ?? this.id,
        projectId: projectId ?? this.projectId,
        parentId: parentId.present ? parentId.value : this.parentId,
        title: title ?? this.title,
        contentJson: contentJson ?? this.contentJson,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Page copyWithCompanion(PagesCompanion data) {
    return Page(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      title: data.title.present ? data.title.value : this.title,
      contentJson:
          data.contentJson.present ? data.contentJson.value : this.contentJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Page(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('parentId: $parentId, ')
          ..write('title: $title, ')
          ..write('contentJson: $contentJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projectId, parentId, title, contentJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Page &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.parentId == this.parentId &&
          other.title == this.title &&
          other.contentJson == this.contentJson &&
          other.updatedAt == this.updatedAt);
}

class PagesCompanion extends UpdateCompanion<Page> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String?> parentId;
  final Value<String> title;
  final Value<String> contentJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PagesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.title = const Value.absent(),
    this.contentJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PagesCompanion.insert({
    required String id,
    required String projectId,
    this.parentId = const Value.absent(),
    required String title,
    required String contentJson,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        projectId = Value(projectId),
        title = Value(title),
        contentJson = Value(contentJson),
        updatedAt = Value(updatedAt);
  static Insertable<Page> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? parentId,
    Expression<String>? title,
    Expression<String>? contentJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (parentId != null) 'parent_id': parentId,
      if (title != null) 'title': title,
      if (contentJson != null) 'content_json': contentJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PagesCompanion copyWith(
      {Value<String>? id,
      Value<String>? projectId,
      Value<String?>? parentId,
      Value<String>? title,
      Value<String>? contentJson,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return PagesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      contentJson: contentJson ?? this.contentJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (contentJson.present) {
      map['content_json'] = Variable<String>(contentJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PagesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('parentId: $parentId, ')
          ..write('title: $title, ')
          ..write('contentJson: $contentJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BranchNodesTable extends BranchNodes
    with TableInfo<$BranchNodesTable, BranchNode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BranchNodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _positionJsonMeta =
      const VerificationMeta('positionJson');
  @override
  late final GeneratedColumn<String> positionJson = GeneratedColumn<String>(
      'position_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tagsJsonMeta =
      const VerificationMeta('tagsJson');
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
      'tags_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _connectedPageIdMeta =
      const VerificationMeta('connectedPageId');
  @override
  late final GeneratedColumn<String> connectedPageId = GeneratedColumn<String>(
      'connected_page_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        projectId,
        type,
        label,
        description,
        positionJson,
        tagsJson,
        connectedPageId,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'branch_nodes';
  @override
  VerificationContext validateIntegrity(Insertable<BranchNode> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('position_json')) {
      context.handle(
          _positionJsonMeta,
          positionJson.isAcceptableOrUnknown(
              data['position_json']!, _positionJsonMeta));
    } else if (isInserting) {
      context.missing(_positionJsonMeta);
    }
    if (data.containsKey('tags_json')) {
      context.handle(_tagsJsonMeta,
          tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta));
    }
    if (data.containsKey('connected_page_id')) {
      context.handle(
          _connectedPageIdMeta,
          connectedPageId.isAcceptableOrUnknown(
              data['connected_page_id']!, _connectedPageIdMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BranchNode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BranchNode(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      positionJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}position_json'])!,
      tagsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags_json'])!,
      connectedPageId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}connected_page_id']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BranchNodesTable createAlias(String alias) {
    return $BranchNodesTable(attachedDatabase, alias);
  }
}

class BranchNode extends DataClass implements Insertable<BranchNode> {
  final String id;
  final String projectId;
  final String type;
  final String label;
  final String description;
  final String positionJson;
  final String tagsJson;
  final String? connectedPageId;
  final DateTime updatedAt;
  const BranchNode(
      {required this.id,
      required this.projectId,
      required this.type,
      required this.label,
      required this.description,
      required this.positionJson,
      required this.tagsJson,
      this.connectedPageId,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['type'] = Variable<String>(type);
    map['label'] = Variable<String>(label);
    map['description'] = Variable<String>(description);
    map['position_json'] = Variable<String>(positionJson);
    map['tags_json'] = Variable<String>(tagsJson);
    if (!nullToAbsent || connectedPageId != null) {
      map['connected_page_id'] = Variable<String>(connectedPageId);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BranchNodesCompanion toCompanion(bool nullToAbsent) {
    return BranchNodesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      type: Value(type),
      label: Value(label),
      description: Value(description),
      positionJson: Value(positionJson),
      tagsJson: Value(tagsJson),
      connectedPageId: connectedPageId == null && nullToAbsent
          ? const Value.absent()
          : Value(connectedPageId),
      updatedAt: Value(updatedAt),
    );
  }

  factory BranchNode.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BranchNode(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      type: serializer.fromJson<String>(json['type']),
      label: serializer.fromJson<String>(json['label']),
      description: serializer.fromJson<String>(json['description']),
      positionJson: serializer.fromJson<String>(json['positionJson']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      connectedPageId: serializer.fromJson<String?>(json['connectedPageId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'type': serializer.toJson<String>(type),
      'label': serializer.toJson<String>(label),
      'description': serializer.toJson<String>(description),
      'positionJson': serializer.toJson<String>(positionJson),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'connectedPageId': serializer.toJson<String?>(connectedPageId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BranchNode copyWith(
          {String? id,
          String? projectId,
          String? type,
          String? label,
          String? description,
          String? positionJson,
          String? tagsJson,
          Value<String?> connectedPageId = const Value.absent(),
          DateTime? updatedAt}) =>
      BranchNode(
        id: id ?? this.id,
        projectId: projectId ?? this.projectId,
        type: type ?? this.type,
        label: label ?? this.label,
        description: description ?? this.description,
        positionJson: positionJson ?? this.positionJson,
        tagsJson: tagsJson ?? this.tagsJson,
        connectedPageId: connectedPageId.present
            ? connectedPageId.value
            : this.connectedPageId,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  BranchNode copyWithCompanion(BranchNodesCompanion data) {
    return BranchNode(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      type: data.type.present ? data.type.value : this.type,
      label: data.label.present ? data.label.value : this.label,
      description:
          data.description.present ? data.description.value : this.description,
      positionJson: data.positionJson.present
          ? data.positionJson.value
          : this.positionJson,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      connectedPageId: data.connectedPageId.present
          ? data.connectedPageId.value
          : this.connectedPageId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BranchNode(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('type: $type, ')
          ..write('label: $label, ')
          ..write('description: $description, ')
          ..write('positionJson: $positionJson, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('connectedPageId: $connectedPageId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, projectId, type, label, description,
      positionJson, tagsJson, connectedPageId, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BranchNode &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.type == this.type &&
          other.label == this.label &&
          other.description == this.description &&
          other.positionJson == this.positionJson &&
          other.tagsJson == this.tagsJson &&
          other.connectedPageId == this.connectedPageId &&
          other.updatedAt == this.updatedAt);
}

class BranchNodesCompanion extends UpdateCompanion<BranchNode> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> type;
  final Value<String> label;
  final Value<String> description;
  final Value<String> positionJson;
  final Value<String> tagsJson;
  final Value<String?> connectedPageId;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BranchNodesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.type = const Value.absent(),
    this.label = const Value.absent(),
    this.description = const Value.absent(),
    this.positionJson = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.connectedPageId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BranchNodesCompanion.insert({
    required String id,
    required String projectId,
    required String type,
    required String label,
    this.description = const Value.absent(),
    required String positionJson,
    this.tagsJson = const Value.absent(),
    this.connectedPageId = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        projectId = Value(projectId),
        type = Value(type),
        label = Value(label),
        positionJson = Value(positionJson),
        updatedAt = Value(updatedAt);
  static Insertable<BranchNode> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? type,
    Expression<String>? label,
    Expression<String>? description,
    Expression<String>? positionJson,
    Expression<String>? tagsJson,
    Expression<String>? connectedPageId,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (type != null) 'type': type,
      if (label != null) 'label': label,
      if (description != null) 'description': description,
      if (positionJson != null) 'position_json': positionJson,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (connectedPageId != null) 'connected_page_id': connectedPageId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BranchNodesCompanion copyWith(
      {Value<String>? id,
      Value<String>? projectId,
      Value<String>? type,
      Value<String>? label,
      Value<String>? description,
      Value<String>? positionJson,
      Value<String>? tagsJson,
      Value<String?>? connectedPageId,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return BranchNodesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      type: type ?? this.type,
      label: label ?? this.label,
      description: description ?? this.description,
      positionJson: positionJson ?? this.positionJson,
      tagsJson: tagsJson ?? this.tagsJson,
      connectedPageId: connectedPageId ?? this.connectedPageId,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (positionJson.present) {
      map['position_json'] = Variable<String>(positionJson.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (connectedPageId.present) {
      map['connected_page_id'] = Variable<String>(connectedPageId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BranchNodesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('type: $type, ')
          ..write('label: $label, ')
          ..write('description: $description, ')
          ..write('positionJson: $positionJson, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('connectedPageId: $connectedPageId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BranchEdgesTable extends BranchEdges
    with TableInfo<$BranchEdgesTable, BranchEdge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BranchEdgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fromIdMeta = const VerificationMeta('fromId');
  @override
  late final GeneratedColumn<String> fromId = GeneratedColumn<String>(
      'from_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _toIdMeta = const VerificationMeta('toId');
  @override
  late final GeneratedColumn<String> toId = GeneratedColumn<String>(
      'to_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _conditionMeta =
      const VerificationMeta('condition');
  @override
  late final GeneratedColumn<String> condition = GeneratedColumn<String>(
      'condition', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, projectId, fromId, toId, condition, label];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'branch_edges';
  @override
  VerificationContext validateIntegrity(Insertable<BranchEdge> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('from_id')) {
      context.handle(_fromIdMeta,
          fromId.isAcceptableOrUnknown(data['from_id']!, _fromIdMeta));
    } else if (isInserting) {
      context.missing(_fromIdMeta);
    }
    if (data.containsKey('to_id')) {
      context.handle(
          _toIdMeta, toId.isAcceptableOrUnknown(data['to_id']!, _toIdMeta));
    } else if (isInserting) {
      context.missing(_toIdMeta);
    }
    if (data.containsKey('condition')) {
      context.handle(_conditionMeta,
          condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BranchEdge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BranchEdge(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id'])!,
      fromId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_id'])!,
      toId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_id'])!,
      condition: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condition']),
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label']),
    );
  }

  @override
  $BranchEdgesTable createAlias(String alias) {
    return $BranchEdgesTable(attachedDatabase, alias);
  }
}

class BranchEdge extends DataClass implements Insertable<BranchEdge> {
  final String id;
  final String projectId;
  final String fromId;
  final String toId;
  final String? condition;
  final String? label;
  const BranchEdge(
      {required this.id,
      required this.projectId,
      required this.fromId,
      required this.toId,
      this.condition,
      this.label});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['from_id'] = Variable<String>(fromId);
    map['to_id'] = Variable<String>(toId);
    if (!nullToAbsent || condition != null) {
      map['condition'] = Variable<String>(condition);
    }
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    return map;
  }

  BranchEdgesCompanion toCompanion(bool nullToAbsent) {
    return BranchEdgesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      fromId: Value(fromId),
      toId: Value(toId),
      condition: condition == null && nullToAbsent
          ? const Value.absent()
          : Value(condition),
      label:
          label == null && nullToAbsent ? const Value.absent() : Value(label),
    );
  }

  factory BranchEdge.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BranchEdge(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      fromId: serializer.fromJson<String>(json['fromId']),
      toId: serializer.fromJson<String>(json['toId']),
      condition: serializer.fromJson<String?>(json['condition']),
      label: serializer.fromJson<String?>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'fromId': serializer.toJson<String>(fromId),
      'toId': serializer.toJson<String>(toId),
      'condition': serializer.toJson<String?>(condition),
      'label': serializer.toJson<String?>(label),
    };
  }

  BranchEdge copyWith(
          {String? id,
          String? projectId,
          String? fromId,
          String? toId,
          Value<String?> condition = const Value.absent(),
          Value<String?> label = const Value.absent()}) =>
      BranchEdge(
        id: id ?? this.id,
        projectId: projectId ?? this.projectId,
        fromId: fromId ?? this.fromId,
        toId: toId ?? this.toId,
        condition: condition.present ? condition.value : this.condition,
        label: label.present ? label.value : this.label,
      );
  BranchEdge copyWithCompanion(BranchEdgesCompanion data) {
    return BranchEdge(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      fromId: data.fromId.present ? data.fromId.value : this.fromId,
      toId: data.toId.present ? data.toId.value : this.toId,
      condition: data.condition.present ? data.condition.value : this.condition,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BranchEdge(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('fromId: $fromId, ')
          ..write('toId: $toId, ')
          ..write('condition: $condition, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projectId, fromId, toId, condition, label);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BranchEdge &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.fromId == this.fromId &&
          other.toId == this.toId &&
          other.condition == this.condition &&
          other.label == this.label);
}

class BranchEdgesCompanion extends UpdateCompanion<BranchEdge> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> fromId;
  final Value<String> toId;
  final Value<String?> condition;
  final Value<String?> label;
  final Value<int> rowid;
  const BranchEdgesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.fromId = const Value.absent(),
    this.toId = const Value.absent(),
    this.condition = const Value.absent(),
    this.label = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BranchEdgesCompanion.insert({
    required String id,
    required String projectId,
    required String fromId,
    required String toId,
    this.condition = const Value.absent(),
    this.label = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        projectId = Value(projectId),
        fromId = Value(fromId),
        toId = Value(toId);
  static Insertable<BranchEdge> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? fromId,
    Expression<String>? toId,
    Expression<String>? condition,
    Expression<String>? label,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (fromId != null) 'from_id': fromId,
      if (toId != null) 'to_id': toId,
      if (condition != null) 'condition': condition,
      if (label != null) 'label': label,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BranchEdgesCompanion copyWith(
      {Value<String>? id,
      Value<String>? projectId,
      Value<String>? fromId,
      Value<String>? toId,
      Value<String?>? condition,
      Value<String?>? label,
      Value<int>? rowid}) {
    return BranchEdgesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      fromId: fromId ?? this.fromId,
      toId: toId ?? this.toId,
      condition: condition ?? this.condition,
      label: label ?? this.label,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (fromId.present) {
      map['from_id'] = Variable<String>(fromId.value);
    }
    if (toId.present) {
      map['to_id'] = Variable<String>(toId.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(condition.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BranchEdgesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('fromId: $fromId, ')
          ..write('toId: $toId, ')
          ..write('condition: $condition, ')
          ..write('label: $label, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _resourceTypeMeta =
      const VerificationMeta('resourceType');
  @override
  late final GeneratedColumn<String> resourceType = GeneratedColumn<String>(
      'resource_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _resourceIdMeta =
      const VerificationMeta('resourceId');
  @override
  late final GeneratedColumn<String> resourceId = GeneratedColumn<String>(
      'resource_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, operation, resourceType, resourceId, payloadJson, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('resource_type')) {
      context.handle(
          _resourceTypeMeta,
          resourceType.isAcceptableOrUnknown(
              data['resource_type']!, _resourceTypeMeta));
    } else if (isInserting) {
      context.missing(_resourceTypeMeta);
    }
    if (data.containsKey('resource_id')) {
      context.handle(
          _resourceIdMeta,
          resourceId.isAcceptableOrUnknown(
              data['resource_id']!, _resourceIdMeta));
    } else if (isInserting) {
      context.missing(_resourceIdMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      resourceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}resource_type'])!,
      resourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}resource_id'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final String id;
  final String operation;
  final String resourceType;
  final String resourceId;
  final String payloadJson;
  final DateTime createdAt;
  const SyncQueueData(
      {required this.id,
      required this.operation,
      required this.resourceType,
      required this.resourceId,
      required this.payloadJson,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['operation'] = Variable<String>(operation);
    map['resource_type'] = Variable<String>(resourceType);
    map['resource_id'] = Variable<String>(resourceId);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      operation: Value(operation),
      resourceType: Value(resourceType),
      resourceId: Value(resourceId),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
    );
  }

  factory SyncQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<String>(json['id']),
      operation: serializer.fromJson<String>(json['operation']),
      resourceType: serializer.fromJson<String>(json['resourceType']),
      resourceId: serializer.fromJson<String>(json['resourceId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'operation': serializer.toJson<String>(operation),
      'resourceType': serializer.toJson<String>(resourceType),
      'resourceId': serializer.toJson<String>(resourceId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncQueueData copyWith(
          {String? id,
          String? operation,
          String? resourceType,
          String? resourceId,
          String? payloadJson,
          DateTime? createdAt}) =>
      SyncQueueData(
        id: id ?? this.id,
        operation: operation ?? this.operation,
        resourceType: resourceType ?? this.resourceType,
        resourceId: resourceId ?? this.resourceId,
        payloadJson: payloadJson ?? this.payloadJson,
        createdAt: createdAt ?? this.createdAt,
      );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      operation: data.operation.present ? data.operation.value : this.operation,
      resourceType: data.resourceType.present
          ? data.resourceType.value
          : this.resourceType,
      resourceId:
          data.resourceId.present ? data.resourceId.value : this.resourceId,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('resourceType: $resourceType, ')
          ..write('resourceId: $resourceId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, operation, resourceType, resourceId, payloadJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.operation == this.operation &&
          other.resourceType == this.resourceType &&
          other.resourceId == this.resourceId &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<String> id;
  final Value<String> operation;
  final Value<String> resourceType;
  final Value<String> resourceId;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.operation = const Value.absent(),
    this.resourceType = const Value.absent(),
    this.resourceId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String id,
    required String operation,
    required String resourceType,
    required String resourceId,
    required String payloadJson,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        operation = Value(operation),
        resourceType = Value(resourceType),
        resourceId = Value(resourceId),
        payloadJson = Value(payloadJson),
        createdAt = Value(createdAt);
  static Insertable<SyncQueueData> custom({
    Expression<String>? id,
    Expression<String>? operation,
    Expression<String>? resourceType,
    Expression<String>? resourceId,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operation != null) 'operation': operation,
      if (resourceType != null) 'resource_type': resourceType,
      if (resourceId != null) 'resource_id': resourceId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<String>? id,
      Value<String>? operation,
      Value<String>? resourceType,
      Value<String>? resourceId,
      Value<String>? payloadJson,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      operation: operation ?? this.operation,
      resourceType: resourceType ?? this.resourceType,
      resourceId: resourceId ?? this.resourceId,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (resourceType.present) {
      map['resource_type'] = Variable<String>(resourceType.value);
    }
    if (resourceId.present) {
      map['resource_id'] = Variable<String>(resourceId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('resourceType: $resourceType, ')
          ..write('resourceId: $resourceId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PagesTable pages = $PagesTable(this);
  late final $BranchNodesTable branchNodes = $BranchNodesTable(this);
  late final $BranchEdgesTable branchEdges = $BranchEdgesTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [pages, branchNodes, branchEdges, syncQueue];
}

typedef $$PagesTableCreateCompanionBuilder = PagesCompanion Function({
  required String id,
  required String projectId,
  Value<String?> parentId,
  required String title,
  required String contentJson,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$PagesTableUpdateCompanionBuilder = PagesCompanion Function({
  Value<String> id,
  Value<String> projectId,
  Value<String?> parentId,
  Value<String> title,
  Value<String> contentJson,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$PagesTableFilterComposer extends Composer<_$AppDatabase, $PagesTable> {
  $$PagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentJson => $composableBuilder(
      column: $table.contentJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PagesTableOrderingComposer
    extends Composer<_$AppDatabase, $PagesTable> {
  $$PagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentJson => $composableBuilder(
      column: $table.contentJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PagesTable> {
  $$PagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get contentJson => $composableBuilder(
      column: $table.contentJson, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PagesTable,
    Page,
    $$PagesTableFilterComposer,
    $$PagesTableOrderingComposer,
    $$PagesTableAnnotationComposer,
    $$PagesTableCreateCompanionBuilder,
    $$PagesTableUpdateCompanionBuilder,
    (Page, BaseReferences<_$AppDatabase, $PagesTable, Page>),
    Page,
    PrefetchHooks Function()> {
  $$PagesTableTableManager(_$AppDatabase db, $PagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> projectId = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> contentJson = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PagesCompanion(
            id: id,
            projectId: projectId,
            parentId: parentId,
            title: title,
            contentJson: contentJson,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String projectId,
            Value<String?> parentId = const Value.absent(),
            required String title,
            required String contentJson,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PagesCompanion.insert(
            id: id,
            projectId: projectId,
            parentId: parentId,
            title: title,
            contentJson: contentJson,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PagesTable,
    Page,
    $$PagesTableFilterComposer,
    $$PagesTableOrderingComposer,
    $$PagesTableAnnotationComposer,
    $$PagesTableCreateCompanionBuilder,
    $$PagesTableUpdateCompanionBuilder,
    (Page, BaseReferences<_$AppDatabase, $PagesTable, Page>),
    Page,
    PrefetchHooks Function()>;
typedef $$BranchNodesTableCreateCompanionBuilder = BranchNodesCompanion
    Function({
  required String id,
  required String projectId,
  required String type,
  required String label,
  Value<String> description,
  required String positionJson,
  Value<String> tagsJson,
  Value<String?> connectedPageId,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$BranchNodesTableUpdateCompanionBuilder = BranchNodesCompanion
    Function({
  Value<String> id,
  Value<String> projectId,
  Value<String> type,
  Value<String> label,
  Value<String> description,
  Value<String> positionJson,
  Value<String> tagsJson,
  Value<String?> connectedPageId,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$BranchNodesTableFilterComposer
    extends Composer<_$AppDatabase, $BranchNodesTable> {
  $$BranchNodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get positionJson => $composableBuilder(
      column: $table.positionJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tagsJson => $composableBuilder(
      column: $table.tagsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get connectedPageId => $composableBuilder(
      column: $table.connectedPageId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$BranchNodesTableOrderingComposer
    extends Composer<_$AppDatabase, $BranchNodesTable> {
  $$BranchNodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get positionJson => $composableBuilder(
      column: $table.positionJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tagsJson => $composableBuilder(
      column: $table.tagsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get connectedPageId => $composableBuilder(
      column: $table.connectedPageId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$BranchNodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BranchNodesTable> {
  $$BranchNodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get positionJson => $composableBuilder(
      column: $table.positionJson, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<String> get connectedPageId => $composableBuilder(
      column: $table.connectedPageId, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BranchNodesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BranchNodesTable,
    BranchNode,
    $$BranchNodesTableFilterComposer,
    $$BranchNodesTableOrderingComposer,
    $$BranchNodesTableAnnotationComposer,
    $$BranchNodesTableCreateCompanionBuilder,
    $$BranchNodesTableUpdateCompanionBuilder,
    (BranchNode, BaseReferences<_$AppDatabase, $BranchNodesTable, BranchNode>),
    BranchNode,
    PrefetchHooks Function()> {
  $$BranchNodesTableTableManager(_$AppDatabase db, $BranchNodesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BranchNodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BranchNodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BranchNodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> projectId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> positionJson = const Value.absent(),
            Value<String> tagsJson = const Value.absent(),
            Value<String?> connectedPageId = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BranchNodesCompanion(
            id: id,
            projectId: projectId,
            type: type,
            label: label,
            description: description,
            positionJson: positionJson,
            tagsJson: tagsJson,
            connectedPageId: connectedPageId,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String projectId,
            required String type,
            required String label,
            Value<String> description = const Value.absent(),
            required String positionJson,
            Value<String> tagsJson = const Value.absent(),
            Value<String?> connectedPageId = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BranchNodesCompanion.insert(
            id: id,
            projectId: projectId,
            type: type,
            label: label,
            description: description,
            positionJson: positionJson,
            tagsJson: tagsJson,
            connectedPageId: connectedPageId,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BranchNodesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BranchNodesTable,
    BranchNode,
    $$BranchNodesTableFilterComposer,
    $$BranchNodesTableOrderingComposer,
    $$BranchNodesTableAnnotationComposer,
    $$BranchNodesTableCreateCompanionBuilder,
    $$BranchNodesTableUpdateCompanionBuilder,
    (BranchNode, BaseReferences<_$AppDatabase, $BranchNodesTable, BranchNode>),
    BranchNode,
    PrefetchHooks Function()>;
typedef $$BranchEdgesTableCreateCompanionBuilder = BranchEdgesCompanion
    Function({
  required String id,
  required String projectId,
  required String fromId,
  required String toId,
  Value<String?> condition,
  Value<String?> label,
  Value<int> rowid,
});
typedef $$BranchEdgesTableUpdateCompanionBuilder = BranchEdgesCompanion
    Function({
  Value<String> id,
  Value<String> projectId,
  Value<String> fromId,
  Value<String> toId,
  Value<String?> condition,
  Value<String?> label,
  Value<int> rowid,
});

class $$BranchEdgesTableFilterComposer
    extends Composer<_$AppDatabase, $BranchEdgesTable> {
  $$BranchEdgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromId => $composableBuilder(
      column: $table.fromId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toId => $composableBuilder(
      column: $table.toId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get condition => $composableBuilder(
      column: $table.condition, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));
}

class $$BranchEdgesTableOrderingComposer
    extends Composer<_$AppDatabase, $BranchEdgesTable> {
  $$BranchEdgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromId => $composableBuilder(
      column: $table.fromId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toId => $composableBuilder(
      column: $table.toId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get condition => $composableBuilder(
      column: $table.condition, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));
}

class $$BranchEdgesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BranchEdgesTable> {
  $$BranchEdgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get fromId =>
      $composableBuilder(column: $table.fromId, builder: (column) => column);

  GeneratedColumn<String> get toId =>
      $composableBuilder(column: $table.toId, builder: (column) => column);

  GeneratedColumn<String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);
}

class $$BranchEdgesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BranchEdgesTable,
    BranchEdge,
    $$BranchEdgesTableFilterComposer,
    $$BranchEdgesTableOrderingComposer,
    $$BranchEdgesTableAnnotationComposer,
    $$BranchEdgesTableCreateCompanionBuilder,
    $$BranchEdgesTableUpdateCompanionBuilder,
    (BranchEdge, BaseReferences<_$AppDatabase, $BranchEdgesTable, BranchEdge>),
    BranchEdge,
    PrefetchHooks Function()> {
  $$BranchEdgesTableTableManager(_$AppDatabase db, $BranchEdgesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BranchEdgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BranchEdgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BranchEdgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> projectId = const Value.absent(),
            Value<String> fromId = const Value.absent(),
            Value<String> toId = const Value.absent(),
            Value<String?> condition = const Value.absent(),
            Value<String?> label = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BranchEdgesCompanion(
            id: id,
            projectId: projectId,
            fromId: fromId,
            toId: toId,
            condition: condition,
            label: label,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String projectId,
            required String fromId,
            required String toId,
            Value<String?> condition = const Value.absent(),
            Value<String?> label = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BranchEdgesCompanion.insert(
            id: id,
            projectId: projectId,
            fromId: fromId,
            toId: toId,
            condition: condition,
            label: label,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BranchEdgesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BranchEdgesTable,
    BranchEdge,
    $$BranchEdgesTableFilterComposer,
    $$BranchEdgesTableOrderingComposer,
    $$BranchEdgesTableAnnotationComposer,
    $$BranchEdgesTableCreateCompanionBuilder,
    $$BranchEdgesTableUpdateCompanionBuilder,
    (BranchEdge, BaseReferences<_$AppDatabase, $BranchEdgesTable, BranchEdge>),
    BranchEdge,
    PrefetchHooks Function()>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  required String id,
  required String operation,
  required String resourceType,
  required String resourceId,
  required String payloadJson,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<String> id,
  Value<String> operation,
  Value<String> resourceType,
  Value<String> resourceId,
  Value<String> payloadJson,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resourceType => $composableBuilder(
      column: $table.resourceType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resourceId => $composableBuilder(
      column: $table.resourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resourceType => $composableBuilder(
      column: $table.resourceType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resourceId => $composableBuilder(
      column: $table.resourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get resourceType => $composableBuilder(
      column: $table.resourceType, builder: (column) => column);

  GeneratedColumn<String> get resourceId => $composableBuilder(
      column: $table.resourceId, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> resourceType = const Value.absent(),
            Value<String> resourceId = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            operation: operation,
            resourceType: resourceType,
            resourceId: resourceId,
            payloadJson: payloadJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String operation,
            required String resourceType,
            required String resourceId,
            required String payloadJson,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            operation: operation,
            resourceType: resourceType,
            resourceId: resourceId,
            payloadJson: payloadJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PagesTableTableManager get pages =>
      $$PagesTableTableManager(_db, _db.pages);
  $$BranchNodesTableTableManager get branchNodes =>
      $$BranchNodesTableTableManager(_db, _db.branchNodes);
  $$BranchEdgesTableTableManager get branchEdges =>
      $$BranchEdgesTableTableManager(_db, _db.branchEdges);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}
