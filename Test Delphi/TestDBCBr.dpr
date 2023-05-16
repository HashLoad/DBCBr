program TestDBCBr;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}
uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  test.dbcbr in 'test.dbcbr.pas',
  dbcbr.database.abstract in '..\Source\Core\dbcbr.database.abstract.pas',
  dbcbr.database.compare in '..\Source\Core\dbcbr.database.compare.pas',
  dbcbr.database.factory in '..\Source\Core\dbcbr.database.factory.pas',
  dbcbr.database.interfaces in '..\Source\Core\dbcbr.database.interfaces.pas',
  dbcbr.database.mapping in '..\Source\Core\dbcbr.database.mapping.pas',
  dbcbr.database.metainfo in '..\Source\Core\dbcbr.database.metainfo.pas',
  dbcbr.ddl.commands in '..\Source\Core\dbcbr.ddl.commands.pas',
  dbcbr.ddl.generator in '..\Source\Core\dbcbr.ddl.generator.pas',
  dbcbr.ddl.interfaces in '..\Source\Core\dbcbr.ddl.interfaces.pas',
  dbcbr.ddl.register in '..\Source\Core\dbcbr.ddl.register.pas',
  dbcbr.ddl.generator.absolutedb in '..\Source\Drivers\dbcbr.ddl.generator.absolutedb.pas',
  dbcbr.ddl.generator.firebird in '..\Source\Drivers\dbcbr.ddl.generator.firebird.pas',
  dbcbr.ddl.generator.firebird3 in '..\Source\Drivers\dbcbr.ddl.generator.firebird3.pas',
  dbcbr.ddl.generator.mssql in '..\Source\Drivers\dbcbr.ddl.generator.mssql.pas',
  dbcbr.ddl.generator.mysql in '..\Source\Drivers\dbcbr.ddl.generator.mysql.pas',
  dbcbr.ddl.generator.oracle in '..\Source\Drivers\dbcbr.ddl.generator.oracle.pas',
  dbcbr.ddl.generator.postgresql in '..\Source\Drivers\dbcbr.ddl.generator.postgresql.pas',
  dbcbr.ddl.generator.sqlite in '..\Source\Drivers\dbcbr.ddl.generator.sqlite.pas',
  dbcbr.metadata.firebird in '..\Source\Drivers\dbcbr.metadata.firebird.pas',
  dbcbr.metadata.firebird3 in '..\Source\Drivers\dbcbr.metadata.firebird3.pas',
  dbcbr.metadata.mssql in '..\Source\Drivers\dbcbr.metadata.mssql.pas',
  dbcbr.metadata.mysql in '..\Source\Drivers\dbcbr.metadata.mysql.pas',
  dbcbr.metadata.oracle in '..\Source\Drivers\dbcbr.metadata.oracle.pas',
  dbcbr.metadata.postgresql in '..\Source\Drivers\dbcbr.metadata.postgresql.pas',
  dbcbr.metadata.sqlite in '..\Source\Drivers\dbcbr.metadata.sqlite.pas',
  dbcbr.types.mapping in '..\Source\Core\dbcbr.types.mapping.pas',
  dbcbr.metadata.db.factory in '..\Source\Core\dbcbr.metadata.db.factory.pas',
  dbcbr.metadata.register in '..\Source\Core\dbcbr.metadata.register.pas',
  dbcbr.metadata.extract in '..\Source\Core\dbcbr.metadata.extract.pas',
  dbcbr.metadata.interfaces in '..\Source\Core\dbcbr.metadata.interfaces.pas',
  dbcbr.metadata.model in '..\Source\Drivers\dbcbr.metadata.model.pas';

{$IFNDEF TESTINSIGHT}
var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
{$ENDIF}
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
{$ELSE}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //tell the runner how we will log things
    //Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; //When true, Assertions must be made during tests;

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
{$ENDIF}
end.
