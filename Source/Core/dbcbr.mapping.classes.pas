{
      ORM Brasil é um ORM simples e descomplicado para quem utiliza Delphi

                   Copyright (c) 2016, Isaque Pinheiro
                          All rights reserved.
                    GNU Lesser General Public License
                      Versão 3, 29 de junho de 2007

       Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
       A todos é permitido copiar e distribuir cópias deste documento de
       licença, mas mudá-lo não é permitido.

       Esta versão da GNU Lesser General Public License incorpora
       os termos e condições da versão 3 da GNU General Public License
       Licença, complementado pelas permissões adicionais listadas no
       arquivo LICENSE na pasta principal.
}
{
  @abstract(ORMBr Framework.)
  @created(20 Jul 2016)
  @author(Isaque Pinheiro <isaquepsp@gmail.com>)
  @abstract(Website : http://www.ormbr.com.br)
  @abstract(Telagram : https://t.me/ormbr)
}

unit dbcbr.mapping.classes;

interface

uses
  DB,
  Classes,
  TypInfo,
  Rtti,
  SysUtils,
  Generics.Collections,
  dbcbr.mapping.attributes,
  dbcbr.types.mapping;

type
  TMappingDescription = class abstract
  protected
    FDescription: String;
  public
    property Description: String read FDescription write FDescription;
  end;

  // TableMapping
  TTableMapping = class(TMappingDescription)
  private
    FName: String;
    FSchema: String;
  public
    property Name: String read FName write FName;
    property Schema: String read FSchema write FSchema;
  end;

  // OrderByMapping
  TOrderByMapping = class
  private
    FColumnsName: String;
  public
    property ColumnsName: String read FColumnsName write FColumnsName;
  end;

  TSequenceMapping = class(TMappingDescription)
  private
    FTableName: String;
    FName: String;
    FInitial: Integer;
    FIncrement: Integer;
  public
    property TableName: String read FTableName write FTableName;
    property Name: String read FName write FName;
    property Initial: Integer read FInitial write FInitial;
    property Increment: Integer read FIncrement write FIncrement;
  end;

  // TriggerMapping
  TTriggerMapping = class(TMappingDescription)
  private
    FName: String;
    FScript: String;
  public
    constructor Create(const AName, AScript: String);
    property Name: String read FName;
    property Script: String read FScript;
  end;
  // ColumnMappingList
  TTriggerMappingList = class(TObjectList<TTriggerMapping>);

  // ColumnMapping
  TColumnMapping = class(TMappingDescription)
  private
    FColumnName: String;
    FFieldType: TFieldType;
    FScale: Integer;
    FSize: Integer;
    FPrecision: Integer;
    FFieldIndex: Integer;
    FDefaultValue: String;
    FIsNoInsert: Boolean;
    FIsNotNull: Boolean;
    FIsCheck: Boolean;
    FIsUnique: Boolean;
    FIsJoinColumn: Boolean;
    FIsHidden: Boolean;
    FIsNoUpdate: Boolean;
    FIsPrimaryKey: Boolean;
    FIsNoValidate: Boolean;
    FIsNullable: Boolean;
    FIsLazy: Boolean;
    FIsVirtualData: Boolean;
    FProperty: TRttiProperty;
    FDictionary: Dictionary;
    FIsCalcField: Boolean;
  public
    property FieldIndex: Integer read FFieldIndex write FFieldIndex;
    property ColumnName: String read FColumnName write FColumnName;
    property FieldType: TFieldType read FFieldType write FFieldType;
    property Scale: Integer read FScale write FScale;
    property Size: Integer read FSize write FSize;
    property Precision: Integer read FPrecision write FPrecision;
    property DefaultValue: String read FDefaultValue write FDefaultValue;
    property IsNoInsert: Boolean read FIsNoInsert write FIsNoInsert;
    property IsNotNull: Boolean read FIsNotNull write FIsNotNull;
    property IsCheck: Boolean read FIsCheck write FIsCheck;
    property IsUnique: Boolean read FIsUnique write FIsUnique;
    property IsJoinColumn: Boolean read FIsJoinColumn write FIsJoinColumn;
    property IsNoUpdate: Boolean read FIsNoUpdate write FIsNoUpdate;
    property IsPrimaryKey: Boolean read FIsPrimaryKey write FIsPrimaryKey;
    property IsNoValidate: Boolean read FIsNoValidate write FIsNoValidate;
    property IsHidden: Boolean read FIsHidden write FIsHidden;
    property IsNullable: Boolean read FIsNullable write FIsNullable;
    property IsLazy: Boolean read FIsLazy write FIsLazy;
    property IsCalcField: Boolean read FIsCalcField write FIsCalcField;
    property IsVirtualData: Boolean read FIsVirtualData write FIsVirtualData;
    property ColumnProperty: TRttiProperty read FProperty write FProperty;
    property ColumnDictionary: Dictionary read FDictionary write FDictionary;
  end;

  // ColumnMappingList
  TColumnMappingList = class(TObjectList<TColumnMapping>);
  TCalcFieldMapping = class(TMappingDescription)
  private
    FFieldName: String;
    FFieldType: TFieldType;
    FSize: Integer;
    FIsHidden: Boolean;
    FProperty: TRttiProperty;
    FDictionary: Dictionary;
  public
    property FieldName: String read FFieldName write FFieldName;
    property FieldType: TFieldType read FFieldType write FFieldType;
    property Size: Integer read FSize write FSize;
    property IsHidden: Boolean read FIsHidden write FIsHidden;
    property CalcProperty: TRttiProperty read FProperty write FProperty;
    property CalcDictionary: Dictionary read FDictionary write FDictionary;
  end;

  // ColumnMappingList
  TCalcFieldMappingList = class(TObjectList<TCalcFieldMapping>);

  // AssociationMapping
  TAssociationMapping = class
  private
    FMultiplicity: TMultiplicity;
    FColumnsName: TList<String>;
    FColumnsNameRef: TList<String>;
    FClassNameRef: String;
    FLazy: Boolean;
    FProperty: TRttiProperty;
    FCascadeActions: TCascadeActions;
  public
    constructor Create(const AMultiplicity: TMultiplicity;
      const AColumnsName, AColumnsNameRef: TArray<String>;
      const AClassNameRef: String;
      const AProperty: TRttiProperty;
      const ALazy: Boolean;
      const ACascadeActions: TCascadeActions);
    destructor Destroy; override;
    property Multiplicity: TMultiplicity read FMultiplicity;
    property ColumnsName: TList<String> read FColumnsName;
    property ColumnsNameRef: TList<String> read FColumnsNameRef;
    property ClassNameRef: String read FClassNameRef;
    property Lazy: Boolean read FLazy;
    property PropertyRtti: TRttiProperty read FProperty;
    property CascadeActions: TCascadeActions read FCascadeActions;
  end;

  // AssociationMappingList
  TAssociationMappingList = class(TObjectList<TAssociationMapping>);

  // PrimaryKeyMapping
  TPrimaryKeyMapping = class(TMappingDescription)
  private
    FName: String;
    FColumns: TList<String>;
    FSortingOrder: TSortingOrder;
    FUnique: Boolean;
    FAutoIncrement: Boolean;
    FGeneratorType: TGeneratorType;
//    FSequenceIncrement: Boolean;
//    FTableIncrement: Boolean;
//    FGuidIncrement: Boolean;
  public
    constructor Create(const AColumns: TArray<String>;
      const AAutoInc: Boolean;
//      const ASequenceInc: Boolean;
//      const ATableInc: Boolean;
//      const AGuidInc: Boolean;
      const AGeneratorType: TGeneratorType;
      const ASortingOrder: TSortingOrder;
      const AUnique: Boolean;
      const ADescription: String = '');
    destructor Destroy; override;
    property Name: String read FName;
    property Columns: TList<String> read FColumns;
    property SortingOrder: TSortingOrder read FSortingOrder;
    property Unique: Boolean read FUnique;
    property AutoIncrement: Boolean read FAutoIncrement;
//    property SequenceIncrement: Boolean read FSequenceIncrement;
//    property TableIncrement: Boolean read FTableIncrement;
//    property GuidIncrement: Boolean read FGuidIncrement;
    property GeneratorType: TGeneratorType read FGeneratorType;
  end;

  // IndexeMapping
  TPrimaryKeyColumnsMapping = class(TMappingDescription)
  private
    FColumns: TList<TColumnMapping>;
  public
    constructor Create;
    destructor Destroy; override;
    property Columns: TList<TColumnMapping> read FColumns;
  end;

  // PrimaryKeyMapping
  TIndexeMapping = class(TPrimaryKeyMapping)
  public
    constructor Create(const AName: String; const AColumns: TArray<String>;
      const ASortingOrder: TSortingOrder;
      const AUnique: Boolean;
      const ADescription: String = '');
  end;

  // IndexeMappingList
  TIndexeMappingList = class(TObjectList<TIndexeMapping>);

  // CheckMapping
  TCheckMapping = class(TMappingDescription)
  private
    FName: String;
    FCondition: String;
  public
    constructor Create(const AName, ACondition, ADescription: String);
    property Name: String read FName;
    property Condition: String read FCondition;
  end;

  // CheckMappingList
  TCheckMappingList = class(TObjectList<TCheckMapping>);

  // RestrictionMapping
  TRestrictionMapping = class
  private
    FRestrictions: TRestrictions;
  public
    constructor Create(ARestrictions: TRestrictions);
    property Restrictions: TRestrictions read FRestrictions;
  end;

  // RestrictionMappingList
  TRestrictionMappingList = class(TObjectList<TRestrictionMapping>);

  // ForeignKeyKeyMapping
  TForeignKeyMapping = class(TMappingDescription)
  private
    FName: String;
    FTableNameRef: String;
    FFromColumns: TList<String>;
    FToColumns: TList<String>;
    FRuleUpdate: TRuleAction;
    FRuleDelete: TRuleAction;
  public
    constructor Create(const AName, ATableNameRef: String;
      const AFromColumns, AToColumns: TArray<String>;
      const ARuleDelete, ARuleUpdate: TRuleAction;
      const ADescription: String = '');
    destructor Destroy; override;
    property Name: String read FName;
    property TableNameRef: String read FTableNameRef;
    property FromColumns: TList<String> read FFromColumns;
    property ToColumns: TList<String> read FToColumns;
    property RuleDelete: TRuleAction read FRuleDelete;
    property RuleUpdate: TRuleAction read FRuleUpdate;
  end;

  // ForeignKeyMappingList
  TForeignKeyMappingList = class(TObjectList<TForeignKeyMapping>);

  // JoinColumnMapping
  TJoinColumnMapping = class
  private
    FColumnName: String;
    FRefTableName: String;
    FRefColumnName: String;
    FRefColumnNameSelect: String;
    FJoin: TJoin;
    FAliasColumn: String;
    FAliasRefTable: String;
  public
    constructor Create(const AColumnName, ARefTableName, ARefColumnName,
      ARefColumnNameSelect: String; const AJoin: TJoin;
      const AAliasColumn: String; const AAliasRefTable: String);
    property ColumnName: String read FColumnName;
    property RefColumnName: String read FRefColumnName;
    property RefTableName: String read FRefTableName;
    property RefColumnNameSelect: String read FRefColumnNameSelect;
    property Join: TJoin read FJoin;
    property AliasColumn: String read FAliasColumn;
    property AliasRefTable: String read FAliasRefTable;
  end;

  // JoinColumnMappingList
  TJoinColumnMappingList = class(TObjectList<TJoinColumnMapping>);

  TEnumerationMapping = class
  private
    FOrdinalType: TRttiOrdinalType;
    FEnumType: TEnumType;
    FEnumValues: TList<String>;
  public
    constructor Create(AOrdinalType: TRttiOrdinalType; AEnumType: TEnumType;
      AEnumValues: TList<Variant>);
    destructor Destroy; override;
    property OrdinalType: TRttiOrdinalType read FOrdinalType;
    property EnumType: TEnumType read FEnumType;
    property EnumValues: TList<String> read FEnumValues;
  end;

  // EnumerationMappingList
  TEnumerationMappingList = class(TObjectList<TEnumerationMapping>);

  // ViewMapping
  TViewMapping = class(TMappingDescription)
  private
    FName: String;
    FScript: String;
  public
    property Name: String read FName write FName;
    property Script: String read FScript write FScript;
  end;
  TFieldEventsMapping = class
  private
    FFieldName: String;
    FFieldEvents: TFieldEvents;
  public
    constructor Create(const AFieldName: String;
      const AFieldEvents: TFieldEvents);
    property FieldName: String read FFieldName;
    property Events: TFieldEvents read FFieldEvents;
  end;

  // FieldEventsMappingList
  TFieldEventsMappingList = class(TObjectList<TFieldEventsMapping>);

  TLazyMapping = class
  private
    FFieldLazy: TRttiField;
  public
    constructor Create(const AFieldLazy: TRttiField);
    property FieldLazy: TRttiField read FFieldLazy;
  end;

implementation

{ TOneToOneRelationMapping }

constructor TAssociationMapping.Create(const AMultiplicity: TMultiplicity;
  const AColumnsName, AColumnsNameRef: TArray<String>;
  const AClassNameRef: String;
  const AProperty: TRttiProperty;
  const ALazy: Boolean;
  const ACascadeActions: TCascadeActions);
var
  LFor: Integer;
begin
  FMultiplicity := AMultiplicity;
  FClassNameRef := AClassNameRef;
  FProperty := AProperty;
  FLazy := ALazy;
  FCascadeActions := ACascadeActions;
  // ColumnsName
  FColumnsName := TList<String>.Create;
  if Length(AColumnsName) > 0 then
  begin
    for LFor := Low(AColumnsName) to High(AColumnsName) do
      FColumnsName.Add(AColumnsName[LFor]);
  end;
  // ColumnsNameRef
  FColumnsNameRef := TList<String>.Create;
  if Length(AColumnsNameRef) > 0 then
  begin
    for LFor := Low(AColumnsNameRef) to High(AColumnsNameRef) do
      FColumnsNameRef.Add(AColumnsNameRef[LFor]);
  end;
end;

destructor TAssociationMapping.Destroy;
begin
  FColumnsName.Free;
  FColumnsNameRef.Free;
  inherited;
end;

{ TPrimaryKeyMapping }

constructor TPrimaryKeyMapping.Create(const AColumns: TArray<String>;
  const AAutoInc: Boolean;
//  const ASequenceInc: Boolean;
//  const ATableInc: Boolean;
//  const AGuidInc: Boolean;
  const AGeneratorType: TGeneratorType;
  const ASortingOrder: TSortingOrder;
  const AUnique: Boolean;
  const ADescription: String);
var
  iFor: Integer;
begin
  FName := 'PK_';
  FColumns := TList<String>.Create;
  FSortingOrder := ASortingOrder;
  FUnique := AUnique;
  FAutoIncrement := AAutoInc;
  FGeneratorType := AGeneratorType;
//  FSequenceIncrement := ASequenceInc;
//  FTableIncrement := ATableInc;
//  FGuidIncrement := AGuidInc;
  FDescription := ADescription;
  if Length(AColumns) > 0 then
  begin
    for iFor := Low(AColumns) to High(AColumns) do
      FColumns.Add(Trim(AColumns[iFor]));
  end;
end;

destructor TPrimaryKeyMapping.Destroy;
begin
  FColumns.Free;
  inherited;
end;

{ TIndexMapping }

constructor TIndexeMapping.Create(const AName: String;
  const AColumns: TArray<String>;
  const ASortingOrder: TSortingOrder;
  const AUnique: Boolean;
  const ADescription: String);
var
  iFor: Integer;
begin
  FColumns := TList<String>.Create;
  FName := AName;
  FSortingOrder := ASortingOrder;
  FUnique := AUnique;
  FDescription := ADescription;
  if Length(AColumns) > 0 then
  begin
    for iFor := Low(AColumns) to High(AColumns) do
      FColumns.Add(Trim(AColumns[iFor]));
  end;
end;

{ TJoinColumnMapping }

constructor TJoinColumnMapping.Create(const AColumnName, ARefTableName,
  ARefColumnName, ARefColumnNameSelect: String; const AJoin: TJoin;
  const AAliasColumn: String; const AAliasRefTable: String);
begin
  FColumnName := AColumnName;
  FRefTableName := ARefTableName;
  FRefColumnName := ARefColumnName;
  FRefColumnNameSelect := ARefColumnNameSelect;
  FJoin := AJoin;
  FAliasColumn := AAliasColumn;
  FAliasRefTable := AAliasRefTable;
end;

{ TForeignKeyMapping }

constructor TForeignKeyMapping.Create(const AName, ATableNameRef: String;
  const AFromColumns, AToColumns: TArray<String>;
  const ARuleDelete, ARuleUpdate: TRuleAction; const ADescription: String);
var
  iFor: Integer;
begin
  if Length(AName) = 0 then
    FName := Format('FK_%s_%s', [ATableNameRef, AFromColumns[0]])
  else
    FName := AName;
  FTableNameRef := ATableNameRef;
  FRuleDelete := ARuleDelete;
  FRuleUpdate := ARuleUpdate;
  FDescription := ADescription;
  // FromColumns
  FFromColumns := TList<String>.Create;
  if Length(AFromColumns) > 0 then
  begin
    for iFor := Low(AFromColumns) to High(AFromColumns) do
      FFromColumns.Add(Trim(AFromColumns[iFor]));
  end;
  // ToColumns
  FToColumns := TList<String>.Create;
  if Length(AToColumns) > 0 then
  begin
    for iFor := Low(AToColumns) to High(AToColumns) do
      FToColumns.Add(Trim(AToColumns[iFor]));
  end;
end;

destructor TForeignKeyMapping.Destroy;
begin
  FFromColumns.Free;
  FToColumns.Free;
  inherited;
end;

{ TTriggerMapping }

constructor TTriggerMapping.Create(const AName, AScript: String);
begin
  FName := AName;
  FScript := AScript;
end;

{ TCheckMapping }

constructor TCheckMapping.Create(const AName, ACondition, ADescription: String);
begin
  FName := AName;
  FCondition := ACondition;
  FDescription := ADescription;
end;

{ TRestrictionMapping }

constructor TRestrictionMapping.Create(ARestrictions: TRestrictions);
begin
  FRestrictions := ARestrictions;
end;

{ TEnumeration }

constructor TEnumerationMapping.Create(AOrdinalType: TRttiOrdinalType;
  AEnumType: TEnumType; AEnumValues: TList<Variant>);
var
  iFor: Integer;
begin
  // EnumValues
  FOrdinalType := AOrdinalType;
  FEnumType := AEnumType;
  FEnumValues := TList<String>.Create;
  if AEnumValues.Count > 0 then
  begin
    for iFor := 0 to AEnumValues.Count -1 do
      FEnumValues.Add(Trim(AEnumValues[iFor]));
  end;
end;

destructor TEnumerationMapping.Destroy;
begin
  FEnumValues.Free;
  inherited;
end;

{ TFieldEvents }

constructor TFieldEventsMapping.Create(const AFieldName: String;
  const AFieldEvents: TFieldEvents);
begin
  FFieldName := AFieldName;
  FFieldEvents := AFieldEvents;
end;

{ TPrimaryKeyColumnsMapping }

constructor TPrimaryKeyColumnsMapping.Create;
begin
  FColumns := TList<TColumnMapping>.Create;
end;

destructor TPrimaryKeyColumnsMapping.Destroy;
begin
  FColumns.Free;
  inherited;
end;

{ TLazyMapping }

constructor TLazyMapping.Create(const AFieldLazy: TRttiField);
begin
  FFieldLazy := AFieldLazy;
end;

end.
