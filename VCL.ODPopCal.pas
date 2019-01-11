{
  Copyright (c) 1998-2015
  Orbital Decisions:- My Power Station Technology (Pty) Ltd
  P.O.Box 1080, Milnerton 7435, South Africa
  components@mypowerstation.biz
  http://www.orbital.co.za/text/prodlist.htm

  Use at your own risk!
}
unit VCL.ODPopCal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, VCL.ODCalend;

type
  TODVCLCalendarForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure btnClearClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    FCalendar: TODVCLCalendar;
    FOnDayDblClick: TODVCLDateEvent;
    procedure Change(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure DayDblClick(Sender: TObject; ADate: TDateTime);
    property Calendar: TODVCLCalendar read FCalendar write FCalendar;
    property OnDayDblClick: TODVCLDateEvent read FOnDayDblClick write FOnDayDblClick;
  end;

  TODVCLCalendarDialog = class(TComponent)
  private
    FForm: TODVCLCalendarForm;
    FMonthNames: TODVCLMonthNames;
    FHeaders: TODVCLCalendarHeaders;
    FCaption, FDateFormat: string;
    FDialogHeight, FDialogWidth: Integer;
    FStartDate, FFinishDate: TDateTime;
    FDisplayYear, FDisplayMonth{, FDisplayWeek}: Integer;
    FDayColor, FTodayColor, FRangeColor, FWeekColor: TColor;
    FTitleFont, FStartFont, FFinishFont, FDateFont: TFont;
    FPrevYearGlyph, FNextYearGlyph, FPrevMonthGlyph, FNextMonthGlyph: TBitmap;
    FAutoPage, FSingleDate, FShowStatus, FShowYearBtns, FStartOnMonday,
      FPlain, FUseTime, FShowTimeBtns, FShowCurrent, FShowWeeks: Boolean;
    FBevelEdge: TPanelBevel;
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
//  procedure SetDisplayWeek(Value: Integer);
    procedure SetTitleFont(Value: TFont);
    procedure SetStartFont(Value: TFont);
    procedure SetFinishFont(Value: TFont);
    procedure SetDateFont(Value: TFont);
    procedure SetPrevYearGlyph(Value: TBitmap);
    procedure SetNextYearGlyph(Value: TBitmap);
    procedure SetPrevMonthGlyph(Value: TBitmap);
    procedure SetNextMonthGlyph(Value: TBitmap);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;
    function DaysInMonth(AMonth, AYear: Integer): Integer;
    function WeeksInYear(AYear: Integer): Integer;
    function WeekToMonth(AWeek: Integer): Integer;
    function MonthToWeek(AMonth: Integer): Integer;
    property StartDate: TDateTime read FStartDate write FStartDate;
    property FinishDate: TDateTime read FFinishDate write FFinishDate;
    property DisplayDate: TDateTime read GetDisplayDate write SetDisplayDate;
  published
    property About: string read GetAbout write SetAbout stored False;
    property Caption: string read FCaption write FCaption;
    property DialogHeight: Integer read FDialogHeight write FDialogHeight default 250;
    property DialogWidth: Integer read FDialogWidth write FDialogWidth default 240;
    property DisplayYear: Integer read FDisplayYear write SetDisplayYear;
    property DisplayMonth: Integer read FDisplayMonth write SetDisplayMonth;
//  property DisplayWeek: Integer read FDisplayWeek write SetDisplayWeek;
    property DayColor: TColor read FDayColor write FDayColor default clWindow;
    property TodayColor: TColor read FTodayColor write FTodayColor default clBlue;
    property RangeColor: TColor read FRangeColor write FRangeColor default clAqua;
    property WeekColor: TColor read FWeekColor write FWeekColor default clWhite;
    property TitleFont: TFont read FTitleFont write SetTitleFont;
    property StartFont: TFont read FStartFont write SetStartFont;
    property FinishFont: TFont read FFinishFont write SetFinishFont;
    property DateFont: TFont read FDateFont write SetDateFont;
    property PrevYearGlyph: TBitmap read FPrevYearGlyph write SetPrevYearGlyph;
    property NextYearGlyph: TBitmap read FNextYearGlyph write SetNextYearGlyph;
    property PrevMonthGlyph: TBitmap read FPrevMonthGlyph write SetPrevMonthGlyph;
    property NextMonthGlyph: TBitmap read FNextMonthGlyph write SetNextMonthGlyph;
    property DateFormat: string read FDateFormat write FDateFormat;
    property MonthNames: TODVCLMonthNames read FMonthNames write FMonthNames;
    property Headers: TODVCLCalendarHeaders read FHeaders write FHeaders;
    property BevelEdge: TPanelBevel read FBevelEdge write FBevelEdge default bvRaised;
    property SingleDate: Boolean read FSingleDate write FSingleDate default False;
    property ShowCurrent: Boolean read FShowCurrent write FShowCurrent default True;
    property ShowStatus: Boolean read FShowStatus write FShowStatus default True;
    property ShowYearBtns: Boolean read FShowYearBtns write FShowYearBtns default True;
    property ShowTimeBtns: Boolean read FShowTimeBtns write FShowTimeBtns default True;
    property ShowWeeks: Boolean read FShowWeeks write FShowWeeks default True;
    property AutoPage: Boolean read FAutoPage write FAutoPage default True;
    property Plain: Boolean read FPlain write FPlain default False;
    property StartOnMonday: Boolean read FStartOnMonday write FStartOnMonday default False;
    property UseTime: Boolean read FUseTime write FUseTime default False;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnDayDblClick: TODVCLDateEvent read FOnDayDblClick write FOnDayDblClick;
    property OnStartClick: TODVCLSelectDateEvent read FOnStartClick write FOnStartClick;
    property OnFinishClick: TODVCLSelectDateEvent read FOnFinishClick write FOnFinishClick;
    property OnSelectYear: TODVCLSelectYearEvent read FOnSelectYear write FOnSelectYear;
    property OnSetupDay: TODVCLSetupDayEvent read FOnSetupDay write FOnSetupDay;
  end;

  TODVCLPopupButton = class(TSpeedButton)
  private
    procedure CMDesignHitTest(var Msg: TCMDesignHitTest); message CM_DESIGNHITTEST;
  end;

  TODVCLPopupCalendar = class(TCustomPanel)
  private
    FMonthNames: TODVCLMonthNames;
    FHeaders: TODVCLCalendarHeaders;
    FDateFormat, FSeperator, FPopupCaption, FTimeFormat: string;
    FStartDate, FFinishDate: TDateTime;
    FDisplayYear, FDisplayMonth{, FDisplayWeek}: Integer;
    FDayColor, FTodayColor, FRangeColor, FWeekColor: TColor;
    FTitleFont, FStartFont, FFinishFont, FDateFont: TFont;
    FPrevYearGlyph, FNextYearGlyph, FPrevMonthGlyph, FNextMonthGlyph: TBitmap;
    FAutoPage, FSingleDate, FShowStatus, FShowYearBtns, FStartOnMonday,
      FPlain, FUseTime, FShowTimeBtns, FShowCurrent, FShowWeeks: Boolean;
    FBevelEdge: TPanelBevel;
    FPopupHeight, FPopupWidth: Integer;
    FOnDayDblClick: TODVCLDateEvent;
    FOnStartClick, FOnFinishClick: TODVCLSelectDateEvent;
    FOnSelectYear: TODVCLSelectYearEvent;
    FOnSetupDay: TODVCLSetupDayEvent;
    FOnChange, FOnPopup: TNotifyEvent;
    function GetAbout: string;
    procedure SetAbout(Value: string);
    function GetDisplayDate: TDateTime;
    procedure SetDisplayDate(Value: TDateTime);
    procedure SetDisplayYear(Value: Integer);
    procedure SetDisplayMonth(Value: Integer);
//  procedure SetDisplayWeek(Value: Integer);
    procedure SetTitleFont(Value: TFont);
    procedure SetStartFont(Value: TFont);
    procedure SetFinishFont(Value: TFont);
    procedure SetDateFont(Value: TFont);
    function GetText: string;
    function GetGlyph: TBitmap;
    procedure SetGlyph(Value: TBitmap);
    procedure SetPrevYearGlyph(Value: TBitmap);
    procedure SetNextYearGlyph(Value: TBitmap);
    procedure SetPrevMonthGlyph(Value: TBitmap);
    procedure SetNextMonthGlyph(Value: TBitmap);
    procedure SetStartDate(Value: TDateTime);
    procedure SetFinishDate(Value: TDateTime);
    procedure SetSingleDate(Value: Boolean);
    procedure SetDateFormat(const Value: string);
    procedure SetSeperator(const Value: string);
    procedure SetUseTime(Value: Boolean);
    procedure ReadStartDate(Reader: TReader);
    procedure WriteStartDate(Writer: TWriter);
    procedure ReadFinishDate(Reader: TReader);
    procedure WriteFinishDate(Writer: TWriter);
  protected
    FForm: TODVCLCalendarForm;
    FText: TEdit;
    FLabel: TLabel;
    FButton: TSpeedButton;
    StoreDates: Boolean;
    procedure SetEnabled(Value: Boolean);
    procedure DefineProperties(Filer: TFiler); override;
    procedure Resize; override;
    procedure DoEnter; override;
    procedure Change(Sender: TObject); virtual;
    procedure StartClick(Sender: TObject; var ADate: TDateTime); virtual;
    procedure FinishClick(Sender: TObject; var ADate: TDateTime); virtual;
    procedure SelectYear(Sender: TObject; Year: Integer;
      var YearStart, YearFinish: TDateTime); virtual;
    procedure SetupDay(Sender: TObject; ADate: TDateTime;
      var AColor: TColor; var AHint: string); virtual;
    procedure SetText;
    procedure ButtonClick(Sender: TObject); virtual;
    procedure TextChange(Sender: TObject);
    procedure SetOnMouseDown(Value: TMouseEvent);
    procedure SetOnMouseUp(Value: TMouseEvent);
    function GetOnMouseDown: TMouseEvent;
    function GetOnMouseUp: TMouseEvent;
    function GetEnabled: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Clear;  // Added By AG 2000/07/11 - See proc for more info.
    function DaysInMonth(AMonth, AYear: Integer): Integer;
    function WeeksInYear(AYear: Integer): Integer;
    function WeekToMonth(AWeek: Integer): Integer;
    function MonthToWeek(AMonth: Integer): Integer;
    property StartDate: TDateTime read FStartDate write SetStartDate;
    property FinishDate: TDateTime read FFinishDate write SetFinishDate;
    property DisplayDate: TDateTime read GetDisplayDate write SetDisplayDate;
    property Text: string read GetText;
  published
    property About: string read GetAbout write SetAbout stored False;
    property DateFormat: string read FDateFormat write SetDateFormat;
    property Seperator: string read FSeperator write SetSeperator;
    property PopupCaption: string read FPopupCaption write FPopupCaption;
    property PopupHeight: Integer read FPopupHeight write FPopupHeight default 250;
    property PopupWidth: Integer read FPopupWidth write FPopupWidth default 240;
    property DisplayYear: Integer read FDisplayYear write SetDisplayYear;
    property DisplayMonth: Integer read FDisplayMonth write SetDisplayMonth;
//  property DisplayWeek: Integer read FDisplayWeek write SetDisplayWeek;
    property DayColor: TColor read FDayColor write FDayColor default clWindow;
    property TodayColor: TColor read FTodayColor write FTodayColor default clBlue;
    property RangeColor: TColor read FRangeColor write FRangeColor default clAqua;
    property WeekColor: TColor read FWeekColor write FWeekColor default clWhite;
    property TitleFont: TFont read FTitleFont write SetTitleFont;
    property StartFont: TFont read FStartFont write SetStartFont;
    property FinishFont: TFont read FFinishFont write SetFinishFont;
    property DateFont: TFont read FDateFont write SetDateFont;
    property MonthNames: TODVCLMonthNames read FMonthNames write FMonthNames;
    property Headers: TODVCLCalendarHeaders read FHeaders write FHeaders;
    property BevelEdge: TPanelBevel read FBevelEdge write FBevelEdge default bvRaised;
    property Plain: Boolean read FPlain write FPlain default False;
    property SingleDate: Boolean read FSingleDate write SetSingleDate default False;
    property ShowCurrent: Boolean read FShowCurrent write FShowCurrent default True;
    property ShowStatus: Boolean read FShowStatus write FShowStatus default True;
    property ShowYearBtns: Boolean read FShowYearBtns write FShowYearBtns default True;
    property ShowTimeBtns: Boolean read FShowTimeBtns write FShowTimeBtns default True;
    property ShowWeeks: Boolean read FShowWeeks write FShowWeeks default True;
    property StartOnMonday: Boolean read FStartOnMonday write FStartOnMonday default False;
    property AutoPage: Boolean read FAutoPage write FAutoPage default True;
    property Enabled: Boolean read GetEnabled write SetEnabled default True;
    property Glyph: TBitmap read GetGlyph write SetGlyph;
    property PrevYearGlyph: TBitmap read FPrevYearGlyph write SetPrevYearGlyph;
    property NextYearGlyph: TBitmap read FNextYearGlyph write SetNextYearGlyph;
    property PrevMonthGlyph: TBitmap read FPrevMonthGlyph write SetPrevMonthGlyph;
    property NextMonthGlyph: TBitmap read FNextMonthGlyph write SetNextMonthGlyph;
    property UseTime: Boolean read FUseTime write SetUseTime default False;
    property TimeFormat: string read FTimeFormat write FTimeFormat;
    property Color;
    property Font;
    property ParentColor;
//  property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnDayDblClick: TODVCLDateEvent read FOnDayDblClick write FOnDayDblClick;
    property OnStartClick: TODVCLSelectDateEvent read FOnStartClick write FOnStartClick;
    property OnFinishClick: TODVCLSelectDateEvent read FOnFinishClick write FOnFinishClick;
    property OnSelectYear: TODVCLSelectYearEvent read FOnSelectYear write FOnSelectYear;
    property OnSetupDay: TODVCLSetupDayEvent read FOnSetupDay write FOnSetupDay;
    property OnPopup: TNotifyEvent read FOnPopup write FOnPopup;
    property OnMouseDown: TMouseEvent read GetOnMouseDown write SetOnMouseDown; // AG 00/07/11
    property OnMouseUp: TMouseEvent read GetOnMouseUp write SetOnMouseUp;       // AG 00/07/11
    property OnEnter;
    property OnExit;
    property OnResize;
  end;




implementation

{$R *.DFM}


//TODVCLCalendarForm

constructor TODVCLCalendarForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCalendar := TODVCLCalendar.Create(Self);
  with FCalendar do
  begin
    Parent := Self;
    Align := alClient;
    OnChange := Change;
    OnDayDblClick := DayDblClick;
  end;
end;

procedure TODVCLCalendarForm.Change(Sender: TObject);
begin
  OKBtn.Enabled := FCalendar.FinishDate > 0;
end;

procedure TODVCLCalendarForm.DayDblClick(Sender: TObject; ADate: TDateTime);
begin
  if Assigned(FOnDayDblClick) then
    FOnDayDblClick(Owner, ADate);
  if FCalendar.SingleDate then
    ModalResult := mrOK;
end;

procedure TODVCLCalendarForm.OKBtnClick(Sender: TObject);
begin

end;

//TODVCLCalendarDialog

constructor TODVCLCalendarDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if not (csDesigning in ComponentState) then
    FForm := TODVCLCalendarForm.Create(Application);
  FMonthNames := TODVCLMonthNames.Create;
  FHeaders := TODVCLCalendarHeaders.Create;
  FTitleFont := TFont.Create;
  FStartFont := TFont.Create;
  FFinishFont := TFont.Create;
  FDateFont := TFont.Create;
  FPrevYearGlyph := TBitmap.Create;
  FNextYearGlyph := TBitmap.Create;
  FPrevMonthGlyph := TBitmap.Create;
  FNextMonthGlyph := TBitmap.Create;
  FDialogHeight := 250;
  FDialogWidth := 240;
  FCaption := 'Select Date Range';
  FDateFormat := 'dddd, mmm d, yyyy';
  FDayColor := clWindow;
  FTodayColor := clBlue;
  FRangeColor := clAqua;
  FWeekColor := clWhite;
  FBevelEdge := bvRaised;
  FShowStatus := True;
  FShowCurrent := True;
  FShowYearBtns := True;
  FShowTimeBtns := True;
  FShowWeeks := True;
  FAutoPage := True;
  SetDisplayDate(Date);
end;

destructor TODVCLCalendarDialog.Destroy;
begin
  FHeaders.Free;
  FMonthNames.Free;
  FTitleFont.Free;
  FStartFont.Free;
  FFinishFont.Free;
  FDateFont.Free;
  FPrevYearGlyph.Free;
  FNextYearGlyph.Free;
  FPrevMonthGlyph.Free;
  FNextMonthGlyph.Free;
  inherited Destroy;
end;

function TODVCLCalendarDialog.Execute: Boolean;
begin
  with FForm.Calendar do
  begin
    MonthNames.Assign(FMonthNames);
    Headers.Assign(FHeaders);
    OnStartClick := FOnStartClick;
    OnFinishClick := FOnFinishClick;
    OnSelectYear := FOnSelectYear;
    OnSetupDay := FOnSetupDay;
    DayColor := FDayColor;
    TodayColor := FTodayColor;
    RangeColor := FRangeColor;
    WeekColor := FWeekColor;
    TitleFont := FTitleFont;
    StartFont := FStartFont;
    FinishFont := FFinishFont;
    DateFont := FDateFont;
    PrevYearGlyph := FPrevYearGlyph;
    NextYearGlyph := FNextYearGlyph;
    PrevMonthGlyph := FPrevMonthGlyph;
    NextMonthGlyph := FNextMonthGlyph;
    BevelEdge := FBevelEdge;
    Plain := FPlain;
    SingleDate := FSingleDate;
    ShowCurrent := FShowCurrent;
    ShowStatus := FShowStatus;
    ShowYearBtns := FShowYearBtns;
    ShowTimeBtns := FShowTimeBtns;
    ShowWeeks := FShowWeeks;
    StartOnMonday := FStartOnMonday;
    AutoPage := FAutoPage;
    DateFormat := FDateFormat;
    DisplayYear := FDisplayYear;
    DisplayMonth := FDisplayMonth;
//  DisplayWeek := FDisplayWeek;
    UseTime := FUseTime;
    if StartDate > 0 then
      DisplayDate := StartDate
    else if ShowCurrent then
      DisplayDate := Date;
    StartDate := FStartDate;
    if not FSingleDate then
      Finishdate := FFinishDate;
  end;
  with FForm do
  begin
{   OnStartChange := FOnStartChange;
    OnFinishChange := FOnFinishChange;}
    OnChange := FOnChange;
    OnDayDblClick := FOnDayDblClick;
    Caption := FCaption;
    Height := FDialogHeight;
    Width := FDialogWidth;
    Result := ShowModal = ID_OK;
    if Result then
    begin
      FStartDate := Calendar.StartDate;
      FFinishDate := Calendar.FinishDate;
    end
    else
    begin
      Calendar.StartDate := FStartDate;
      Calendar.FinishDate := FFinishDate;
    end;
  end;
end;

function TODVCLCalendarDialog.DaysInMonth(AMonth, AYear: Integer): Integer;
begin
  Result := FForm.Calendar.DaysInMonth(AMonth, AYear);
end;

function TODVCLCalendarDialog.WeeksInYear(AYear: Integer): Integer;
begin
  Result := FForm.Calendar.WeeksInYear(AYear);
end;

function TODVCLCalendarDialog.WeekToMonth(AWeek: Integer): Integer;
begin
  Result := FForm.Calendar.WeekToMonth(AWeek);
end;

function TODVCLCalendarDialog.MonthToWeek(AMonth: Integer): Integer;
begin
  Result := FForm.Calendar.MonthToWeek(AMonth);
end;

function TODVCLCalendarDialog.GetDisplayDate: TDateTime;
begin
  Result := EncodeDate(FDisplayYear, FDisplayMonth, 1);
end;

procedure TODVCLCalendarDialog.SetDisplayDate(Value: TDateTime);
var
  yr, mo, dy: Word;
begin
  DecodeDate(Value, yr, mo, dy);
  FDisplayYear := yr;
  FDisplayMonth := mo;
  FShowCurrent := False;
end;

procedure TODVCLCalendarDialog.SetDisplayYear(Value: Integer);
begin
  if Value < 1900 then FDisplayYear := 1900
  else if Value > 2100 then FDisplayYear := 2100
  else FDisplayYear := Value;
  FShowCurrent := False;
end;

procedure TODVCLCalendarDialog.SetDisplayMonth(Value: Integer);
begin
  if Value < 1 then FDisplayMonth := 1
  else if Value > 12 then FDisplayMonth := 12
  else FDisplayMonth := Value;
  FShowCurrent := False;
end;
{
procedure TODVCLCalendarDialog.SetDisplayWeek(Value: Integer);
var
  tw: Integer;
begin
  tw := FCalendar.WeeksInYear(FDisplayYear);
  if Value < 1 then Value := 1
  else if Value > tw then Value := tw;
  FDisplayMonth := FForm.Calendar.WeekToMonth(Value);
  FShowCurrent := False;
end;
}
procedure TODVCLCalendarDialog.SetTitleFont(Value: TFont);
begin
  FTitleFont.Assign(Value);
end;

procedure TODVCLCalendarDialog.SetStartFont(Value: TFont);
begin
  FStartFont.Assign(Value);
end;

procedure TODVCLCalendarDialog.SetFinishFont(Value: TFont);
begin
  FFinishFont.Assign(Value);
end;

procedure TODVCLCalendarDialog.SetDateFont(Value: TFont);
begin
  FDateFont.Assign(Value);
end;

procedure TODVCLCalendarDialog.SetPrevYearGlyph(Value: TBitmap);
begin
  FPrevYearGlyph.Assign(Value);
end;

procedure TODVCLCalendarDialog.SetNextYearGlyph(Value: TBitmap);
begin
  FNextYearGlyph.Assign(Value);
end;

procedure TODVCLCalendarDialog.SetPrevMonthGlyph(Value: TBitmap);
begin
  FPrevMonthGlyph.Assign(Value);
end;

procedure TODVCLCalendarDialog.SetNextMonthGlyph(Value: TBitmap);
begin
  FNextMonthGlyph.Assign(Value);
end;

function TODVCLCalendarDialog.GetAbout: string;
begin
  Result := 'Version ' + ODVCLCalendarVersion;
end;

procedure TODVCLCalendarDialog.SetAbout(Value: string);
begin
  {do nothing}
end;

//TODVCLPopupButton

procedure TODVCLPopupButton.CMDesignHitTest(var Msg: TCMDesignHitTest);
begin
  if Parent.CanFocus and
     PtInRect(Rect(0, 0, Width, Height), SmallPointToPoint(Msg.Pos)) then
    Msg.Result := 1;
end;

//TODVCLPopupCalendar

constructor TODVCLPopupCalendar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 320;
  Height := 21;
  BevelOuter := bvNone;
  BorderStyle := bsSingle;
  Color := clWindow;
  ControlStyle := ControlStyle - [csAcceptsControls];
  FMonthNames := TODVCLMonthNames.Create;
  FHeaders := TODVCLCalendarHeaders.Create;
  FButton := TODVCLPopupButton.Create(Self);
  with FButton do
  begin
    Parent := Self;
    Font.Style := [fsBold];
    Caption := '...';
    GroupIndex := 1;
    AllowAllUp := True;
    Layout := blGlyphTop;
    OnClick := ButtonClick;
  end;
  FText := TEdit.Create(Self);
  with FText do
  begin
    Parent := Self;
    AutoSize := False;
    ReadOnly := True;
    BorderStyle := bsNone;
    Top := 1;
    Left := 1;
    Height := 16;
    OnChange := TextChange;
  end;
  FLabel := TLabel.Create(Self);
  with FLabel do
  begin
    Parent := Self;
    Width := 1;
    Color := clBtnFace;
  end;
  Resize;
  if not (csDesigning in ComponentState) then
    FForm := TODVCLCalendarForm.Create(Self);
  FTitleFont := TFont.Create;
  FStartFont := TFont.Create;
  FFinishFont := TFont.Create;
  FDateFont := TFont.Create;
  FPrevYearGlyph := TBitmap.Create;
  FNextYearGlyph := TBitmap.Create;
  FPrevMonthGlyph := TBitmap.Create;
  FNextMonthGlyph := TBitmap.Create;
  FPopupHeight := 250;
  FPopupWidth := 240;
  FPopupCaption := 'Select Date Range';
  FDateFormat := 'dddd, mmm d, yyyy';
  FTimeFormat := 'hh:mm';
  FSeperator := ' - ';
  FDayColor := clWindow;
  FTodayColor := clBlue;
  FRangeColor := clAqua;
  FWeekColor := clWhite;
  FBevelEdge := bvRaised;
  FShowCurrent := True;
  FShowStatus := True;
  FShowYearBtns := True;
  FShowTimeBtns := True;
  FShowWeeks := True;
  FAutoPage := True;
  SetDisplayDate(Date);
  StoreDates := True;
end;

destructor TODVCLPopupCalendar.Destroy;
begin
  FHeaders.Free;
  FMonthNames.Free;
  FTitleFont.Free;
  FStartFont.Free;
  FFinishFont.Free;
  FDateFont.Free;
  FPrevYearGlyph.Free;
  FNextYearGlyph.Free;
  FPrevMonthGlyph.Free;
  FNextMonthGlyph.Free;
  inherited Destroy;
end;

procedure TODVCLPopupCalendar.Loaded;
begin
  inherited Loaded;
  Resize;
  if not FButton.Glyph.Empty then
    SetGlyph(FButton.Glyph)
end;

procedure TODVCLPopupCalendar.Clear;
begin
  // Added by Alan Givati - Clears FText EditBox and resets start+finish dates.
  // This procedure used to be called ClearEdit
  // ClearEdit only cleared the EditBox - the actual
  // start and finish dates were not being reset.
  FText.Text := '';
  SetStartDate(0);
  SetFinishDate(0);
  SetDisplayDate(Date);
end;

function TODVCLPopupCalendar.DaysInMonth(AMonth, AYear: Integer): Integer;
begin
  Result := FForm.Calendar.DaysInMonth(AMonth, AYear);
end;

function TODVCLPopupCalendar.WeeksInYear(AYear: Integer): Integer;
begin
  Result := FForm.Calendar.WeeksInYear(AYear);
end;

function TODVCLPopupCalendar.WeekToMonth(AWeek: Integer): Integer;
begin
  Result := FForm.Calendar.WeekToMonth(AWeek);
end;

function TODVCLPopupCalendar.MonthToWeek(AMonth: Integer): Integer;
begin
  Result := FForm.Calendar.MonthToWeek(AMonth);
end;

procedure TODVCLPopupCalendar.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  if StoreDates then
  begin
    Filer.DefineProperty('StartDate',
      ReadStartDate, WriteStartDate, FStartDate > 0);
    Filer.DefineProperty('FinishDate',
      ReadFinishDate, WriteFinishDate, FFinishDate > 0);
  end;
end;

procedure TODVCLPopupCalendar.ReadStartDate;
begin
  SetStartDate(Reader.ReadFloat);
end;

procedure TODVCLPopupCalendar.WriteStartDate;
begin
  Writer.WriteFloat(FStartDate);
end;

procedure TODVCLPopupCalendar.ReadFinishDate;
begin
  SetFinishDate(Reader.ReadFloat);
end;

procedure TODVCLPopupCalendar.WriteFinishDate;
begin
  Writer.WriteFloat(FFinishDate);
end;

procedure TODVCLPopupCalendar.ButtonClick(Sender: TObject);
begin
  SetFocus;
  if Assigned(FOnPopup) then FOnPopup(Self);
  if FForm = nil then
    FForm := TODVCLCalendarForm.Create(Application);
  with FForm.Calendar do
  begin
    MonthNames.Assign(FMonthNames);
    Headers.Assign(FHeaders);
    OnStartClick := StartClick;
    OnFinishClick := FinishClick;
//  OnDayDblClick := FOnDayDblClick;
    OnSelectYear := SelectYear;
    OnSetupDay := SetupDay;
    DisplayYear := FDisplayYear;
    DisplayMonth := FDisplayMonth;
//  DisplayWeek := FDisplayWeek;
    DayColor := FDayColor;
    TodayColor := FTodayColor;
    RangeColor := FRangeColor;
    WeekColor := FWeekColor;
    TitleFont := FTitleFont;
    StartFont := FStartFont;
    FinishFont := FFinishFont;
    DateFont := FDateFont;
    PrevYearGlyph := FPrevYearGlyph;
    NextYearGlyph := FNextYearGlyph;
    PrevMonthGlyph := FPrevMonthGlyph;
    NextMonthGlyph := FNextMonthGlyph;
    BevelEdge := FBevelEdge;
    Plain := FPlain;
    SingleDate := FSingleDate;
    ShowCurrent := FShowCurrent;
    ShowStatus := FShowStatus;
    ShowYearBtns := FShowYearBtns;
    ShowTimeBtns := FShowTimeBtns;
    ShowWeeks := FShowWeeks;
    StartOnMonday := FStartOnMonday;
    AutoPage := FAutoPage;
    DateFormat := FDateFormat;
    UseTime := FUseTime;
    if FStartDate > 0 then
      DisplayDate := FStartDate
    else if ShowCurrent then
      DisplayDate := Date;
    StartDate := FStartDate;
    if not FSingleDate then
      FinishDate := FFinishDate;
  end;
  with FForm do
  begin
    Height := FPopupHeight;
    Width := FPopupWidth;
    Caption := FPopupCaption;
    ShowHint := ShowHint;
    OnDayDblClick := FOnDayDblClick;
  end;
  if FForm.ShowModal = ID_OK then
  begin
    if (FStartDate <> FForm.Calendar.StartDate) or
       (FFinishDate <> FForm.Calendar.FinishDate) then
    begin
      FStartDate := FForm.Calendar.StartDate;
      FFinishDate := FForm.Calendar.FinishDate;
      SetText;
    end;
  end
  else
  begin
    FForm.Calendar.StartDate := FStartDate;
    FForm.Calendar.FinishDate := FFinishDate;
  end;
  if csDesigning in ComponentState then
  begin
    FForm.Free;
    FForm := nil;
  end;
  FButton.Down := False;
end;

procedure TODVCLPopupCalendar.TextChange(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TODVCLPopupCalendar.Resize;
begin
  inherited Resize;
  FButton.Height := Height - 4;
  FButton.Width := FButton.Height;
  FButton.Left := Width - FButton.Width - 4;
  FText.Top := (FButton.Height - FText.Height + 1) div 2;
  FText.Width := Width - FButton.Width - 6;
  FLabel.Height := FButton.Height;
  FLabel.Left := FButton.Left - 1;
end;

procedure TODVCLPopupCalendar.DoEnter;
begin
  inherited DoEnter;
  FText.SetFocus;
end;

procedure TODVCLPopupCalendar.Change(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TODVCLPopupCalendar.StartClick(Sender: TObject; var ADate: TDateTime);
begin
  if Assigned(FOnStartClick) then
    FOnStartClick(Self, ADate);
end;

procedure TODVCLPopupCalendar.FinishClick(Sender: TObject; var ADate: TDateTime);
begin
  if Assigned(FOnFinishClick) then
    FOnFinishClick(Self, ADate);
end;

procedure TODVCLPopupCalendar.SelectYear(Sender: TObject; Year: Integer;
  var YearStart, YearFinish: TDateTime);
begin
  if Assigned(FOnSelectYear) then
    FOnSelectYear(Self, Year, YearStart, YearFinish);
end;

procedure TODVCLPopupCalendar.SetupDay(Sender: TObject; ADate: TDateTime;
  var AColor: TColor; var AHint: string);
begin
  if Assigned(FOnSetupDay) then
    FOnSetupDay(Self, ADate, AColor, AHint);
end;

function TODVCLPopupCalendar.GetText: string;
begin
  Result := FText.Text;
end;

procedure TODVCLPopupCalendar.SetStartDate(Value: TDateTime);
begin
  FStartDate := Value;
  if FStartDate > FFinishDate then
    FFinishDate := FStartDate;
  SetText;
end;

procedure TODVCLPopupCalendar.SetFinishDate(Value: TDateTime);
begin
  FFinishDate := Value;
  if FFinishDate < FStartDate then
    FStartDate := FFinishDate;
  SetText;
end;

procedure TODVCLPopupCalendar.SetDateFormat(const Value: string);
begin
  FDateFormat := Value;
  if not (csLoading in ComponentState) then SetText;
end;

procedure TODVCLPopupCalendar.SetSeperator(const Value: string);
begin
  FSeperator := Value;
  if not (csLoading in ComponentState) then SetText;
end;

procedure TODVCLPopupCalendar.SetUseTime(Value: Boolean);
begin
  FUseTime := Value;
  SetText;
end;

procedure TODVCLPopupCalendar.SetText;
var
  fs: string;

begin
  if FUseTime then
    fs := FDateFormat + ' ' + FTimeFormat
  else
    fs := FDateFormat;
  if FStartDate = 0 then
    FText.Text := ''
  else if FSingleDate then
    FText.Text := FormatDateTime(fs, FStartDate)
  else
    FText.Text := FormatDateTime(fs, FStartDate) +
      FSeperator + FormatDateTime(fs, FFinishDate);
end;

procedure TODVCLPopupCalendar.SetSingleDate(Value: Boolean);
begin
  FSingleDate := Value;
  SetText;
end;

function TODVCLPopupCalendar.GetDisplayDate: TDateTime;
begin
  Result := EncodeDate(FDisplayYear, FDisplayMonth, 1);
end;

procedure TODVCLPopupCalendar.SetDisplayDate(Value: TDateTime);
var
  yr, mo, dy: Word;
begin
  DecodeDate(Value, yr, mo, dy);
  FDisplayYear := yr;
  FDisplayMonth := mo;
  FShowCurrent := False;
end;

procedure TODVCLPopupCalendar.SetDisplayYear(Value: Integer);
begin
  if Value < 1900 then FDisplayYear := 1900
  else if Value > 2100 then FDisplayYear := 2100
  else FDisplayYear := Value;
  FShowCurrent := False;
end;

procedure TODVCLPopupCalendar.SetDisplayMonth(Value: Integer);
begin
  if Value < 1 then FDisplayMonth := 1
  else if Value > 12 then FDisplayMonth := 12
  else FDisplayMonth := Value;
  FShowCurrent := False;
end;
{
procedure TODVCLPopupCalendar.SetDisplayWeek(Value: Integer);
var
  tw: Integer;
begin
  tw := FCalendar.WeeksInYear(FDisplayYear);
  if Value < 1 then Value := 1
  else if Value > tw then Value := tw;
  FDisplayMonth := FForm.Calendar.WeekToMonth(Value);
  FShowCurrent := False;
end;
}
procedure TODVCLPopupCalendar.SetTitleFont(Value: TFont);
begin
  FTitleFont.Assign(Value);
end;

procedure TODVCLPopupCalendar.SetStartFont(Value: TFont);
begin
  FStartFont.Assign(Value);
end;

procedure TODVCLPopupCalendar.SetFinishFont(Value: TFont);
begin
  FFinishFont.Assign(Value);
end;

procedure TODVCLPopupCalendar.SetDateFont(Value: TFont);
begin
  FDateFont.Assign(Value);
end;

function TODVCLPopupCalendar.GetGlyph: TBitmap;
begin
  Result := FButton.Glyph;
end;

procedure TODVCLPopupCalendar.SetGlyph(Value: TBitmap);
begin
  with FButton do
  begin
    Glyph.Assign(Value);
    if Glyph.Empty then
    begin
      Caption := '...';
      Margin := -1;
    end
    else
    begin
      Caption := '';
      Margin := 0;
      NumGlyphs := Glyph.Width div Glyph.Height;
    end;
  end;
end;

procedure TODVCLPopupCalendar.SetPrevYearGlyph(Value: TBitmap);
begin
  FPrevYearGlyph.Assign(Value);
end;

procedure TODVCLPopupCalendar.SetNextYearGlyph(Value: TBitmap);
begin
  FNextYearGlyph.Assign(Value);
end;

procedure TODVCLPopupCalendar.SetPrevMonthGlyph(Value: TBitmap);
begin
  FPrevMonthGlyph.Assign(Value);
end;

procedure TODVCLPopupCalendar.SetNextMonthGlyph(Value: TBitmap);
begin
  FNextMonthGlyph.Assign(Value);
end;

function TODVCLPopupCalendar.GetEnabled: Boolean;
begin
  Result := FButton.Enabled;
end;

procedure TODVCLPopupCalendar.SetEnabled(Value: Boolean);
begin
  FButton.Enabled := Value;
end;

// Following TWO procedures and TWO functions added by AG 2000/07/11
// ALL they do is interact with the MouseUp and MouseDown events of
// the FText (TEdit) component, as the actual component does not have
// a visible clickable area
procedure TODVCLPopupCalendar.SetOnMouseDown(Value: TMouseEvent);
begin
  FText.OnMouseDown := Value;
end;

procedure TODVCLPopupCalendar.SetOnMouseUp(Value: TMouseEvent);
begin
  FText.OnMouseUp := Value;
end;

function TODVCLPopupCalendar.GetOnMouseDown: TMouseEvent;
begin
  Result := FText.OnMouseDown;
end;

function TODVCLPopupCalendar.GetOnMouseUp: TMouseEvent;
begin
  Result := FText.OnMouseUp;
end;
// END of AG Additions

function TODVCLPopupCalendar.GetAbout: string;
begin
  Result := 'Version ' + ODVCLCalendarVersion;
end;

procedure TODVCLPopupCalendar.SetAbout(Value: string);
begin
  {do nothing}
end;


procedure TODVCLCalendarForm.btnClearClick(Sender: TObject);
begin
//  FCalendar.
end;

end.
