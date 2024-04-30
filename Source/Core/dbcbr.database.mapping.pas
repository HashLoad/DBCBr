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

{ @abstract(ORMBr Framework.)
  @created(20 Jul 2016)
  @author(Isaque Pinheiro <isaquepsp@gmail.com>)
  @author(Skype : ispinheiro)
}

unit dbcbr.database.mapping;

interface

uses
  DB,
  Rtti,
  SysUtils,
  Generics.Collections,
  Generics.Defaults,
  dbcbr.types.mapping;

type
  TTableMIK = class;
  TCatalogMetadataMIK = class;

  TMetaInfoKind = class abstract
  strict private
    FDescription: String;
  public
    property Description: String read FDescription write FDescription;
  end;

  TColumnMIK = class(TMetaInfoKind)
  strict private
    FTable: TTableMIK;
    FName: String;
    FPosition: Integer;
    FFieldType: TFieldType;
    FTypeName: String;
    FSize: Integer;
    FPrecision: Integer;
    FScale: Integer;
    FNotNull: Boolean;
    FAutoIncrement: Boolean;
    FSortingOrder: TSortingOrder;
    FDefaultValue: String;
    FIsPrimaryKey: Boolean;
    FCharSet: String;
  public
    constructor Create(ATable: TTableMIK = nil);
    property Table: TTableMIK read FTable;
    property Name: String read FName write FName;
    property Position: Integer read FPosition write FPosition;
    property FieldType: TFieldType read FFieldType write FFieldType;
    property TypeName: String read FTypeName write FTypeName;
    property Size: Integer read FSize write FSize;
    property Precision: Integer read FPrecision write FPrecision;
    property Scale: Integer read FScale write FScale;
    property NotNull: Boolean read FNotNull write FNotNull;
    property AutoIncrement: Boolean read FAutoIncrement write FAutoIncrement;
    property SortingOrder: TSortingOrder read FSortingOrder write FSortingOrder;
    property DefaultValue: String read FDefaultValue write FDefaultValue;
    property IsPrimaryKey: Boolean read FIsPrimaryKey write FIsPrimaryKey;
    property CharSet: String read FcharSet write FCharSet;
  end;

  TIndexeKeyMIK = class(TMetaInfoKind)
  strict private
    FTable: TTableMIK;
    FName: String;
    FUnique: Boolean;
    FFields: TObjectDictionary<String, TColumnMIK>;
  public
    constructor Create(ATable: TTableMIK);
    destructor Destroy; override;
    function FieldsSort: TArray<TPair<String, TColumnMIK>>;
    property Table: TTableMIK read FTable;
    property Name: String read FName write FName;
    property Unique: Boolean read FUnique write FUnique;
    property Fields: TObjectDictionary<String, TColumnMIK> read FFields;
  end;

  TSequenceMIK = class(TMetaInfoKind)
  strict private
    FTableName: String;
    FName: String;
    FInitialValue: Integer;
    FIncrement: Integer;
    FCatalog: TCatalogMetadataMIK;
  public
    constructor Create(ADatabase: TCatalogMetadataMIK);
    property Name: String read FName write FName;
    property InitialValue: Integer read FInitialValue write FInitialValue;
    property Increment: Integer read FIncrement write FIncrement;
    property TableName: String read FTableName write FTableName;
    property Database: TCatalogMetadataMIK read FCatalog;
  end;

  TForeignKeyMIK = class(TMetaInfoKind)
  strict private
    FTable: TTableMIK;
    FName: String;
    FFromTable: String;
    FFromFields: TObjectDictionary<String, TColumnMIK>;
    FToFields: TObjectDictionary<String, TColumnMIK>;
    FOnUpdate: TRuleAction;
    FOnDelete: TRuleAction;
  public
    constructor Create(ATable: TTableMIK);
    destructor Destroy; override;
    function FromFieldsSort: TArray<TPair<String, TColumnMIK>>;
    function ToFieldsSort: TArray<TPair<String, TColumnMIK>>;
    property Table: TTableMIK read FTable;
    property Name: String read FName write FName;
    property FromTable: String read FFromTable write FFromTable;
    property FromFields: TObjectDictionary<String, TColumnMIK> read FFromFields;
    property ToFields: TObjectDictionary<String, TColumnMIK> read FToFields;
    property OnUpdate: TRuleAction read FOnUpdate write FOnUpdate;
    property OnDelete: TRuleAction read FOnDelete write FOnDelete;
  end;

  TPrimaryKeyMIK = class(TMetaInfoKind)
  strict private
    FTable: TTableMIK;
    FName: String;
    FAutoIncrement: Boolean;
    FFields: TObjectDictionary<String, TColumnMIK>;
  public
    constructor Create(ATable: TTableMIK);
    destructor Destroy; override;
    function FieldsSort: TArray<TPair<String, TColumnMIK>>;
    property Table: TTableMIK read FTable;
    property Name: String read FName write FName;
    property AutoIncrement: Boolean read FAutoIncrement write FAutoIncrement;
    property Fields: TObjectDictionary<String, TColumnMIK> read FFields;
  end;

  TTriggerMIK = class(TMetaInfoKind)
  strict private
    FTable: TTableMIK;
    FName: String;
    FScript: String;
  public
    constructor Create(ATable: TTableMIK);
    property Table: TTableMIK read FTable;
    property Name: String read FName write FName;
    property Script: String read FScript write FScript;
  end;

  TCheckMIK = class(TMetaInfoKind)
  strict private
    FTable: TTableMIK;
    FName: String;
    FCondition: String;
  public
    constructor Create(ATable: TTableMIK);
    property Table: TTableMIK read FTable;
    property Name: String read FName write FName;
    property Condition: String read FCondition write FCondition;
  end;

  TTableMIK = class(TMetaInfoKind)
  strict private
    FCatalog: TCatalogMetadataMIK;
    FName: String;
    FDescription: String;
    FPrimaryKey: TPrimaryKeyMIK;
    FFields: TObjectDictionary<String, TColumnMIK>;
    FIndexeKeys: TObjectDictionary<String, TIndexeKeyMIK>;
    FForeignKeys: TObjectDictionary<String, TForeignKeyMIK>;
    FChecks: TObjectDictionary<String, TCheckMIK>;
    FTriggers: TObjectDictionary<String, TTriggerMIK>;
  public
    constructor Create(ADatabase: TCatalogMetadataMIK);
    destructor Destroy; override;
    function FieldsSort: TArray<TPair<String, TColumnMIK>>;
    property Database: TCatalogMetadataMIK read FCatalog;
    property Name: String read FName write FName;
    property Description: String read FDescription write FDescription;
    property Fields: TObjectDictionary<String, TColumnMIK> read FFields;
    property PrimaryKey: TPrimaryKeyMIK read FPrimaryKey write FPrimaryKey;
    property IndexeKeys: TObjectDictionary<String, TIndexeKeyMIK> read FIndexeKeys;
    property Checks: TObjectDictionary<String, TCheckMIK> read FChecks;
    property ForeignKeys: TObjectDictionary<String, TForeignKeyMIK> read FForeignKeys;
    property Triggers: TObjectDictionary<String, TTriggerMIK> read FTriggers;
  end;

  TViewMIK = class(TMetaInfoKind)
  strict private
    FCatalog: TCatalogMetadataMIK;
    FName: String;
    FScript: String;
    FFields: TObjectDictionary<String, TColumnMIK>;
  private

  public
    constructor Create(ADatabase: TCatalogMetadataMIK);
    destructor Destroy; override;
    property Database: TCatalogMetadataMIK read FCatalog;
    property Name: String read FName write FName;
    property Fields: TObjectDictionary<String, TColumnMIK> read FFields write FFields;
    property Script: String read FScript write FScript;
  end;

  TCatalogMetadataMIK = class(TMetaInfoKind)
  strict private
    FName: String;
    FSchema: String;
    FTables: TObjectDictionary<String, TTableMIK>;
    FSequences: TObjectDictionary<String, TSequenceMIK>;
    FViews: TObjectDictionary<String, TViewMIK>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function TablesSort: TArray<TPair<String, TTableMIK>>;
    property Name: String read FName write FName;
    property Schema: String read FSchema write FSchema;
    property Tables: TObjectDictionary<String, TTableMIK> read FTables;
    property Sequences: TObjectDictionary<String, TSequenceMIK> read FSequences;
    property Views: TObjectDictionary<String, TViewMIK> read FViews;
  end;

implementation

{ TTableMIK }

constructor TTableMIK.Create(ADatabase: TCatalogMetadataMIK);
begin
  FFields := TObjectDictionary<String, TColumnMIK>.Create([doOwnsValues]);
  FIndexeKeys := TObjectDictionary<String, TIndexeKeyMIK>.Create([doOwnsValues]);
  FChecks := TObjectDictionary<String, TCheckMIK>.Create([doOwnsValues]);
  FForeignKeys := TObjectDictionary<String, TForeignKeyMIK>.Create([doOwnsValues]);
  FTriggers := TObjectDictionary<String, TTriggerMIK>.Create([doOwnsValues]);
  FPrimaryKey := TPrimaryKeyMIK.Create(Self);
  FCatalog := ADatabase;
end;

destructor TTableMIK.Destroy;
begin
  FFields.Free;
  FIndexeKeys.Free;
  FChecks.Free;
  FForeignKeys.Free;
  FPrimaryKey.Free;
  FTriggers.Free;
  inherited;
end;

function TTableMIK.FieldsSort: TArray<TPair<String, TColumnMIK>>;

  function ToArray: TArray<TPair<String, TColumnMIK>>;
  var
    LPair: TPair<String, TColumnMIK>;
    LIndex: Integer;
  begin
    SetLength(Result, FFields.Count);
    LIndex := 0;
    for LPair in FFields do
    begin
      Result[LIndex] := LPair;
      Inc(LIndex);
    end;
  end;

begin
  Result := ToArray;
  TArray.Sort<TPair<String, TColumnMIK>>(Result,
    TComparer<TPair<String, TColumnMIK>>.Construct(
      function (const Left, Right: TPair<String, TColumnMIK>): Integer
      begin
        Result := CompareStr(Left.Key, Right.Key);
      end)
    );
end;

{ TForeignKeyMIK }

constructor TForeignKeyMIK.Create(ATable: TTableMIK);
begin
  FTable := ATable;
  FFromFields := TObjectDictionary<String, TColumnMIK>.Create([doOwnsValues]);
  FToFields := TObjectDictionary<String, TColumnMIK>.Create([doOwnsValues]);
end;

destructor TForeignKeyMIK.Destroy;
begin
  FFromFields.Free;
  FToFields.Free;
  inherited;
end;

function TForeignKeyMIK.FromFieldsSort: TArray<TPair<String, TColumnMIK>>;

  function ToArray: TArray<TPair<String, TColumnMIK>>;
  var
    LPair: TPair<String, TColumnMIK>;
    LIndex: Integer;
  begin
    SetLength(Result, FFromFields.Count);
    LIndex := 0;
    for LPair in FFromFields do
    begin
      Result[LIndex] := LPair;
      Inc(LIndex);
    end;
  end;

begin
  Result := ToArray;
  TArray.Sort<TPair<String, TColumnMIK>>(Result,
    TComparer<TPair<String, TColumnMIK>>.Construct(
      function (const Left, Right: TPair<String, TColumnMIK>): Integer
      begin
        Result := CompareStr(Left.Key, Right.Key);
      end)
    );
end;

function TForeignKeyMIK.ToFieldsSort: TArray<TPair<String, TColumnMIK>>;

  function ToArray: TArray<TPair<String, TColumnMIK>>;
  var
    LPair: TPair<String, TColumnMIK>;
    LIndex: Integer;
  begin
    SetLength(Result, FToFields.Count);
    LIndex := 0;
    for LPair in FToFields do
    begin
      Result[LIndex] := LPair;
      Inc(LIndex);
    end;
  end;

begin
  Result := ToArray;
  TArray.Sort<TPair<String, TColumnMIK>>(Result,
    TComparer<TPair<String, TColumnMIK>>.Construct(
      function (const Left, Right: TPair<String, TColumnMIK>): Integer
      begin
        Result := CompareStr(Left.Key, Right.Key);
      end)
    );
end;

{ TIndexeKeyMIK }

constructor TIndexeKeyMIK.Create(ATable: TTableMIK);
begin
  FFields := TObjectDictionary<String, TColumnMIK>.Create([doOwnsValues]);
  FTable := ATable;
end;

destructor TIndexeKeyMIK.Destroy;
begin
  FFields.Free;
  inherited;
end;

function TIndexeKeyMIK.FieldsSort: TArray<TPair<String, TColumnMIK>>;

  function ToArray: TArray<TPair<String, TColumnMIK>>;
  var
    LPair: TPair<String, TColumnMIK>;
    LIndex: Integer;
  begin
    SetLength(Result, FFields.Count);
    LIndex := 0;
    for LPair in FFields do
    begin
      Result[LIndex] := LPair;
      Inc(LIndex);
    end;
  end;

begin
  Result := ToArray;
  TArray.Sort<TPair<String, TColumnMIK>>(Result,
    TComparer<TPair<String, TColumnMIK>>.Construct(
      function (const Left, Right: TPair<String, TColumnMIK>): Integer
      begin
        Result := CompareStr(Left.Key, Right.Key);
      end)
    );
end;

{ TCatalogMetadataMIK }

procedure TCatalogMetadataMIK.Clear;
begin
  Tables.Clear;
  Sequences.Clear;
end;

constructor TCatalogMetadataMIK.Create;
begin
  FTables := TObjectDictionary<String, TTableMIK>.Create([doOwnsValues]);
  FSequences := TObjectDictionary<String, TSequenceMIK>.Create([doOwnsValues]);
  FViews := TObjectDictionary<String, TViewMIK>.Create([doOwnsValues]);
end;

destructor TCatalogMetadataMIK.Destroy;
begin
  FTables.Free;
  FSequences.Free;
  FViews.Free;
  inherited;
end;

function TCatalogMetadataMIK.TablesSort: TArray<TPair<String, TTableMIK>>;

  function ToArray: TArray<TPair<String, TTableMIK>>;
  var
    LPair: TPair<String, TTableMIK>;
    LIndex: Integer;
  begin
    SetLength(Result, FTables.Count);
    LIndex := 0;
    for LPair in FTables do
    begin
      Result[LIndex] := LPair;
      Inc(LIndex);
    end;
  end;

begin
  Result := ToArray;
  TArray.Sort<TPair<String, TTableMIK>>(Result,
    TComparer<TPair<String, TTableMIK>>.Construct(
      function (const Left, Right: TPair<String, TTableMIK>): Integer
      begin
        Result := CompareStr(Left.Key, Right.Key);
      end)
    );
end;

{ TColumnMIK }

constructor TColumnMIK.Create(ATable: TTableMIK);
begin
  FTable := ATable;
  FPosition := 0;
end;

{ TSequenceMIK }

constructor TSequenceMIK.Create(ADatabase: TCatalogMetadataMIK);
begin
  FCatalog := ADatabase;
end;

{ TPrimaryKeyMIK }

constructor TPrimaryKeyMIK.Create(ATable: TTableMIK);
begin
  FTable := ATable;
  FAutoIncrement := False;
  FFields := TObjectDictionary<String, TColumnMIK>.Create([doOwnsValues]);
end;

destructor TPrimaryKeyMIK.Destroy;
begin
  FFields.Free;
  inherited;
end;

function TPrimaryKeyMIK.FieldsSort: TArray<TPair<String, TColumnMIK>>;

  function ToArray: TArray<TPair<String, TColumnMIK>>;
  var
    LPair: TPair<String, TColumnMIK>;
    LIndex: Integer;
  begin
    SetLength(Result, FFields.Count);
    LIndex := 0;
    for LPair in FFields do
    begin
      Result[LIndex] := LPair;
      Inc(LIndex);
    end;
  end;

begin
  Result := ToArray;
  TArray.Sort<TPair<String, TColumnMIK>>(Result,
    TComparer<TPair<String, TColumnMIK>>.Construct(
      function (const Left, Right: TPair<String, TColumnMIK>): Integer
      begin
        Result := CompareStr(Left.Key, Right.Key);
      end)
    );
end;

{ TTriggerMIK }

constructor TTriggerMIK.Create(ATable: TTableMIK);
begin
  FTable := ATable;
end;

{ TCheckMIK }

constructor TCheckMIK.Create(ATable: TTableMIK);
begin
  FTable := ATable;
end;

{ TViewMIK }

constructor TViewMIK.Create(ADatabase: TCatalogMetadataMIK);
begin
  FFields := TObjectDictionary<String, TColumnMIK>.Create([doOwnsValues]);
  FCatalog := ADatabase;
end;

destructor TViewMIK.Destroy;
begin
   FFields.Free;
  inherited;
end;

end.

