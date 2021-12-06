object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 656
  ClientWidth = 1194
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pgc1: TPageControl
    Left = 0
    Top = 0
    Width = 1194
    Height = 656
    ActivePage = ts1
    Align = alClient
    TabOrder = 0
    object ts1: TTabSheet
      Caption = 'Tempo dos programadores'
      object pnl2: TPanel
        Left = 0
        Top = 0
        Width = 1186
        Height = 628
        Align = alClient
        Color = clSilver
        ParentBackground = False
        TabOrder = 0
        object pnl3: TPanel
          Left = 1
          Top = 1
          Width = 1184
          Height = 338
          Align = alTop
          BiDiMode = bdRightToLeft
          ParentBiDiMode = False
          TabOrder = 3
          VerticalAlignment = taAlignTop
          object lblDevDesenvolvimento: TLabel
            Left = 208
            Top = 104
            Width = 96
            Height = 13
            Caption = 'DESENVOLVIMENTO'
          end
          object lbl11: TLabel
            Left = 17
            Top = 19
            Width = 57
            Height = 13
            Caption = 'ID Relat'#243'rio'
          end
          object lbl15: TLabel
            Left = 208
            Top = 19
            Width = 50
            Height = 13
            Caption = 'Express'#227'o'
          end
          object lbl12: TLabel
            Left = 758
            Top = 104
            Width = 58
            Height = 13
            Caption = 'QUALIDADE'
          end
          object lstDevDesenvi: TListBox
            Left = 67
            Top = 123
            Width = 385
            Height = 198
            BiDiMode = bdLeftToRight
            ItemHeight = 13
            ParentBiDiMode = False
            TabOrder = 0
          end
          object chk1: TCheckBox
            Left = 1040
            Top = 233
            Width = 121
            Height = 25
            Caption = 'Agrupar por E-mail'
            TabOrder = 1
          end
          object mmoDevURL: TMemo
            Left = 264
            Top = 16
            Width = 753
            Height = 64
            BiDiMode = bdRightToLeftNoAlign
            Lines.Strings = (
              'project = MILLEN AND issuetype = Bug AND resolved >= -3d')
            ParentBiDiMode = False
            ScrollBars = ssVertical
            TabOrder = 2
          end
          object btnDevCarregarURL: TButton
            Left = 1040
            Top = 19
            Width = 121
            Height = 37
            Caption = 'Carregar express'#227'o'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
            OnClick = btnDevCarregarURLClick
          end
          object edtDevdFiltro: TEdit
            Left = 80
            Top = 16
            Width = 122
            Height = 21
            BiDiMode = bdLeftToRight
            ParentBiDiMode = False
            TabOrder = 4
            Text = '27060'
          end
          object btnDevCarregarEmails: TButton
            Left = 1040
            Top = 270
            Width = 121
            Height = 37
            Caption = 'Carregar E-mails'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
            OnClick = btnDevCarregarEmailsClick
          end
          object lstQualidade: TListBox
            Left = 592
            Top = 123
            Width = 385
            Height = 198
            BiDiMode = bdLeftToRight
            ItemHeight = 13
            ParentBiDiMode = False
            TabOrder = 6
          end
          object btn4: TButton
            Left = 488
            Top = 179
            Width = 75
            Height = 25
            Caption = '<<'
            TabOrder = 7
            OnClick = btn4Click
          end
          object btn5: TButton
            Left = 488
            Top = 233
            Width = 75
            Height = 25
            Caption = '>>'
            TabOrder = 8
            OnClick = btn5Click
          end
        end
        object pnl4: TPanel
          Left = 1
          Top = 352
          Width = 1184
          Height = 275
          Align = alBottom
          TabOrder = 2
          VerticalAlignment = taAlignBottom
          object mmoDevResultado: TMemo
            Left = 67
            Top = 16
            Width = 910
            Height = 224
            Lines.Strings = (
              '')
            ScrollBars = ssVertical
            TabOrder = 0
          end
          object mmoDevLog: TMemo
            Left = 1040
            Top = 16
            Width = 121
            Height = 121
            Color = clScrollBar
            Lines.Strings = (
              '')
            TabOrder = 1
            Visible = False
          end
        end
        object pbDev: TProgressBar
          Left = 53
          Top = 598
          Width = 925
          Height = 25
          TabOrder = 0
        end
        object btnDevCarregarRelatorio: TButton
          Left = 1041
          Top = 582
          Width = 121
          Height = 43
          Caption = 'CARREGAR DADOS'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = btnDevCarregarRelatorioClick
        end
        object btn6: TButton
          Left = 1041
          Top = 519
          Width = 121
          Height = 43
          Caption = 'Exibir Log'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          OnClick = btn6Click
        end
      end
    end
    object ts2: TTabSheet
      Caption = 'Tempo por prioridade'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 1464
      ExplicitHeight = 617
      object pnl1: TPanel
        Left = 0
        Top = 0
        Width = 1186
        Height = 628
        Align = alClient
        Color = clSilver
        ParentBackground = False
        TabOrder = 0
        ExplicitWidth = 1464
        ExplicitHeight = 617
        object lbl1: TLabel
          Left = 24
          Top = 19
          Width = 61
          Height = 13
          Caption = 'ID Relat'#243'rio:'
        end
        object lbl2: TLabel
          Left = 426
          Top = 123
          Width = 123
          Height = 13
          Caption = 'Tempo m'#233'dio de entrega:'
        end
        object lbl3: TLabel
          Left = 97
          Top = 123
          Width = 128
          Height = 13
          Caption = 'Quantidade de Pendencias'
        end
        object lbl4_relatorio: TLabel
          Left = 24
          Top = 54
          Width = 43
          Height = 13
          Caption = 'Relat'#243'rio'
        end
        object lbl4: TLabel
          Left = 24
          Top = 83
          Width = 23
          Height = 13
          Caption = 'URL:'
        end
        object lbl5_url: TLabel
          Left = 24
          Top = 307
          Width = 23
          Height = 13
          Caption = 'URL:'
        end
        object lbl5: TLabel
          Left = 73
          Top = 145
          Width = 12
          Height = 13
          Caption = 'P0'
        end
        object lbl6: TLabel
          Left = 73
          Top = 177
          Width = 12
          Height = 13
          Caption = 'P1'
        end
        object lbl7: TLabel
          Left = 73
          Top = 209
          Width = 12
          Height = 13
          Caption = 'P2'
        end
        object lbl8: TLabel
          Left = 73
          Top = 241
          Width = 12
          Height = 13
          Caption = 'P3'
        end
        object lbl9: TLabel
          Left = 470
          Top = 19
          Width = 24
          Height = 13
          Caption = 'Dias:'
        end
        object lbl10: TLabel
          Left = 61
          Top = 268
          Width = 24
          Height = 13
          Caption = 'Total'
        end
        object btn1: TButton
          Left = 864
          Top = 510
          Width = 75
          Height = 25
          Caption = 'Processar'
          TabOrder = 0
          OnClick = btn1Click
        end
        object edt1_relatorio: TEdit
          Left = 91
          Top = 16
          Width = 54
          Height = 21
          TabOrder = 1
          Text = '21770'
        end
        object edtP0_Tempo: TEdit
          Left = 418
          Top = 142
          Width = 295
          Height = 21
          ReadOnly = True
          TabOrder = 2
        end
        object edtP0_qtd: TEdit
          Left = 91
          Top = 142
          Width = 295
          Height = 21
          ReadOnly = True
          TabOrder = 3
        end
        object pb1_progress: TProgressBar
          Left = 16
          Top = 510
          Width = 825
          Height = 17
          TabOrder = 4
        end
        object edt1_url: TEdit
          Left = 53
          Top = 80
          Width = 809
          Height = 21
          TabOrder = 5
          Text = 'project = MILLEN AND issuetype = Bug AND status = Done'
        end
        object mmo1: TMemo
          Left = 53
          Top = 307
          Width = 820
          Height = 150
          Lines.Strings = (
            '')
          TabOrder = 6
        end
        object edtP1_qtd: TEdit
          Left = 91
          Top = 174
          Width = 295
          Height = 21
          ReadOnly = True
          TabOrder = 7
        end
        object edtP2_qtd: TEdit
          Left = 91
          Top = 206
          Width = 295
          Height = 21
          ReadOnly = True
          TabOrder = 8
        end
        object edtP3_qtd: TEdit
          Left = 91
          Top = 238
          Width = 295
          Height = 21
          ReadOnly = True
          TabOrder = 9
        end
        object edtP1_Tempo: TEdit
          Left = 418
          Top = 174
          Width = 295
          Height = 21
          ReadOnly = True
          TabOrder = 10
        end
        object edtP2_Tempo: TEdit
          Left = 418
          Top = 206
          Width = 295
          Height = 21
          ReadOnly = True
          TabOrder = 11
        end
        object edtP3_Tempo: TEdit
          Left = 418
          Top = 238
          Width = 295
          Height = 21
          ReadOnly = True
          TabOrder = 12
        end
        object chkP0: TCheckBox
          Left = 264
          Top = 18
          Width = 42
          Height = 17
          Caption = 'P0'
          TabOrder = 13
          OnClick = chkP0Click
        end
        object chkP1: TCheckBox
          Left = 312
          Top = 18
          Width = 33
          Height = 17
          Caption = 'P1'
          TabOrder = 14
          OnClick = chkP1Click
        end
        object chkP2: TCheckBox
          Left = 367
          Top = 18
          Width = 34
          Height = 17
          Caption = 'P2'
          TabOrder = 15
          OnClick = chkP2Click
        end
        object chkP3: TCheckBox
          Left = 415
          Top = 18
          Width = 34
          Height = 17
          Caption = 'P3'
          TabOrder = 16
          OnClick = chkP3Click
        end
        object edtDias: TEdit
          Left = 500
          Top = 16
          Width = 121
          Height = 21
          TabOrder = 17
          Text = '30'
          OnExit = edtDiasExit
        end
        object edtMediaTotal: TEdit
          Left = 418
          Top = 265
          Width = 295
          Height = 21
          ReadOnly = True
          TabOrder = 18
        end
        object edtQtdTotal: TEdit
          Left = 91
          Top = 265
          Width = 295
          Height = 21
          ReadOnly = True
          TabOrder = 19
        end
        object btn2: TButton
          Left = 151
          Top = 14
          Width = 75
          Height = 25
          Caption = 'Carregar URL'
          TabOrder = 20
          OnClick = btn2Click
        end
        object btn3: TButton
          Left = 868
          Top = 78
          Width = 53
          Height = 25
          Caption = 'REFLESH'
          TabOrder = 21
          OnClick = btn3Click
        end
      end
    end
  end
end
