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

unit dbcbr.ddl.interfaces;

interface

uses
  dbcbr.database.mapping;

type
  TSupportedFeature = (Sequences, ForeignKeys, Checks, Views, Triggers);
  TSupportedFeatures = set of TSupportedFeature;
  /// <summary>
  /// Class unit : dbcbr.ddl.generator.pas
  /// Class Name : TDDLSQLGeneratorAbstract
  /// </summary>
  IDDLGeneratorCommand = interface
    ['{9E14DD57-94B9-4117-982A-BB9E8CBA54C6}']
    function GenerateCreateTable(ATable: TTableMIK): String;
    function GenerateCreatePrimaryKey(APrimaryKey: TPrimaryKeyMIK): String;
    function GenerateCreateForeignKey(AForeignKey: TForeignKeyMIK): String;
    function GenerateCreateSequence(ASequence: TSequenceMIK): String;
    function GenerateCreateIndexe(AIndexe: TIndexeKeyMIK): String;
    function GenerateCreateCheck(ACheck: TCheckMIK): String;
    function GenerateCreateView(AView: TViewMIK): String;
    function GenerateCreateTrigger(ATrigger: TTriggerMIK): String;
    function GenerateCreateColumn(AColumn: TColumnMIK): String;
    function GenerateAlterColumn(AColumn: TColumnMIK): String;
    function GenerateAlterColumnPosition(AColumn: TColumnMIK): String;
    function GenerateAlterDefaultValue(AColumn: TColumnMIK): String;
    function GenerateAlterCheck(ACheck: TCheckMIK): String;
    function GenerateDropTable(ATable: TTableMIK): String;
    function GenerateDropPrimaryKey(APrimaryKey: TPrimaryKeyMIK): String;
    function GenerateDropForeignKey(AForeignKey: TForeignKeyMIK): String;
    function GenerateDropSequence(ASequence: TSequenceMIK): String;
    function GenerateDropIndexe(AIndexe: TIndexeKeyMIK): String;
    function GenerateDropCheck(ACheck: TCheckMIK): String;
    function GenerateDropView(AView: TViewMIK): String;
    function GenerateDropTrigger(ATrigger: TTriggerMIK): String;
    function GenerateDropColumn(AColumn: TColumnMIK): String;
    function GenerateDropDefaultValue(AColumn: TColumnMIK): String;
    function GenerateEnableForeignKeys(AEnable: Boolean): String;
    function GenerateEnableTriggers(AEnable: Boolean): String;
    /// <summary>
    /// Propriedade para identificar os recursos de diferentes banco de dados
    /// usando o mesmo modelo.
    /// </summary>
    function GetSupportedFeatures: TSupportedFeatures;
    property SupportedFeatures: TSupportedFeatures read GetSupportedFeatures;
  end;

implementation

end.
