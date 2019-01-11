{
  My Power Station Technology (Pty) Ltd - was Orbital Decisions
  P.O.Box 1080, Milnerton 7435, South Africa
  components@mypowerstation.biz
  http://www.orbital.co.za/text/prodlist.htm
  Copyright (c) 1998-2019

  Use at your own risk!
}

unit VCL.ODDBCal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Data.DB, Vcl.DBCtrls,
  VCL.ODCalend, VCL.ODPopCal;

type
  TODVCLCustomDBCalendar = class(TODVCLCustomCalendar)
  private
    FStartDateLink, FFinishDateLink: TFieldDataLink;
    FBrowsing, FEditing: Boolean;
    function GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function GetStartDateName: string;
    procedure SetStartDateName(const Value: string);
    function GetFinishDateName: string;
    procedure SetFinishDateName(const Value: string);
    function GetStartDateField: TField;
    function GetFinishDateField: TField;
  protected
    procedure DoChange; override;
    procedure StartDataChange(Sender: TObject);
    procedure FinishDataChange(Sender: TObject);
    procedure UpdateStartData(Sender: TObject);
    procedure UpdateFinishData(Sender: TObject);
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property StartDateName: string read GetStartDateName write SetStartDateName;
    property FinishDateName: string read GetFinishDateName write SetFinishDateName;
    property StartDateField: TField read GetStartDateField;
    property FinishDateField: TField read GetFinishDateField;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  end;

  TODVCLDBCalendar = class(TODVCLCustomDBCalendar)
  private
    function GetStartDate: TDateTime;
    function GetFinishDate: TDateTime;
  public
    property StartDate read GetStartDate;
    property FinishDate read GetFinishDate;
    property DisplayDate;
    property StartDateField;
    property FinishDateField;
  published
    property DataSource;
    property StartDateName;
    property FinishDateName;
//  property DisplayYear;
//  property DisplayMonth;
//  property DisplayWeek;
    property DayColor;
    property TODVCLayColor;
    property RangeColor;
    property WeekColor;
    property TitleFont;
    property StartFont;
    property FinishFont;
    property PrevYearGlyph;
    property NextYearGlyph;
    property PrevMonthGlyph;
    property NextMonthGlyph;
    property DateFormat;
//  property Framed;
    property MonthNames;
    property Headers;
//  property SingleDate;
    property AutoPage;
    property Plain;
    property ShowStatus;
    property ShowWeeks;
    property ShowYearBtns;
    property StartOnMonday;
//    property TimeEditMask;
//    property TimeEditWidth;
    property UseTime;
    property Align;
    property BevelEdge;
    property Enabled;
    property Color;
//  property Ctl3D;
    property Font;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnDayDblClick;
    property OnStartClick;
    property OnFinishClick;
    property OnSelectYear;
    property OnSetupDay;
    property OnEnter;
    property OnExit;
    property OnResize;
  end;

  TODVCLDBPopupCalendar = class(TODVCLPopupCalendar)
  private
    FStartDateLink, FFinishDateLink: TFieldDataLink;
    FEditing: Boolean;
    function GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function GetStartDateName: string;
    procedure SetStartDateName(const Value: string);
    function GetFinishDateName: string;
    procedure SetFinishDateName(const Value: string);
    function GetStartDateField: TField;
    function GetFinishDateField: TField;
    function GetStartDate: TDateTime;
    function GetFinishDate: TDateTime;
  protected
    procedure ButtonClick(Sender: TObject); override;
    procedure Change(Sender: TObject); override;
    procedure StartDataChange(Sender: TObject);
    procedure FinishDataChange(Sender: TObject);
    procedure UpdateStartData(Sender: TObject);
    procedure UpdateFinishData(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property StartDate read GetStartDate;
    property FinishDate read GetFinishDate;
    property StartField: TField read GetStartDateField;
    property FinishField: TField read GetFinishDateField;
  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property StartDateName: string read GetStartDateName write SetStartDateName;
    property FinishDateName: string read GetFinishDateName write SetFinishDateName;
  end;

implementation

constructor TODVCLCustomDBCalendar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStartDateLink := TFieldDataLink.Create;
  FStartDateLink.Control := Self;
  FStartDateLink.OnDataChange := StartDataChange;
  FStartDateLink.OnUpdateData := UpdateStartData;
  FFinishDateLink := TFieldDataLink.Create;
  FFinishDateLink.Control := Self;
  FFinishDateLink.OnDataChange := FinishDataChange;
  FFinishDateLink.OnUpdateData := UpdateFinishData;
  FBrowsing := True;
end;

destructor TODVCLCustomDBCalendar.Destroy;
begin
  FStartDateLink.Free;
  FFinishDateLink.Free;
  FStartDateLink := nil;
  FFinishDateLink := nil;
  inherited Destroy;
end;

procedure TODVCLCustomDBCalendar.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then
  begin
    StartDataChange(Self);
    FinishDataChange(Self);
  end;
end;

procedure TODVCLCustomDBCalendar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FStartDateLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TODVCLCustomDBCalendar.GetDataSource: TDataSource;
begin
  Result := FStartDateLink.DataSource;
end;

procedure TODVCLCustomDBCalendar.SetDataSource(Value: TDataSource);
begin
  FStartDateLink.DataSource := Value;
  FFinishDateLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TODVCLCustomDBCalendar.GetStartDateName: string;
begin
  Result := FStartDateLink.FieldName;
end;

procedure TODVCLCustomDBCalendar.SetStartDateName(const Value: string);
begin
  FStartDateLink.FieldName := Value;
  SingleDate := FFinishDateLink.FieldName = '';
end;

function TODVCLCustomDBCalendar.GetFinishDateName: string;
begin
  Result := FFinishDateLink.FieldName;
end;

procedure TODVCLCustomDBCalendar.SetFinishDateName(const Value: string);
begin
  FFinishDateLink.FieldName := Value;
  SingleDate := Value = '';
end;

function TODVCLCustomDBCalendar.GetStartDateField: TField;
begin
  Result := FStartDateLink.Field;
end;

function TODVCLCustomDBCalendar.GetFinishDateField: TField;
begin
  Result := FFinishDateLink.Field;
end;

procedure TODVCLCustomDBCalendar.DoChange;
begin
  if not FBrowsing then       //if not moving to another record
  begin
    FEditing := True;
    FStartDateLink.Edit;
    FFinishDateLink.Edit;
    FStartDateLink.Modified;
    FFinishDateLink.Modified;
    FStartDateLink.UpdateRecord;
    FFinishDateLink.UpdateRecord;
    FEditing := False;
  end;
  inherited DoChange;
end;

procedure TODVCLCustomDBCalendar.StartDataChange(Sender: TObject);
var
  yr, mo, dy: Word;
begin
  if FEditing then Exit;
  FBrowsing := True;
  try
    if FStartDateLink.Field = nil then
      StartDate := 0
    else
    begin
      StartDate := FStartDateLink.Field.AsDateTime;
      if StartDate <> 0 then
      begin
        DecodeDate(StartDate, yr, mo, dy);
        DisplayYear := yr;
        DisplayMonth := mo;
      end;
    end;
    if SingleDate then
      FinishDate := StartDate;
  finally
    FBrowsing := False;
  end;
end;

procedure TODVCLCustomDBCalendar.FinishDataChange(Sender: TObject);
begin
  if FEditing then Exit;
  FBrowsing := True;
  try
    if FFinishDateLink.Field = nil then
      FinishDate := StartDate
    else
      FinishDate := FFinishDateLink.Field.AsDateTime;
  finally
    FBrowsing := False;
  end;
end;

procedure TODVCLCustomDBCalendar.UpdateStartData(Sender: TObject);
begin
  if FStartDateLink.Field <> nil then
    FStartDateLink.Field.AsDateTime := StartDate;
end;

procedure TODVCLCustomDBCalendar.UpdateFinishData(Sender: TObject);
begin
  if FFinishDateLink.Field <> nil then
    FFinishDateLink.Field.AsDateTime := FinishDate;
end;

//TODVCLDBCalendar

function TODVCLDBCalendar.GetStartDate: TDateTime;
begin
  Result := inherited StartDate;
end;

function TODVCLDBCalendar.GetFinishDate: TDateTime;
begin
  Result := inherited FinishDate;
end;

//TODVCLDBPopupCalendar

constructor TODVCLDBPopupCalendar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStartDateLink := TFieldDataLink.Create;
  FStartDateLink.Control := Self;
  FStartDateLink.OnDataChange := StartDataChange;
  FStartDateLink.OnUpdateData := UpdateStartData;
  FFinishDateLink := TFieldDataLink.Create;
  FFinishDateLink.Control := Self;
  FFinishDateLink.OnDataChange := FinishDataChange;
  FFinishDateLink.OnUpdateData := UpdateFinishData;
  StoreDates := False;
end;

destructor TODVCLDBPopupCalendar.Destroy;
begin
  FStartDateLink.Free;
  FFinishDateLink.Free;
  inherited Destroy;
end;

procedure TODVCLDBPopupCalendar.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then
  begin
    StartDataChange(Self);
    FinishDataChange(Self);
  end;
end;

procedure TODVCLDBPopupCalendar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FStartDateLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TODVCLDBPopupCalendar.GetDataSource: TDataSource;
begin
  Result := FStartDateLink.DataSource;
end;

procedure TODVCLDBPopupCalendar.SetDataSource(Value: TDataSource);
begin
  FStartDateLink.DataSource := Value;
  FFinishDateLink.DataSource := Value;
end;

function TODVCLDBPopupCalendar.GetStartDateName: string;
begin
  Result := FStartDateLink.FieldName;
end;

procedure TODVCLDBPopupCalendar.SetStartDateName(const Value: string);
begin
  FStartDateLink.FieldName := Value;
  SingleDate := FFinishDateLink.FieldName = '';
end;

function TODVCLDBPopupCalendar.GetFinishDateName: string;
begin
  Result := FFinishDateLink.FieldName;
end;

procedure TODVCLDBPopupCalendar.SetFinishDateName(const Value: string);
begin
  FFinishDateLink.FieldName := Value;
  SingleDate := Value = '';
end;

function TODVCLDBPopupCalendar.GetStartDateField: TField;
begin
  Result := FStartDateLink.Field;
end;

function TODVCLDBPopupCalendar.GetFinishDateField: TField;
begin
  Result := FFinishDateLink.Field;
end;

procedure TODVCLDBPopupCalendar.ButtonClick(Sender: TObject);
begin
  if csDesigning in ComponentState then
  begin
    FButton.Down := False;
    Exit;
  end;
  if (DataSource = nil) or (DataSource.DataSet = nil) or
      not DataSource.DataSet.Active or (StartDateName = '') then
  begin
    ShowMessage('Date data not fully defined or inactive.');
    FButton.Down := False;
  end else
  begin
    FEditing := True;
    inherited ButtonClick(Sender);
    if FForm.ModalResult = mrOK then
      Change(Self);
    FEditing := False;
  end;
end;

procedure TODVCLDBPopupCalendar.Change(Sender: TObject);
begin
  inherited Change(Sender);
  if not (csDesigning in ComponentState) then
  begin
    FEditing := True;
    FStartDateLink.Edit;
    FFinishDateLink.Edit;
    FStartDateLink.Modified;
    FFinishDateLink.Modified;
    FStartDateLink.UpdateRecord;
    FFinishDateLink.UpdateRecord;
    FEditing := False;
  end;
end;

procedure TODVCLDBPopupCalendar.StartDataChange(Sender: TObject);
begin
  if FEditing then Exit;
  if (FStartDateLink.Field = nil) or not FStartDateLink.Active then
    StartDate := 0
  else
  begin
    StartDate := FStartDateLink.Field.AsDateTime;
    if StartDate <> 0 then
      DisplayDate := StartDate;
  end;
  if SingleDate then
    FinishDate := StartDate;
end;

procedure TODVCLDBPopupCalendar.FinishDataChange(Sender: TObject);
begin
  if FEditing then Exit;
  if FFinishDateLink.Field <> nil then
    FinishDate := FFinishDateLink.Field.AsDateTime;
end;

procedure TODVCLDBPopupCalendar.UpdateStartData(Sender: TObject);
begin
  if FStartDateLink.Field <> nil then
    FStartDateLink.Field.AsDateTime := StartDate;
end;

procedure TODVCLDBPopupCalendar.UpdateFinishData(Sender: TObject);
begin
  if FFinishDateLink.Field <> nil then
    FFinishDateLink.Field.AsDateTime := FinishDate;
end;

function TODVCLDBPopupCalendar.GetStartDate: TDateTime;
begin
  Result := inherited StartDate;
end;

function TODVCLDBPopupCalendar.GetFinishDate: TDateTime;
begin
  Result := inherited FinishDate;
end;

end.
