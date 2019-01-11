unit ODCalenReg;
{
  Copyright (c) 1998-2019
  Orbital Decisions:- My Power Station Technology (Pty) Ltd
  P.O.Box 1080, Milnerton 7435, South Africa
  components@mypowerstation.biz
  http://www.orbital.co.za/text/prodlist.htm
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, Buttons, ExtCtrls, Mask,DB,
  DesignIntf, DesignEditors, ODCalend, ODPopcal, ODDBCal, ODTime;

Type
  TODCalendarAboutProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TODPopupCalendarEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TODDateFieldProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

procedure Register;

implementation

procedure Register;
begin
  // ODCalend
  RegisterComponents('Orbital', [TODCalendar]);
  RegisterPropertyEditor(TypeInfo(string),
    TODCustomCalendar, 'About', TODCalendarAboutProperty);

  // ODPopCal
  RegisterComponents('Orbital', [TODCalendarDialog, TODPopupCalendar]);
  RegisterPropertyEditor(TypeInfo(string),
    TODCalendarDialog, 'About', TODCalendarAboutProperty);
  RegisterPropertyEditor(TypeInfo(string),
    TODPopupCalendar, 'About', TODCalendarAboutProperty);
  RegisterComponentEditor(TODPopupCalendar, TODPopupCalendarEditor);

  // ODDBCal
  RegisterComponents('Orbital',
    [TODDBCalendar, TODDBPopupCalendar]);
  RegisterPropertyEditor(TypeInfo(string), TODDBCalendar,
    'StartDateName', TODDateFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TODDBCalendar,
    'FinishDateName', TODDateFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TODDBPopupCalendar,
    'StartDateName', TODDateFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TODDBPopupCalendar,
    'FinishDateName', TODDateFieldProperty);

  // ODTime
  RegisterComponents('Orbital', [TODTimePicker, TODDBTimePicker]);
end;

// TODCalendarAboutProperty Implementation
function TODCalendarAboutProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

procedure TODCalendarAboutProperty.Edit;
begin
  MessageDlg('Orbital Decisions Calendar Components ' + ODCalendarVersion +
    #13#13 + 'My Power Station Technology (Pty) Ltd'#13 +
    'Delphi development, solutions and business components'#13#13 +
    'Addr.:   P.O.Box 1080, Milnerton, 7435, South Africa'#13 +
    'EMail:  components@mypowerstation.biz'#13 +
    'URL:    http://www.orbital.co.za',
    mtInformation, [mbOK], 0);
end;

//TODPopupCalendarEditor

procedure TODPopupCalendarEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then
    with (Component as TODPopupCalendar) do
    begin
      StartDate := 0;
      FinishDate := 0;
    end;
end;

function TODPopupCalendarEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := 'Clear &Dates';
end;

function TODPopupCalendarEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

//TODDateFieldProperty

function TODDateFieldProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paRevertable];
end;

procedure TODDateFieldProperty.GetValues(Proc: TGetStrProc);
var
  ix: Integer;
  ac: Boolean;
  ds: TDataSource;
begin
  if GetComponent(0) is TODDBCalendar then
    ds := TODDBCalendar(GetComponent(0)).DataSource
  else if GetComponent(0) is TODDBPopupCalendar then
    ds := TODDBPopupCalendar(GetComponent(0)).DataSource
  else
    raise EComponentError.Create('Unknown component');
  if ds.DataSet <> nil then
    with ds.DataSet do
    begin
      ac := Active;
      if not ac and (FieldCount = 0) then   //if closed & no static fields
        Open;     //then open to get dynamic fields
      for ix := 0 to FieldCount-1 do
        Proc(Fields[ix].FieldName);
      Active := ac;
    end;
end;

end.
