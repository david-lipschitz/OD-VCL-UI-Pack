unit VCL.ODCalenReg;
{
  My Power Station Technology (Pty) Ltd - was Orbital Decisions
  P.O.Box 1080, Milnerton 7435, South Africa
  components@mypowerstation.biz
  http://www.orbital.co.za/text/prodlist.htm
  Copyright (c) 1998-2019

  Use at your own risk!
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask,
  Data.DB,  DesignIntf, DesignEditors,
  VCL.ODCalend, VCL.ODPopcal, VCL.ODDBCal, VCL.ODTime;

Type
  TODVCLCalendarAboutProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TODVCLPopupCalendarEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TODVCLDateFieldProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

procedure Register;

implementation

procedure Register;
begin
  // ODCalend
  RegisterComponents('Orbital', [TODVCLCalendar]);
  RegisterPropertyEditor(TypeInfo(string),
    TODVCLCustomCalendar, 'About', TODVCLCalendarAboutProperty);

  // ODPopCal
  RegisterComponents('Orbital', [TODVCLCalendarDialog, TODVCLPopupCalendar]);
  RegisterPropertyEditor(TypeInfo(string),
    TODVCLCalendarDialog, 'About', TODVCLCalendarAboutProperty);
  RegisterPropertyEditor(TypeInfo(string),
    TODVCLPopupCalendar, 'About', TODVCLCalendarAboutProperty);
  RegisterComponentEditor(TODVCLPopupCalendar, TODVCLPopupCalendarEditor);

  // ODDBCal
  RegisterComponents('Orbital',
    [TODVCLDBCalendar, TODVCLDBPopupCalendar]);
  RegisterPropertyEditor(TypeInfo(string), TODVCLDBCalendar,
    'StartDateName', TODVCLDateFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TODVCLDBCalendar,
    'FinishDateName', TODVCLDateFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TODVCLDBPopupCalendar,
    'StartDateName', TODVCLDateFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TODVCLDBPopupCalendar,
    'FinishDateName', TODVCLDateFieldProperty);

  // ODTime
  RegisterComponents('Orbital', [TODVCLTimePicker, TODVCLDBTimePicker]);
end;

// TODVCLCalendarAboutProperty Implementation
function TODVCLCalendarAboutProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

procedure TODVCLCalendarAboutProperty.Edit;
begin
  MessageDlg('Orbital Decisions Calendar Components ' + ODVCLCalendarVersion +
    #13#13 + 'My Power Station Technology (Pty) Ltd'#13 +
    'Delphi development, solutions and business components'#13#13 +
    'Addr.:   P.O.Box 1080, Milnerton, 7435, South Africa'#13 +
    'EMail:  components@mypowerstation.biz'#13 +
    'URL:    http://www.orbital.co.za',
    mtInformation, [mbOK], 0);
end;

//TODVCLPopupCalendarEditor

procedure TODVCLPopupCalendarEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then
    with (Component as TODVCLPopupCalendar) do
    begin
      StartDate := 0;
      FinishDate := 0;
    end;
end;

function TODVCLPopupCalendarEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := 'Clear &Dates';
end;

function TODVCLPopupCalendarEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

//TODVCLDateFieldProperty

function TODVCLDateFieldProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paRevertable];
end;

procedure TODVCLDateFieldProperty.GetValues(Proc: TGetStrProc);
var
  ix: Integer;
  ac: Boolean;
  ds: TDataSource;
begin
  if GetComponent(0) is TODVCLDBCalendar then
    ds := TODVCLDBCalendar(GetComponent(0)).DataSource
  else if GetComponent(0) is TODVCLDBPopupCalendar then
    ds := TODVCLDBPopupCalendar(GetComponent(0)).DataSource
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
