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
  ormbr.database.abstract in '..\Source\Core\ormbr.database.abstract.pas',
  ormbr.database.compare in '..\Source\Core\ormbr.database.compare.pas',
  ormbr.database.factory in '..\Source\Core\ormbr.database.factory.pas',
  ormbr.database.interfaces in '..\Source\Core\ormbr.database.interfaces.pas',
  ormbr.database.mapping in '..\Source\Core\ormbr.database.mapping.pas',
  ormbr.database.metainfo in '..\Source\Core\ormbr.database.metainfo.pas',
  ormbr.ddl.commands in '..\Source\Core\ormbr.ddl.commands.pas',
  ormbr.ddl.generator in '..\Source\Core\ormbr.ddl.generator.pas',
  ormbr.ddl.interfaces in '..\Source\Core\ormbr.ddl.interfaces.pas',
  ormbr.ddl.register in '..\Source\Core\ormbr.ddl.register.pas',
  ormbr.ddl.generator.absolutedb in '..\Source\Drivers\ormbr.ddl.generator.absolutedb.pas',
  ormbr.ddl.generator.firebird in '..\Source\Drivers\ormbr.ddl.generator.firebird.pas',
  ormbr.ddl.generator.interbase in '..\Source\Drivers\ormbr.ddl.generator.interbase.pas',
  ormbr.ddl.generator.mssql in '..\Source\Drivers\ormbr.ddl.generator.mssql.pas',
  ormbr.ddl.generator.mysql in '..\Source\Drivers\ormbr.ddl.generator.mysql.pas',
  ormbr.ddl.generator.oracle in '..\Source\Drivers\ormbr.ddl.generator.oracle.pas',
  ormbr.ddl.generator.postgresql in '..\Source\Drivers\ormbr.ddl.generator.postgresql.pas',
  ormbr.ddl.generator.sqlite in '..\Source\Drivers\ormbr.ddl.generator.sqlite.pas',
  ormbr.metadata.absolutedb in '..\Source\Drivers\ormbr.metadata.absolutedb.pas',
  ormbr.metadata.firebird in '..\Source\Drivers\ormbr.metadata.firebird.pas',
  ormbr.metadata.interbase in '..\Source\Drivers\ormbr.metadata.interbase.pas',
  ormbr.metadata.mssql in '..\Source\Drivers\ormbr.metadata.mssql.pas',
  ormbr.metadata.mysql in '..\Source\Drivers\ormbr.metadata.mysql.pas',
  ormbr.metadata.oracle in '..\Source\Drivers\ormbr.metadata.oracle.pas',
  ormbr.metadata.postgresql in '..\Source\Drivers\ormbr.metadata.postgresql.pas',
  ormbr.metadata.sqlite in '..\Source\Drivers\ormbr.metadata.sqlite.pas',
  ormbr.types.mapping in '..\Source\Core\ormbr.types.mapping.pas',
  ormbr.metadata.db.factory in '..\Source\Core\ormbr.metadata.db.factory.pas',
  ormbr.metadata.register in '..\Source\Core\ormbr.metadata.register.pas',
  ormbr.metadata.extract in '..\Source\Core\ormbr.metadata.extract.pas',
  ormbr.metadata.interfaces in '..\Source\Core\ormbr.metadata.interfaces.pas',
  ormbr.factory.interfaces in 'D:\DBEnginesBr\Source\Core\ormbr.factory.interfaces.pas';

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
