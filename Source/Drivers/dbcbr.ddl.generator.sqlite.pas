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

unit dbcbr.ddl.generator.sqlite;

interface

uses
  SysUtils,
  StrUtils,
  Generics.Collections,
  dbebr.factory.interfaces,
  dbcbr.ddl.register,
  dbcbr.ddl.generator,
  dbcbr.database.mapping;

type
  TDDLSQLGeneratorSQLite = class(TDDLSQLGenerator)
  protected
    function BuilderCreateFieldDefinition(AColumn: TColumnMIK): String; override;
    function GetFieldPrimaryKeyAutoincrement(AColumn: TColumnMIK): String;
  public
    function GenerateCreateTable(ATable: TTableMIK): String; override;
    function GenerateCreateSequence(ASequence: TSequenceMIK): String; override;
    function GenerateCreateForeignKey(AForeignKey: TForeignKeyMIK): String; override;
    function GenerateDropTable(ATable: TTableMIK): String; override;
    function GenerateDropSequence(ASequence: TSequenceMIK): String; override;
    function GenerateEnableForeignKeys(AEnable: Boolean): String; override;
    function GenerateEnableTriggers(AEnable: Boolean): String; override;
  end;

implementation

{ TDDLSQLGeneratorSQLite }

function TDDLSQLGeneratorSQLite.BuilderCreateFieldDefinition(AColumn: TColumnMIK): String;
begin
  Result := '  ' + AColumn.Name +
            GetFieldTypeDefinition(AColumn)    +
            GetCreateFieldDefaultDefinition(AColumn) +
            GetFieldNotNullDefinition(AColumn) +
            GetFieldPrimaryKeyAutoincrement(AColumn);
end;

function TDDLSQLGeneratorSQLite.GetFieldPrimaryKeyAutoincrement(AColumn: TColumnMIK): String;
var
  oColumn: TPair<String,TColumnMIK>;
begin
  Result := '';
  for oColumn in AColumn.Table.PrimaryKey.FieldsSort do
  begin
    if SameText(oColumn.Value.Name, AColumn.Name) then
    begin
      if oColumn.Value.AutoIncrement then
        Result := ' PRIMARY KEY AUTOINCREMENT'
      else
        Result := ' PRIMARY KEY'
    end;
  end;
end;

function TDDLSQLGeneratorSQLite.GenerateCreateForeignKey(AForeignKey: TForeignKeyMIK): String;
begin
  Result := 'CONSTRAINT %s FOREIGN KEY (%s) REFERENCES %s(%s) %s %s';
  Result := Format(Result, [AForeignKey.Name,
                            GetForeignKeyFromColumnsDefinition(AForeignKey),
                            AForeignKey.FromTable,
                            GetForeignKeyToColumnsDefinition(AForeignKey),
                            GetRuleDeleteActionDefinition(AForeignKey.OnDelete),
                            GetRuleUpdateActionDefinition(AForeignKey.OnUpdate)]);
end;

function TDDLSQLGeneratorSQLite.GenerateCreateSequence(ASequence: TSequenceMIK): String;
begin
  inherited;
  Result := 'INSERT INTO SQLITE_SEQUENCE(NAME, SEQ) VALUES (%s, %s);';
  Result := Format(Result, [QuotedStr(ASequence.Name), IntToStr(0)]);
end;

function TDDLSQLGeneratorSQLite.GenerateCreateTable(ATable: TTableMIK): String;
var
  oSQL: TStringBuilder;
  oColumn: TPair<String,TColumnMIK>;
begin
  oSQL := TStringBuilder.Create;
  Result := inherited GenerateCreateTable(ATable);
  try
    if ATable.Database.Schema <> '' then
      oSQL.Append(Format(Result, [ATable.Database.Schema + '.' + ATable.Name]))
    else
      oSQL.Append(Format(Result, [ATable.Name]));
    /// <summary>
    /// Add Colunas
    /// </summary>
    for oColumn in ATable.FieldsSort do
    begin
      oSQL.AppendLine;
      oSQL.Append(BuilderCreateFieldDefinition(oColumn.Value));
      oSQL.Append(',');
    end;
    /// <summary>
    /// Remove a última vírgula.
    /// </summary>
    oSQL.Remove(oSQL.Length -1, 1);
    /// <summary>
    /// Add ForeignKey
    /// </summary>
    if ATable.ForeignKeys.Count > 0 then
    begin
      oSQL.Append(',');
      oSQL.Append(BuilderForeignKeyDefinition(ATable));
    end;
    /// <summary>
    /// Add Checks
    /// </summary>
    if ATable.Checks.Count > 0 then
    begin
      oSQL.Append(',');
      oSQL.Append(BuilderCheckDefinition(ATable));
    end;
    oSQL.AppendLine;
    oSQL.Append(');');
    /// <summary>
    /// Add Indexe
    /// </summary>
    if ATable.IndexeKeys.Count > 0 then
      oSQL.Append(BuilderIndexeDefinition(ATable));
    Result := oSQL.ToString;
  finally
    oSQL.Free;
  end;
end;

function TDDLSQLGeneratorSQLite.GenerateDropSequence(ASequence: TSequenceMIK): String;
begin
  inherited;
  Result := 'DELETE FROM SQLITE_SEQUENCE WHERE NAME = %s;';
  Result := Format(Result, [QuotedStr(ASequence.Name)]);
end;

function TDDLSQLGeneratorSQLite.GenerateDropTable(ATable: TTableMIK): String;
begin
  Result := inherited GenerateDropTable(ATable);
end;

function TDDLSQLGeneratorSQLite.GenerateEnableForeignKeys(AEnable: Boolean): String;
begin
  if AEnable then
    Result := 'PRAGMA foreign_keys = on;'
  else
    Result := 'PRAGMA foreign_keys = off;';
end;

function TDDLSQLGeneratorSQLite.GenerateEnableTriggers(AEnable: Boolean): String;
begin

end;

initialization
  TSQLDriverRegister.GetInstance.RegisterDriver(dnSQLite, TDDLSQLGeneratorSQLite.Create);

end.
