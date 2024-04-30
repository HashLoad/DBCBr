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
  @created(12 Out 2016)
  @author(Isaque Pinheiro <isaquepsp@gmail.com>)
  @author(Skype : ispinheiro)

  ORM Brasil é um ORM simples e descomplicado para quem utiliza Delphi.
}

unit dbcbr.ddl.generator;

interface

uses
  SysUtils,
  Generics.Collections,
  dbcbr.ddl.interfaces,
  dbebr.factory.interfaces,
  dbcbr.database.mapping,
  dbcbr.types.mapping;

type
  TDDLSQLGeneratorAbstract = class abstract(TInterfacedObject, IDDLGeneratorCommand)
  protected
    FConnection: IDBConnection;
  public
    function GenerateCreateTable(ATable: TTableMIK): String; virtual; abstract;
    function GenerateCreateColumn(AColumn: TColumnMIK): String; virtual; abstract;
    function GenerateCreatePrimaryKey(APrimaryKey: TPrimaryKeyMIK): String; virtual; abstract;
    function GenerateCreateForeignKey(AForeignKey: TForeignKeyMIK): String; virtual; abstract;
    function GenerateCreateSequence(ASequence: TSequenceMIK): String; virtual; abstract;
    function GenerateCreateIndexe(AIndexe: TIndexeKeyMIK): String; virtual; abstract;
    function GenerateCreateCheck(ACheck: TCheckMIK): String; virtual; abstract;
    function GenerateCreateView(AView: TViewMIK): String; virtual; abstract;
    function GenerateCreateTrigger(ATrigger: TTriggerMIK): String; virtual; abstract;
    function GenerateAlterColumn(AColumn: TColumnMIK): String; virtual; abstract;
    function GenerateAlterColumnPosition(AColumn: TColumnMIK): String; virtual; abstract;
    function GenerateAlterDefaultValue(AColumn: TColumnMIK): String; virtual; abstract;
    function GenerateAlterCheck(ACheck: TCheckMIK): String; virtual; abstract;
    function GenerateAddPrimaryKey(APrimaryKey: TPrimaryKeyMIK): String; virtual; abstract;
    function GenerateDropTable(ATable: TTableMIK): String; virtual; abstract;
    function GenerateDropPrimaryKey(APrimaryKey: TPrimaryKeyMIK): String; virtual; abstract;
    function GenerateDropForeignKey(AForeignKey: TForeignKeyMIK): String; virtual; abstract;
    function GenerateDropSequence(ASequence: TSequenceMIK): String; virtual; abstract;
    function GenerateDropIndexe(AIndexe: TIndexeKeyMIK): String; virtual; abstract;
    function GenerateDropCheck(ACheck: TCheckMIK): String; virtual; abstract;
    function GenerateDropColumn(AColumn: TColumnMIK): String; virtual; abstract;
    function GenerateDropDefaultValue(AColumn: TColumnMIK): String; virtual; abstract;
    function GenerateDropView(AView: TViewMIK): String; virtual; abstract;
    function GenerateDropTrigger(ATrigger: TTriggerMIK): String; virtual; abstract;
    function GenerateEnableForeignKeys(AEnable: Boolean): String; virtual; abstract;
    function GenerateEnableTriggers(AEnable: Boolean): String; virtual; abstract;
    /// <summary>
    /// Propriedade para identificar os recursos de diferentes banco de dados
    /// usando o mesmo modelo.
    /// </summary>
    function GetSupportedFeatures: TSupportedFeatures; virtual; abstract;
    property SupportedFeatures: TSupportedFeatures read GetSupportedFeatures;
  end;

  TDDLSQLGenerator = class(TDDLSQLGeneratorAbstract)
  protected
    function GetRuleDeleteActionDefinition(ARuleAction: TRuleAction): String;
    function GetRuleUpdateActionDefinition(ARuleAction: TRuleAction): String;
    function GetPrimaryKeyColumnsDefinition(APrimaryKey: TPrimaryKeyMIK): String;
    function GetForeignKeyFromColumnsDefinition(AForeignKey: TForeignKeyMIK): String;
    function GetForeignKeyToColumnsDefinition(AForeignKey: TForeignKeyMIK): String;
    function GetIndexeKeyColumnsDefinition(AIndexeKey: TIndexeKeyMIK): String;
    function GetUniqueColumnDefinition(AUnique: Boolean): String;
    function GetFieldTypeDefinition(AColumn: TColumnMIK): String;
    function GetFieldNotNullDefinition(AColumn: TColumnMIK): String;
    function GetCreateFieldDefaultDefinition(AColumn: TColumnMIK): String;
    function GetAlterFieldDefaultDefinition(AColumn: TColumnMIK): String;
    function BuilderCreateFieldDefinition(AColumn: TColumnMIK): String; virtual;
    function BuilderAlterFieldDefinition(AColumn: TColumnMIK): String; virtual;
    function BuilderPrimayKeyDefinition(ATable: TTableMIK): String; virtual;
    function BuilderIndexeDefinition(ATable: TTableMIK): String; virtual;
    function BuilderForeignKeyDefinition(ATable: TTableMIK): String; virtual;
    function BuilderCheckDefinition(ATable: TTableMIK): String; virtual;
  public
    function GenerateCreateTable(ATable: TTableMIK): String; override;
    function GenerateCreateColumn(AColumn: TColumnMIK): String; override;
    function GenerateCreatePrimaryKey(APrimaryKey: TPrimaryKeyMIK): String; override;
    function GenerateCreateForeignKey(AForeignKey: TForeignKeyMIK): String; override;
    function GenerateCreateView(AView: TViewMIK): String; override;
    function GenerateCreateTrigger(ATrigger: TTriggerMIK): String; override;
    function GenerateCreateSequence(ASequence: TSequenceMIK): String; override;
    function GenerateCreateIndexe(AIndexe: TIndexeKeyMIK): String; override;
    function GenerateCreateCheck(ACheck: TCheckMIK): String; override;
    function GenerateAlterColumn(AColumn: TColumnMIK): String; override;
    function GenerateAlterCheck(ACheck: TCheckMIK): String; override;
    function GenerateAddPrimaryKey(APrimaryKey: TPrimaryKeyMIK): String; override;
    function GenerateDropTable(ATable: TTableMIK): String; override;
    function GenerateDropColumn(AColumn: TColumnMIK): String; override;
    function GenerateDropPrimaryKey(APrimaryKey: TPrimaryKeyMIK): String; override;
    function GenerateDropForeignKey(AForeignKey: TForeignKeyMIK): String; override;
    function GenerateDropIndexe(AIndexe: TIndexeKeyMIK): String; override;
    function GenerateDropCheck(ACheck: TCheckMIK): String; override;
    function GenerateDropView(AView: TViewMIK): String; override;
    function GenerateDropTrigger(ATrigger: TTriggerMIK): String; override;
    function GenerateDropSequence(ASequence: TSequenceMIK): String; override;
    /// <summary>
    /// Propriedade para identificar os recursos de diferentes banco de dados
    /// usando o mesmo modelo.
    /// </summary>
    function GetSupportedFeatures: TSupportedFeatures; override;
    property SupportedFeatures: TSupportedFeatures read GetSupportedFeatures;
  end;

implementation

uses
  StrUtils;

{ TDDLSQLGenerator }

function TDDLSQLGenerator.GenerateCreateTable(ATable: TTableMIK): String;
begin
  Result := 'CREATE TABLE %s (';
end;

function TDDLSQLGenerator.GenerateCreateTrigger(ATrigger: TTriggerMIK): String;
begin
  Result := 'CREATE TRIGGER %s AS %s;';
  Result := Format(Result, [ATrigger.Name, ATrigger.Script]);
end;

function TDDLSQLGenerator.GenerateCreateView(AView: TViewMIK): String;
begin
  Result := 'CREATE VIEW %s AS %s;';
  Result := Format(Result, [AView.Name, AView.Script]);
end;

function TDDLSQLGenerator.GenerateDropTable(ATable: TTableMIK): String;
begin
  Result := 'DROP TABLE %s;';
  if ATable.Database.Schema <> '' then
    Result := Format(Result, [ATable.Database.Schema + '.' + ATable.Name])
  else
    Result := Format(Result, [ATable.Name]);
end;

function TDDLSQLGenerator.GenerateDropTrigger(ATrigger: TTriggerMIK): String;
begin
  Result := 'DROP TRIGGER %s;';
  Result := Format(Result, [ATrigger.Name]);
end;

function TDDLSQLGenerator.GenerateDropView(AView: TViewMIK): String;
begin
  Result := 'DROP VIEW %s;';
  Result := Format(Result, [AView.Name]);
end;

function TDDLSQLGenerator.GenerateAddPrimaryKey(APrimaryKey: TPrimaryKeyMIK): String;
begin
  Result := 'ALTER TABLE %s ADD PRIMARY KEY (%s);';
  Result := Format(Result, [APrimaryKey.Table.Name,
                            GetPrimaryKeyColumnsDefinition(APrimaryKey)]);
end;

function TDDLSQLGenerator.GenerateAlterColumn(AColumn: TColumnMIK): String;
begin
  Result := 'ALTER TABLE %s ALTER COLUMN %s;';
  Result := Format(Result, [AColumn.Table.Name, BuilderAlterFieldDefinition(AColumn)]);
end;

function TDDLSQLGenerator.GenerateCreateCheck(ACheck: TCheckMIK): String;
begin
  Result := 'CONSTRAINT %s CHECK (%s)';
  Result := Format(Result, [ACheck.Name, ACheck.Condition]);
end;

function TDDLSQLGenerator.GenerateAlterCheck(ACheck: TCheckMIK): String;
begin
  Result := 'ALTER TABLE %s ADD CONSTRAINT %s CHECK (%s);';
  Result := Format(Result, [ACheck.Table.Name,  ACheck.Name, ACheck.Condition]);
end;

function TDDLSQLGenerator.GenerateCreateColumn(AColumn: TColumnMIK): String;
begin
  Result := 'ALTER TABLE %s ADD %s;';
  Result := Format(Result, [AColumn.Table.Name, BuilderCreateFieldDefinition(AColumn)]);
end;

function TDDLSQLGenerator.GenerateCreateForeignKey(AForeignKey: TForeignKeyMIK): String;
begin
  Result := 'ALTER TABLE %s ADD CONSTRAINT %s FOREIGN KEY (%s) REFERENCES %s(%s) %s %s';
  Result := Format(Result, [AForeignKey.Table.Name,
                            AForeignKey.Name,
                            GetForeignKeyFromColumnsDefinition(AForeignKey),
                            AForeignKey.FromTable,
                            GetForeignKeyToColumnsDefinition(AForeignKey),
                            GetRuleDeleteActionDefinition(AForeignKey.OnDelete),
                            GetRuleUpdateActionDefinition(AForeignKey.OnUpdate)]);
  Result := Trim(Result) + ';';
end;

function TDDLSQLGenerator.GenerateCreateIndexe(AIndexe: TIndexeKeyMIK): String;
begin
  Result := 'CREATE %s INDEX %s ON %s (%s);';
  Result := Format(Result, [GetUniqueColumnDefinition(AIndexe.Unique),
                            AIndexe.Name,
                            AIndexe.Table.Name,
                            GetIndexeKeyColumnsDefinition(AIndexe)]);
end;

function TDDLSQLGenerator.GenerateCreatePrimaryKey(APrimaryKey: TPrimaryKeyMIK): String;
begin
  Result := 'CONSTRAINT %s PRIMARY KEY (%s)';
  Result := Format(Result, [APrimaryKey.Name,
                            GetPrimaryKeyColumnsDefinition(APrimaryKey)]);
end;

function TDDLSQLGenerator.GenerateCreateSequence(ASequence: TSequenceMIK): String;
begin
  Result := '';
end;

function TDDLSQLGenerator.GenerateDropColumn(AColumn: TColumnMIK): String;
begin
  Result := 'ALTER TABLE %s DROP COLUMN %s;';
  Result := Format(Result, [AColumn.Table.Name, AColumn.Name]);
end;

function TDDLSQLGenerator.GenerateDropForeignKey(AForeignKey: TForeignKeyMIK): String;
begin
  Result := 'ALTER TABLE %s DROP CONSTRAINT %s;';
  Result := Format(Result, [AForeignKey.Table.Name, AForeignKey.Name]);
end;

function TDDLSQLGenerator.GenerateDropIndexe(AIndexe: TIndexeKeyMIK): String;
begin
  Result := 'DROP INDEX %s ON %s;';
  Result := Format(Result, [AIndexe.Name, AIndexe.Table.Name]);
end;

function TDDLSQLGenerator.GenerateDropCheck(ACheck: TCheckMIK): String;
begin
  Result := 'ALTER TABLE %s DROP CONSTRAINT %s;';
  Result := Format(Result, [ACheck.Table.Name, ACheck.Name]);
end;

function TDDLSQLGenerator.GenerateDropPrimaryKey(APrimaryKey: TPrimaryKeyMIK): String;
begin
  Result := 'ALTER TABLE %s DROP CONSTRAINT %s;';
  Result := Format(Result, [APrimaryKey.Table.Name, APrimaryKey.Name]);
end;

function TDDLSQLGenerator.GenerateDropSequence(ASequence: TSequenceMIK): String;
begin
  Result := 'DROP SEQUENCE %s;';
  Result := Format(Result, [ASequence.Name]);
end;

function TDDLSQLGenerator.GetAlterFieldDefaultDefinition(AColumn: TColumnMIK): String;
begin
  Result := IfThen(Length(AColumn.DefaultValue) > 0, AColumn.DefaultValue, '');
end;

function TDDLSQLGenerator.GetCreateFieldDefaultDefinition(AColumn: TColumnMIK): String;
begin
  Result := IfThen(Length(AColumn.DefaultValue) > 0, ' DEFAULT ' + AColumn.DefaultValue, '');
end;

function TDDLSQLGenerator.BuilderAlterFieldDefinition(AColumn: TColumnMIK): String;
begin
  Result := AColumn.Name + ' ' +
            GetFieldTypeDefinition(AColumn)    +
//            GetAlterFieldDefaultDefinition(AColumn) +
            GetFieldNotNullDefinition(AColumn) ;
end;

function TDDLSQLGenerator.BuilderCheckDefinition(ATable: TTableMIK): String;
var
  oCheck: TPair<String,TCheckMIK>;
begin
  Result := '';
  for oCheck in ATable.Checks do
  begin
    Result := Result + sLineBreak;
    Result := Result + '  ' + GenerateCreateCheck(oCheck.Value);
  end;
end;

function TDDLSQLGenerator.BuilderCreateFieldDefinition(AColumn: TColumnMIK): String;
begin
  Result := AColumn.Name + ' ' +
            GetFieldTypeDefinition(AColumn) +
            GetCreateFieldDefaultDefinition(AColumn) +
            GetFieldNotNullDefinition(AColumn) ;
end;

function TDDLSQLGenerator.BuilderForeignKeyDefinition(ATable: TTableMIK): String;
var
  oForeignKey: TPair<String,TForeignKeyMIK>;
begin
  Result := '';
  for oForeignKey in ATable.ForeignKeys do
  begin
    Result := Result + sLineBreak;
    Result := Result + '  ' + GenerateCreateForeignKey(oForeignKey.Value);
  end;
end;

function TDDLSQLGenerator.GetFieldNotNullDefinition(AColumn: TColumnMIK): String;
begin
  Result := ifThen(AColumn.NotNull, ' NOT NULL', '');
end;

function TDDLSQLGenerator.GetFieldTypeDefinition(AColumn: TColumnMIK): String;
var
  LResult: String;
begin
  LResult := AColumn.TypeName + IfThen(Length(AColumn.CharSet) > 0, ' CHARACTER SET ' + AColumn.CharSet, '');
  LResult := StringReplace(LResult, '%l', IntToStr(AColumn.Size), [rfIgnoreCase]);
  LResult := StringReplace(LResult, '%p', IntToStr(AColumn.Precision), [rfIgnoreCase]);
  LResult := StringReplace(LResult, '%s', IntToStr(AColumn.Scale), [rfIgnoreCase]);
  Result  := ' ' + LResult;
end;

function TDDLSQLGenerator.BuilderIndexeDefinition(ATable: TTableMIK): String;
var
  oIndexe: TPair<String,TIndexeKeyMIK>;
begin
  Result := '';
  for oIndexe in ATable.IndexeKeys do
  begin
    Result := Result + sLineBreak;
    Result := Result + GenerateCreateIndexe(oIndexe.Value);
  end;
end;

function TDDLSQLGenerator.BuilderPrimayKeyDefinition(ATable: TTableMIK): String;
begin
  Result := '  ' + GenerateCreatePrimaryKey(ATable.PrimaryKey);
end;

function TDDLSQLGenerator.GetRuleDeleteActionDefinition(ARuleAction: TRuleAction): String;
begin
  Result := '';
  if      ARuleAction in [TRuleAction.Cascade]    then Result := 'ON DELETE CASCADE'
  else if ARuleAction in [TRuleAction.SetNull]    then Result := 'ON DELETE SET NULL'
  else if ARuleAction in [TRuleAction.SetDefault] then Result := 'ON DELETE SET DEFAULT';
end;

function TDDLSQLGenerator.GetRuleUpdateActionDefinition(ARuleAction: TRuleAction): String;
begin
  Result := '';
  if      ARuleAction in [TRuleAction.Cascade]    then Result := 'ON UPDATE CASCADE'
  else if ARuleAction in [TRuleAction.SetNull]    then Result := 'ON UPDATE SET NULL'
  else if ARuleAction in [TRuleAction.SetDefault] then Result := 'ON UPDATE SET DEFAULT';
end;

function TDDLSQLGenerator.GetSupportedFeatures: TSupportedFeatures;
begin
  Result := [TSupportedFeature.Sequences,
             TSupportedFeature.ForeignKeys,
             TSupportedFeature.Checks,
             TSupportedFeature.Views,
             TSupportedFeature.Triggers];
end;

function TDDLSQLGenerator.GetUniqueColumnDefinition(AUnique: Boolean): String;
begin
  Result := ifThen(AUnique, 'UNIQUE', '');
end;

function TDDLSQLGenerator.GetForeignKeyFromColumnsDefinition(AForeignKey: TForeignKeyMIK): String;
var
  oColumn: TPair<String,TColumnMIK>;
begin
  for oColumn in AForeignKey.FromFieldsSort do
    Result := Result + oColumn.Value.Name + ', ';
  Result := Trim(Result);
  Delete(Result, Length(Result), 1);
end;

function TDDLSQLGenerator.GetForeignKeyToColumnsDefinition(AForeignKey: TForeignKeyMIK): String;
var
  oColumn: TPair<String,TColumnMIK>;
begin
  for oColumn in AForeignKey.ToFieldsSort do
    Result := Result + oColumn.Value.Name + ', ';
  Result := Trim(Result);
  Delete(Result, Length(Result), 1);
end;

function TDDLSQLGenerator.GetIndexeKeyColumnsDefinition(AIndexeKey: TIndexeKeyMIK): String;
var
  oColumn: TPair<String,TColumnMIK>;
begin
  for oColumn in AIndexeKey.FieldsSort do
    Result := Result + oColumn.Value.Name + ', ';
  Result := Trim(Result);
  Delete(Result, Length(Result), 1);
end;

function TDDLSQLGenerator.GetPrimaryKeyColumnsDefinition(APrimaryKey: TPrimaryKeyMIK): String;
var
  oColumn: TPair<String,TColumnMIK>;
begin
  for oColumn in APrimaryKey.FieldsSort do
    Result := Result + oColumn.Value.Name + ', ';
  Result := Trim(Result);
  Delete(Result, Length(Result), 1);
end;

end.
