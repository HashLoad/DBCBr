unit test.dbcbr;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestDBCBr = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    procedure Test1;
    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('TestA','1,2')]
    [TestCase('TestB','3,4')]
    procedure Test2(const AValue1 : Integer;const AValue2 : Integer);
  end;

implementation

procedure TTestDBCBr.Setup;
begin
end;

procedure TTestDBCBr.TearDown;
begin
end;

procedure TTestDBCBr.Test1;
begin
end;

procedure TTestDBCBr.Test2(const AValue1 : Integer;const AValue2 : Integer);
begin
end;

initialization
  TDUnitX.RegisterTestFixture(TTestDBCBr);

end.
