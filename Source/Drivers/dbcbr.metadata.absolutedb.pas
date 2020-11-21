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
}

unit dbcbr.metadata.absolutedb;

interface

uses
  DB,
  Classes,
  SysUtils,
  StrUtils,
  Variants,
  Generics.Collections,
  ABSMain,
  ABSTypes,
  dbebr.factory.interfaces,
  dbcbr.metadata.register,
  dbcbr.metadata.extract,
  dbcbr.database.mapping;

type
  TCatalogMetadataAbsoluteDB = class(TCatalogMetadataAbstract)
  strict private
    procedure ResolveFieldType(AColumn: TColumnMIK; ADataType: TABSAdvancedFieldType);
  protected
    function Execute: IDBResultSet;
  public
    procedure GetCatalogs; override;
    procedure GetSchemas; override;
    procedure GetTables; override;
    procedure GetColumns(ATable: TTableMIK); override;
    procedure GetPrimaryKey(ATable: TTableMIK); override;
    procedure GetIndexeKeys(ATable: TTableMIK); override;
    procedure GetSequences; override;
    procedure GetDatabaseMetadata; override;
  end;

implementation

{ TSchemaExtractSQLite }

function TCatalogMetadataAbsoluteDB.Execute: IDBResultSet;
var
  LSQLQuery: IDBQuery;
begin
  inherited;
  LSQLQuery := FConnection.CreateQuery;
  try
    LSQLQuery.CommandText := FSQLText;
    Exit(LSQLQuery.ExecuteQuery);
  except
    raise
  end;
end;

procedure TCatalogMetadataAbsoluteDB.GetDatabaseMetadata;
begin
  inherited;
  GetCatalogs;
end;

procedure TCatalogMetadataAbsoluteDB.GetCatalogs;
begin
  inherited;
  FCatalogMetadata.Name := '';
  GetSchemas;
end;

procedure TCatalogMetadataAbsoluteDB.GetSchemas;
begin
  inherited;
  FCatalogMetadata.Schema := '';
  GetTables;
end;

procedure TCatalogMetadataAbsoluteDB.GetTables;
var
  LTableList: TStringList;
  LTable: TTableMIK;
  LFor: Integer;
begin
  inherited;
  LTableList := TStringList.Create;
  try
    TABSDatabase(FConnection).GetTablesList(LTableList);
    for LFor := 0 to LTableList.Count - 1 do
    begin
      LTable := TTableMIK.Create(FCatalogMetadata);
      LTable.Name := LTableList[LFor];
      LTable.Description := '';
      /// <summary>
      /// Extrair colunas da tabela
      /// </summary>
      GetColumns(LTable);
      /// <summary>
      /// Extrair Primary Key da tabela
      /// </summary>
      GetPrimaryKey(LTable);
      /// <summary>
      /// Extrair Indexes da tabela
      /// </summary>
      GetIndexeKeys(LTable);
      /// <summary>
      /// Adiciona na lista de tabelas extraidas
      /// </summary>
      FCatalogMetadata.Tables.Add(UpperCase(LTable.Name), LTable);
    end;
  finally
    LTableList.Free;
  end;
end;

procedure TCatalogMetadataAbsoluteDB.GetColumns(ATable: TTableMIK);
var
  LABSTable: TABSTable;
  LColumn: TColumnMIK;
  LFor: Integer;
begin
  inherited;
  LABSTable.Close;
  LABSTable.DatabaseName := (FConnection as TABSDatabase).DatabaseName;
  LABSTable.TableName := ATable.Name;
  LABSTable.FieldDefs.Update;

  for LFor := 0 to LABSTable.AdvFieldDefs.Count - 1 do
  begin
    LColumn := TColumnMIK.Create(ATable);
    LColumn.Name := LABSTable.AdvFieldDefs[LFor].Name;
    LColumn.Description := LColumn.Name;
    LColumn.Position := LFor + 1;
    /// <summary>
    /// O método ResolveTypeField() extrai e popula as propriedades relacionadas abaixo
    /// </summary>
    /// <param name="AColumn: TColumnMIK">Informar [LColumn] para receber informações adicionais
    /// </param>
    /// <param name="ATypeName: String">Campo com descriçao do tipo que veio na extração do metadata
    /// </param>
    /// <remarks>
    /// Relação das propriedades que serão alimentadas no método ResolveTypeField()
    /// LColumn.FieldType: TTypeField;
    /// LColumn.LTypeName: string;
    /// LColumn.Size: Integer;
    /// LColumn.Precision: Integer;
    /// LColumn.Scale: Integer;
    /// </remarks>
    ResolveFieldType(LColumn, LABSTable.AdvFieldDefs[LFor].DataType);
    ///
    LColumn.Size := LABSTable.AdvFieldDefs[LFor].Size;
    LColumn.NotNull := LABSTable.AdvFieldDefs[LFor].Required;
    LColumn.DefaultValue := LABSTable.AdvFieldDefs[LFor].DefaultValue.AsVariant;
    LColumn.AutoIncrement := (Pos('AutoInc', LColumn.LTypeName) > 0);

    ATable.Fields.Add(FormatFloat('000000', LColumn.Position), LColumn);
  end;
end;

procedure TCatalogMetadataAbsoluteDB.GetPrimaryKey(ATable: TTableMIK);
{
var
  LDBResultSet: IDBResultSet;

  function GetColumnAutoIncrement(ATableName: string): integer;
  var
    LDBResultSet: IDBResultSet;
  begin
    FSQLText := ' select count(*) as autoinc ' +
                ' from sqlite_sequence ' +
                ' where name = ''' + ATableName + ''' ' +
                ' order by name';
    LDBResultSet := Execute;
    Exit(LDBResultSet.GetFieldValue('autoinc'));
  end;

  procedure GetPrimaryKeyColumns(APrimaryKey: TPrimaryKeyMIK);
  var
    LDBResultSet: IDBResultSet;
    LColumn: TColumnMIK;
  begin
    FSQLText := Format('PRAGMA table_info("%s")', [ATable.Name]);
    LDBResultSet := Execute;
    while LDBResultSet.NotEof do
    begin
      LColumn := TColumnMIK.Create(ATable);
      LColumn.Name := VarToStr(LDBResultSet.GetFieldValue('name'));
      LColumn.NotNull := LDBResultSet.GetFieldValue('notnull') = 1;
      LColumn.Position := VarAsType(LDBResultSet.GetFieldValue('cid'), varInteger);
//      LColumn.AutoIncrement := GetColumnAutoIncrement(ATable.Name) > 0;
      APrimaryKey.Fields.Add(FormatFloat('000000', LColumn.Position), LColumn);
    end;
  end;
}
begin
  inherited;
{
  FSQLText := GetSelectPrimaryKey(ATable.Name);
  LDBResultSet := Execute;
  while LDBResultSet.NotEof do
  begin
    if VarAsType(LDBResultSet.GetFieldValue('pk'), varInteger) = 1 then
    begin
      ATable.PrimaryKey.Name := Format('PK_%s', [ATable.Name]);
      ATable.PrimaryKey.Description := '';
      ATable.PrimaryKey.AutoIncrement := GetColumnAutoIncrement(ATable.Name) > 0;
      /// <summary>
      /// Estrai as columnas da primary key
      /// </summary>
      GetPrimaryKeyColumns(ATable.PrimaryKey);
      Break
    end;
  end;
}
end;

procedure TCatalogMetadataAbsoluteDB.GetSequences;
{
var
  LDBResultSet: IDBResultSet;
  LSequence: TSequenceMIK;
}
begin
  inherited;
{
  FSQLText := GetSelectSequences;
  LDBResultSet := Execute;
  while LDBResultSet.NotEof do
  begin
    LSequence := TSequenceMIK.Create(FCatalogMetadata);
    LSequence.Name := VarToStr(LDBResultSet.GetFieldValue('name'));
    LSequence.Description := VarToStr(LDBResultSet.GetFieldValue('description'));;
    FCatalogMetadata.Sequences.Add(UpperCase(LSequence.Name), LSequence);
  end;
}
end;

procedure TCatalogMetadataAbsoluteDB.GetIndexeKeys(ATable: TTableMIK);
{
var
  LDBResultSet: IDBResultSet;
  LIndexeKey: TIndexeKeyMIK;

  procedure GetIndexeKeyColumns(AIndexeKey: TIndexeKeyMIK);
  var
    LDBResultSet: IDBResultSet;
    LColumn: TColumnMIK;
  begin
    FSQLText := GetSelectIndexeColumns(AIndexeKey.Name);
    LDBResultSet := Execute;
    while LDBResultSet.NotEof do
    begin
      LColumn := TColumnMIK.Create(ATable);
      LColumn.Name := VarToStr(LDBResultSet.GetFieldValue('name'));
      AIndexeKey.Fields.Add(LColumn.Name, LColumn);
    end;
  end;
}
begin
  inherited;
{
  FSQLText := GetSelectIndexe(ATable.Name);
  LDBResultSet := Execute;
  while LDBResultSet.NotEof do
  begin
    if VarAsType(LDBResultSet.GetFieldValue('origin'), varString) = 'pk' then
       Continue;
    LIndexeKey := TIndexeKeyMIK.Create(ATable);
    LIndexeKey.Name := VarToStr(LDBResultSet.GetFieldValue('name'));
    LIndexeKey.Unique := VarAsType(LDBResultSet.GetFieldValue('unique'), varInteger) = 1;
    ATable.IndexeKeys.Add(UpperCase(LIndexeKey.Name), LIndexeKey);
    /// <summary>
    /// Gera a lista de campos do indexe
    /// </summary>
    GetIndexeKeyColumns(LIndexeKey);
  end;
}
end;

procedure TCatalogMetadataAbsoluteDB.ResolveFieldType(AColumn: TColumnMIK;
  ADataType: TABSAdvancedFieldType);
var
  LTypeName: string;
begin
  AColumn.FieldType := ftUnknown;
  AColumn.Precision := 0;
  case ADataType of
    aftChar:            begin AColumn.FieldType := ftFixedChar; AColumn.LTypeName := 'CHAR' end;
    aftString:          begin AColumn.FieldType := ftString; AColumn.LTypeName := 'VARCHAR' end;
    aftWideChar:        begin AColumn.FieldType := ftWideString; AColumn.LTypeName := 'WIDESTRING' end;
    aftWideString:      begin AColumn.FieldType := ftWideString; AColumn.LTypeName := 'WIDESTRING' end;
    aftShortint:        begin AColumn.FieldType := ftSmallint; AColumn.LTypeName := 'SMALLINT' end;
    aftSmallint:        begin AColumn.FieldType := ftSmallint; AColumn.LTypeName := 'SMALLINT' end;
    aftInteger:         begin AColumn.FieldType := ftInteger; AColumn.LTypeName := 'INTEGER' end;
    aftLargeint:        begin AColumn.FieldType := ftLargeint; AColumn.LTypeName := 'LARGEINT' end;
    aftByte:            begin AColumn.FieldType := ftByte; AColumn.LTypeName := 'BYTE' end;
    aftWord:            begin AColumn.FieldType := ftWord; AColumn.LTypeName := 'WORD' end;
    aftCardinal:        begin AColumn.FieldType := ftWord; AColumn.LTypeName := 'CARDINAL' end;
    aftAutoInc:         begin AColumn.FieldType := ftInteger; AColumn.LTypeName := 'AUTOINC' end;
    aftAutoIncShortint: begin AColumn.FieldType := ftShortint; AColumn.LTypeName := 'AUTOINC(SHORTINT)' end;
    aftAutoIncSmallint: begin AColumn.FieldType := ftSmallint; AColumn.LTypeName := 'AUTOINC(SMALLINT)' end;
    aftAutoIncInteger:  begin AColumn.FieldType := ftInteger; AColumn.LTypeName := 'AUTOINC(INTEGER)' end;
    aftAutoIncLargeint: begin AColumn.FieldType := ftLargeint; AColumn.LTypeName := 'AUTOINC(LARGEINT)' end;
    aftAutoIncByte:     begin AColumn.FieldType := ftByte; AColumn.LTypeName := 'AUTOINC(BYTE)' end;
    aftAutoIncWord:     begin AColumn.FieldType := ftWord; AColumn.LTypeName := 'AUTOINC(WORD)' end;
    aftAutoIncCardinal: begin AColumn.FieldType := ftInteger; AColumn.LTypeName := 'AUTOINC(CARDINAL)' end;
    aftSingle:          begin AColumn.FieldType := ftSingle; AColumn.LTypeName := 'SINGLE' end;
    aftDouble:          begin AColumn.FieldType := ftFloat; AColumn.LTypeName := 'FLOAT' end;
    aftExtended:        begin AColumn.FieldType := ftBCD; AColumn.LTypeName := 'EXTENDED' end;
    aftBoolean:         begin AColumn.FieldType := ftBoolean; AColumn.LTypeName := 'BOOLEAN' end;
    aftCurrency:        begin AColumn.FieldType := ftCurrency; AColumn.LTypeName := 'CURRENCY' end;
    aftDate:            begin AColumn.FieldType := ftDate; AColumn.LTypeName := 'DATE' end;
    aftTime:            begin AColumn.FieldType := ftTime; AColumn.LTypeName := 'TIME' end;
    aftDateTime:        begin AColumn.FieldType := ftDateTime; AColumn.LTypeName := 'DATETIME' end;
    aftTimeStamp:       begin AColumn.FieldType := ftTimeStamp; AColumn.LTypeName := 'TIMESTAMP' end;
    aftBytes:           begin AColumn.FieldType := ftBytes; AColumn.LTypeName := 'BYTES' end;
    aftVarBytes:        begin AColumn.FieldType := ftVarBytes; AColumn.LTypeName := 'VARBYTES' end;
    aftBlob:            begin AColumn.FieldType := ftBlob; AColumn.LTypeName := 'BLOB' end;
    aftGraphic:         begin AColumn.FieldType := ftGraphic; AColumn.LTypeName := 'GRAPHIC' end;
    aftMemo:            begin AColumn.FieldType := ftMemo; AColumn.LTypeName := 'MEMO' end;
    aftFormattedMemo:   begin AColumn.FieldType := ftWideMemo; AColumn.LTypeName := 'FORMATTEDMEMO' end;
    aftWideMemo:        begin AColumn.FieldType := ftWideMemo; AColumn.LTypeName := 'WIDEMEMO' end;
    aftGuid:            begin AColumn.FieldType := ftGuid; AColumn.LTypeName := 'GUID' end;
  end;
end;

initialization
  TMetadataRegister.GetInstance.RegisterMetadata(dnAbsoluteDB, TCatalogMetadataAbsoluteDB.Create);

end.

