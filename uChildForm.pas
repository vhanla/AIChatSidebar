unit uChildForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uWVBrowser, uWVWinControl, uWVWindowParent, uWVTypes, uWVTypeLibrary,
  uWVBrowserBase, uWVCoreWebView2Args, uWVCoreWebView2Deferral;

type
  TChildForm = class(TForm)
    WVWindowParent1: TWVWindowParent;
    WVBrowser1: TWVBrowser;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);

    procedure WVBrowser1AfterCreated(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure WVBrowser1WindowCloseRequested(Sender: TObject);
    procedure WVBrowser1NewWindowRequested(Sender: TObject;
      const aWebView: ICoreWebView2;
      const aArgs: ICoreWebView2NewWindowRequestedEventArgs);

  private
    FArgs     : TCoreWebView2NewWindowRequestedEventArgs;
    FDeferral : TCoreWebView2Deferral;

  public
    constructor Create(AOwner: TComponent; const aArgs : ICoreWebView2NewWindowRequestedEventArgs); reintroduce;
  end;

var
  ChildForm: TChildForm;

implementation

{$R *.dfm}

uses
  uWVCoreWebView2WindowFeatures;

constructor TChildForm.Create(AOwner: TComponent; const aArgs : ICoreWebView2NewWindowRequestedEventArgs);
begin
  inherited Create(AOwner);

  FArgs     := TCoreWebView2NewWindowRequestedEventArgs.Create(aArgs);
  FDeferral := TCoreWebView2Deferral.Create(FArgs.Deferral);
end;

procedure TChildForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TChildForm.FormDestroy(Sender: TObject);
begin
  if assigned(FDeferral) then
    FreeAndNil(FDeferral);

  if assigned(FArgs) then
    FreeAndNil(FArgs);
end;

procedure TChildForm.FormShow(Sender: TObject);
var
  TempWindowFeatures : TCoreWebView2WindowFeatures;
begin
  TempWindowFeatures := nil;

  if assigned(FArgs) then
    try
      TempWindowFeatures := TCoreWebView2WindowFeatures.Create(FArgs.WindowFeatures);

      if TempWindowFeatures.HasPosition then
        begin
          WVBrowser1.SetFormLeftTo(TempWindowFeatures.Left);
          WVBrowser1.SetFormTopTo(TempWindowFeatures.Top);
        end;

      if TempWindowFeatures.HasSize then
        begin
          WVBrowser1.ResizeFormWidthTo(TempWindowFeatures.width);
          WVBrowser1.ResizeFormHeightTo(TempWindowFeatures.height);
        end;
    finally
      if assigned(TempWindowFeatures) then
        FreeAndNil(TempWindowFeatures);
    end;
//    WVBrowser1.UserAgent := 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36 Edg/116.0.0.0';
  WVBrowser1.CreateBrowser(WVWindowParent1.Handle);

end;

procedure TChildForm.WVBrowser1AfterCreated(Sender: TObject);
begin
  if assigned(FArgs) and assigned(FDeferral) then
    try
      FArgs.NewWindow := WVBrowser1.CoreWebView2.BaseIntf;
      FArgs.Handled   := True;

      FDeferral.Complete;
    finally
      FreeAndNil(FDeferral);
      FreeAndNil(FArgs);
    end;

  WVWindowParent1.UpdateSize;
end;

procedure TChildForm.WVBrowser1NewWindowRequested(Sender: TObject;
  const aWebView: ICoreWebView2;
  const aArgs: ICoreWebView2NewWindowRequestedEventArgs);
var
  TempChildForm : TChildForm;
begin
  TempChildForm := TChildForm.Create(Self, aArgs);
  TempChildForm.Show;
end;

procedure TChildForm.WVBrowser1WindowCloseRequested(Sender: TObject);
begin
  PostMessage(Handle, WM_CLOSE, 0, 0);
end;

end.
