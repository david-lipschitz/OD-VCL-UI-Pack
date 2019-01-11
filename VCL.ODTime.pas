{
  My Power Station Technology (Pty) Ltd - was Orbital Decisions
  P.O.Box 1080, Milnerton 7435, South Africa
  components@mypowerstation.biz
  http://www.orbital.co.za/text/prodlist.htm
  Copyright (c) 1998-2019

  Use at your own risk!
}

unit VCL.ODTime;

interface

uses
  Winapi.Messages, Winapi.Windows, System.SysUtils, Winapi.CommCtrl,
  System.Classes, Vcl.Controls, Vcl.Forms, Vcl.Menus, Vcl.Graphics,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Data.DB, Vcl.DBCtrls;

type
  TODVCLTimePicker = class(TCustomPanel)
  private
    FTimePanel: TPanel;
    FH1Edit, FH2Edit, FM1Edit, FM2Edit: TEdit;
    FUpBtn, FDnBtn: TSpeedButton;
    FHyphenLabel: TLabel;
    FOnChange: TNotifyEvent;
    FChanging, FClicking, FResizing: Boolean;
    function GetTime: TTime;
    procedure SetTime(Value: TTime);
    function GetCtl3D: Boolean;
    procedure SetCtl3D(Value: Boolean);
    function GetShowButtons: Boolean;
    procedure SetShowButtons(Value: Boolean);
    procedure WMMove(var Msg: TWMMove); message WM_MOVE;
  protected
    function GetEnabled: Boolean;
    procedure DoChange; virtual;
    procedure DoEnter; override;
    procedure Resize; override;
    procedure EditChange(Sender: TObject);
    procedure EditEnter(Sender: TObject);
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UpBtnClick(Sender: TObject);
    procedure DnBtnClick(Sender: TObject);
    procedure SetEnabled(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    property Time: TTime read GetTime write SetTime;
  published
    property ShowButtons: Boolean read GetShowButtons write SetShowButtons default True;
    property Enabled: Boolean read GetEnabled write SetEnabled default True;
    property Color;
    property Ctl3D read GetCtl3D write SetCtl3D;
    property Font;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnEnter;
    property OnExit;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TODVCLDBTimePicker = class(TODVCLTimePicker)
  private
    FDataLink: TFieldDataLink;
    FEnabled, FEditing, FBrowsing: Boolean;
    function GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function GetDataField: string;
    procedure SetDataField(const Value: string);
    function GetField: TField;
    function GetTime: TTime;
  protected
    procedure SetEnabled(Value: Boolean);
    procedure DoChange; override;
    procedure ActiveChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property Field: TField read GetField;
    property Time: TTime read GetTime;
  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DataField: string read GetDataField write SetDataField;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
  end;

implementation

//needed for TIMEUP and TIMEDN
{$R *.RES}

constructor TODVCLTimePicker.Create(AOwner: TComponent);
  function GetEdit(ALeft: Integer): TEdit;
  begin
    Result := TEdit.Create(Self);
    with Result do
    begin
      Parent := FTimePanel;
      AutoSize := False;
      BorderStyle := bsNone;
      Ctl3D := False;
      Top := 2;
      Left := ALeft;
      Width := 7;
      Height := 13;
      MaxLength := 1;
      Text := '0';
      OnChange := EditChange;
      OnEnter := EditEnter;
      OnKeyDown := EditKeyDown;
    end;
  end;
begin
  inherited Create(AOwner);
  Height := 21;
  Width := 57;
  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption];
  ControlStyle := ControlStyle + [csFixedWidth, csFixedHeight];
  BevelOuter := bvNone;
  BorderStyle := bsSingle;
  FTimePanel := TPanel.Create(Self);
  with FTimePanel do
  begin
    Parent := Self;
    Width := 37;
    Height := Self.Height - 4;
    BevelOuter := bvNone;
    Color := clWindow;
    ParentColor := False;
  end;
  FH1Edit := GetEdit(2);
  FH2Edit := GetEdit(9);
  FM1Edit := GetEdit(21);
  FM2Edit := GetEdit(28);
  FHyphenLabel := TLabel.Create(Self);
  with FHyphenLabel do
  begin
    Parent := FTimePanel;
    AutoSize := False;
    Top := 1;
    Left := 17;
    Width := 3;
    Height := 13;
    Caption := ':';
  end;
  FUpBtn := TSpeedButton.Create(Self);
  with FUpBtn do
  begin
    Parent := Self;
    Left := 38;
    Width := 15;
    Height := 8;
    Glyph.LoadFromResourceName(HInstance, 'TIMEUP');
    NumGlyphs := 2;
    OnClick := UpBtnClick;
  end;
  FDnBtn := TSpeedButton.Create(Self);
  with FDnBtn do
  begin
    Parent := Self;
    Top := 9;
    Left := 38;
    Width := 15;
    Height := 8;
    Glyph.LoadFromResourceName(HInstance, 'TIMEDN');
    NumGlyphs := 2;
    OnClick := DnBtnClick;
  end;
end;

procedure TODVCLTimePicker.UpBtnClick(Sender: TObject);
var
  ed: Tedit;
begin
  if FH2Edit.Focused then ed := FH2Edit
  else if FM1Edit.Focused then ed := FM1Edit
  else if FM2Edit.Focused then ed := FM2Edit
  else
  begin
    FH1Edit.SetFocus;
    ed := FH1Edit;
  end;
  FClicking := True;
  if ed.Text = '' then ed.Text := '0'
  else if ed.Text <> '9' then
    ed.Text := IntToStr(StrToInt(ed.Text) + 1);
  FClicking := False;
  ed.SelectAll;
end;

procedure TODVCLTimePicker.DnBtnClick(Sender: TObject);
var
  ed: Tedit;
begin
  if FH2Edit.Focused then ed := FH2Edit
  else if FM1Edit.Focused then ed := FM1Edit
  else if FM2Edit.Focused then ed := FM2Edit
  else
  begin
    FH1Edit.SetFocus;
    ed := FH1Edit;
  end;
  FClicking := True;
  if ed.Text <> '0' then
    ed.Text := IntToStr(StrToInt(ed.Text) - 1);
  FClicking := False;
  ed.SelectAll;
end;

procedure TODVCLTimePicker.EditChange(Sender: TObject);
var
  ed: Tedit;
  ch: Char;
begin
  if FChanging then Exit;
  FChanging := True;
  if FH1Edit.Text = '' then FH1Edit.Text := '0';
  if FH2Edit.Text = '' then FH2Edit.Text := '0';
  if FM1Edit.Text = '' then FM1Edit.Text := '0';
  if FM2Edit.Text = '' then FM2Edit.Text := '0';
  ed := Sender as TEdit;
  ch := ed.Text[1];
  if not (ch in ['0'..'9']) then ch := '0'
  else if ed = FH1Edit then
  begin
    if (ch = '2') and (FH2Edit.Text <> '') and (FH2Edit.Text[1] > '3') then
      FH2Edit.Text := '3'
    else if ch > '2' then ch := '2'
  end
  else if ed = FH2Edit then
  begin
    if (FH1Edit.Text = '2') and (ch > '3') then ch := '3';
  end
  else if (ed = FM1Edit) and (ch > '5') then ch := '5';
  if ch <> ed.Text then ed.Text := ch;
  FChanging := False;
  DoChange;
  if FClicking then Exit;
  if FH1Edit.Focused then FH2Edit.SetFocus
  else if FH2Edit.Focused then FM1Edit.SetFocus
  else if FM1Edit.Focused then FM2Edit.SetFocus;
end;

procedure TODVCLTimePicker.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_LEFT:
      if Sender = FM2Edit then FM1Edit.SetFocus
      else if Sender = FM1Edit then FH2Edit.SetFocus
      else if Sender = FH2Edit then FH1Edit.SetFocus
      else FM2Edit.SetFocus;
    VK_RIGHT:
      if Sender = FH1Edit then FH2Edit.SetFocus
      else if Sender = FH2Edit then FM1Edit.SetFocus
      else if Sender = FM1Edit then FM2Edit.SetFocus
      else FH1Edit.SetFocus;
    VK_UP:
      UpBtnClick(nil);
    VK_DOWN:
      DnBtnClick(nil);
    else (Sender as TEdit).SelectAll;
  end;
end;

procedure TODVCLTimePicker.EditEnter;
begin
  (Sender as TEdit).SelectAll;
end;

procedure TODVCLTimePicker.DoEnter;
begin
  inherited DoEnter;
  FH1Edit.SetFocus;
end;

function TODVCLTimePicker.GetTime: TTime;
begin
  if (FH1Edit.Text = '') or (FH2Edit.Text = '') or
     (FM1Edit.Text = '') or (FM2Edit.Text = '') then
    Result := -0.1
  else
    Result := StrToTime(
      FH1Edit.Text + FH2Edit.Text + ':' + FM1Edit.Text + FM2Edit.Text);
end;

procedure TODVCLTimePicker.SetTime(Value: TTime);
var
  st: string;
  hh, mm, ss, ms: Word;
begin
  FChanging := True;
  if Value < 0 then
  begin
    FH1Edit.Text := '';
    FH2Edit.Text := '';
    FM1Edit.Text := '';
    FM2Edit.Text := '';
  end
  else
  begin
    DecodeTime(Frac(Value), hh, mm, ss, ms);
    st := IntToStr(hh);
    while Length(st) < 2 do
      st := '0' + st;
    FH1Edit.Text := st[1];
    FH2Edit.Text := st[2];
    st := IntToStr(mm);
    while Length(st) < 2 do
      st := '0' + st;
    FM1Edit.Text := st[1];
    FM2Edit.Text := st[2];
  end;
  FTimePanel.Refresh;
  FChanging := False;
end;

function TODVCLTimePicker.GetCtl3D: Boolean;
begin
  Result := BorderStyle = bsSingle;
end;

procedure TODVCLTimePicker.SetCtl3D(Value: Boolean);
begin
  if Value <> GetCtl3D then
  begin
    if Value then
      BorderStyle := bsSingle
    else
      BorderStyle := bsNone;
    FUpBtn.Flat := not Value;
    FDnBtn.Flat := not Value;
  end;
  Resize;
end;

function TODVCLTimePicker.GetShowButtons: Boolean;
begin
  Result := FUpBtn.Visible;
end;

procedure TODVCLTimePicker.SetShowButtons(Value: Boolean);
begin
  FUpBtn.Visible := Value;
  FDnBtn.Visible := Value;
  Resize;
  FTimePanel.Refresh;
end;

function TODVCLTimePicker.GetEnabled: Boolean;
begin
  Result := inherited Enabled;
end;

procedure TODVCLTimePicker.SetEnabled(Value: Boolean);
begin
  inherited Enabled := Value;
  FUpBtn.Enabled := Value;
  FDnBtn.Enabled := Value;
  FTimePanel.Refresh;
end;

procedure TODVCLTimePicker.Resize;
var
  wi, ht: Integer;
begin
  if FResizing then Exit;
  FResizing := True;
  inherited Resize;
  wi := 38;
  ht := 17;
  if GetShowButtons then Inc(wi, 15);
  if GetCtl3D then
  begin
    Inc(wi, 4);
    Inc(ht, 4);
  end;
  Width := wi;
  Height := ht;
{  if GetCtl3D then
  begin
    Width := 57;
    Height := 21;
  end
  else
  begin
    Width := 53;
    Height := 17;
  end;}
  FResizing := False;
end;

procedure TODVCLTimePicker.DoChange;
begin
  if not (csDesigning in ComponentState) and Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TODVCLTimePicker.WMMove(var Msg: TWMMove);
begin
  inherited;
  if csDesigning in ComponentState then
    FTimePanel.Refresh;
end;

{TODVCLDBTimePicker}

constructor TODVCLDBTimePicker.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnActiveChange := ActiveChange;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  FEnabled := True;
  FBrowsing := True;
  inherited Time := -0.1;
  inherited Enabled := False;
end;

destructor TODVCLDBTimePicker.Destroy;
begin
  FDataLink.Free;
  inherited Destroy;
end;

procedure TODVCLDBTimePicker.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TODVCLDBTimePicker.ActiveChange(Sender: TObject);
begin
  inherited Enabled := FEnabled and FDataLink.Active;
  if FdataLink.Active then DataChange(nil)
  else inherited Time := -0.1;
end;

procedure TODVCLDBTimePicker.DataChange(Sender: TObject);
begin
  if FEditing then Exit;
  FBrowsing := True;
  if FDataLink.Field <> nil then
    if FDataLink.Field.IsNull then
      inherited Time := -0.1      //make blank
    else if FDataLink.Field is TDateTimeField then
      inherited Time := Frac(FDataLink.Field.AsDateTime)
    else if FDataLink.Field is TStringField then
      try
        inherited Time := StrToTime(FDataLink.Field.AsString);
      except
        on Exception do inherited Time := -0.1;
      end
    else inherited Time := -0.1;
  FBrowsing := False;
end;

procedure TODVCLDBTimePicker.UpdateData(Sender: TObject);
begin
  if FDataLink.Field <> nil then
    if FDataLink.Field is TDateTimeField then
      FDataLink.Field.AsDateTime :=
        Trunc(FDataLink.Field.AsDateTime) + Frac(Time)
    else if FDataLink.Field is TStringField then
      FDataLink.Field.AsString := Copy(TimeToStr(Time), 1, 5);
end;

procedure TODVCLDBTimePicker.DoChange;
begin
  if not FBrowsing then       //if not moving to another record
  begin
    FEditing := True;
    FDataLink.Edit;
    FDataLink.Modified;
    FDataLink.UpdateRecord;
    FEditing := False;
  end;
  inherited DoChange;
end;

function TODVCLDBTimePicker.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TODVCLDBTimePicker.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TODVCLDBTimePicker.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TODVCLDBTimePicker.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TODVCLDBTimePicker.GetField: TField;
begin
  Result := FDataLink.Field;
end;

function TODVCLDBTimePicker.GetTime: TTime;
begin
  Result := inherited Time;
end;

procedure TODVCLDBTimePicker.SetEnabled(Value: Boolean);
begin
  FEnabled := Value;
  inherited Enabled := FEnabled and FDataLink.Active;
  if not FDataLink.Active then inherited Time := -0.1;
end;

end.
