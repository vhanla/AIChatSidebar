object ChildForm: TChildForm
  Left = 0
  Top = 0
  Caption = 'ChildForm'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  object WVWindowParent1: TWVWindowParent
    Left = 0
    Top = 0
    Width = 624
    Height = 441
    Align = alClient
    Color = clNone
    TabOrder = 0
    Browser = WVBrowser1
    ExplicitWidth = 618
    ExplicitHeight = 432
  end
  object WVBrowser1: TWVBrowser
    TargetCompatibleBrowserVersion = '95.0.1020.44'
    AllowSingleSignOnUsingOSPrimaryAccount = False
    OnAfterCreated = WVBrowser1AfterCreated
    OnNewWindowRequested = WVBrowser1NewWindowRequested
    OnWindowCloseRequested = WVBrowser1WindowCloseRequested
    Left = 144
    Top = 168
  end
end
