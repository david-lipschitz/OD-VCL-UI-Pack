{
  My Power Station Technology (Pty) Ltd - was Orbital Decisions
  P.O.Box 1080, Milnerton 7435, South Africa
  components@mypowerstation.biz
  http://www.orbital.co.za/text/prodlist.htm
  Copyright (c) 1998-2019

  Use at your own risk!
}

unit VCL.ODCalend;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask,
  VCL.ODTime;

const
  ODVCLCalendarVersion = '5.0';

type
  TODVCLDateEvent = procedure(Sender: TObject; ADate: TDateTime) of object;
  TODVCLSelectDateEvent = procedure(Sender: TObject;
    var ADate: TDateTime) of object;
  TODVCLSelectYearEvent = procedure(Sender: TObject; Year: Integer;
    var YearStart, YearFinish: TDateTime) of object;
  TODVCLSetupDayEvent = procedure(Sender: TObject; DayDate: TDateTime;
    var DayColor: TColor; var DayHint: string) of object;

  TODVCLMonthNames = class(TPersistent)
  private
    FNames: array[1..12] of string;
    function GetMonthName(Index: Integer): string;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    property MonthName[Index: Integer]: string read GetMonthName; default;
  published
    property Jan: string read FNames[1] write FNames[1];
    property Feb: string read FNames[2] write FNames[2];
    property Mar: string read FNames[3] write FNames[3];
    property Apr: string read FNames[4] write FNames[4];
    property May: string read FNames[5] write FNames[5];
    property Jun: string read FNames[6] write FNames[6];
    property Jul: string read FNames[7] write FNames[7];
    property Aug: string read FNames[8] write FNames[8];
    property Sep: string read FNames[9] write FNames[9];
    property Oct: string read FNames[10] write FNames[10];
    property Nov: string read FNames[11] write FNames[11];
    property Dec: string read FNames[12] write FNames[12];
  end;

  TODVCLCalendarHeaders = class(TPersistent)
  private
    FCaptions: array[0..7] of string;
    function GetCaption(Index: Integer): string;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    property Caption[Index: Integer]: string read GetCaption; default;
  published
    property Week: string read FCaptions[0] write FCaptions[0];
    property Sunday: string read FCaptions[1] write FCaptions[1];
    property Monday: string read FCaptions[2] write FCaptions[2];
    property Tuesday: string read FCaptions[3] write FCaptions[3];
    property Wednesday: string read FCaptions[4] write FCaptions[4];
    property Thursday: string read FCaptions[5] write FCaptions[5];
    property Friday: string read FCaptions[6] write FCaptions[6];
    property Saturday: string read FCaptions[7] write FCaptions[7];
  end;

  TODVCLCustomCalendar = class(TCustomPanel)
  private
    FHeaderPanel, FGridPanel, FFooterPanel, FStartPanel, FFinishPanel: TPanel;
    FDays: array[0..5, 0..6] of TPanel;
    FWeeks: array[0..5] of TPanel;
    FHeadings: array[0..7] of TPanel;
    FStartTimePicker, FFinishTimePicker: TODVCLTimePicker;
    FMonthNames: TODVCLMonthNames;
    FHeaders: TODVCLCalendarHeaders;
//  FHeaderPopup: TPopupMenu;
    FPrevYearBtn, FNextYearBtn, FPrevMonthBtn, FNextMonthBtn,
      FMonthBtn, FYearBtn: TSpeedButton;
    FDisplayYear, FDisplayMonth: Integer;
    FStartDate, FFinishDate, FOldStartDate, FOldFinishDate: TDateTime;
    FDayColor, FTODVCLayColor, FRangeColor, FWeekColor: TColor;
    FDateFormat{, FStartTimeHint, FFinishTimeHint}: string;
    FSingleDate, FStartOnMonday, FAutoPage, FPaging, FPlain, FSetting,
      FShowCurrent, FShowWeeks, FResizing: Boolean;
    FOnChange: TNotifyEvent;
    FOnDayDblClick: TODVCLDateEvent;
    FOnStartClick, FOnFinishClick: TODVCLSelectDateEvent;
    FOnSelectYear: TODVCLSelectYearEvent;
    FOnSetupDay: TODVCLSetupDayEvent;
    function GetAbout: string;
    procedure SetAbout(Value: string);
    function GetDisplayDate: TDateTime;
    procedure SetDisplayDate(Value: TDateTime);
    procedure SetDisplayYear(Value: Integer);
    procedure SetDisplayMonth(Value: Integer);
//  function GetDisplayWeek: Integer;
//  procedure SetDisplayWeek(Value: Integer);
    procedure SetStartDate(Value: TDateTime);
    procedure SetFinishDate(Value: TDateTime);
    procedure SetDateFormat(const Value: string);
    function GetPanelDate(Panel: TPanel): TDateTime;
    procedure SetDayColor(Value: TColor);
    procedure SetTODVCLayColor(Value: TColor);
    procedure SetRangeColor(Value: TColor);
    procedure SetWeekColor(Value: TColor);
    function GetTitleFont: TFont;
    procedure SetTitleFont(Value: TFont);
    function GetStartFont: TFont;
    procedure SetStartFont(Value: TFont);
    function GetFinishFont: TFont;
    procedure SetFinishFont(Value: TFont);
    function GetBevelEdge: TPanelBevel;
    procedure SetBevelEdge(Value: TPanelBevel);
    procedure SetPlain(Value: Boolean);
    function GetShowStatus: Boolean;
    procedure SetShowStatus(Value: Boolean);
    procedure SetShowCurrent(Value: Boolean);
    procedure SetShowWeeks(Value: Boolean);
    procedure SetSingleDate(Value: Boolean);
    procedure SetStartOnMonday(Value: Boolean);
    function GetUseTime: Boolean;
    procedure SetUseTime(Value: Boolean);
    function GetShowTimeBtns: Boolean;
    procedure SetShowTimeBtns(Value: Boolean);
    function GetShowYearBtns: Boolean;
    procedure SetShowYearBtns(Value: Boolean);
    function GetPrevYearGlyph: TBitmap;
    procedure SetPrevYearGlyph(Value: TBitmap);
    function GetNextYearGlyph: TBitmap;
    procedure SetNextYearGlyph(Value: TBitmap);
    function GetPrevMonthGlyph: TBitmap;
    procedure SetPrevMonthGlyph(Value: TBitmap);
    function GetNextMonthGlyph: TBitmap;
    procedure SetNextMonthGlyph(Value: TBitmap);
    procedure WMMove(var Msg: TWMMove); message WM_MOVE;
  protected
    procedure Resize; override;
    procedure ResetTitleBtns;
    procedure MonthItemClick(Sender: TObject);
    procedure ThisMonthClick(Sender: TObject);
    procedure BtnClick(Sender: TObject);
    procedure DoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MonthMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure YearMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure DoDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure DoDayDblClick(Sender: TObject);
//  procedure DoHeaderPopup(Sender: TObject);
    procedure DoChange; virtual;
    procedure TimeEditChange(Sender: TObject);
    procedure SetBlank;
    function AdjustForWeekStart(ADayNo: Integer): Integer;
    procedure SetupMonth;
    procedure ShowCtrl(Control: TControl; ToShow: Boolean);
    property StartDate: TDateTime read FStartDate write SetStartDate;
    property FinishDate: TDateTime read FFinishDate write SetFinishDate;
    property DisplayDate: TDateTime read GetDisplayDate write SetDisplayDate;
    property DisplayYear: Integer read FDisplayYear write SetDisplayYear;
    property DisplayMonth: Integer read FDisplayMonth write SetDisplayMonth;
//  property DisplayWeek: Integer read GetDisplayWeek write SetDisplayWeek;
    property DayColor: TColor read FDayColor write SetDayColor default clWindow;
    property TODVCLayColor: TColor read FTODVCLayColor write SetTODVCLayColor default clBlue;
    property RangeColor: TColor read FRangeColor write SetRangeColor default clAqua;
    property WeekColor: TColor read FWeekColor write SetWeekColor default clWhite;
    property TitleFont: TFont read GetTitleFont write SetTitleFont;
    property StartFont: TFont read GetStartFont write SetStartFont;
    property FinishFont: TFont read GetFinishFont write SetFinishFont;
    property PrevYearGlyph: TBitmap read GetPrevYearGlyph write SetPrevYearGlyph;
    property NextYearGlyph: TBitmap read GetNextYearGlyph write SetNextYearGlyph;
    property PrevMonthGlyph: TBitmap read GetPrevMonthGlyph write SetPrevMonthGlyph;
    property NextMonthGlyph: TBitmap read GetNextMonthGlyph write SetNextMonthGlyph;
    property DateFormat: string read FDateFormat write SetDateFormat;
    property MonthNames: TODVCLMonthNames read FMonthNames write FMonthNames;
    property Headers: TODVCLCalendarHeaders read FHeaders write FHeaders;
    property BevelEdge: TPanelBevel read GetBevelEdge write SetBevelEdge default bvNone;
    property AutoPage: Boolean read FAutoPage write FAutoPage default True;
    property Plain: Boolean read FPlain write SetPlain default False;
    property ShowCurrent: Boolean read FShowCurrent write SetShowCurrent default True;
    property ShowStatus: Boolean read GetShowStatus write SetShowStatus default True;
    property SingleDate: Boolean read FSingleDate write SetSingleDate default False;
    property StartOnMonday: Boolean read FStartOnMonday write SetStartOnMonday default False;
    property ShowYearBtns: Boolean read GetShowYearBtns write SetShowYearBtns default True;
    property ShowTimeBtns: Boolean read GetShowTimeBtns write SetShowTimeBtns default True;
    property ShowWeeks: Boolean read FShowWeeks write SetShowWeeks default True;
    property UseTime: Boolean read GetUseTime write SetUseTime default False;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnDayDblClick: TODVCLDateEvent read FOnDayDblClick write FOnDayDblClick;
    property OnStartClick: TODVCLSelectDateEvent read FOnStartClick write FOnStartClick;
    property OnFinishClick: TODVCLSelectDateEvent read FOnFinishClick write FOnFinishClick;
    property OnSelectYear: TODVCLSelectYearEvent read FOnSelectYear write FOnSelectYear;
    property OnSetupDay: TODVCLSetupDayEvent read FOnSetupDay write FOnSetupDay;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure ResetDates;  // Added by A.G.  24/01/2001
    function DaysInMonth(AMonth, AYear: Integer): Integer;
    function WeeksInYear(AYear: Integer): Integer;
    function WeekToMonth(AWeek: Integer): Integer;
    function MonthToWeek(AMonth: Integer): Integer;
  published
    property About: string read GetAbout write SetAbout stored False;
    property Height default 206;
    property Width default 236;
  end;

  TODVCLCalendar = class(TODVCLCustomCalendar)
  public
    property StartDate;
    property FinishDate;
    property DisplayDate;
  published
    property DisplayYear;
    property DisplayMonth;
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
    property MonthNames;
    property Headers;
    property SingleDate;
    property AutoPage;
    property Plain;
    property ShowCurrent;
    property ShowStatus;
    property ShowTimeBtns;
    property ShowYearBtns;
    property ShowWeeks;
    property StartOnMonday;
    property UseTime;
    property Align;
    property BevelEdge;
    property Enabled;
    property Color;
//  property Ctl3D;
    property Font;
    property ParentColor;
//  property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnStartClick;
    property OnFinishClick;
    property OnDayDblClick;
    property OnSelectYear;
    property OnSetupDay;
    property OnEnter;
    property OnExit;
    property OnResize;
  end;

implementation

var
  Fmt: TFormatSettings;
//TODVCLMonthNames

constructor TODVCLMonthNames.Create;
var
  ix: Integer;
begin
  inherited Create;
  for ix := 1 to 12 do
    FNames[ix] := Fmt.LongMonthNames[ix];
end;

procedure TODVCLMonthNames.Assign(Source: TPersistent);
var
  ix: Integer;
begin
  if Source is TODVCLMonthNames then
    for ix := 1 to 12 do
      FNames[ix] := TODVCLMonthNames(Source)[ix]
  else inherited Assign(Source);
end;

function TODVCLMonthNames.GetMonthName(Index: Integer): string;
begin
  Result := FNames[Index];
end;

//TODVCLCalendarHeaders

constructor TODVCLCalendarHeaders.Create;
var
  ix: Integer;
begin
  inherited Create;
  FCaptions[0] := 'Wk';
  for ix := 1 to 7 do
    FCaptions[ix] := Fmt.ShortDayNames[ix];
end;

procedure TODVCLCalendarHeaders.Assign(Source: TPersistent);
var
  ix: Integer;
begin
  if Source is TODVCLCalendarHeaders then
    for ix := 0 to 7 do
      FCaptions[ix] := TODVCLCalendarHeaders(Source)[ix]
  else inherited Assign(Source);
end;

function TODVCLCalendarHeaders.GetCaption(Index: Integer): string;
begin
  Result := FCaptions[Index];
end;

//TODVCLCustomCalendar

constructor TODVCLCustomCalendar.Create(AOwner: TComponent);
(*
  procedure AddMonthItems(Popup: TPopupMenu);
    function MonthItem(Cn: string; Nr: Integer): TMenuItem;
    begin
      Result := TMenuItem.Create(Self);
      with Result do
      begin
        Caption := Cn;
        Tag := Nr;
        RadioItem := True;
        GroupIndex := 1;
    //  ShortCut := TextToShortCut('F' + IntToStr(Nr));
        OnClick := MonthItemClick;
      end;
    end;
  begin
    with Popup.Items do
    begin
      Add(MonthItem('January', 1));
      Add(MonthItem('February', 2));
      Add(MonthItem('March', 3));
      Add(MonthItem('April', 4));
      Add(MonthItem('May', 5));
      Add(MonthItem('June', 6));
      Add(MonthItem('July', 7));
      Add(MonthItem('August', 8));
      Add(MonthItem('September', 9));
      Add(MonthItem('October', 10));
      Add(MonthItem('November', 11));
      Add(MonthItem('December', 12));
    end;
  end;
*)
  function CreateBtn(ALeft: Integer; const ACaption, AHint: string): TSpeedButton;
  begin
    Result := TSpeedButton.Create(Self);
    with Result do
    begin
      Parent := FHeaderPanel;
      Top := 2;
      Left := ALeft;
      Width := 21;
      Height := 22;
      Flat := True;
      Font.Style := [fsBold];
//    Margin := 3;
      Layout := blGlyphBottom;
      ShowHint := True;
      Hint := AHint;
      Caption := ACaption;
      OnClick := BtnClick;
    end;
  end;

var
  ix, iy: Integer;
//mi: TMenuItem;

begin {Create}
  inherited Create(AOwner);
  Height := 206;
  Width := 236;
  BorderWidth := 1;
  BevelOuter := bvNone;
  BevelInner := bvLowered;
  FMonthNames := TODVCLMonthNames.Create;
  FHeaders := TODVCLCalendarHeaders.Create;
  //init header panel
{ FHeaderPopup := TPopupMenu.Create(Self);
  mi := TMenuItem.Create(Self);
  mi.Caption := '&This Month';
  mi.OnClick := ThisMonthClick;
  FHeaderPopup.Items.Add(mi);
  mi := TMenuItem.Create(Self);
  mi.Caption := '-';
  FHeaderPopup.Items.Add(mi);
  AddMonthItems(FHeaderPopup);
  FHeaderPopup.OnPopup := DoHeaderPopup;}
  FHeaderPanel := TPanel.Create(Self);
  with FHeaderPanel do
  begin
    Parent := Self;
    Height := 26;
    Align := alTop;
    Font.Style := [fsBold];
    ControlStyle := ControlStyle - [csParentBackground];
//  PopupMenu := FHeaderPopup;
  end;
  FFooterPanel := TPanel.Create(Self);
  with FFooterPanel do
  begin
    Parent := Self;
    Height := 38;
    Align := alBottom;
    BevelOuter := bvNone;
    ControlStyle := ControlStyle - [csParentBackground];
  end;
  FStartPanel := TPanel.Create(Self);
  with FStartPanel do
  begin
    Parent := FFooterPanel;
    Height := 19;
    Align := alTop;
    Alignment := taLeftJustify;
    ControlStyle := ControlStyle - [csParentBackground];
  end;
  FFinishPanel := TPanel.Create(Self);
  with FFinishPanel do
  begin
    Parent := FFooterPanel;
    Align := alClient;
    Alignment := taLeftJustify;
    ControlStyle := ControlStyle - [csParentBackground];
  end;
  FStartTimePicker := TODVCLTimePicker.Create(Self);
  with FStartTimePicker do
  begin
    Parent := FStartPanel;
    ControlStyle := ControlStyle + [csNoDesignVisible];
    ParentCtl3D := False;
    Left := FStartPanel.Width - Width;
    Enabled := False;
    Visible := False;
    OnChange := TimeEditChange;
    ControlStyle := ControlStyle - [csParentBackground];
  end;
  FFinishTimePicker := TODVCLTimePicker.Create(Self);
  with FFinishTimePicker do
  begin
    Parent := FFinishPanel;
    ControlStyle := ControlStyle + [csNoDesignVisible];
    ParentCtl3D := False;
    Left := FFinishPanel.Width - Width;
    Enabled := False;
    Visible := False;
    OnChange := TimeEditChange;
    ControlStyle := ControlStyle - [csParentBackground];
  end;
  FGridPanel := TPanel.Create(Self);
  FGridPanel.Parent := Self;
  FGridPanel.Align := alClient;
  FGridPanel.ControlStyle := FGridPanel.ControlStyle - [csParentBackground];
  FPrevYearBtn  := CreateBtn(4, '<<', '- Year');
  FPrevMonthBtn := CreateBtn(25, '<', '- Month');
  FNextMonthBtn := CreateBtn(154, '>', '+ Month');
  FNextYearBtn  := CreateBtn(175, '>>', '+ Year');
  FMonthBtn := TSpeedButton.Create(Self);
  with FMonthBtn do
  begin
    Parent := FHeaderPanel;
    Top := 2;
    Left := 48;
    Width := 64;
    Height := 22;
    Flat := True;
    Font.Style := [fsBold];
    Margin := 0;
    Layout := blGlyphRight;
    ShowHint := True;
    OnMouseDown := MonthMouseDown;
    ControlStyle := ControlStyle - [csParentBackground];
  end;
  FYearBtn := TSpeedButton.Create(Self);
  with FYearBtn do
  begin
    Parent := FHeaderPanel;
    Top := 2;
    Left := 112;
    Width := 40;
    Height := 22;
    Flat := True;
    Font.Style := [fsBold];
    Margin := 0;
    OnMouseDown := YearMouseDown;
    ControlStyle := ControlStyle - [csParentBackground];
  end;
  //init col headers
  for ix := 0 to 7 do
  begin
    FHeadings[ix] := TPanel.Create(Self);
    with FHeadings[ix] do
    begin
      Parent := FGridPanel;
      Height := 16;
      Width := 25;
      Left := ix * Width;
      Top := 0;
      Alignment := taCenter;
//    Caption := CalendarHeaders[ix];
      ControlStyle := ControlStyle - [csParentBackground];
    end;
  end;
  FHeadings[0].Caption := FHeaders[0];
  //init weeks
  for iy := 0 to 5 do
  begin
    FWeeks[iy] := TPanel.Create(Self);
    with FWeeks[iy] do
    begin
      Parent := FGridPanel;
      Height := 25;
      Width := 25;
      Left := 0;
      Top := iy * Height + 16;
      Tag := iy * -1;   //identifies it as a week & not a day
      Alignment := taCenter;
      ParentShowHint := False;
      OnMouseDown := DoMouseDown;
      OnMouseMove := DoMouseMove;
{}    OnDragOver := DoDragOver;
      ControlStyle := ControlStyle - [csParentBackground];
    end;
  end;
  //init grid
  for iy := 0 to 5 do
  begin
    for ix := 0 to 6 do
    begin
      FDays[iy, ix] := TPanel.Create(Self);
      with FDays[iy, ix] do
      begin
        Parent := FGridPanel;
        Height := 25;
        Width := 25;
        Left := ix * Width + 25;
        Top := iy * Height + 16;
        Alignment := taCenter;
        ShowHint := True;
        OnMouseDown := DoMouseDown;
        OnMouseMove := DoMouseMove;
{}      OnDragOver := DoDragOver;
        OnDblClick := DoDayDblClick;
        ControlStyle := ControlStyle - [csParentBackground];
      end;
    end;
  end;
  FDayColor := clWindow;
  FTODVCLayColor := clBlue;
  FRangeColor := clAqua;
  FWeekColor := clWhite;
  FAutoPage := True;
  FDateFormat := 'dddd, mmm d, yyyy';
  FShowCurrent := True;
  FShowWeeks := True;
  ControlStyle := ControlStyle - [csAcceptsControls] - [csParentBackground];
  for ix := 0 to ComponentCount-1 do
  begin
    if Components[ix] is TWinControl then
      with TWinControl(Components[ix]) do
        ControlStyle := ControlStyle - [csAcceptsControls] - [csParentBackground];
  end;
  if not (csLoading in ComponentState) then
  begin
    if FShowCurrent then SetDisplayDate(Date);
    Resize;
  end;
end;

destructor TODVCLCustomCalendar.Destroy;
begin
  FHeaders.Free;
  FMonthNames.Free;
  inherited Destroy;
end;

procedure TODVCLCustomCalendar.Loaded;
begin
  inherited Loaded;
  if FShowCurrent then SetDisplayDate(Date);
  SetPrevYearGlyph(FPrevYearBtn.Glyph);
  SetNextYearGlyph(FNextYearBtn.Glyph);
  SetPrevMonthGlyph(FPrevMonthBtn.Glyph);
  SetNextMonthGlyph(FNextMonthBtn.Glyph);
  Resize;
end;

procedure TODVCLCustomCalendar.ResetDates;
begin
  // Added 24/01/2001
  // Sets the Start and Finish dates to nil.
  SetStartDate(0);
  SetFinishDate(0);
end;

procedure TODVCLCustomCalendar.SetupMonth;

  procedure SetColors(ARow, ACol, AYear: Integer; var ATODVCLayRow: Integer);
  var
    aDate: TDateTime;
    aSelected: Boolean;
    aColor: TColor;
    aHint: string;

  begin
    with FDays[ARow, ACol] do
    begin
      aDate := EncodeDate(AYear, Tag, StrToInt(Caption));
      aColor := FDayColor;
      aHint := '';
      if Assigned(FOnSetupDay) then
        FOnSetupDay(Self, aDate, aColor, aHint);
      aSelected := (aDate >= Trunc(FStartDate)) and (aDate <= FFinishDate);
      if aDate = Date then
      begin //set as TODVCLay
        if Tag = FDisplayMonth then
        begin  //a display month day
          Color := FTODVCLayColor;
          if aSelected then
            Font.Color := FRangeColor
          else
            Font.Color := FDayColor;
        end
        else
        begin        //a day from the prev or following month
          Color := Self.Color;
          Font.Color := FTODVCLayColor;
        end;
        Hint := 'TODVCLay';
        if aHint <> '' then
          Hint := Hint + ' - ' + aHint;
        ATODVCLayRow := ARow;
      end
      else
      begin            //another day
        if Tag = FDisplayMonth then
        begin          //a display month day
          if aSelected then
            Color := FRangeColor
          else
            Color := FDayColor;
          Font.Color := Self.Font.Color;
        end
        else
        begin          //a day from the prev or following month
          Color := Self.Color;
          if aSelected then
            Font.Color := FRangeColor
          else
            Font.Color := clGray;
        end;
        if Color = FDayColor then      //implement any custom color
          Color := aColor
        else if (Color = Self.Color) and (aColor <> FDayColor) and
          not aSelected then Font.Color := aColor;
        Hint := aHint;             //implement any custom hint
      end;
    end;
  end;

var
  aFirstDate: TDateTime;
  aTotalDays, aWeekDay, aCurDay, aTODVCLayRow, aWeekNo, aWeeksLastYear,
    aWeeksThisYear, iCol, iRow: Integer;
begin  {SetupMonth}
  aFirstDate := EncodeDate(FDisplayYear, FDisplayMonth, 1);    //get first day's date
  aWeekDay := AdjustForWeekStart(DayOfWeek(aFirstDate));
  aTotalDays := DaysInMonth(FDisplayMonth, FDisplayYear);
  aCurDay := 1;
  aTODVCLayRow := -1;
  if FSingleDate and not (csDesigning in ComponentState) then
    FHeaderPanel.Caption := FMonthNames[FDisplayMonth] + ' ' + IntToStr(FDisplayYear)
  else
  begin
    FHeaderPanel.Caption := '';
    FMonthBtn.Caption := FMonthNames[FDisplayMonth];
    FYearBtn.Caption := FormatDateTime('yyy', aFirstDate);
  end;
  ResetTitleBtns;
  for iRow := 0 to 5 do
    for iCol := 0 to 6 do
      with FDays[iRow, iCol] do
      begin
        if (iRow = 0) and (iCol + 1 < aWeekDay) then
        begin   //belongs to the prev month
          if FDisplayMonth = 1 then
          begin
            Tag := 12;
            Caption := IntToStr(DaysInMonth(12, FDisplayYear -1) -
              aWeekDay + iCol + 2);
            SetColors(iRow, iCol, FDisplayYear -1, aTODVCLayRow);
          end
          else
          begin
            Tag := FDisplayMonth - 1;
            Caption := IntToStr(DaysInMonth(Tag, FDisplayYear) -
              aWeekDay + iCol + 2);
            SetColors(iRow, iCol, FDisplayYear, aTODVCLayRow);
          end;
        end
        else
        begin
          if aCurDay > aTotalDays then
          begin   //belongs to the next month
            Caption := IntToStr(aCurDay - aTotalDays);
            if FDisplayMonth = 12 then
            begin
              Tag := 1;
              SetColors(iRow, iCol, FDisplayYear +1, aTODVCLayRow);
            end
            else
            begin
              Tag := FDisplayMonth + 1;
              SetColors(iRow, iCol, FDisplayYear, aTODVCLayRow);
            end;
          end
          else
          begin                //belongs to display month
            Tag := FDisplayMonth;
            Caption := IntToStr(aCurDay);
            SetColors(iRow, iCol, FDisplayYear, aTODVCLayRow);
          end;
          Inc(aCurDay);
        end;
      end;
  aWeeksLastYear := WeeksInYear(FDisplayYear-1);
  aWeeksThisYear := WeeksInYear(FDisplayYear);
  for iRow := 0 to 5 do
    with FWeeks[iRow] do
    begin
      if FDisplayMonth = 1 then     //special handling!
        if (iRow = 0) and (aWeekDay > 4) then
          aWeekNo := aWeeksLastYear //part of last week of last year
        else if aWeekDay > 4 then  //if falls under last year's last week
          aWeekNo := iRow     //make next week no's one less after 1st
        else
          aWeekNo := iRow + 1  //no deduction
      else
      begin
        aWeekNo := MonthToWeek(FDisplayMonth) + iRow;
        if aWeekNo > aWeeksThisYear then
          aWeekNo := aWeekNo - aWeeksThisYear;  //belongs to next year
      end;
      Caption := IntToStr(aWeekNo);
      ShowHint := iRow = aTODVCLayRow;
      if ShowHint then
      begin
        Font.Color := FTODVCLayColor;
        Hint := 'This week';
      end
      else
      begin
        aFirstDate := GetPanelDate(FWeeks[iRow]);
        if ((FStartDate >= aFirstDate) and (FStartDate <= aFirstDate+6)) or
           ((FFinishDate >= aFirstDate) and (FFinishDate <= aFirstDate+6)) or
           ((FStartDate < aFirstDate) and (FFinishDate > aFirstDate+6)) then
          Font.Color := FRangeColor
        else
          Font.Color := FWeekColor;
        Hint := '';
      end;
    end;
  FHeadings[0].Font.Color := FWeekColor;
  if FStartOnMonday then
  begin
    for iCol := 1 to 6 do
      FHeadings[iCol].Caption := FHeaders[iCol+1];
    FHeadings[7].Caption := FHeaders[1];
  end
  else
    for iCol := 1 to 7 do
      FHeadings[iCol].Caption := FHeaders[iCol];
end;

procedure TODVCLCustomCalendar.DoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  dt: TDateTime;
  wk: Boolean;
begin
  dt := Trunc(GetPanelDate(Sender as TPanel));
  wk := (Sender as TPanel).Tag < 1;      //clicked on a week panel
  if Shift = [ssLeft] then
  begin
    if wk and (dt + 6 > FFinishDate) then
      SetFinishDate(dt + 6 + Frac(FFinishDate)); //select whole week
    SetStartDate(dt + Frac(FStartDate));
    if FStartTimePicker.Focused then //to reset focus below
      FFinishTimePicker.SetFocus;
    if FStartTimePicker.CanFocus then
      FStartTimePicker.SetFocus;
  end
  else if not SingleDate and (Shift = [ssRight]) then
  begin
    if wk then
    begin
      if dt < FStartDate then
        SetStartDate(dt + Frac(FStartDate));  //select whole week
      dt := dt + 6;             //to end of week
    end;
    SetFinishDate(dt + Frac(FFinishDate));
    if FFinishTimePicker.Focused then //to reset focus below
      FStartTimePicker.SetFocus;
    if FFinishTimePicker.CanFocus then
      FFinishTimePicker.SetFocus;
  end;
end;

procedure TODVCLCustomCalendar.MonthMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  dt: TDateTime;
begin
  if Shift = [ssLeft] then        //a start date click
  begin
    dt := EncodeDate(FDisplayYear, FDisplayMonth,
      DaysInMonth(FDisplayMonth, FDisplayYear));
    if FFinishDate < dt then SetFinishDate(dt + Frac(FFinishDate));
    SetStartDate(EncodeDate(FDisplayYear, FDisplayMonth, 1) + Frac(FStartDate));
    if FStartTimePicker.CanFocus then
      FStartTimePicker.SetFocus;
  end
  else if Shift = [ssRight] then   //a finish date click
  begin
    dt := EncodeDate(FDisplayYear, FDisplayMonth, 1);
    if FStartDate > dt then SetStartDate(dt + Frac(FStartDate));
    SetFinishDate(EncodeDate(FDisplayYear, FDisplayMonth,
      DaysInMonth(FDisplayMonth, FDisplayYear)) + Frac(FFinishDate));
    if FFinishTimePicker.CanFocus then
      FFinishTimePicker.SetFocus;
  end;
end;

procedure TODVCLCustomCalendar.YearMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  dStart, dFinish: TDateTime;
begin
  dStart := EncodeDate(FDisplayYear, 1, 1) + Frac(FStartDate);
  dFinish := EncodeDate(FDisplayYear, 12, 31) + Frac(FFinishDate);
  if Assigned(FOnSelectYear) then
    FOnSelectYear(Self, FDisplayYear, dStart, dFinish);
  if Shift = [ssLeft] then
  begin
    if FFinishDate < dFinish then
      SetFinishDate(dFinish);
    SetStartDate(dStart);
    if FStartTimePicker.CanFocus then
      FStartTimePicker.SetFocus;
  end
  else if Shift = [ssRight] then
  begin
    if FStartDate > dStart then
      SetStartDate(dStart);
    SetFinishDate(dFinish);
    if FFinishTimePicker.CanFocus then
      FFinishTimePicker.SetFocus;
  end;
end;

procedure TODVCLCustomCalendar.DoMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (ssLeft in Shift) and not (ssDouble in Shift) then
    (Sender as TPanel).BeginDrag(False);
end;

procedure TODVCLCustomCalendar.DoDragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  aCaption: string;
  aTag, yOffset, iCol, iRow: Integer;
begin
  Accept := Source is TPanel;
  if Accept{ and not FPaging} then
  begin
    DoMouseDown(Sender, mbLeft, [ssRight], X, Y);
    with Sender as TPanel do
      if FAutoPage and not FPaging and (Tag <> FDisplayMonth) then
      begin     //auto page to month dragged to
        FPaging := True;
        aCaption := Caption;
        aTag := Tag;
        yOffset := Top;
        if (StrToInt(Caption) > 20) and (Tag = 12) then //dragging to prev Dec
          Dec(FDisplayYear)       //then go back a year
        else if Tag = 1 then     //dragging to next Jan
          Inc(FDisplayYear);     //then go forward a year
        SetDisplayMonth(Tag);
        for iCol := 0 to 5 do
          for iRow := 0 to 6 do
            if (FDays[iCol][iRow].Caption = aCaption) and
               (FDays[iCol][iRow].Tag = aTag) then
            begin
              yOffset := FDays[iCol][iRow].Top - yOffset;
              Break;
            end;
        Mouse_Event(MOUSEEVENTF_MOVE, 0, yOffset div 2, 0, 0);
      end
      else if Tag = FDisplayMonth then
        FPaging := False;
  end;
end;

procedure TODVCLCustomCalendar.DoDayDblClick(Sender: TObject);
begin
  if Assigned(FOnDayDblClick) then
  begin
//  SetStartDate(FOldStartDate);
  //SetFinishDate(FOldFinishDate);
    FOnDayDblClick(Self, EncodeDate(FDisplayYear, FDisplayMonth,
      StrToInt((Sender as TPanel).Caption)));
  end;
end;

procedure TODVCLCustomCalendar.DoChange;
begin
  if not (csDesigning in ComponentState) and Assigned(FOnChange) then
    FOnChange(Self);
end;

function TODVCLCustomCalendar.GetPanelDate(Panel: TPanel): TDateTime;
var
  yr: Word;
begin
  if Panel.Tag < 1 then          //is a week panel
    Panel := FDays[Panel.Tag * -1, 0];   //so get 1st day in week panel
  if (Panel.Tag = 12) and (FDisplayMonth = 1) then
    yr := FDisplayYear - 1        //prev year
  else if (Panel.Tag = 1) and (FDisplayMonth = 12) then
    yr := FDisplayYear + 1       //next year
  else
    yr := FDisplayYear;          //this year
  Result := EncodeDate(yr, Panel.Tag, StrToInt(Panel.Caption));
end;

procedure TODVCLCustomCalendar.SetBlank;
begin
  FStartDate := 0;
  FFinishDate := 0;
  FStartPanel.Caption := '';
  FFinishPanel.Caption := '';
  FStartTimePicker.Time := -0.1;
  FFinishTimePicker.Time := -0.1;
  SetupMonth;
  DoChange;
end;

procedure TODVCLCustomCalendar.SetStartDate(Value: TDateTime);
var
  st: string;
// oldYr, oldMo, oldDy, newYr, newMo, newDy: Word;
begin
  if Value <> FStartDate then
  begin
    if Value = 0 then SetBlank
    else
    begin
      FOldStartDate := FStartDate;
      FStartDate := Value;
      if not (csDesigning in ComponentState) and Assigned(FOnStartClick) then
        FOnStartClick(Self, FStartDate);
      if FSingleDate then st := ' Date' else st := ' Start';
      FStartPanel.Caption := st + ':   ' +
        FormatDateTime(FDateFormat, FStartDate);
      if not FSetting then
      begin
        FSetting := True;
        FStartTimePicker.Time := Frac(FStartDate);
        FSetting := False;
      end;
      if (FStartDate > FFinishDate) or
         (FSingleDate and (FFinishDate <> FStartDate)) then
        SetFinishDate(FStartDate)
      else SetupMonth;
      DoChange;
    end;
{    DecodeDate(FOldStartDate, oldYr, oldMo, oldDy);
    DecodeDate(FStartDate, newYr, newMo, newDy);
    if (oldYr <> newYr) and Assigned(FOnYearChange) then
      FOnYearChange(Self, oldYr, newYr);
    if (oldMo <> newMo) and Assigned(FOnMonthChange) then
      FOnMonthChange(Self, oldMo, newMo);
    if Assigned(FOnStartDateChange) then
      FOnStartDateChange(Self, FOldStartDate, FStartDate);}
  end;
  FStartTimePicker.Enabled := FStartDate <> 0;
end;

procedure TODVCLCustomCalendar.SetFinishDate(Value: TDateTime);
{var
 oldYr, oldMo, oldDy, newYr, newMo, newDy: Word;}
begin
  if Value <> FFinishDate then
  begin
    if Value = 0 then SetBlank
    else
      begin
        FOldFinishDate := FFinishDate;
        FFinishDate := Value;
        if not (csDesigning in ComponentState) and Assigned(FOnFinishClick) then
          FOnFinishClick(Self, FFinishDate);
        FFinishPanel.Caption := ' Finish: ' +
          FormatDateTime(FDateFormat, FFinishDate);
        if not FSetting then
        begin
          FSetting := True;
          FFinishTimePicker.Time := Frac(FFinishDate);
          FSetting := False;
        end;
        if FFinishDate < FStartDate then
          SetStartDate(FFinishDate)
        else if FStartDate > 0 then
          SetupMonth;
        DoChange;
      end;
{    DecodeDate(FOldFinishDate, oldYr, oldMo, oldDy);
    DecodeDate(FFinishDate, newYr, newMo, newDy);
    if (oldYr <> newYr) and Assigned(FOnYearChange) then
      FOnYearChange(Self, oldYr, newYr);
    if (oldMo <> newMo) and Assigned(FOnMonthChange) then
      FOnMonthChange(Self, oldMo, newMo);
    if Assigned(FOnStartDateChange) then
      FOnStartDateChange(Self, FOldStartDate, FStartDate);}
  end;
  FFinishTimePicker.Enabled := FFinishDate <> 0;
end;

procedure TODVCLCustomCalendar.SetDateFormat(const Value: string);
begin
  if FDateFormat <> Value then
  begin
    FDateFormat := Value;
    if FStartPanel.Caption <> '' then
      SetStartDate(FStartDate);
    if FFinishPanel.Caption <> '' then
      SetFinishDate(FFinishDate);
  end;
end;

procedure TODVCLCustomCalendar.SetPlain(Value: Boolean);
var
  ix: Integer;
  aBevel: TPanelBevel;
begin
  if FPlain = Value then Exit;
  FPlain := Value;
  if FPlain then
  begin
    aBevel := bvNone;
    BevelInner := bvNone;
    FStartTimePicker.Top := 1;
    FFinishTimePicker.Top := 1;
  end
  else
  begin
    aBevel := bvRaised;
    BevelInner := bvLowered;
    FStartTimePicker.Top := 0;
    FFinishTimePicker.Top := 0;
  end;
  for ix := 0 to ComponentCount-1 do
    if (Components[ix] is TPanel) and (Components[ix] <> FFooterPanel) then
      TPanel(Components[ix]).BevelOuter := aBevel;
  FStartTimePicker.Ctl3D := not Value;
  FFinishTimePicker.Ctl3D := not Value;
  Resize;
end;

procedure TODVCLCustomCalendar.MonthItemClick(Sender: TObject);
begin
  SetDisplayMonth((Sender as TMenuItem).Tag);
end;

procedure TODVCLCustomCalendar.ThisMonthClick(Sender: TObject);
begin
  SetDisplayDate(Date);
end;

procedure TODVCLCustomCalendar.BtnClick(Sender: TObject);
begin
  if Sender = FPrevMonthBtn then
    if FDisplayMonth = 1 then
    begin
      Dec(FDisplayYear);
      FDisplayMonth := 12;
     end
     else Dec(FDisplayMonth)
  else if Sender = FNextMonthBtn then
    if FDisplayMonth = 12 then
    begin
      Inc(FDisplayYear);
      FDisplayMonth := 1;
     end
     else Inc(FDisplayMonth)
  else if Sender = FPrevYearBtn then
    Dec(FDisplayYear)
  else if Sender = FNextYearBtn then
    Inc(FDisplayYear);
  SetupMonth;
end;

procedure TODVCLCustomCalendar.TimeEditChange(Sender: TObject);
begin
  if FSetting then Exit;
  FSetting := True;
  try
    if Sender = FStartTimePicker then
      SetStartDate(Trunc(FStartDate) + Frac(FStartTimePicker.Time))
    else
      SetFinishDate(Trunc(FFinishDate) + Frac(FFinishTimePicker.Time))
  finally
    FSetting := False;
  end;
end;

function TODVCLCustomCalendar.GetDisplayDate: TDateTime;
begin
  Result := EncodeDate(FDisplayYear, FDisplayMonth, 1);
end;

procedure TODVCLCustomCalendar.SetDisplayDate(Value: TDateTime);
var
  yr, mo, dy: Word;
begin
  if (FDisplayYear = 0) or (FDisplayMonth = 0) or (DisplayDate <> Value) then
  begin
    DecodeDate(Value, yr, mo, dy);
    FDisplayYear := yr;
    FDisplayMonth := mo;
    SetupMonth;
  end;
  FShowCurrent := False;
end;

procedure TODVCLCustomCalendar.SetDisplayYear(Value: Integer);
begin
  if Value <> FDisplayYear then
  begin
    if Value < 1900 then FDisplayYear := 1900
    else if Value > 2100 then FDisplayYear := 2100
    else FDisplayYear := Value;
    SetupMonth;
  end;
  FShowCurrent := False;
end;

procedure TODVCLCustomCalendar.SetDisplayMonth(Value: Integer);
begin
  if Value <> FDisplayMonth then
  begin
    if Value < 1 then FDisplayMonth := 1
    else if Value > 12 then FDisplayMonth := 12
    else FDisplayMonth := Value;
    SetupMonth;
  end;
  FShowCurrent := False;
end;
{
procedure TODVCLCustomCalendar.SetDisplayDay(Value: Integer);
begin
  if Value < 1 then FDisplayDay := 1
  else if Value > DaysInMonth(FDisplayMonth, FDisplayYear) then
    FDisplayDay := DaysInMonth(FDisplayMonth, FDisplayYear)
  else FDisplayDay := Value;
  SetupMonth;
end;
}
function TODVCLCustomCalendar.AdjustForWeekStart(ADayNo: Integer): Integer;
begin
  Result := ADayNo;
  if FStartOnMonday then
    if Result = 1 then Result := 7 else Dec(Result);
end;

function TODVCLCustomCalendar.DaysInMonth(AMonth, AYear: Integer): Integer;
const
  DaysPerMonth: array[1..12] of Integer =
    (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
begin
  Result := DaysPerMonth[AMonth];
  if (AMonth = 2) and IsLeapYear(AYear) then Inc(Result);
end;

function TODVCLCustomCalendar.WeeksInYear(AYear: Integer): Integer;
var
  wd: Integer;
begin
  if IsLeapYear(AYear) then
    Result := 366 else
    Result := 365;
  wd := AdjustForWeekStart(DayOfWeek(EncodeDate(AYear, 1, 1))); //get 1st day
  if wd > 4 then
    Dec(Result, wd)     //belongs to prev so deduct
  else
    Inc(Result, 7 - wd);    //add whole week to this year
  wd := AdjustForWeekStart(DayOfWeek(EncodeDate(AYear, 12, 31)));//get last day
  if wd > 3 then
    Inc(Result, 7 - wd)  //add whole week to this year
  else
    Dec(Result, wd);      //belongs to prev so deduct
  Result := Result div 7;    //get weeks in year
  if Result = 51 then Result := 52;
end;

function TODVCLCustomCalendar.WeekToMonth(AWeek: Integer): Integer;
var
  ix: Integer;
begin
  Result := AWeek * 7;       //convert to days
  for ix := 1 to FDisplayMonth-1 do
    Dec(Result, DaysInMonth(ix, FDisplayYear));
  if Result < 1 then Result := 1;
end;

function TODVCLCustomCalendar.MonthToWeek(AMonth: Integer): Integer;
var
  ix, dw: Integer;
begin
  Result := 0;
  for ix := 1 to FDisplayMonth-1 do
    Inc(Result, DaysInMonth(ix, FDisplayYear));
  dw := AdjustForWeekStart(DayOfWeek(EncodeDate(FDisplayYear, 1, 1)));
  if dw > 4 then    //month starts in last week of last year
    Dec(Result, 7 - dw)
  else  //so remove those days
    Inc(Result, dw - 1);  //else last days of last year fall under 1st week
  Result := (Result div 7) + 1;
  if not FStartOnMonday and (DayOfWeek(EncodeDate(FDisplayYear, AMonth, 1)) = 7) then
    Dec(Result);
end;
{
function TODVCLCustomCalendar.GetDisplayWeek: Integer;
begin
  Result := MonthToWeek(DisplayMonth);
end;

procedure TODVCLCustomCalendar.SetDisplayWeek(Value: Integer);
var
  tw: Integer;
begin
  tw := WeeksInYear(FDisplayYear);
  if Value < 1 then Value := 1
  else if Value > tw then Value := tw;
  SetDisplayMonth(WeekToMonth(Value));
end;
{
procedure TODVCLCustomCalendar.DoHeaderPopup(Sender: TObject);
var
  yr, mo, dy: Word;
begin
  with Sender as TPopupMenu do
  begin
    DecodeDate(Date, yr, mo, dy);
    Items[0].Enabled := (FDisplayMonth <> mo) or (FDisplayYear <> yr);
    Items[FDisplayMonth + 1].Checked := True;
  end;
end;
}
procedure TODVCLCustomCalendar.SetDayColor(Value: TColor);
begin
  if FDayColor <> Value then
  begin
    FDayColor := Value;
    SetupMonth;
  end;
end;

procedure TODVCLCustomCalendar.SetTODVCLayColor(Value: TColor);
begin
  if FTODVCLayColor <> Value then
  begin
    FTODVCLayColor := Value;
    SetupMonth;
  end;
end;

procedure TODVCLCustomCalendar.SetRangeColor(Value: TColor);
begin
  if FRangeColor <> Value then
  begin
    FRangeColor := Value;
    SetupMonth;
  end;
end;

procedure TODVCLCustomCalendar.SetWeekColor(Value: TColor);
begin
  if FWeekColor <> Value then
  begin
    FWeekColor := Value;
    SetupMonth;
  end;
end;

function TODVCLCustomCalendar.GetTitleFont: TFont;
begin
  Result := FMonthBtn.Font;
end;

procedure TODVCLCustomCalendar.SetTitleFont(Value: TFont);
begin
  FMonthBtn.Font.Assign(Value);
  FYearBtn.Font.Assign(Value);
end;

function TODVCLCustomCalendar.GetStartFont: TFont;
begin
  Result := FStartPanel.Font;
end;

procedure TODVCLCustomCalendar.SetStartFont(Value: TFont);
begin
  FStartPanel.Font.Assign(Value);
end;

function TODVCLCustomCalendar.GetFinishFont: TFont;
begin
  Result := FFinishPanel.Font;
end;

procedure TODVCLCustomCalendar.SetFinishFont(Value: TFont);
begin
  FFinishPanel.Font.Assign(Value);
end;

function TODVCLCustomCalendar.GetBevelEdge: TPanelBevel;
begin
  Result := BevelOuter;
end;

procedure TODVCLCustomCalendar.SetBevelEdge(Value: TPanelBevel);
begin
  if BevelOuter <> Value then
  begin
    BevelOuter := Value;
    Resize;
  end;
end;

function TODVCLCustomCalendar.GetShowStatus: Boolean;
begin
  Result := FFooterPanel.Height > 0;
end;

procedure TODVCLCustomCalendar.SetShowStatus(Value: Boolean);
begin
  if ShowStatus <> Value then
  begin
    if Value then
      if FSingleDate then
        FFooterPanel.Height := 19
      else
        FFooterPanel.Height := 38
    else
      FFooterPanel.Height := 0;
    Resize;
  end;
end;

procedure TODVCLCustomCalendar.SetShowCurrent(Value: Boolean);
var
  yr, mo, dy: Word;
begin
  if Value and not FShowCurrent then
  begin
    DecodeDate(Date, yr, mo, dy);
    FDisplayYear := yr;
    FDisplayMonth := mo;
    SetupMonth;
  end;
  FShowCurrent := Value;
end;
procedure TODVCLCustomCalendar.SetSingleDate(Value: Boolean);
begin
  if FSingleDate <> Value then
  begin
    FSingleDate := Value;
    FMonthBtn.Visible := not FSingleDate;
    FYearBtn.Visible := not FSingleDate;
    if GetShowStatus then
      if FSingleDate then
      begin
        FFinishPanel.Height := 0;
        FFooterPanel.Height := 19;
        FFinishDate := FStartDate;
      end
      else
      begin
        FFinishPanel.Height := 19;
        FFooterPanel.Height := 38;
      end;
    FStartDate := 0;
    SetStartDate(FFinishDate);    //update caption
    if not FSingleDate then
      SetFinishDate(FFinishDate);
    Resize;
    SetupMonth;
  end;
end;

procedure TODVCLCustomCalendar.SetStartOnMonday(Value: Boolean);
begin
  if FStartOnMonday <> Value then
  begin
    FStartOnMonday := Value;
    SetupMonth;
  end;
end;

procedure TODVCLCustomCalendar.ShowCtrl(Control: TControl; ToShow: Boolean);
begin
  with Control do
  begin
    Visible := ToShow;
    if Visible then
      ControlStyle := ControlStyle - [csNoDesignVisible]
    else
      ControlStyle := ControlStyle + [csNoDesignVisible];
  end;
end;

function TODVCLCustomCalendar.GetShowYearBtns: Boolean;
begin
  Result := FPrevYearBtn.Visible;
end;

procedure TODVCLCustomCalendar.SetShowYearBtns(Value: Boolean);
begin
  ShowCtrl(FPrevYearBtn, Value);
  ShowCtrl(FNextYearBtn, Value);
end;

function TODVCLCustomCalendar.GetShowTimeBtns: Boolean;
begin
  Result := FStartTimePicker.ShowButtons;
end;

procedure TODVCLCustomCalendar.SetShowTimeBtns(Value: Boolean);
begin
  FStartTimePicker.ShowButtons := Value;
  FFinishTimePicker.ShowButtons := Value;
  Resize;
end;

procedure TODVCLCustomCalendar.SetShowWeeks(Value: Boolean);
begin
  FShowWeeks := Value;
  Resize;
end;

function TODVCLCustomCalendar.GetUseTime: Boolean;
begin
  Result := FStartTimePicker.Visible;
end;

procedure TODVCLCustomCalendar.SetUseTime(Value: Boolean);
begin
  ShowCtrl(FStartTimePicker, Value);
  ShowCtrl(FFinishTimePicker, Value);
  Resize;
end;

function TODVCLCustomCalendar.GetPrevYearGlyph: TBitmap;
begin
  Result := FPrevYearBtn.Glyph;
end;

procedure TODVCLCustomCalendar.SetPrevYearGlyph(Value: TBitmap);
begin
  with FPrevYearBtn do
  begin
    Glyph := Value;
    if Glyph.Empty then
      Caption := '<<'
    else
      Caption := '';
  end;
end;

function TODVCLCustomCalendar.GetNextYearGlyph: TBitmap;
begin
  Result := FNextYearBtn.Glyph;
end;

procedure TODVCLCustomCalendar.SetNextYearGlyph(Value: TBitmap);
begin
  with FNextYearBtn do
  begin
    Glyph := Value;
    if Glyph.Empty then
      Caption := '>>'
    else
      Caption := '';
  end;
end;

function TODVCLCustomCalendar.GetPrevMonthGlyph: TBitmap;
begin
  Result := FPrevMonthBtn.Glyph;
end;

procedure TODVCLCustomCalendar.SetPrevMonthGlyph(Value: TBitmap);
begin
  with FPrevMonthBtn do
  begin
    Glyph := Value;
    if Glyph.Empty then
      Caption := '<'
    else
      Caption := '';
  end;
end;

function TODVCLCustomCalendar.GetNextMonthGlyph: TBitmap;
begin
  Result := FNextMonthBtn.Glyph;
end;

procedure TODVCLCustomCalendar.SetNextMonthGlyph(Value: TBitmap);
begin
  with FNextMonthBtn do
  begin
    Glyph := Value;
    if Glyph.Empty then
      Caption := '>'
    else
      Caption := '';
  end;
end;

procedure TODVCLCustomCalendar.Resize;
var
  aDayHeight, aDayWidth, aHeaderHeight, aWeekWidth,
    ir, ic: Integer;
begin
  inherited Resize;
  if FResizing then Exit;
  aHeaderHeight := Height div 14;
  aDayHeight := (FGridPanel.Height - aHeaderHeight) div 6;
  aHeaderHeight := FGridPanel.Height - (aDayHeight * 6);
  if FShowWeeks then
  begin
    aDayWidth := FGridPanel.Width div 8;
    aWeekWidth := FGridPanel.Width - (aDayWidth * 7);  //take up extra width in week col
  end
  else
  begin
    aDayWidth := FGridPanel.Width div 7;
    FResizing := True;
    Width := Width - FGridPanel.Width + (aDayWidth * 7);  //adjust width so that day col widths equal
    FResizing := False;
    aWeekWidth := 0;
  end;
  with FHeadings[0] do
  begin      //week header
    Height := aHeaderHeight;
    Width := aWeekWidth;
  end;
  for ic := 1 to 7 do             //day headers
    with FHeadings[ic] do
    begin
      Height := aHeaderHeight;
      Width := aDayWidth;
      Left := aDayWidth * ic + (aWeekWidth - aDayWidth);
    end;
  for ir := 0 to 5 do             //week items
    with FWeeks[ir] do
    begin
      Height := aDayHeight;
      Width := aWeekWidth;
      Top := aHeaderHeight + (aDayHeight * ir);
    end;
  for ir := 0 to 5 do             //day items
    for ic := 0 to 6 do
      with FDays[ir, ic] do
      begin
        Height := aDayHeight;
        Width := aDayWidth;
        Left := aWeekWidth + (aDayWidth * ic);
        Top := aHeaderHeight + (aDayHeight * ir);
      end;
  FNextYearBtn.Left := FHeaderPanel.Width - FNextYearBtn.Width - 2;
  FNextMonthBtn.Left := FNextYearBtn.Left - FNextMonthBtn.Width;
  if FPlain then ic := 0 else ic := 3;
  FStartTimePicker.Left := FStartPanel.Width - FStartTimePicker.Width + ic;
  FFinishTimePicker.Left := FStartTimePicker.Left;
  ResetTitleBtns;
end;

procedure TODVCLCustomCalendar.ResetTitleBtns;
var
  wf: Single;
  wi: Integer;
begin
  wi := FNextMonthBtn.Left - 2 - FMonthBtn.Left;
  wf := wi /(Length(FMonthBtn.Caption) + Length(FYearBtn.Caption));
{}if Length(FMonthBtn.Caption) > 3 then
    wf := wf * 0.9
  else
    wf := wf * 1.1;
  FMonthBtn.Width := Round(Length(FMonthBtn.Caption) * wf);
  FYearBtn.Left := FMonthBtn.Left + FMonthBtn.Width;
  FYearBtn.Width := wi - FMonthBtn.Width;
end;

procedure TODVCLCustomCalendar.WMMove(var Msg: TWMMove);
begin
  inherited;
  if csDesigning in ComponentState then
    FGridPanel.Refresh;
end;

function TODVCLCustomCalendar.GetAbout: string;
begin
  Result := 'Version ' + ODVCLCalendarVersion;
end;

procedure TODVCLCustomCalendar.SetAbout(Value: string);
begin
  {do nothing}
end;

initialization
  Fmt := TFormatSettings.Create;
finalization
//  FreeAndNil(Fmt);
end.

