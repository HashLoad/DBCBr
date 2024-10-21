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
}

unit dbcbr.mapping.attributes;

interface

uses
  DB,
  Rtti,
  Classes,
  SysUtils,
  TypInfo,
  Generics.Collections,
  dbcbr.mapping.exceptions,
  dbcbr.types.mapping;

type
  EFieldNotNull = class(Exception)
  public
    constructor Create(const ADisplayLabel: String);
  end;

  Entity = class(TCustomAttribute)
  private
    FName: String;
    FSchemaName: String;
  public
    constructor Create; overload;
    constructor Create(const AName: String; const ASchemaName: String); overload;
    property Name: String Read FName;
    property SchemaName: String Read FSchemaName;
  end;

  Resource = class(TCustomAttribute)
  private
    FName: String;
  public
    constructor Create(const AName: String);
    property Name: String Read FName;
  end;

  NotServerUse = class(TCustomAttribute)
  public
    constructor Create;
  end;

  SubResource = class(TCustomAttribute)
  private
    FName: String;
  public
    constructor Create(const AName: String);
    property Name: String Read FName;
  end;

  Table = class(TCustomAttribute)
  private
    FName: String;
    FDescription: String;
  public
    constructor Create; overload;
    constructor Create(const AName: String); overload;
    constructor Create(const AName, ADescription: String); overload;
    property Name: String Read FName;
    property Description: String read FDescription;
  end;

  View = class(TCustomAttribute)
  private
    FName: String;
    FDescription: String;
  public
    constructor Create; overload;
    constructor Create(const AName: String); overload;
    constructor Create(const AName, ADescription: String); overload;
    property Name: String Read FName;
    property Description: String read FDescription;
  end;

  Trigger = class(TCustomAttribute)
  private
    FName: String;
    FTableName: String;
    FDescription: String;
  public
    constructor Create; overload;
    constructor Create(const AName, ATableName: String); overload;
    constructor Create(const AName, ATableName, ADescription: String); overload;
    property TableName: String Read FTableName;
    property Name: String Read FName;
    property Description: String read FDescription;
  end;

  Sequence = class(TCustomAttribute)
  private
    FName: String;
    FInitial: Integer;
    FIncrement: Integer;
  public
    constructor Create(const AName: String; const AInitial: Integer = 0;
      const AIncrement: Integer = 1);
    property Name: String read FName;
    property Initial: Integer read FInitial;
    property Increment: Integer read FIncrement;
  end;

  Column = class(TCustomAttribute)
  private
    FColumnName: String;
    FFieldType: TFieldType;
    FScale: Integer;
    FSize: Integer;
    FPrecision: Integer;
    FDescription: String;
  public
    constructor Create(const AColumnName: String;
      const AFieldType: TFieldType;
      const ADescription: String = ''); overload;
    constructor Create(const AColumnName: String;
      const AFieldType: TFieldType;
      const ASize: Integer;
      const ADescription: String = ''); overload;
    constructor Create(const AColumnName: String;
      const AFieldType: TFieldType;
      const APrecision, AScale: Integer;
      const ADescription: String = ''); overload;
    property ColumnName: String read FColumnName;
    property FieldType: TFieldType read FFieldType;
    property Size: Integer read FSize;
    property Scale: Integer read FScale;
    property Precision: Integer read FPrecision;
    property Description: String read FDescription;
  end;

  /// <summary>
  ///   DataSets Attribute
  /// </summary>
  AggregateField = class(TCustomAttribute)
  private
    FFieldName: String;
    FExpression: String;
    FAlignment: TAlignment;
    FDisplayFormat: String;
  public
    constructor Create(const AFieldName, AExpression: String;
      const AAlignment: TAlignment = taLeftJustify;
      const ADisplayFormat: String = '');
    property FieldName: String read FFieldName;
    property Expression: String read FExpression;
    property Alignment: TAlignment read FAlignment;
    property DisplayFormat: String read FDisplayFormat;
  end;

  /// <summary>
  ///   DataSets Attribute
  /// </summary>
  CalcField = class(TCustomAttribute)
  private
    FFieldName: String;
    FFieldType: TFieldType;
    FSize: Integer;
    FHidden: Boolean;
  public
    constructor Create(const AFieldName: String; const AFieldType: TFieldType;
      const ASize: Integer = 0; const AHidden: Boolean = False);
    property FieldName: String read FFieldName;
    property FieldType: TFieldType read FFieldType;
    property Size: Integer read FSize;
    property IsHidden: Boolean read FHidden;
  end;

  /// Association 1:1, 1:N, N:N, N:1
  Association = class(TCustomAttribute)
  private
    FMultiplicity: TMultiplicity;
    FColumnsName: TArray<String>;
    FTabelNameRef: String;
    FColumnsNameRef: TArray<String>;
    FLazy: Boolean;
  public
    constructor Create(const AMultiplicity: TMultiplicity;
      const AColumnsName, ATableNameRef, AColumnsNameRef: String;
      const ALazy: Boolean = False);
    property Multiplicity: TMultiplicity read FMultiplicity;
    property ColumnsName: TArray<String> read FColumnsName;
    property TableNameRef: String read FTabelNameRef;
    property ColumnsNameRef: TArray<String> read FColumnsNameRef;
    property Lazy: Boolean read FLazy;
  end;

  CascadeActions = class(TCustomAttribute)
  private
    FCascadeActions: TCascadeActions;
  public
    constructor Create(const ACascadeActions: TCascadeActions);
    property CascadeActions: TCascadeActions read FCascadeActions;
  end;

  ForeignKey = class(TCustomAttribute)
  private
    FName: String;
    FTableNameRef: String;
    FFromColumns: TArray<String>;
    FToColumns: TArray<String>;
    FRuleUpdate: TRuleAction;
    FRuleDelete: TRuleAction;
    FDescription: String;
  public
    constructor Create(const AName, AFromColumns, ATableNameRef, AToColumns: String;
      const ARuleDelete: TRuleAction = TRuleAction.None;
      const ARuleUpdate: TRuleAction = TRuleAction.None;
      const ADescription: String = ''); overload;
    property Name: String read FName;
    property TableNameRef: String read FTableNameRef;
    property FromColumns: TArray<String> read FFromColumns;
    property ToColumns: TArray<String> read FToColumns;
    property RuleDelete: TRuleAction read FRuleDelete;
    property RuleUpdate: TRuleAction read FRuleUpdate;
    property Description: String read FDescription;
  end;

  PrimaryKey = class(TCustomAttribute)
  private
    FColumns: TArray<String>;
    FSortingOrder: TSortingOrder;
    FUnique: Boolean;
    FAutoIncType: TAutoIncType;
    FGeneratorType: TGeneratorType;
    FDescription: String;
  public
    constructor Create(const AColumns, ADescription: String); overload;
    constructor Create(const AColumns: String;
      const AAutoIncType: TAutoIncType = TAutoIncType.NotInc;
      const ASortingOrder: TSortingOrder = TSortingOrder.NoSort;
      const AUnique: Boolean = False;
      const ADescription: String = ''); overload;
    constructor Create(const AColumns: String;
      const AAutoIncType: TAutoIncType = TAutoIncType.NotInc;
      const AGeneratorType: TGeneratorType = TGeneratorType.NoneInc;
      const ASortingOrder: TSortingOrder = TSortingOrder.NoSort;
      const AUnique: Boolean = False;
      const ADescription: String = ''); overload;
    property Columns: TArray<String> read FColumns;
    property SortingOrder: TSortingOrder read FSortingOrder;
    property Unique: Boolean read FUnique;
    property AutoIncType: TAutoIncType read FAutoIncType;
    property GeneratorType: TGeneratorType read FGeneratorType;
    property Description: String read FDescription;
  end;

  Indexe = class(TCustomAttribute)
  private
    FName: String;
    FColumns: TArray<String>;
    FSortingOrder: TSortingOrder;
    FUnique: Boolean;
    FDescription: String;
  public
    constructor Create(const AName, AColumns, ADescription: String); overload;
    constructor Create(const AName, AColumns: String;
      const ASortingOrder: TSortingOrder = TSortingOrder.NoSort;
      const AUnique: Boolean = False;
      const ADescription: String = ''); overload;
    property Name: String read FName;
    property Columns: TArray<String> read FColumns;
    property SortingOrder: TSortingOrder read FSortingOrder;
    property Unique: Boolean read FUnique;
    property Description: String read FDescription;
  end;

  Check = class(TCustomAttribute)
  private
    FName: String;
    FCondition: String;
    FDescription: String;
  public
    constructor Create(const AName, ACondition: String; const ADescription: String = '');
    property Name: String read FName;
    property Condition: String read FCondition;
    property Description: String read FDescription;
  end;

  // INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN
  JoinColumn = class(TCustomAttribute)
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
      const AAliasColumn, AAliasRefTable: String); overload;
    constructor Create(const AColumnName, ARefTableName, ARefColumnName,
      ARefColumnNameSelect: String; const AJoin: TJoin;
      const AAliasColumn: String); overload;
    constructor Create(const AColumnName, ARefTableName, ARefColumnName,
      ARefColumnNameSelect: String; const AJoin: TJoin = TJoin.InnerJoin); overload;
    property ColumnName: String read FColumnName;
    property RefColumnName: String read FRefColumnName;
    property RefTableName: String read FRefTableName;
    property RefColumnNameSelect: String read FRefColumnNameSelect;
    property Join: TJoin read FJoin;
    property AliasColumn: String read FAliasColumn;
    property AliasRefTable: String read FAliasRefTable;
  end;

  Restrictions = class(TCustomAttribute)
  private
    FRestrictions: TRestrictions;
  public
    constructor Create(const ARestrictions: TRestrictions);
    property Restrictions: TRestrictions read FRestrictions;
  end;

  Dictionary = class(TCustomAttribute)
  private
    FDisplayLabel: String;
    FDefaultExpression: Variant;
    FConstraintErrorMessage: String;
    FDisplayFormat: String;
    FEditMask: String;
    FAlignment: TAlignment;
    FOrigin: String;
  public
    constructor Create(const ADisplayLabel, AConstraintErrorMessage: String); overload;
    constructor Create(const ADisplayLabel, AConstraintErrorMessage,
      ADefaultExpression: String); overload;
    constructor Create(const ADisplayLabel, AConstraintErrorMessage,
      ADefaultExpression, ADisplayFormat: String); overload;
    constructor Create(const ADisplayLabel, AConstraintErrorMessage,
      ADefaultExpression, ADisplayFormat, AEditMask: String); overload;
    constructor Create(const ADisplayLabel, AConstraintErrorMessage,
      ADefaultExpression, ADisplayFormat, AEditMask: String;
      const AAlignment: TAlignment); overload;
    constructor Create(const ADisplayLabel, AConstraintErrorMessage,
      ADefaultExpression, ADisplayFormat, AEditMask: String;
      const AAlignment: TAlignment;
      const AOrigin: String); overload;
    constructor Create(const ADisplayLabel, AConstraintErrorMessage, ADefaultExpression: String;
      const AAlignment: TAlignment); overload;
    constructor Create(const ADisplayLabel, AConstraintErrorMessage: String;
      const AAlignment: TAlignment); overload;
    constructor Create(const ADisplayLabel, AConstraintErrorMessage: String;
      const AAlignment: TAlignment;
      const AOrigin: String); overload;
    // OBJECT
    constructor Create(const ADefaultExpression: String); overload;
    constructor Create(const ADefaultExpression: Integer); overload;
    constructor Create(const ADefaultExpression: Boolean); overload;
    constructor Create(const ADefaultExpression: Char); overload;
    constructor Create(const ADefaultExpression: Cardinal); overload;
    constructor Create(const ADefaultExpression: Int64); overload;
    constructor Create(const ADefaultExpression: UInt64); overload;
    constructor Create(const ADefaultExpression: Extended); overload;
{$IFNDEF NEXTGEN}
    constructor Create(const ADefaultExpression: AnsiChar); overload;
{$ENDIF !NEXTGEN}
    property DisplayLabel: String read FDisplayLabel;
    property ConstraintErrorMessage: String read FConstraintErrorMessage;
    property DefaultExpression: Variant read FDefaultExpression;
    property DisplayFormat: String read FDisplayFormat;
    property EditMask: String read FEditMask;
    property Alignment: TAlignment read FAlignment;
    property Origin: String read FOrigin;
  end;

  OrderBy = class(TCustomAttribute)
  private
    FColumnsName: String;
  public
    constructor Create(const AColumnsName: String);
    property ColumnsName: String read FColumnsName;
  end;

  Enumeration = class(TCustomAttribute)
  private
    FEnumType: TEnumType;
    FEnumValues: TList<Variant>;
    function ValidateEnumValue(const AValue: String): String;
  public
    constructor Create(const AEnumType: TEnumType; const AEnumValues: String);
    destructor Destroy; override;
    property EnumType: TEnumType read FEnumType;
    property EnumValues: TList<Variant> read FEnumValues;
  end;

  FieldEvents = class(TCustomAttribute)
  private
    FFieldEvents: TFieldEvents;
  public
    constructor Create(const AFieldEvents: TFieldEvents);
    property Events: TFieldEvents read FFieldEvents;
  end;

  NotNullConstraint = class(TCustomAttribute)
  public
    constructor Create;
    procedure Validate(const ADisplayLabel: String; const AValue: TValue);
  end;

  MinimumValueConstraint = class(TCustomAttribute)
  private
    FValue: Double;
  public
    constructor Create(const AValue: Double);
    procedure Validate(const ADisplayLabel: String; const AValue: TValue);
  end;

  MaximumValueConstraint = class(TCustomAttribute)
  private
    FValue: Double;
  public
    constructor Create(const AValue: Double);
    procedure Validate(const ADisplayLabel: String; const AValue: TValue);
  end;

  NullIfEmpty = class(TCustomAttribute)
  end;

  NotEmpty = class(TCustomAttribute)
  public
    constructor Create;
    procedure Validate(const AProperty: TRttiProperty; AObject: TObject);
  end;

  Size = class(TCustomAttribute)
  private
    FMin: Integer;
    FMax: Integer;
  public
    constructor create(Max: Integer; Min: Integer = 0);
    procedure Validate(const AProperty: TRttiProperty; AObject: TObject);
  end;

implementation

{ Table }

constructor Table.Create;
begin
  Create('');
end;

constructor Table.Create(const AName: String);
begin
  Create(AName, '');
end;

constructor Table.Create(const AName, ADescription: String);
begin
  FName := AName;
  FDescription := ADescription;
end;

{ View }

constructor View.Create;
begin
  Create('');
end;

constructor View.Create(const AName: String);
begin
  Create(AName, '');
end;

constructor View.Create(const AName, ADescription: String);
begin
  FName := AName;
  FDescription := ADescription;
end;

{ ColumnDictionary }

constructor Dictionary.Create(const ADefaultExpression: String);
begin
  FDefaultExpression := ADefaultExpression;
end;
//
constructor Dictionary.Create(const ADefaultExpression: Cardinal);
begin
  FDefaultExpression := ADefaultExpression;
end;

constructor Dictionary.Create(const ADefaultExpression: Char);
begin
  FDefaultExpression := ADefaultExpression;
end;

constructor Dictionary.Create(const ADefaultExpression: Boolean);
begin
  FDefaultExpression := Ord(ADefaultExpression);
end;

constructor Dictionary.Create(const ADefaultExpression: Integer);
begin
  FDefaultExpression := ADefaultExpression;
end;

{$IFNDEF NEXTGEN}
constructor Dictionary.Create(const ADefaultExpression: AnsiChar);
begin
  FDefaultExpression := ADefaultExpression;
end;
{$ENDIF !NEXTGEN}

constructor Dictionary.Create(const ADefaultExpression: Extended);
begin
  FDefaultExpression := ADefaultExpression;
end;

constructor Dictionary.Create(const ADefaultExpression: UInt64);
begin
  FDefaultExpression := ADefaultExpression;
end;

constructor Dictionary.Create(const ADefaultExpression: Int64);
begin
  FDefaultExpression := ADefaultExpression;
end;

constructor Dictionary.Create(const ADisplayLabel, AConstraintErrorMessage: String);
begin
  FDisplayLabel := ADisplayLabel;
  FConstraintErrorMessage := AConstraintErrorMessage;
end;

constructor Dictionary.Create(const ADisplayLabel, AConstraintErrorMessage,
  ADefaultExpression: String);
begin
  Create(ADisplayLabel, AConstraintErrorMessage);
  FDefaultExpression := ADefaultExpression;
end;

constructor Dictionary.Create(const ADisplayLabel, AConstraintErrorMessage,
  ADefaultExpression, ADisplayFormat: String);
begin
  Create(ADisplayLabel, AConstraintErrorMessage, ADefaultExpression);
  FDisplayFormat := ADisplayFormat;
end;

constructor Dictionary.Create(const ADisplayLabel, AConstraintErrorMessage,
  ADefaultExpression, ADisplayFormat, AEditMask: String;
  const AAlignment: TAlignment);
begin
  Create(ADisplayLabel,
         AConstraintErrorMessage,
         ADefaultExpression,
         ADisplayFormat,
         AEditMask);
  FAlignment := AAlignment;
end;

constructor Dictionary.Create(const ADisplayLabel, AConstraintErrorMessage,
  ADefaultExpression, ADisplayFormat, AEditMask: String);
begin
  Create(ADisplayLabel,
         AConstraintErrorMessage,
         ADefaultExpression,
         ADisplayFormat);
  FEditMask := AEditMask;
end;

constructor Dictionary.Create(const ADisplayLabel, AConstraintErrorMessage: String;
  const AAlignment: TAlignment);
begin
  Create(ADisplayLabel, AConstraintErrorMessage);
  FAlignment := AAlignment;
end;

{ Column }

constructor Column.Create(const AColumnName: String; const AFieldType: TFieldType;
  const ADescription: String);
begin
  Create(AColumnName, AFieldType, 0, ADescription);
end;

constructor Column.Create(const AColumnName: String;
  const AFieldType: TFieldType;
  const ASize: Integer;
  const ADescription: String);
begin
  Create(AColumnName, AFieldType, 0, 0, ADescription);
  FSize := ASize;
end;

constructor Column.Create(const AColumnName: String; const AFieldType: TFieldType;
  const APrecision, AScale: Integer; const ADescription: String);
begin
  FColumnName := AColumnName;
  FFieldType := AFieldType;
  FPrecision := APrecision;
  FScale := AScale;
  FSize := AScale;
  FDescription := ADescription;
end;

{ ColumnRestriction }

constructor Restrictions.Create(const ARestrictions: TRestrictions);
begin
  FRestrictions := ARestrictions;
end;

{ NotNull }

constructor NotNullConstraint.Create;
begin

end;

procedure NotNullConstraint.Validate(const ADisplayLabel: String;
  const AValue: TValue);
begin
  if AValue.AsString = '' then
  begin
     raise EFieldNotNull.Create(ADisplayLabel);
  end;
end;

{ Association }

constructor Association.Create(const AMultiplicity: TMultiplicity;
  const AColumnsName, ATableNameRef, AColumnsNameRef: String;
  const ALazy: Boolean);
var
  rColumns: TStringList;
  iFor: Integer;
begin
  FMultiplicity := AMultiplicity;
  FLazy := ALazy;
  /// ColumnsName
  if Length(AColumnsName) > 0 then
  begin
    rColumns := TStringList.Create;
    try
      rColumns.Duplicates := dupError;
      ExtractStrings([',', ';'], [' '], PChar(AColumnsName), rColumns);
      SetLength(FColumnsName, rColumns.Count);
      for iFor := 0 to rColumns.Count -1 do
        FColumnsName[iFor] := Trim(rColumns[iFor]);
    finally
      rColumns.Free;
    end;
  end;
  FTabelNameRef := ATableNameRef;
  /// ColumnsNameRef
  if Length(AColumnsNameRef) > 0 then
  begin
    rColumns := TStringList.Create;
    try
      rColumns.Duplicates := dupError;
      ExtractStrings([',', ';'], [' '], PChar(AColumnsNameRef), rColumns);
      SetLength(FColumnsNameRef, rColumns.Count);
      for iFor := 0 to rColumns.Count -1 do
        FColumnsNameRef[iFor] := Trim(rColumns[iFor]);
    finally
      rColumns.Free;
    end;
  end;
end;

{ JoinColumn }

constructor JoinColumn.Create(const AColumnName, ARefTableName, ARefColumnName,
  ARefColumnNameSelect: String; const AJoin: TJoin;
  const AAliasColumn, AAliasRefTable: String);
begin
  FColumnName :=  LowerCase(AColumnName);
  FRefTableName := LowerCase(ARefTableName);
  FRefColumnName := LowerCase(ARefColumnName);
  FRefColumnNameSelect := LowerCase(ARefColumnNameSelect);
  FJoin := AJoin;
  FAliasColumn := LowerCase(AAliasColumn);
  FAliasRefTable := LowerCase(AAliasRefTable);
  ///
  if Length(FAliasRefTable) = 0 then
    FAliasRefTable := FRefTableName;
end;

constructor JoinColumn.Create(const AColumnName, ARefTableName, ARefColumnName,
  ARefColumnNameSelect: String; const AJoin: TJoin);
begin
  Create(AColumnName, ARefTableName, ARefColumnName, ARefColumnNameSelect,
         AJoin, '', '');
end;

constructor JoinColumn.Create(const AColumnName, ARefTableName, ARefColumnName,
  ARefColumnNameSelect: String; const AJoin: TJoin; const AAliasColumn: String);
begin
  Create(AColumnName, ARefTableName, ARefColumnName, ARefColumnNameSelect,
         AJoin, AAliasColumn, '');
end;

{ ForeignKey }

constructor ForeignKey.Create(const AName, AFromColumns, ATableNameRef, AToColumns: String;
  const ARuleDelete, ARuleUpdate: TRuleAction;
  const ADescription: String);
var
  rColumns: TStringList;
  iFor: Integer;
begin
  FName := AName;
  FTableNameRef := ATableNameRef;
  if Length(AFromColumns) > 0 then
  begin
    rColumns := TStringList.Create;
    try
      rColumns.Duplicates := dupError;
      ExtractStrings([',', ';'], [' '], PChar(AFromColumns), rColumns);
      SetLength(FFromColumns, rColumns.Count);
      for iFor := 0 to rColumns.Count -1 do
        FFromColumns[iFor] := Trim(rColumns[iFor]);
    finally
      rColumns.Free;
    end;
  end;
  if Length(AToColumns) > 0 then
  begin
    rColumns := TStringList.Create;
    try
      rColumns.Duplicates := dupError;
      ExtractStrings([',', ';'], [' '], PChar(AToColumns), rColumns);
      SetLength(FToColumns, rColumns.Count);
      for iFor := 0 to rColumns.Count -1 do
        FToColumns[iFor] := Trim(rColumns[iFor]);
    finally
      rColumns.Free;
    end;
  end;
  FRuleDelete := ARuleDelete;
  FRuleUpdate := ARuleUpdate;
  FDescription := ADescription;
end;

{ PrimaryKey }

constructor PrimaryKey.Create(const AColumns, ADescription: String);
begin
  Create(AColumns,
         TAutoIncType.NotInc,
         TGeneratorType.SequenceInc,
         TSortingOrder.NoSort,
         False,
         ADescription);
end;

constructor PrimaryKey.Create(const AColumns: String;
  const AAutoIncType: TAutoIncType;
  const ASortingOrder: TSortingOrder;
  const AUnique: Boolean;
  const ADescription: String);
begin
  Create(AColumns,
         AAutoIncType,
         TGeneratorType.NoneInc,
         ASortingOrder,
         AUnique,
         ADescription);
end;

constructor PrimaryKey.Create(const AColumns: String;
  const AAutoIncType: TAutoIncType;
  const AGeneratorType: TGeneratorType;
  const ASortingOrder: TSortingOrder;
  const AUnique: Boolean;
  const ADescription: String);
var
  rColumns: TStringList;
  iFor: Integer;
begin
  if Length(AColumns) > 0 then
  begin
    rColumns := TStringList.Create;
    try
      rColumns.Duplicates := dupError;
      ExtractStrings([',', ';'], [' '], PChar(AColumns), rColumns);
      SetLength(FColumns, rColumns.Count);
      for iFor := 0 to rColumns.Count -1 do
        FColumns[iFor] := Trim(rColumns[iFor]);
    finally
      rColumns.Free;
    end;
  end;
  FAutoIncType := AAutoIncType;
  FGeneratorType := AGeneratorType;
  FSortingOrder := ASortingOrder;
  FUnique := AUnique;
  FDescription := ADescription;
end;

{ Catalog }

constructor Entity.Create(const AName: String; const ASchemaName: String);
begin
  FName := AName;
  FSchemaName := ASchemaName;
end;

constructor Entity.Create;
begin
  Create('','');
end;

{ ZeroConstraint }

constructor MinimumValueConstraint.Create(const AValue: Double);
begin
  FValue := AValue;
end;

procedure MinimumValueConstraint.Validate(const ADisplayLabel: String;
  const AValue: TValue);
begin
  if AValue.AsExtended < FValue then
  begin
    raise EMinimumValueConstraint.Create(ADisplayLabel, FValue);
  end;
end;

{Sequence }

constructor Sequence.Create(const AName: String; const AInitial, AIncrement: Integer);
begin
  FName := AName;
  FInitial := AInitial;
  FIncrement := AIncrement;
end;

{ Trigger }

constructor Trigger.Create;
begin
  Create('','');
end;

constructor Trigger.Create(const AName, ATableName: String);
begin
  Create(AName, ATableName, '')
end;

constructor Trigger.Create(const AName, ATableName, ADescription: String);
begin
  FName := AName;
  FTableName := ATableName;
  FDescription := ADescription;
end;

{ Indexe }

constructor Indexe.Create(const AName, AColumns, ADescription: String);
begin
  Create(AName, AColumns, TSortingOrder.NoSort, False, ADescription);
end;

constructor Indexe.Create(const AName, AColumns: String;
  const ASortingOrder: TSortingOrder;
  const AUnique: Boolean;
  const ADescription: String);
var
  LColumns: TStringList;
  LFor: Integer;
begin
  FName := AName;
  if Length(AColumns) > 0 then
  begin
    LColumns := TStringList.Create;
    try
      LColumns.Duplicates := dupError;
      ExtractStrings([',', ';'], [' '], PChar(AColumns), LColumns);
      SetLength(FColumns, LColumns.Count);
      for LFor := 0 to LColumns.Count -1 do
        FColumns[LFor] := Trim(LColumns[LFor]);
    finally
      LColumns.Free;
    end;
  end;
  FSortingOrder := ASortingOrder;
  FUnique := AUnique;
  FDescription := ADescription;
end;

{ Check }

constructor Check.Create(const AName, ACondition, ADescription: String);
begin
  FName := AName;
  FCondition := ACondition;
  FDescription := ADescription;
end;

{ OrderBy }

constructor OrderBy.Create(const AColumnsName: String);
begin
  FColumnsName := AColumnsName;
end;

{ AggregateField }

constructor AggregateField.Create(const AFieldName, AExpression: String;
  const AAlignment: TAlignment;
  const ADisplayFormat: String);
begin
  FFieldName := AFieldName;
  FExpression := AExpression;
  FAlignment := AAlignment;
  FDisplayFormat := ADisplayFormat;
end;

{ CalcField }

constructor CalcField.Create(const AFieldName: String; const AFieldType: TFieldType;
  const ASize: Integer; const AHidden: Boolean);
begin
  FFieldName := AFieldName;
  FFieldType := AFieldType;
  FSize := ASize;
  FHidden := AHidden;
end;

{ CascadeActions }

constructor CascadeActions.Create(const ACascadeActions: TCascadeActions);
begin
  FCascadeActions := ACascadeActions;
end;

{ Enumeration }

constructor Enumeration.Create(const AEnumType: TEnumType;
  const AEnumValues: String);
var
  LEnumList: TStringList;
  LFor: Integer;
begin
  FEnumType := AEnumType;
  FEnumValues := TList<Variant>.Create;
  LEnumList := TStringList.Create;
  try
    LEnumList.Duplicates := dupError;
    ExtractStrings([',', ';'], [' '], PChar(AEnumValues), LEnumList);
    for LFor := 0 to LEnumList.Count - 1 do
      FEnumValues.Add(ValidateEnumValue(LEnumList[LFor]));
  finally
    LEnumList.Free;
  end;
end;

destructor Enumeration.Destroy;
begin
  FEnumValues.Free;
  inherited;
end;

function Enumeration.ValidateEnumValue(const AValue: String): String;
var
  LFor: Integer;
begin
  Result := AValue;
  for LFor := 0 to Length(AValue) -1 do
  begin
    {$IFDEF NEXTGEN}
    if not CharInSet(AValue.Chars[LFor], ['A'..'Z', '0'..'9']) then
    {$ELSE}
    if not CharInSet(AValue[LFor+1], ['A'..'Z', '0'..'9']) then
    {$ENDIF}
      raise Exception.CreateFmt('Enumeration definido "%s" inválido para o tipo.' +
                                'Nota: Tipo chars ou Strings, defina em maiúsculo.',
                                [AValue]);
  end;
end;

{ Resource }

constructor Resource.Create(const AName: String);
begin
  FName := AName;
end;

{ SubResource }

constructor SubResource.Create(const AName: String);
begin
  FName := AName;
end;

constructor Dictionary.Create(const ADisplayLabel, AConstraintErrorMessage,
  ADefaultExpression, ADisplayFormat, AEditMask: String;
  const AAlignment: TAlignment;
  const AOrigin: String);
begin
   Create(ADisplayLabel,
          AConstraintErrorMessage,
          ADefaultExpression,
          ADisplayFormat,
          AEditMask,
          AAlignment);
   FOrigin := AOrigin;
end;

constructor Dictionary.Create(const ADisplayLabel, AConstraintErrorMessage: String;
  const AAlignment: TAlignment;
  const AOrigin: String);
begin
  Create(ADisplayLabel, AConstraintErrorMessage, AAlignment);
  FOrigin := AOrigin;
end;

constructor Dictionary.Create(const ADisplayLabel, AConstraintErrorMessage,
  ADefaultExpression: String;
  const AAlignment: TAlignment);
begin
  Create(ADisplayLabel, AConstraintErrorMessage, ADefaultExpression);
  FAlignment := AAlignment;
end;

{ NotServerUse }

constructor NotServerUse.Create;
begin

end;

{ FieldEvents }

constructor FieldEvents.Create(const AFieldEvents: TFieldEvents);
begin
  FFieldEvents := AFieldEvents;
end;

{ MaximumValueConstraint }

constructor MaximumValueConstraint.Create(const AValue: Double);
begin
  FValue := AValue;
end;

procedure MaximumValueConstraint.Validate(const ADisplayLabel: String;
  const AValue: TValue);
begin
  if AValue.AsExtended > FValue then
  begin
    raise EMaximumValueConstraint.Create(ADisplayLabel, FValue);
  end;
end;

{ NotEmpty }

constructor NotEmpty.Create;
begin
end;

procedure NotEmpty.Validate(const AProperty: TRttiProperty; AObject: TObject);
var
  isOk: Boolean;
begin
  isOk := True;

  case AProperty.PropertyType.TypeKind of
    tkString,
    tkChar,
    tkWChar,
    tkLString,
    tkWString,
    tkUString: isOk := not (AProperty.GetValue(AObject).AsString = '');
    tkFloat : isOk := not (AProperty.GetValue(AObject).AsExtended = 0);
    tkInteger,
    tkInt64 : isOk := not (AProperty.GetValue(AObject).IsEmpty);
  end;

  if not isOk then
    raise ENotEmptyConstraint.Create(AProperty.name);
end;

{ Size }

constructor Size.create(Max: Integer; Min: Integer = 0);
begin
  FMin := Min;
  FMax := Max;
end;

procedure Size.Validate(const AProperty: TRttiProperty; AObject: TObject);
begin
  if (FMax > 0) and (Length(AProperty.GetValue(AObject).AsString) > FMax) then
    raise EMaxLengthConstraint.Create(AProperty.name, FMax);

  if (FMin > 0) and (Length(AProperty.GetValue(AObject).AsString) < FMin) then
    raise EMinLengthConstraint.Create(AProperty.name, FMin);
end;

{ EFieldNotNull }

constructor EFieldNotNull.Create(const ADisplayLabel: String);
begin
  inherited CreateFmt('Campo [ %s ] não pode ser vazio',
                      [ADisplayLabel]);
end;

end.
