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

unit dbcbr.database.factory;

interface

uses
  DB,
  Classes,
  SysUtils,
  Generics.Collections,
  dbebr.factory.interfaces,
  dbcbr.ddl.interfaces,
  dbcbr.database.abstract,
  dbcbr.database.mapping,
  dbcbr.ddl.commands;

type
  TDatabaseFactory = class(TDatabaseAbstract)
  private
    procedure CompareTables(AMasterDB, ATargetDB: TCatalogMetadataMIK);
    procedure CompareViews(AMasterDB, ATargetDB: TCatalogMetadataMIK);
    procedure CompareSequences(AMasterDB, ATargetDB: TCatalogMetadataMIK);
    procedure CompareTablesForeignKeys(AMasterDB, ATargetDB: TCatalogMetadataMIK);
    procedure CompareForeignKeys(AMasterTable, ATargetTable: TTableMIK);
    procedure CompareColumns(AMasterTable, ATargetTable: TTableMIK);
    procedure ComparePrimaryKey(AMasterTable, ATargetTable: TTableMIK);
    procedure CompareIndexes(AMasterTable, ATargetTable: TTableMIK);
    procedure CompareTriggers(AMasterTable, ATargetTable: TTableMIK);
    procedure CompareChecks(AMasterTable, ATargetTable: TTableMIK);
    procedure ActionCreateTable(ATable: TTableMIK);
    procedure ActionCreateIndexe(AIndexe: TIndexeKeyMIK);
    procedure ActionCreateCheck(ACheck: TCheckMIK);
    procedure ActionCreatePrimaryKey(APrimaryKey: TPrimaryKeyMIK);
    procedure ActionCreateColumn(AColumn: TColumnMIK);
    procedure ActionCreateSequence(ASequence: TSequenceMIK);
    procedure ActionCreateForeignKey(AForeignKey: TForeignKeyMIK);
    procedure ActionCreateView(AView: TViewMIK);
    procedure ActionDropTable(ATable: TTableMIK);
    procedure ActionDropColumn(AColumn: TColumnMIK);
    procedure ActionDropPrimaryKey(APrimaryKey: TPrimaryKeyMIK);
    procedure ActionDropSequence(ASequence: TSequenceMIK);
    procedure ActionDropIndexe(AIndexe: TIndexeKeyMIK);
    procedure ActionDropForeignKey(AForeignKey: TForeignKeyMIK);
    procedure ActionDropCheck(ACheck: TCheckMIK);
    procedure ActionDropView(AView: TViewMIK);
    procedure ActionAlterColumn(AColumn: TColumnMIK);
    procedure ActionAlterColumnPosition(AColumn: TColumnMIK);
    procedure ActionDropDefaultValue(AColumn: TColumnMIK);
    procedure ActionAlterDefaultValue(AColumn: TColumnMIK);
    procedure ActionAlterCheck(ACheck: TCheckMIK);
    /// <summary>
    /// Gera script que desabilita todas as ForeignKeys
    /// </summary>
    procedure ActionEnableForeignKeys(AEnable: Boolean);
    procedure ActionEnableTriggers(AEnable: Boolean);
    function DeepEqualsColumn(AMasterColumn, ATargetColumn: TColumnMIK): Boolean;
    function KeepEqualsPosition(AMasterColumn, ATargetColumn: TColumnMIK): Boolean;
    function DeepEqualsDefaultValue(AMasterColumn, ATargetColumn: TColumnMIK): Boolean;
    function DeepEqualsForeignKey(AMasterForeignKey, ATargetForeignKey: TForeignKeyMIK): Boolean;
    function DeepEqualsForeignKeyFromColumns(AMasterForeignKey, ATargetForeignKey: TForeignKeyMIK): Boolean;
    function DeepEqualsForeignKeyToColumns(AMasterForeignKey, ATargetForeignKey: TForeignKeyMIK): Boolean;
    function DeepEqualsIndexe(AMasterIndexe, ATargetIndexe: TIndexeKeyMIK): Boolean;
    function DeepEqualsIndexeColumns(AMasterIndexe, ATargetIndexe: TIndexeKeyMIK): Boolean;
  protected
    function GetFieldTypeValid(AFieldType: TFieldType): TFieldType; override;
    procedure GenerateDDLCommands(AMasterDB, ATargetDB: TCatalogMetadataMIK); override;
  public
    procedure BuildDatabase; override;
  end;

implementation

{ TDatabaseFactory }

procedure TDatabaseFactory.BuildDatabase;
begin
  inherited;
  FCatalogMaster := TCatalogMetadataMIK.Create;
  FCatalogTarget := TCatalogMetadataMIK.Create;
  try
    // Extrai o metadata com base nos modelos existentes e no banco de dados
    ExtractDatabase;
    // Gera os comandos DDL para atualização do banco da dados.
    GenerateDDLCommands(FCatalogMaster, FCatalogTarget);
  finally
    FCatalogMaster.Free;
    FCatalogTarget.Free;
  end;
end;

function TDatabaseFactory.DeepEqualsColumn(AMasterColumn, ATargetColumn: TColumnMIK): Boolean;
begin
  Result := True;
  if AMasterColumn.TypeName <> ATargetColumn.TypeName then
    Exit(False);
  if AMasterColumn.Size <> ATargetColumn.Size then
    Exit(False);
  if AMasterColumn.Precision <> ATargetColumn.Precision then
    Exit(False);
  if AMasterColumn.NotNull <> ATargetColumn.NotNull then
    Exit(False);
  if AMasterColumn.AutoIncrement <> ATargetColumn.AutoIncrement then
    Exit(False);
  if AMasterColumn.SortingOrder <> ATargetColumn.SortingOrder then
    Exit(False);
  if AMasterColumn.DefaultValue <> ATargetColumn.DefaultValue then
    Exit(False);
  if GetFieldTypeValid(AMasterColumn.FieldType) <> GetFieldTypeValid(ATargetColumn.FieldType) then
    Exit(False);
  if (AMasterColumn.CharSet <> EmptyStr) and (AMasterColumn.CharSet <> ATargetColumn.CharSet) then
    Exit(False);
//  if AMasterColumn.Description <> ATargetColumn.Description then
//    Exit(False);
end;

function TDatabaseFactory.DeepEqualsDefaultValue(AMasterColumn, ATargetColumn: TColumnMIK): Boolean;
begin
  Result := True;
  if AMasterColumn.DefaultValue <> ATargetColumn.DefaultValue then
    Exit(False);
end;

function TDatabaseFactory.DeepEqualsForeignKey(AMasterForeignKey, ATargetForeignKey: TForeignKeyMIK): Boolean;
begin
  Result := True;
  if not SameText(AMasterForeignKey.FromTable, ATargetForeignKey.FromTable) then
    Exit(False);
  if AMasterForeignKey.OnDelete <> ATargetForeignKey.OnDelete then
    Exit(False);
  if AMasterForeignKey.OnUpdate <> ATargetForeignKey.OnUpdate then
    Exit(False);
//  if AMasterForeignKey.Description <> ATargetForeignKey.Description then
//    Exit(False);
end;

function TDatabaseFactory.DeepEqualsIndexe(AMasterIndexe, ATargetIndexe: TIndexeKeyMIK): Boolean;
begin
  Result := True;
  if AMasterIndexe.Unique <> ATargetIndexe.Unique then
    Exit(False);
//  if AMasterIndexe.Description <> ATargetIndexe.Description then
//    Exit(False);
end;

procedure TDatabaseFactory.GenerateDDLCommands(AMasterDB, ATargetDB: TCatalogMetadataMIK);
begin
  inherited;
  FDDLCommands.Clear;
  // Gera script que desabilita todas as ForeignKeys
  ActionEnableForeignKeys(False);
  // Gera script que desabilita todas as Triggers
  ActionEnableTriggers(False);
  // Compara Tabelas
  CompareTables(AMasterDB, ATargetDB);
  // Compara Views
  CompareViews(AMasterDB, ATargetDB);
  // Compara Sequences
  CompareSequences(AMasterDB, ATargetDB);
  // Compara ForeingKeys
  CompareTablesForeignKeys(AMasterDB, ATargetDB);
  // Gera script que habilita todas as ForeignKeys
  ActionEnableForeignKeys(True);
  // Gera script que habilita todas as Triggers
  ActionEnableTriggers(True);
  // Execute Commands
  ExecuteDDLCommands;
end;

function TDatabaseFactory.GetFieldTypeValid(AFieldType: TFieldType): TFieldType;
begin
  if AFieldType in [ftCurrency, ftFloat, ftBCD, ftExtended, ftSingle, ftFMTBcd] then
    Result := ftCurrency
  else
  if AFieldType in [ftString, ftFixedChar, ftWideString, ftFixedWideChar, ftGuid] then
    Result := ftString
  else
  if AFieldType in [ftInteger, ftShortint, ftSmallint, ftLargeint] then
    Result := ftInteger
  else
  if AFieldType in [ftMemo, ftFmtMemo, ftWideMemo] then
    Result := ftMemo
  else
    Result := AFieldType;
end;

function TDatabaseFactory.KeepEqualsPosition(AMasterColumn,
  ATargetColumn: TColumnMIK): Boolean;
begin
  Result := True;
  if (AMasterColumn.Position <> ATargetColumn.Position) then
    Exit(False);
end;

procedure TDatabaseFactory.CompareTables(AMasterDB, ATargetDB: TCatalogMetadataMIK);
var
  LTableMaster: TPair<string, TTableMIK>;
  LTableTarget: TPair<string, TTableMIK>;
begin
  // Gera script de exclusão de tabela, caso não exista um modelo para ela no banco.
  for LTableTarget in ATargetDB.Tables do
  begin
    if not AMasterDB.Tables.ContainsKey(LTableTarget.Key) then
      ActionDropTable(LTableTarget.Value);
  end;
  // Gera script de criação de tabela, caso a tabela do modelo não exista no banco.
  for LTableMaster in AMasterDB.Tables do
  begin
    if ATargetDB.Tables.ContainsKey(LTableMaster.Key) then
    begin
      // Table Columns
      CompareColumns(LTableMaster.Value, ATargetDB.Tables.Items[LTableMaster.Key]);

      // Table PrimaryKey
      if (LTableMaster.Value.PrimaryKey.Fields.Count > 0) or
         (ATargetDB.Tables.Items[LTableMaster.Key].PrimaryKey.Fields.Count > 0) then
        ComparePrimaryKey(LTableMaster.Value, ATargetDB.Tables.Items[LTableMaster.Key]);

      // Table Indexes
      if (LTableMaster.Value.IndexeKeys.Count > 0) or
         (ATargetDB.Tables.Items[LTableMaster.Key].IndexeKeys.Count > 0) then
        CompareIndexes(LTableMaster.Value, ATargetDB.Tables.Items[LTableMaster.Key]);

      // Table Checks
      if (LTableMaster.Value.Checks.Count > 0) or
         (ATargetDB.Tables.Items[LTableMaster.Key].Checks.Count > 0) then
        CompareChecks(LTableMaster.Value, ATargetDB.Tables.Items[LTableMaster.Key]);

      // Table Triggers
      if (LTableMaster.Value.Triggers.Count > 0) or
         (ATargetDB.Tables.Items[LTableMaster.Key].Triggers.Count > 0) then
        CompareTriggers(LTableMaster.Value, ATargetDB.Tables.Items[LTableMaster.Key]);
    end
    else
      ActionCreateTable(LTableMaster.Value);
  end;
end;

procedure TDatabaseFactory.CompareTriggers(AMasterTable, ATargetTable: TTableMIK);
var
  LTriggerMaster: TPair<string, TTriggerMIK>;
  LTriggerTarget: TPair<string, TTriggerMIK>;
begin
  if TSupportedFeature.Triggers in FGeneratorCommand.SupportedFeatures then
  begin
    // Remove trigger que não existe no modelo.
    for LTriggerTarget in ATargetTable.Triggers do
    begin
      if not AMasterTable.Triggers.ContainsKey(LTriggerTarget.Key) then
  //      ActionDropTrigger(LTriggerTarget.Value);
    end;
    // Gera script de criação de trigger, caso a trigger do modelo não exista no banco.
    for LTriggerMaster in AMasterTable.Triggers do
    begin
      if ATargetTable.Triggers.ContainsKey(LTriggerMaster.Key) then
//        CompareTriggerScript(LTriggerMaster.Value, ATargetTable.Triggers.Items[LTriggerMaster.Key])
      else
//        ActionCreateTrigger(LTriggerMaster.Value);
    end;
  end;
end;

procedure TDatabaseFactory.CompareViews(AMasterDB, ATargetDB: TCatalogMetadataMIK);
var
  LViewMaster: TPair<string, TViewMIK>;
  LViewTarget: TPair<string, TViewMIK>;
begin
  if TSupportedFeature.Triggers in FGeneratorCommand.SupportedFeatures then
  begin
    // Gera script de exclusão da view, caso não exista um modelo para ela no banco.
    for LViewTarget in ATargetDB.Views do
    begin
      if not AMasterDB.Views.ContainsKey(LViewTarget.Key) then
        ActionDropView(LViewTarget.Value);
    end;
    // Gera script de criação da view, caso a view do modelo não exista no banco.
    for LViewMaster in AMasterDB.Views do
    begin
      if ATargetDB.Views.ContainsKey(LViewMaster.Key) then
      begin
        LViewTarget.Value := LViewMaster.Value;

        if CompareText(LViewMaster.Value.Script, LViewTarget.Value.Script) <> 0 then
          ActionDropView(LViewTarget.Value);
      end
      else
        ActionCreateView(LViewMaster.Value);
    end;
  end;
end;

procedure TDatabaseFactory.CompareChecks(AMasterTable, ATargetTable: TTableMIK);
var
  LCheckMaster: TPair<string, TCheckMIK>;
  LCheckTarget: TPair<string, TCheckMIK>;
begin
  if TSupportedFeature.Checks in FGeneratorCommand.SupportedFeatures then
  begin
     for LCheckTarget in ATargetTable.Checks do
     begin
       if not AMasterTable.Checks.ContainsKey(LCheckTarget.Key) then
         ActionDropCheck(LCheckTarget.Value);
     end;

     for LCheckMaster in AMasterTable.Checks do
     begin
       if ATargetTable.Checks.ContainsKey(LCheckMaster.Key) then
         ActionDropCheck(LCheckTarget.Value);

       ActionAlterCheck(LCheckMaster.Value);
     end;
  end;
end;

procedure TDatabaseFactory.CompareColumns(AMasterTable, ATargetTable: TTableMIK);
var
  LColumnMaster: TPair<string, TColumnMIK>;
  LColumnTarget: TPair<string, TColumnMIK>;
  LColumn: TColumnMIK;
  LReorderColumns: Boolean;

  function ExistMasterColumn(AColumnName: string): TColumnMIK;
  var
    LColumn: TColumnMIK;
  begin
    Result := nil;
    for LColumn in AMasterTable.Fields.Values do
      if SameText(LColumn.Name, AColumnName) then
        Exit(LColumn);
  end;

  function ExistTargetColumn(AColumnName: string): TColumnMIK;
  var
    LColumn: TColumnMIK;
  begin
    Result := nil;
    for LColumn in ATargetTable.Fields.Values do
      if SameText(LColumn.Name, AColumnName) then
        Exit(LColumn);
  end;

begin
  // Remove coluna que não existe no modelo.
  for LColumnTarget in ATargetTable.FieldsSort do
  begin
    LColumn := ExistMasterColumn(LColumnTarget.Value.Name);
    if LColumn = nil then
      ActionDropColumn(LColumnTarget.Value);
  end;
  // Adiciona coluna do modelo que não exista no banco
  // Compara coluna que exista no modelo e no banco
  LReorderColumns := False;
  for LColumnMaster in AMasterTable.FieldsSort do
  begin
    LColumn := ExistTargetColumn(LColumnMaster.Value.Name);
    if LColumn = nil then
      ActionCreateColumn(LColumnMaster.Value)
    else
    begin
      if not DeepEqualsColumn(LColumnMaster.Value, LColumn) then
        ActionAlterColumn(LColumnMaster.Value);

      if not KeepEqualsPosition(LColumnMaster.Value, LColumn) then
        LReorderColumns := True;

      // Compara DefaultValue
      if not DeepEqualsDefaultValue(LColumnMaster.Value, LColumn) then
      begin
        if Length(LColumnMaster.Value.DefaultValue) > 0 then
          ActionAlterDefaultValue(LColumnMaster.Value)
        else
          ActionDropDefaultValue(LColumn);
      end;
    end;
  end;
  if ComparerFieldPosition and LReorderColumns then
    for LColumnMaster in AMasterTable.FieldsSort do
    begin
      ActionAlterColumnPosition(LColumnMaster.Value);
    end;
end;

procedure TDatabaseFactory.CompareTablesForeignKeys(AMasterDB, ATargetDB: TCatalogMetadataMIK);
var
  LTableMaster: TPair<string, TTableMIK>;
  LForeignKeyMaster: TPair<string, TForeignKeyMIK>;
begin
  // Gera script de criação das ForeingnKeys, caso não exista no banco.
  for LTableMaster in AMasterDB.Tables do
  begin
    if ATargetDB.Tables.ContainsKey(LTableMaster.Key) then
    begin
      // Table ForeignKeys
      if (LTableMaster.Value.ForeignKeys.Count > 0) or
         (ATargetDB.Tables.Items[LTableMaster.Key].ForeignKeys.Count > 0) then
        CompareForeignKeys(LTableMaster.Value, ATargetDB.Tables.Items[LTableMaster.Key]);
    end
    else
    begin
      // Gera script de criação dos ForeignKey da nova tabela.
      if FDriverName <> dnSQLite then
        for LForeignKeyMaster in LTableMaster.Value.ForeignKeys do
          ActionCreateForeignKey(LForeignKeyMaster.Value);
    end;
  end;
end;

function TDatabaseFactory.DeepEqualsForeignKeyFromColumns(AMasterForeignKey, ATargetForeignKey: TForeignKeyMIK): Boolean;
var
  LColumnMaster: TPair<string, TColumnMIK>;
  LColumnTarget: TPair<string, TColumnMIK>;
  LColumn: TColumnMIK;

  function ExistMasterFromColumn(AColumnName: string): TColumnMIK;
  var
    LColumn: TPair<string, TColumnMIK>;
  begin
    Result := nil;
    for LColumn in AMasterForeignKey.FromFields do
      if SameText(LColumn.Value.Name, AColumnName) then
        Exit(LColumn.Value);
  end;

  function ExistTargetFromColumn(AColumnName: string): TColumnMIK;
  var
    LColumn: TPair<string, TColumnMIK>;
  begin
    Result := nil;
    for LColumn in ATargetForeignKey.FromFields do
      if SameText(LColumn.Value.Name, AColumnName) then
        Exit(LColumn.Value);
  end;

begin
  Result := True;
  // Comparação dos campos dos indexes banco/modelo
  for LColumnTarget in ATargetForeignKey.FromFieldsSort do
  begin
    LColumn := ExistMasterFromColumn(LColumnTarget.Value.Name);
    if LColumn = nil then
      Exit(False)
  end;
  // Comparação dos campos dos indexes modelo/banco
  for LColumnMaster in AMasterForeignKey.FromFieldsSort do
  begin
    LColumn := ExistTargetFromColumn(LColumnMaster.Value.Name);
    if LColumn = nil then
      Exit(False)
    else
    begin
      if not DeepEqualsColumn(LColumnMaster.Value, LColumn) then
        Exit(False);
    end;
  end;
end;

procedure TDatabaseFactory.CompareForeignKeys(AMasterTable, ATargetTable: TTableMIK);
var
  LForeignKeyMaster: TPair<string, TForeignKeyMIK>;
  LForeignKeyTarget: TPair<string, TForeignKeyMIK>;
begin
  if TSupportedFeature.ForeignKeys in FGeneratorCommand.SupportedFeatures then
  begin
    // Remove indexe que não existe no modelo.
    for LForeignKeyTarget in ATargetTable.ForeignKeys do
    begin
      if not AMasterTable.ForeignKeys.ContainsKey(LForeignKeyTarget.Key) then
        ActionDropForeignKey(LForeignKeyTarget.Value);
    end;
    // Gera script de criação de indexe, caso a indexe do modelo não exista no banco.
    for LForeignKeyMaster in AMasterTable.ForeignKeys do
    begin
      if ATargetTable.ForeignKeys.ContainsKey(LForeignKeyMaster.Key) then
      begin
        // Checa diferença do ForeignKey
        LForeignKeyTarget.Value := ATargetTable.ForeignKeys.Items[LForeignKeyMaster.Key];

        if (not DeepEqualsForeignKey(LForeignKeyMaster.Value, LForeignKeyTarget.Value)) or
           (not DeepEqualsForeignKeyFromColumns(LForeignKeyMaster.Value, LForeignKeyTarget.Value)) or
           (not DeepEqualsForeignKeyToColumns  (LForeignKeyMaster.Value, LForeignKeyTarget.Value)) then
        begin
          ActionDropForeignKey(LForeignKeyTarget.Value);
          ActionCreateForeignKey(LForeignKeyMaster.Value);
        end;
      end
      else
        ActionCreateForeignKey(LForeignKeyMaster.Value);
    end;
  end;
end;

function TDatabaseFactory.DeepEqualsForeignKeyToColumns(AMasterForeignKey, ATargetForeignKey: TForeignKeyMIK): Boolean;
var
  LColumnMaster: TPair<string, TColumnMIK>;
  LColumnTarget: TPair<string, TColumnMIK>;
  LColumn: TColumnMIK;

  function ExistMasterToColumn(AColumnName: string): TColumnMIK;
  var
    LColumn: TPair<string, TColumnMIK>;
  begin
    Result := nil;
    for LColumn in AMasterForeignKey.ToFields do
      if SameText(LColumn.Value.Name, AColumnName) then
        Exit(LColumn.Value);
  end;

  function ExistTargetFromColumn(AColumnName: string): TColumnMIK;
  var
    LColumn: TPair<string, TColumnMIK>;
  begin
    Result := nil;
    for LColumn in ATargetForeignKey.ToFields do
      if SameText(LColumn.Value.Name, AColumnName) then
        Exit(LColumn.Value);
  end;

begin
  Result := True;
  // Comparação dos campos dos indexes banco/modelo
  for LColumnTarget in ATargetForeignKey.ToFieldsSort do
  begin
    LColumn := ExistMasterToColumn(LColumnTarget.Value.Name);
    if LColumn = nil then
      Exit(False)
  end;
  // Comparação dos campos dos indexes modelo/banco
  for LColumnMaster in AMasterForeignKey.ToFieldsSort do
  begin
    LColumn := ExistTargetFromColumn(LColumnMaster.Value.Name);
    if LColumn = nil then
      Exit(False)
    else
    begin
      if not DeepEqualsColumn(LColumnMaster.Value, LColumn) then
        Exit(False);
    end;
  end;
end;

function TDatabaseFactory.DeepEqualsIndexeColumns(AMasterIndexe, ATargetIndexe: TIndexeKeyMIK): Boolean;
var
  LColumnMaster: TPair<string, TColumnMIK>;
  LColumnTarget: TPair<string, TColumnMIK>;
  LColumn: TColumnMIK;

  function ExistMasterColumn(AColumnName: string): TColumnMIK;
  var
    LColumn: TPair<string, TColumnMIK>;
  begin
    Result := nil;
    for LColumn in AMasterIndexe.Fields do
      if SameText(LColumn.Value.Name, AColumnName) then
        Exit(LColumn.Value);
  end;

  function ExistTargetColumn(AColumnName: string): TColumnMIK;
  var
    LColumn: TPair<string, TColumnMIK>;
  begin
    Result := nil;
    for LColumn in ATargetIndexe.Fields do
      if SameText(LColumn.Value.Name, AColumnName) then
        Exit(LColumn.Value);
  end;

begin
  Result := True;
  // Comparação dos campos dos indexes banco/modelo
  for LColumnTarget in ATargetIndexe.FieldsSort do
  begin
    LColumn := ExistMasterColumn(LColumnTarget.Value.Name);
    if LColumn = nil then
      Exit(False)
  end;
  // Comparação dos campos dos indexes modelo/banco
  for LColumnMaster in AMasterIndexe.FieldsSort do
  begin
    LColumn := ExistTargetColumn(LColumnMaster.Value.Name);
    if LColumn = nil then
      Exit(False)
    else
    begin
      if not DeepEqualsColumn(LColumnMaster.Value, LColumn) then
        Exit(False);
    end;
  end;
end;

procedure TDatabaseFactory.CompareIndexes(AMasterTable, ATargetTable: TTableMIK);
var
  LIndexeMaster: TPair<string, TIndexeKeyMIK>;
  LIndexeTarget: TPair<string, TIndexeKeyMIK>;
begin
  // Remove indexe que não existe no modelo.
  for LIndexeTarget in ATargetTable.IndexeKeys do
  begin
    if not AMasterTable.IndexeKeys.ContainsKey(LIndexeTarget.Key) then
      ActionDropIndexe(LIndexeTarget.Value);
  end;
  // Gera script de criação de indexe, caso a indexe do modelo não exista no banco.
  for LIndexeMaster in AMasterTable.IndexeKeys do
  begin
    if ATargetTable.IndexeKeys.ContainsKey(LIndexeMaster.Key) then
    begin
      LIndexeTarget.Value := ATargetTable.IndexeKeys.Items[LIndexeMaster.Key];
      if (not DeepEqualsIndexe(LIndexeMaster.Value, LIndexeTarget.Value)) or
         (not DeepEqualsIndexeColumns(LIndexeMaster.Value, LIndexeTarget.Value)) then
      begin
        ActionDropIndexe(LIndexeTarget.Value);
        ActionCreateIndexe(LIndexeMaster.Value);
      end;
    end
    else
      ActionCreateIndexe(LIndexeMaster.Value);
  end;
end;

procedure TDatabaseFactory.ComparePrimaryKey(AMasterTable, ATargetTable: TTableMIK);
var
  LColumnMaster: TPair<string, TColumnMIK>;
  LColumn: TColumnMIK;
  LDropPK: Boolean;
  LRecreatePK: Boolean;

  function ExistTargetColumn(AColumnName: string): TColumnMIK;
  var
    LColumn: TPair<string, TColumnMIK>;
  begin
    Result := nil;
    for LColumn in ATargetTable.PrimaryKey.Fields do
      if SameText(LColumn.Value.Name, AColumnName) then
        Exit(LColumn.Value);
  end;

begin
  LDropPK := False;
  if not SameText(AMasterTable.PrimaryKey.Name, ATargetTable.PrimaryKey.Name) and
    (Trim(ATargetTable.PrimaryKey.Name) <> EmptyStr) then
  begin
  	LDropPK := True;
  end;

  // Se alguma coluna não existir na PrimaryKey do banco recria a PrimaryKey.
  LRecreatePK := False;
  for LColumnMaster in AMasterTable.PrimaryKey.FieldsSort do
  begin
    LColumn := ExistTargetColumn(LColumnMaster.Value.Name);
    if LColumn = nil then
    begin
      LRecreatePK := True;
      Break;
    end;
  end;
  if LDropPK then
    ActionDropPrimaryKey(ATargetTable.PrimaryKey);
  if LRecreatePK then
    ActionCreatePrimaryKey(AMasterTable.PrimaryKey);
end;

procedure TDatabaseFactory.CompareSequences(AMasterDB, ATargetDB: TCatalogMetadataMIK);
var
  LSequenceMaster: TPair<string, TSequenceMIK>;
  LSequenceTarget: TPair<string, TSequenceMIK>;
begin
  if TSupportedFeature.Sequences in FGeneratorCommand.SupportedFeatures then
  begin
    // Checa se existe alguma sequence no banco, da qual não exista nos modelos
    // para exclusão da mesma.
    for LSequenceTarget in ATargetDB.Sequences do
    begin
      if not AMasterDB.Sequences.ContainsKey(LSequenceTarget.Key) then
        ActionDropSequence(LSequenceTarget.Value);
    end;
    // Checa se existe a sequence no banco, se não existir cria se existir.
    for LSequenceMaster in AMasterDB.Sequences do
    begin
      if not ATargetDB.Sequences.ContainsKey(LSequenceMaster.Key) then
        ActionCreateSequence(LSequenceMaster.Value);
    end;
  end;
end;

procedure TDatabaseFactory.ActionAlterColumn(AColumn: TColumnMIK);
begin
  FDDLCommands.Add(TDDLCommandAlterColumn.Create(AColumn));
end;

procedure TDatabaseFactory.ActionAlterColumnPosition(AColumn: TColumnMIK);
begin
  FDDLCommands.Add(TDDLCommandAlterColumnPosition.Create(AColumn));
end;

procedure TDatabaseFactory.ActionAlterDefaultValue(AColumn: TColumnMIK);
begin
  FDDLCommands.Add(TDDLCommandAlterDefaultValue.Create(AColumn));
end;

procedure TDatabaseFactory.ActionCreateCheck(ACheck: TCheckMIK);
begin
  FDDLCommands.Add(TDDLCommandCreateCheck.Create(ACheck));
end;

procedure TDatabaseFactory.ActionAlterCheck(ACheck: TCheckMIK);
begin
  FDDLCommands.Add(TDDLCommandAlterCheck.Create(ACheck));
end;

procedure TDatabaseFactory.ActionCreateColumn(AColumn: TColumnMIK);
begin
  FDDLCommands.Add(TDDLCommandCreateColumn.Create(AColumn));
end;

procedure TDatabaseFactory.ActionCreateForeignKey(AForeignKey: TForeignKeyMIK);
begin
  FDDLCommands.Add(TDDLCommandCreateForeignKey.Create(AForeignKey));
end;

procedure TDatabaseFactory.ActionCreateIndexe(AIndexe: TIndexeKeyMIK);
begin
  FDDLCommands.Add(TDDLCommandCreateIndexe.Create(AIndexe));
end;

procedure TDatabaseFactory.ActionCreatePrimaryKey(APrimaryKey: TPrimaryKeyMIK);
begin
  FDDLCommands.Add(TDDLCommandCreatePrimaryKey.Create(APrimaryKey));
end;

procedure TDatabaseFactory.ActionCreateSequence(ASequence: TSequenceMIK);
begin
  FDDLCommands.Add(TDDLCommandCreateSequence.Create(ASequence));
end;

procedure TDatabaseFactory.ActionCreateTable(ATable: TTableMIK);
begin
  FDDLCommands.Add(TDDLCommandCreateTable.Create(ATable));
end;

procedure TDatabaseFactory.ActionCreateView(AView: TViewMIK);
begin
  FDDLCommands.Add(TDDLCommandCreateView.Create(AView));
end;

procedure TDatabaseFactory.ActionDropCheck(ACheck: TCheckMIK);
begin
  FDDLCommands.Add(TDDLCommandDropCheck.Create(ACheck));
end;

procedure TDatabaseFactory.ActionDropColumn(AColumn: TColumnMIK);
begin
  FDDLCommands.Add(TDDLCommandDropColumn.Create(AColumn));
end;

procedure TDatabaseFactory.ActionDropDefaultValue(AColumn: TColumnMIK);
begin
  FDDLCommands.Add(TDDLCommandDropDefaultValue.Create(AColumn));
end;

procedure TDatabaseFactory.ActionDropForeignKey(AForeignKey: TForeignKeyMIK);
begin
  FDDLCommands.Add(TDDLCommandDropForeignKey.Create(AForeignKey));
end;

procedure TDatabaseFactory.ActionDropIndexe(AIndexe: TIndexeKeyMIK);
begin
  FDDLCommands.Add(TDDLCommandDropIndexe.Create(AIndexe));
end;

procedure TDatabaseFactory.ActionDropPrimaryKey(APrimaryKey: TPrimaryKeyMIK);
begin
  FDDLCommands.Add(TDDLCommandDropPrimaryKey.Create(APrimaryKey));
end;

procedure TDatabaseFactory.ActionDropSequence(ASequence: TSequenceMIK);
begin
  FDDLCommands.Add(TDDLCommandDropSequence.Create(ASequence));
end;

procedure TDatabaseFactory.ActionDropTable(ATable: TTableMIK);
begin
  FDDLCommands.Add(TDDLCommandDropTable.Create(ATable));
end;

procedure TDatabaseFactory.ActionDropView(AView: TViewMIK);
begin
  FDDLCommands.Add(TDDLCommandDropView.Create(AView));
end;

procedure TDatabaseFactory.ActionEnableForeignKeys(AEnable: Boolean);
begin
  FDDLCommands.Add(TDDLCommandEnableForeignKeys.Create(AEnable));
end;

procedure TDatabaseFactory.ActionEnableTriggers(AEnable: Boolean);
begin
  FDDLCommands.Add(TDDLCommandEnableTriggers.Create(AEnable));
end;

end.
