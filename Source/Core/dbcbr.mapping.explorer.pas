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
  @abstract(Website : http://www.ormbr.com.br)
  @abstract(Telagram : https://t.me/ormbr)
}

unit dbcbr.mapping.explorer;

interface

uses
  DB,
  Rtti,
  Classes,
  TypInfo,
  SysUtils,
  Generics.Collections,
  /// DBCBr
  dbcbr.rtti.helper,
  dbcbr.mapping.classes,
  dbcbr.mapping.popular,
  dbcbr.mapping.repository,
  dbcbr.mapping.register;

type
  TMappingExplorer = class
  private
  class var
    FContext: TRttiContext;
    FRepositoryMapping: TMappingRepository;
    FPopularMapping: TMappingPopular;
    FTableMapping: TDictionary<string, TTableMapping>;
    FOrderByMapping: TDictionary<string, TOrderByMapping>;
    FSequenceMapping: TDictionary<string, TSequenceMapping>;
    FPrimaryKeyMapping: TDictionary<string, TPrimaryKeyMapping>;
    FForeingnKeyMapping: TDictionary<string, TForeignKeyMappingList>;
    FIndexeMapping: TDictionary<string, TIndexeMappingList>;
    FCheckMapping: TDictionary<string, TCheckMappingList>;
    FColumnMapping: TDictionary<string, TColumnMappingList>;
    FCalcFieldMapping: TDictionary<string, TCalcFieldMappingList>;
    FAssociationMapping: TDictionary<string, TAssociationMappingList>;
    FJoinColumnMapping: TDictionary<string, TJoinColumnMappingList>;
    FTriggerMapping: TDictionary<string, TTriggerMappingList>;
    FViewMapping: TDictionary<string, TViewMapping>;
    FEnumerationMapping: TDictionary<string, TEnumerationMappingList>;
    FFieldEventsMapping: TDictionary<string, TFieldEventsMappingList>;
    FPrimaryKeyColumnsMapping: TDictionary<string, TPrimaryKeyColumnsMapping>;
//    FLazyLoadMapping: TDictionary<string, TLazyMapping>;
    FNotServerUse: TDictionary<string, Boolean>;
    class procedure ExecuteCreate;
    class procedure ExecuteDestroy;
  public
    { Public declarations }
    class function GetMappingTable(const AClass: TClass): TTableMapping;
    class function GetMappingOrderBy(const AClass: TClass): TOrderByMapping;
    class function GetMappingSequence(const AClass: TClass): TSequenceMapping;
    class function GetMappingPrimaryKey(const AClass: TClass): TPrimaryKeyMapping;
    class function GetMappingForeignKey(const AClass: TClass): TForeignKeyMappingList;
    class function GetMappingColumn(const AClass: TClass): TColumnMappingList;
    class function GetMappingCalcField(const AClass: TClass): TCalcFieldMappingList;
    class function GetMappingAssociation(const AClass: TClass): TAssociationMappingList;
    class function GetMappingJoinColumn(const AClass: TClass): TJoinColumnMappingList;
    class function GetMappingIndexe(const AClass: TClass): TIndexeMappingList;
    class function GetMappingCheck(const AClass: TClass): TCheckMappingList;
    class function GetMappingTrigger(const AClass: TClass): TTriggerMappingList;
    class function GetMappingView(const AClass: TClass): TViewMapping;
    class function GetMappingFieldEvents(const AClass: TClass): TFieldEventsMappingList;
    class function GetMappingEnumeration(const AClass: TClass): TEnumerationMappingList;
    class function GetMappingPrimaryKeyColumns(const AClass: TClass): TPrimaryKeyColumnsMapping;
    class function GetNotServerUse(const AClass: TClass): Boolean;
    class function GetRepositoryMapping: TMappingRepository;
//    class procedure GetMappingLazy(const AClass: TClass);
  end;

implementation

{ TMappingExplorer }

class procedure TMappingExplorer.ExecuteCreate;
begin
  FContext := TRttiContext.Create;
  FPopularMapping     := TMappingPopular.Create;
  FTableMapping       := TObjectDictionary<string, TTableMapping>.Create([doOwnsValues]);
  FOrderByMapping     := TObjectDictionary<string, TOrderByMapping>.Create([doOwnsValues]);
  FSequenceMapping    := TObjectDictionary<string, TSequenceMapping>.Create([doOwnsValues]);
  FPrimaryKeyMapping  := TObjectDictionary<string, TPrimaryKeyMapping>.Create([doOwnsValues]);
  FForeingnKeyMapping := TObjectDictionary<string, TForeignKeyMappingList>.Create([doOwnsValues]);
  FColumnMapping      := TObjectDictionary<string, TColumnMappingList>.Create([doOwnsValues]);
  FCalcFieldMapping   := TObjectDictionary<string, TCalcFieldMappingList>.Create([doOwnsValues]);
  FAssociationMapping := TObjectDictionary<string, TAssociationMappingList>.Create([doOwnsValues]);
  FJoinColumnMapping  := TObjectDictionary<string, TJoinColumnMappingList>.Create([doOwnsValues]);
  FIndexeMapping      := TObjectDictionary<string, TIndexeMappingList>.Create([doOwnsValues]);
  FCheckMapping       := TObjectDictionary<string, TCheckMappingList>.Create([doOwnsValues]);
  FTriggerMapping     := TObjectDictionary<string, TTriggerMappingList>.Create([doOwnsValues]);
  FViewMapping        := TObjectDictionary<string, TViewMapping>.Create([doOwnsValues]);
  FFieldEventsMapping := TObjectDictionary<string, TFieldEventsMappingList>.Create([doOwnsValues]);
  FEnumerationMapping := TObjectDictionary<string, TEnumerationMappingList>.Create([doOwnsValues]);
  FPrimaryKeyColumnsMapping := TObjectDictionary<string, TPrimaryKeyColumnsMapping>.Create([doOwnsValues]);
  FNotServerUse := TDictionary<string, Boolean>.Create();
//  FLazyLoadMapping    := TObjectDictionary<string, TLazyMapping>.Create([doOwnsValues]);
end;

class procedure TMappingExplorer.ExecuteDestroy;
begin
  FContext.Free;
  FPopularMapping.Free;
  FTableMapping.Free;
  FOrderByMapping.Free;
  FSequenceMapping.Free;
  FPrimaryKeyMapping.Free;
  FForeingnKeyMapping.Free;
  FColumnMapping.Free;
  FCalcFieldMapping.Free;
  FAssociationMapping.Free;
  FJoinColumnMapping.Free;
  FIndexeMapping.Free;
  FTriggerMapping.Free;
  FCheckMapping.Free;
  FViewMapping.Free;
  FFieldEventsMapping.Free;
  FEnumerationMapping.Free;
//  FLazyLoadMapping.Free;
  FPrimaryKeyColumnsMapping.Free;
  FNotServerUse.Free;
  if Assigned(FRepositoryMapping) then
     FRepositoryMapping.Free;
end;

class function TMappingExplorer.GetMappingPrimaryKey(
  const AClass: TClass): TPrimaryKeyMapping;
var
  LRttiType: TRttiType;
begin
  if FPrimaryKeyMapping.ContainsKey(AClass.ClassName) then
     Exit(FPrimaryKeyMapping[AClass.ClassName]);

  LRttiType := FContext.GetType(AClass);
  Result    := FPopularMapping.PopularPrimaryKey(LRttiType);
  // Add List
  FPrimaryKeyMapping.Add(AClass.ClassName, Result);
end;

class function TMappingExplorer.GetMappingPrimaryKeyColumns(
  const AClass: TClass): TPrimaryKeyColumnsMapping;
var
  LRttiType: TRttiType;
begin
  if FPrimaryKeyColumnsMapping.ContainsKey(AClass.ClassName) then
     Exit(FPrimaryKeyColumnsMapping[AClass.ClassName]);

  LRttiType := FContext.GetType(AClass);
  Result    := FPopularMapping.PopularPrimaryKeyColumns(LRttiType, AClass);
  // Add List
  FPrimaryKeyColumnsMapping.Add(AClass.ClassName, Result);
end;

class function TMappingExplorer.GetMappingSequence(
  const AClass: TClass): TSequenceMapping;
var
  LRttiType: TRttiType;
begin
  if FSequenceMapping.ContainsKey(AClass.ClassName) then
     Exit(FSequenceMapping[AClass.ClassName]);

  LRttiType := FContext.GetType(AClass);
  Result    := FPopularMapping.PopularSequence(LRttiType);
  // Add List
  FSequenceMapping.Add(AClass.ClassName, Result);
end;

class function TMappingExplorer.GetMappingCalcField(
  const AClass: TClass): TCalcFieldMappingList;
var
  LRttiType: TRttiType;
begin
  if FCalcFieldMapping.ContainsKey(AClass.ClassName) then
     Exit(FCalcFieldMapping[AClass.ClassName]);

  LRttiType := FContext.GetType(AClass);
  Result    := FPopularMapping.PopularCalcField(LRttiType);
  // Add List
  FCalcFieldMapping.Add(AClass.ClassName, Result);
end;

class function TMappingExplorer.GetMappingCheck(
  const AClass: TClass): TCheckMappingList;
var
  LRttiType: TRttiType;
begin
  if FCheckMapping.ContainsKey(AClass.ClassName) then
     Exit(FCheckMapping[AClass.ClassName]);

  LRttiType := FContext.GetType(AClass);
  Result    := FPopularMapping.PopularCheck(LRttiType);
  // Add List
  FCheckMapping.Add(AClass.ClassName, Result);
end;

class function TMappingExplorer.GetMappingColumn(const AClass: TClass): TColumnMappingList;
var
  LRttiType: TRttiType;
begin
  if FColumnMapping.ContainsKey(AClass.ClassName) then
     Exit(FColumnMapping[AClass.ClassName]);

  LRttiType := FContext.GetType(AClass);
  Result    := FPopularMapping.PopularColumn(LRttiType, AClass);
  // Add List
  FColumnMapping.Add(AClass.ClassName, Result);
end;

class function TMappingExplorer.GetMappingEnumeration(
  const AClass: TClass): TEnumerationMappingList;
var
  LRttiType: TRttiType;
begin
  if FEnumerationMapping.ContainsKey(AClass.ClassName) then
     Exit(FEnumerationMapping[AClass.ClassName]);

  LRttiType := FContext.GetType(AClass);
  Result := FPopularMapping.PopularEnumeration(LRttiType);
  // Add List
  FEnumerationMapping.Add(AClass.ClassName, Result);
end;

class function TMappingExplorer.GetMappingFieldEvents(
  const AClass: TClass): TFieldEventsMappingList;
var
  LRttiType: TRttiType;
begin
  if FFieldEventsMapping.ContainsKey(AClass.ClassName) then
     Exit(FFieldEventsMapping[AClass.ClassName]);

  LRttiType := FContext.GetType(AClass);
  Result    := FPopularMapping.PopularFieldEvents(LRttiType);
  // Add List
  FFieldEventsMapping.Add(AClass.ClassName, Result);
end;

class function TMappingExplorer.GetMappingForeignKey(
  const AClass: TClass): TForeignKeyMappingList;
var
  LRttiType: TRttiType;
begin
  if FForeingnKeyMapping.ContainsKey(AClass.ClassName) then
     Exit(FForeingnKeyMapping[AClass.ClassName]);

  LRttiType := FContext.GetType(AClass);
  Result    := FPopularMapping.PopularForeignKey(LRttiType);
  // Add List
  FForeingnKeyMapping.Add(AClass.ClassName, Result);
end;

class function TMappingExplorer.GetMappingIndexe(
  const AClass: TClass): TIndexeMappingList;
var
  LRttiType: TRttiType;
begin
  if FIndexeMapping.ContainsKey(AClass.ClassName) then
     Exit(FIndexeMapping[AClass.ClassName]);

  LRttiType := FContext.GetType(AClass);
  Result    := FPopularMapping.PopularIndexe(LRttiType);
  // Add List
  FIndexeMapping.Add(AClass.ClassName, Result);
end;

class function TMappingExplorer.GetMappingJoinColumn(
  const AClass: TClass): TJoinColumnMappingList;
var
  LRttiType: TRttiType;
begin
  if FJoinColumnMapping.ContainsKey(AClass.ClassName) then
     Exit(FJoinColumnMapping[AClass.ClassName]);

  LRttiType := FContext.GetType(AClass);
  Result    := FPopularMapping.PopularJoinColumn(LRttiType);
  // Add List
  FJoinColumnMapping.Add(AClass.ClassName, Result);
end;

//class procedure TMappingExplorer.GetMappingLazy(const AClass: TClass);
//var
//  LRttiType: TRttiType;
//  LFieldName: String;
//  LField: TRttiField;
//begin
//  LRttiType := FContext.GetType(AClass);
//  for LField in LRttiType.GetFields do
//  begin
//    if LField.IsLazy then
//      GetMappingLazy(LField.GetLazyValue.AsInstance.MetaclassType)
//    else
//    if LField.FieldType.TypeKind = tkClass then
//      GetMappingLazy(LField.GetTypeValue.AsInstance.MetaclassType)
//    else
//      Continue;
//    LFieldName := 'T' + LField.FieldType.Handle.NameFld.ToString;
//    FLazyLoadMapping.Add(LFieldName, TLazyMapping.Create(LField));
//  end;
//end;

class function TMappingExplorer.GetMappingOrderBy(
  const AClass: TClass): TOrderByMapping;
var
  LRttiType: TRttiType;
begin
  if FOrderByMapping.ContainsKey(AClass.ClassName) then
     Exit(FOrderByMapping[AClass.ClassName]);

  LRttiType := FContext.GetType(AClass);
  Result    := FPopularMapping.PopularOrderBy(LRttiType);
  // Add List
  FOrderByMapping.Add(AClass.ClassName, Result);
end;

class function TMappingExplorer.GetMappingAssociation(
  const AClass: TClass): TAssociationMappingList;
var
  LRttiType: TRttiType;
begin
  if FAssociationMapping.ContainsKey(AClass.ClassName) then
     Exit(FAssociationMapping[AClass.ClassName]);

  LRttiType := FContext.GetType(AClass);
  Result    := FPopularMapping.PopularAssociation(LRttiType);
  // Add List
  FAssociationMapping.Add(AClass.ClassName, Result);
end;

class function TMappingExplorer.GetMappingTable(
  const AClass: TClass): TTableMapping;
var
  LRttiType: TRttiType;
begin
  if FTableMapping.ContainsKey(AClass.ClassName) then
     Exit(FTableMapping[AClass.ClassName]);

  LRttiType := FContext.GetType(AClass);
  Result    := FPopularMapping.PopularTable(LRttiType);
  // Add List
  FTableMapping.Add(AClass.ClassName, Result);
end;

class function TMappingExplorer.GetMappingTrigger(
  const AClass: TClass): TTriggerMappingList;
var
  LRttiType: TRttiType;
begin
  if FTriggerMapping.ContainsKey(AClass.ClassName) then
     Exit(FTriggerMapping[AClass.ClassName]);

  LRttiType := FContext.GetType(AClass);
  Result    := FPopularMapping.PopularTrigger(LRttiType);
  // Add List
  FTriggerMapping.Add(AClass.ClassName, Result);
end;

class function TMappingExplorer.GetMappingView(
  const AClass: TClass): TViewMapping;
var
  LRttiType: TRttiType;
begin
  if FViewMapping.ContainsKey(AClass.ClassName) then
     Exit(FViewMapping[AClass.ClassName]);

  LRttiType := FContext.GetType(AClass);
  Result    := FPopularMapping.PopularView(LRttiType);
  // Add List
  FViewMapping.Add(AClass.ClassName, Result);
end;

class function TMappingExplorer.GetNotServerUse(const AClass: TClass): Boolean;
var
  LRttiType: TRttiType;
begin
  if FNotServerUse.ContainsKey(AClass.ClassName) then
     Exit(FNotServerUse[AClass.ClassName]);

  LRttiType := FContext.GetType(AClass);
  Result    := FPopularMapping.PopularNotServerUse(LRttiType);
  // Add List
  FNotServerUse.Add(AClass.ClassName, Result);
end;

class function TMappingExplorer.GetRepositoryMapping: TMappingRepository;
begin
  if not Assigned(FRepositoryMapping) then
    FRepositoryMapping := TMappingRepository.Create(TRegisterClass.GetAllEntityClass,
                                                    TRegisterClass.GetAllViewClass);
  Result := FRepositoryMapping;
end;

initialization
  TMappingExplorer.ExecuteCreate;

finalization
  TMappingExplorer.ExecuteDestroy;

end.

