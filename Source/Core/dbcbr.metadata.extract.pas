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

  ORM Brasil é um ORM simples e descomplicado para quem utiliza Delphi.

  @abstract(Contribuição - Carlos Eduardo R. Grillo)
}

unit dbcbr.metadata.extract;

interface

uses
  DB,
  SysUtils,
  StrUtils,
  Generics.Collections,
  dbebr.factory.interfaces,
  dbcbr.metadata.interfaces,
  dbcbr.database.mapping,
  dbcbr.types.mapping;

type
  TMetadataAbstract = class(TInterfacedObject)
  private
    function GetModelForDatabase: Boolean;
    procedure SetModelForDatabase(const Value: Boolean);
    function GetCatalogMetadata: TCatalogMetadataMIK;
    procedure SetCatalogMetadata(const Value: TCatalogMetadataMIK);
    procedure SetGuidOrOctetos(const AColumn: TColumnMIK;
      const ADriverName: TDriverName);
  protected
    FConnection: IDBConnection;
    FCatalogMetadata: TCatalogMetadataMIK;
    FModelForDatabase: Boolean;
    procedure GetFieldTypeDefinition(const AColumn: TColumnMIK); virtual;
    function GetRuleAction(ARuleAction: string): TRuleAction; overload;
    function GetRuleAction(ARuleAction: Variant): TRuleAction; overload;
  public
    constructor Create; overload; virtual; abstract;
    constructor Create(ACatalogMetadata: TCatalogMetadataMIK); overload; virtual; abstract;
    property CatalogMetadata: TCatalogMetadataMIK read GetCatalogMetadata write SetCatalogMetadata;
    property ModelForDatabase: Boolean read GetModelForDatabase write SetModelForDatabase;
  end;

  TCatalogMetadataAbstract = class(TMetadataAbstract, IDatabaseMetadata)
  private
    function GetConnection: IDBConnection;
    procedure SetConnection(const Value: IDBConnection);
  protected
    FSQLText: string;
    FFieldType: TDictionary<string, TFieldType>;
    procedure SetFieldType(var AColumnMIK: TColumnMIK); virtual;
    function GetSelectTables: string; virtual; abstract;
    function GetSelectTableColumns(ATableName: string): string; virtual; abstract;
    function GetSelectPrimaryKey(ATableName: string): string; virtual; abstract;
    function GetSelectPrimaryKeyColumns(APrimaryKeyName: string): string; virtual; abstract;
    function GetSelectForeignKey(ATableName: string): string; virtual; abstract;
    function GetSelectForeignKeyColumns(AForeignKeyName: string): string; virtual; abstract;
    function GetSelectIndexe(ATableName: string): string; virtual; abstract;
    function GetSelectIndexeColumns(AIndexeName: string): string; virtual; abstract;
    function GetSelectTriggers(ATableName: string): string; virtual; abstract;
    function GetSelectChecks(ATableName: string): string; virtual; abstract;
    function GetSelectViews: string; virtual; abstract;
    function GetSelectSequences: string; virtual; abstract;
  public
    constructor Create; overload; override;
    destructor Destroy; override;
    procedure CreateFieldTypeList; virtual;
    procedure GetCatalogs; virtual; abstract;
    procedure GetSchemas; virtual; abstract;
    procedure GetTables; virtual; abstract;
    procedure GetColumns(ATable: TTableMIK); virtual; abstract;
    procedure GetPrimaryKey(ATable: TTableMIK); virtual; abstract;
    procedure GetIndexeKeys(ATable: TTableMIK); virtual; abstract;
    procedure GetForeignKeys(ATable: TTableMIK); virtual; abstract;
    procedure GetChecks(ATable: TTableMIK); virtual; abstract;
    procedure GetTriggers(ATable: TTableMIK); virtual; abstract;
    procedure GetSequences; virtual; abstract;
    procedure GetProcedures; virtual; abstract;
    procedure GetFunctions; virtual; abstract;
    procedure GetViews; virtual; abstract;
    procedure GetDatabaseMetadata; virtual; abstract;
    property Connection: IDBConnection read GetConnection write SetConnection;
  end;

  TModelMetadataAbstract = class(TMetadataAbstract, IModelMetadata)
  private
    function GetConnection: IDBConnection;
    procedure SetConnection(const Value: IDBConnection);
  public
    constructor Create; overload; override;
    procedure GetCatalogs; virtual; abstract;
    procedure GetSchemas; virtual; abstract;
    procedure GetTables; virtual; abstract;
    procedure GetColumns(ATable: TTableMIK; AClass: TClass); virtual; abstract;
    procedure GetPrimaryKey(ATable: TTableMIK; AClass: TClass); virtual; abstract;
    procedure GetIndexeKeys(ATable: TTableMIK; AClass: TClass); virtual; abstract;
    procedure GetForeignKeys(ATable: TTableMIK; AClass: TClass); virtual; abstract;
    procedure GetChecks(ATable: TTableMIK; AClass: TClass); virtual; abstract;
    procedure GetSequences; virtual; abstract;
    procedure GetProcedures; virtual; abstract;
    procedure GetFunctions; virtual; abstract;
    procedure GetViews; virtual; abstract;
    procedure GetTriggers; virtual; abstract;
    procedure GetModelMetadata; virtual; abstract;
    property Connection: IDBConnection read GetConnection write SetConnection;
  end;

implementation

{ TCatalogMetadataAbstract }

constructor TCatalogMetadataAbstract.Create;
begin
  FFieldType := TDictionary<string, TFieldType>.Create;
  // Instância um dicionário interno com uma lista de NOMES e TIPOS de
  // colunas dos bancos de dados.
  CreateFieldTypeList;
end;

procedure TCatalogMetadataAbstract.CreateFieldTypeList;
begin

end;

destructor TCatalogMetadataAbstract.Destroy;
begin
  FFieldType.Free;
  inherited;
end;

function TCatalogMetadataAbstract.GetConnection: IDBConnection;
begin
  Result := FConnection;
end;

procedure TCatalogMetadataAbstract.SetFieldType(var AColumnMIK: TColumnMIK);
begin
  AColumnMIK.FieldType := FFieldType[Trim(AColumnMIK.TypeName)];
end;

procedure TCatalogMetadataAbstract.SetConnection(const Value: IDBConnection);
begin
  FConnection := Value;
end;

{ TModelMetadataAbstract }

constructor TModelMetadataAbstract.Create;
begin

end;

function TModelMetadataAbstract.GetConnection: IDBConnection;
begin
  Result := FConnection;
end;

procedure TModelMetadataAbstract.SetConnection(const Value: IDBConnection);
begin
  FConnection := Value;
end;

{ TMetadataAbstract }

function TMetadataAbstract.GetCatalogMetadata: TCatalogMetadataMIK;
begin
  Result := FCatalogMetadata;
end;

procedure TMetadataAbstract.SetCatalogMetadata(const Value: TCatalogMetadataMIK);
begin
  FCatalogMetadata := Value;
end;

procedure TMetadataAbstract.SetModelForDatabase(const Value: Boolean);
begin
  FModelForDatabase := Value;
end;

procedure TMetadataAbstract.GetFieldTypeDefinition(const AColumn: TColumnMIK);
var
  LDriverName: TDriverName;
begin
  LDriverName := FConnection.GetDriverName;
  case AColumn.FieldType of
    ftBoolean:
    begin
      if      LDriverName = dnADS   then AColumn.TypeName := 'LOGICAL'
      else if LDriverName = dnASA   then AColumn.TypeName := 'BIT'
      else if LDriverName = dnMSSQL then AColumn.TypeName := 'BIT'
      else                               AColumn.TypeName := 'BOOLEAN';
    end;
    ftByte, ftShortint, ftSmallint, ftWord:
    begin
      if LDriverName = dnOracle then AColumn.TypeName := 'NUMBER'
      else                           AColumn.TypeName := 'SMALLINT';
    end;
    ftInteger, ftLongWord:
    begin
      if      LDriverName = dnMSSQL  then AColumn.TypeName := 'INT'
      else if LDriverName = dnMySQL  then AColumn.TypeName := 'INT'
      else if LDriverName = dnOracle then AColumn.TypeName := 'NUMBER'
      else                                AColumn.TypeName := 'INTEGER';
    end;
    ftLargeint:
      if      LDriverName = dnOracle     then AColumn.TypeName := 'NUMBER'
      else if LDriverName = dnFirebird   then AColumn.TypeName := 'BIGINT'
      else if LDriverName = dnInterbase  then AColumn.TypeName := 'BIGINT'
      else if LDriverName = dnPostgreSQL then AColumn.TypeName := 'BIGINT'
      else                                    AColumn.TypeName := 'NUMERIC(%l)';
    ftString:
      if LDriverName = dnOracle                               then AColumn.TypeName := 'VARCHAR2(%l)'
      else if (LDriverName = dnMSSQL) and (AColumn.Size = -1) then AColumn.TypeName := 'VARCHAR(MAX)'
      else                                                         AColumn.TypeName := 'VARCHAR(%l)';
    ftWideString:
      if      LDriverName = dnOracle    then AColumn.TypeName := 'NVARCHAR2(%l)'
      else if LDriverName = dnFirebird  then AColumn.TypeName := 'VARCHAR(%l)'
      else if LDriverName = dnInterbase then AColumn.TypeName := 'VARCHAR(%l)'
      else                                   AColumn.TypeName := 'NVARCHAR(%l)';
    ftFixedChar:
      AColumn.TypeName := 'CHAR(%l)';
    ftFixedWideChar:
      AColumn.TypeName := 'NCHAR(%l)';
    ftDate:
      AColumn.TypeName := 'DATE';
    ftTime:
      if LDriverName = dnOracle then AColumn.TypeName := 'DATE'
      else                           AColumn.TypeName := 'TIME';
    ftDateTime:
      if      LDriverName = dnInterbase  then AColumn.TypeName := 'DATE'
      else if LDriverName = dnFirebird   then AColumn.TypeName := 'DATE'
      else if LDriverName = dnOracle     then AColumn.TypeName := 'DATE'
      else if LDriverName = dnPostgreSQL then AColumn.TypeName := 'DATE'
      else                                   AColumn.TypeName := 'DATETIME';
    ftTimeStamp, ftOraTimeStamp, ftTimeStampOffset:
      if LDriverName = dnOracle    then AColumn.TypeName := 'DATE'
      else                              AColumn.TypeName := 'TIMESTAMP';
    ftFloat:
    begin
      if      LDriverName = dnSQLite     then AColumn.TypeName := 'FLOAT(%p,%s)'
      else if LDriverName = dnPostgreSQL then AColumn.TypeName := 'NUMERIC(%p,%s)'
      else                                    AColumn.TypeName := 'FLOAT';
    end;
    ftSingle:
      if LDriverName = dnOracle    then AColumn.TypeName := 'NUMBER(%p,%s)'
      else                              AColumn.TypeName := 'REAL';
    ftExtended:
    begin
      if      LDriverName = dnMSSQL  then AColumn.TypeName := 'FLOAT'
      else if LDriverName = dnSQLite then AColumn.TypeName := 'DOUBLE'
      else if LDriverName = dnMySQL  then AColumn.TypeName := 'DOUBLE'
      else if LDriverName = dnDB2    then AColumn.TypeName := 'DOUBLE'
      else if LDriverName = dnOracle then AColumn.TypeName := 'BINARY_DOUBLE'
      else                                AColumn.TypeName := 'DOUBLE PRECISION';
    end;
    ftCurrency:
    begin
      if      LDriverName = dnMSSQL      then AColumn.TypeName := 'MONEY'
      else if LDriverName = dnSQLite     then AColumn.TypeName := 'MONEY'
      else if LDriverName = dnPostgreSQL then AColumn.TypeName := 'MONEY'
      else if LDriverName = dnOracle     then AColumn.TypeName := 'NUMBER(%p,%s)'
      else                                    AColumn.TypeName := 'NUMERIC(%p,%s)';
    end;
    ftBCD, ftFMTBcd:
    begin
      if      LDriverName = dnOracle  then AColumn.TypeName := 'NUMBER(%p,%s)'
      else if LDriverName = dnSQLite  then AColumn.TypeName := 'FLOAT(%p,%s)'
      else                                 AColumn.TypeName := 'DECIMAL(%p,%s)';
    end;
    ftBlob, ftOraBlob:
    begin
      if      LDriverName = dnMSSQL      then AColumn.TypeName := 'VARBINARY(MAX)'
      else if LDriverName = dnPostgreSQL then AColumn.TypeName := 'BYTEA'
      else                                    AColumn.TypeName := 'BLOB'
    end;
    ftGraphic:
    begin
      if LDriverName = dnMSSQL  then AColumn.TypeName := 'IMAGE'
      else                           AColumn.TypeName := 'BLOB'
    end;
    ftWideMemo:
    begin
      if      LDriverName = dnFirebird  then AColumn.TypeName := 'BLOB SUB_TYPE 1'
      else if LDriverName = dnInterbase then AColumn.TypeName := 'BLOB SUB_TYPE 1'
      else if LDriverName = dnMSSQL     then AColumn.TypeName := 'NTEXT'
      else if LDriverName = dnOracle    then AColumn.TypeName := 'NCLOB'
      else                                   AColumn.TypeName := 'TEXT';
    end;
    ftMemo, ftOraClob:
    begin
      if      LDriverName = dnFirebird  then AColumn.TypeName := 'BLOB SUB_TYPE 1'
      else if LDriverName = dnInterbase then AColumn.TypeName := 'BLOB SUB_TYPE 1'
      else if LDriverName = dnOracle    then AColumn.TypeName := 'CLOB'
      else                                   AColumn.TypeName := 'TEXT';
    end;
    ftGuid:
    begin
      // GUID OCTETs (ou simplesmente octetos) se referem aos 16 bytes
      // (128 bits) que compõem um GUID (Globally Unique Identifier).
      // Cada octeto é representado por dois caracteres em hexadecimal,
      // formando uma sequência de 32 caracteres hexadecimais separados
      // por hífens (por exemplo, "550e8400-e29b-41d4-a716-446655440000").
      if FConnection.Options.StoreGUIDAsOctet then
      begin
        SetGuidOrOctetos(AColumn, LDriverName);
      end
      else if LDriverName = dnPostgreSQL then AColumn.TypeName := 'CHAR(%1)'
      else if LDriverName = dnFirebird   then AColumn.TypeName := 'CHAR(%1)'
      else if LDriverName = dnInterbase  then AColumn.TypeName := 'CHAR(%1)'
      else if LDriverName = dnMySQL      then AColumn.TypeName := 'CHAR(%1)'
      else if LDriverName = dnOracle     then AColumn.TypeName := 'NCHAR2(%1)'
      else                                    AColumn.TypeName := 'GUID';
    end;
  else
    raise Exception.Create('Tipo da coluna definida [' + AColumn.Table.Name + '.' +
                                          FieldTypeNames[AColumn.FieldType] + '], não existe no DBCBr.');
  end;
  // Definições de propriedades de tamnanho
  if FModelForDatabase then
  begin
    if MatchStr(AColumn.TypeName, ['SMALLINT','INT','INT4','INT8','INTEGER',
                                   'DATE','TIME','BIGINT','DATETIME','TIMESTAMP',
                                   'REAL','DOUBLE PRECISION','BLOB SUB_TYPE TEXT',
                                   'TEXT','NTEXT','NUMBER','BLOB SUB_TYPE 1']) then
    begin
      AColumn.Size := 0;
      AColumn.Precision := 0;
      AColumn.Scale := 0;
    end
    else
    if MatchStr(AColumn.TypeName, ['BLOB']) then
      AColumn.Size := 8
    else
    if MatchStr(AColumn.TypeName, ['BOOLEAN']) then
      AColumn.Size := 1
    else
    if MatchStr(AColumn.TypeName, ['FLOAT']) then
      AColumn.Size := 0
    else
    if MatchStr(AColumn.TypeName, ['DECIMAL(%p,%s)','NUMERIC(%p,%s)','NUMBER(%p,%s)',
                                   'FLOAT(%p,%s)']) then
      AColumn.Size := 0
    else
    if MatchStr(AColumn.TypeName, ['NUMERIC(%l)','VARCHAR(%l)','VARCHAR2(%l)',
                                   'NVARCHAR(%l)','NVARCHAR(%l)','CHAR(%l)','NCHAR(%l)']) then
    begin
      AColumn.Precision := 0;
      AColumn.Scale := 0;
    end;
  end;
end;

function TMetadataAbstract.GetModelForDatabase: Boolean;
begin
  Result := FModelForDatabase;
end;

function TMetadataAbstract.GetRuleAction(ARuleAction: string): TRuleAction;
begin
  if      ARuleAction = 'NO ACTION'   then Result := TRuleAction.None
  else if ARuleAction = 'SET NULL'    then Result := TRuleAction.SetNull
  else if ARuleAction = 'SET DEFAULT' then Result := TRuleAction.SetDefault
  else if ARuleAction = 'CASCADE'     then Result := TRuleAction.Cascade
  else Result := TRuleAction.None;
end;

function TMetadataAbstract.GetRuleAction(ARuleAction: Variant): TRuleAction;
begin
  if      ARuleAction = 0 then Result := TRuleAction.None
  else if ARuleAction = 1 then Result := TRuleAction.Cascade
  else if ARuleAction = 2 then Result := TRuleAction.SetNull
  else if ARuleAction = 3 then Result := TRuleAction.SetDefault
  else Result := TRuleAction.None;
end;

procedure TMetadataAbstract.SetGuidOrOctetos(const AColumn: TColumnMIK;
  const ADriverName: TDriverName);
begin
  if ADriverName = dnFirebird  then
  begin
    AColumn.TypeName := 'CHAR(%l)';
    AColumn.CharSet := 'OCTETS';
    AColumn.Size := 16;
  end
  else
  if ADriverName = dnPostgreSQL  then
  begin
    AColumn.TypeName := 'BYTE(%1)';
    AColumn.Size := 16;
  end
  else
    AColumn.TypeName := 'CHAR(%1)';
end;

end.
