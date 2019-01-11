program Calendar;

uses
  Forms,
  TestUnit in 'TestUnit.pas' {TestForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TTestForm, TestForm);
  Application.Run;
end.
