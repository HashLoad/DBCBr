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

  ORM Brasil � um ORM simples e descomplicado para quem utiliza Delphi.
}

unit dbcbr.metadata.firebird3;

interface

uses
  dbcbr.metadata.firebird,
  dbcbr.metadata.register,
  dbcbr.metadata.extract,
  dbebr.factory.interfaces;

type
  TCatalogMetadataFirebird3 = class(TCatalogMetadataFirebird)
  end;

implementation

initialization
  TMetadataRegister.GetInstance.RegisterMetadata(dnFirebird3, TCatalogMetadataFirebird3.Create);

end.
