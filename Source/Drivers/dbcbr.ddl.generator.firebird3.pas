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
  @created(12 Out 2016)
  @author(Isaque Pinheiro <isaquepsp@gmail.com>)
  @author(Skype : ispinheiro)

  ORM Brasil � um ORM simples e descomplicado para quem utiliza Delphi.
}

unit dbcbr.ddl.generator.firebird3;

interface

uses
  dbebr.factory.interfaces,
  dbcbr.ddl.register,
  dbcbr.ddl.generator,
  dbcbr.ddl.generator.firebird;

type
  TDDLSQLGeneratorFirebird3 = class(TDDLSQLGeneratorFirebird)
  end;

implementation

initialization
  TSQLDriverRegister.GetInstance.RegisterDriver(dnFirebird3, TDDLSQLGeneratorFirebird3.Create);

end.
