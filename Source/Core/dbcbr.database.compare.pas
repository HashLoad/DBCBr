{
      ORM Brasil � um ORM simples e descomplicado para quem utiliza Delphi

                   Copyright (c) 2016, Isaque Pinheiro
                          All rights reserved.

                    GNU Lesser General Public License
                      Vers�o 3, 29 de junho de 2007

       Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
       A todos � permitido copiar e distribuir c�pias deste documento de
       licen�a, mas mud�-lo n�o � permitido.

       Esta vers�o da GNU Lesser General Public License incorpora
       os termos e condi��es da vers�o 3 da GNU General Public License
       Licen�a, complementado pelas permiss�es adicionais listadas no
       arquivo LICENSE na pasta principal.
}

{ @abstract(ORMBr Framework.)
  @created(20 Jul 2016)
  @author(Isaque Pinheiro <isaquepsp@gmail.com>)
  @author(Skype : ispinheiro)
}

unit dbcbr.database.compare;

interface

uses
  SysUtils,
  Classes,
  dbebr.factory.interfaces,
  dbcbr.metadata.db.factory,
  dbcbr.database.factory;

type
  TDatabaseCompare = class(TDatabaseFactory)
  protected
    FAutoManager: Boolean;
    FConnMaster: IDBConnection;
    FConnTarget: IDBConnection;
    FMetadataMaster: TMetadataDBAbstract;
    FMetadataTarget: TMetadataDBAbstract;
    procedure ExtractDatabase; override;
    procedure ExecuteDDLCommands; override;
  public
    constructor Create(AConnMaster, AConnTarget: IDBConnection); overload;
    destructor Destroy; override;
  end;

implementation

uses
  dbcbr.ddl.commands;

{ TDatabaseCompare }

constructor TDatabaseCompare.Create(AConnMaster, AConnTarget: IDBConnection);
begin
  FModelForDatabase := False;
  FConnMaster := AConnMaster;
  FConnMaster.Connect;
  if not FConnMaster.IsConnected then
    raise Exception.Create('N�o foi possivel fazer conex�o com o banco de dados Master');

  FConnTarget := AConnTarget;
  FConnTarget.Connect;
  if not FConnTarget.IsConnected then
    raise Exception.Create('N�o foi possivel fazer conex�o com o banco de dados Target');

  inherited Create(AConnMaster.GetDriverName);
  FMetadataMaster := TMetadataDBFactory.Create(Self, AConnMaster);
  FMetadataTarget := TMetadataDBFactory.Create(Self, AConnTarget);
end;

destructor TDatabaseCompare.Destroy;
begin
  FMetadataMaster.Free;
  FMetadataTarget.Free;
  inherited;
end;

procedure TDatabaseCompare.ExecuteDDLCommands;
var
  LDDLCommand: TDDLCommand;
  LCommand: String;
begin
  inherited;
  if FCommandsAutoExecute then
    FConnTarget.StartTransaction;
  try
    try
      for LDDLCommand in FDDLCommands do
      begin
        LCommand := LDDLCommand.BuildCommand(FGeneratorCommand);
        if Length(LCommand) > 0 then
          if FCommandsAutoExecute then
            FConnTarget.AddScript(LCommand);
      end;
      if FConnTarget.InTransaction then
      begin
        FConnTarget.ExecuteScripts;
        FConnTarget.Commit;
      end;
    except
      on E: Exception do
      begin
        if FConnTarget.InTransaction then
          FConnTarget.Rollback;
        raise Exception.Create('DBCBr Command : [' + LDDLCommand.Warning + '] - ' + E.Message + sLineBreak +
                               'Script : "' + LCommand + '"');
      end;
    end;
  finally
    FConnMaster.Disconnect;
    FConnTarget.Disconnect;
  end;
end;

procedure TDatabaseCompare.ExtractDatabase;
begin
  inherited;
  // Extrai todo metadata com base nos modelos existentes
  FMetadataMaster.ExtractMetadata(FCatalogMaster);
  // Extrai todo metadata com base banco de dados acessado
  FMetadataTarget.ExtractMetadata(FCatalogTarget);
end;

end.
