unit JiraLista;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,
  EcoUtils,ResUnit,JSON,UTF8,IdCoderMIME,jpeg,logfiles,RESTClient,
  EcoStatus,DateUtils,HTTPApp, ComCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    pnl1: TPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4_relatorio: TLabel;
    lbl4: TLabel;
    lbl5_url: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    lbl10: TLabel;
    btn1: TButton;
    edt1_relatorio: TEdit;
    edtP0_Tempo: TEdit;
    edtP0_qtd: TEdit;
    pb1_progress: TProgressBar;
    edt1_url: TEdit;
    mmo1: TMemo;
    edtP1_qtd: TEdit;
    edtP2_qtd: TEdit;
    edtP3_qtd: TEdit;
    edtP1_Tempo: TEdit;
    edtP2_Tempo: TEdit;
    edtP3_Tempo: TEdit;
    chkP0: TCheckBox;
    chkP1: TCheckBox;
    chkP2: TCheckBox;
    chkP3: TCheckBox;
    edtDias: TEdit;
    edtMediaTotal: TEdit;
    edtQtdTotal: TEdit;
    btn2: TButton;
    btn3: TButton;
    pnl2: TPanel;
    lbl11: TLabel;
    lbl15: TLabel;
    edtDevdFiltro: TEdit;
    pbDev: TProgressBar;
    mmoDevResultado: TMemo;
    btnDevCarregarURL: TButton;
    btnDevCarregarRelatorio: TButton;
    mmoDevURL: TMemo;
    mmoDevLog: TMemo;
    pnl4: TPanel;
    lbl16: TLabel;
    btnDevCarregarEmails: TButton;
    pnl3: TPanel;
    lstDevDesenvi: TListBox;
    lblDevDesenvolvimento: TLabel;
    chk1: TCheckBox;
    procedure btn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtDiasExit(Sender: TObject);
    procedure chkP0Click(Sender: TObject);
    procedure chkP1Click(Sender: TObject);
    procedure chkP2Click(Sender: TObject);
    procedure chkP3Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btnDevCarregarURLClick(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btnDevCarregarEmailsClick(Sender: TObject);
    procedure btnDevCarregarRelatorioClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  type
  apontamento = record
   tempo:string;
   comantario:string;
  end;

  type
  usuario = record
   email:string;
   apontamentos:array of apontamento;
  end;

  type
  dados = record
   pendencia:string;
   tempoEstimado:string;
   usuarios:array of usuario;
  end;

  type
  dadosExcel = record
   pendencia:string;
   tempoEstimado:string;
   emailDev:string;
   tempoDev:string;
   emailQual:string;
   tempoQual:string;
  end;


var
  Form1: TForm1;
  Adados:array of dados;

implementation

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
var RESTClient: TRESTClient;
    response,sres:String;
    jarr,jarr2: TJSONarray;
    I,numeroProducao,numeroProducaoP0,numeroProducaoP1,numeroProducaoP2,numeroProducaoP3: Integer;
    tempoEntregaProducao,tempoEntrega,
    tempoEntregaProducaoP0,tempoEntregaP0,
    tempoEntregaProducaoP1,tempoEntregaP1,
    tempoEntregaProducaoP2,tempoEntregaP2,
    tempoEntregaProducaoP3,tempoEntregaP3:Double;

function BuscaPascoa(ano: Word): TDate;
var
 n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12: Integer;
 mes, dia: Word;

begin

  n1  := ano mod 19;
  n2  := trunc(ano/100);
  n3  := ano mod 100;
  n4  := trunc(n2/4);
  n5  := n2 mod 4;
  n6  := trunc((n2+8)/25);
  n7  := trunc((n2-n6+1)/3);
  n8  := (19*n1+n2-n4-n7+15) mod 30;
  n9  := trunc(n3/4);
  n10 := n3 mod 4;
  n11 := (32+2*n5+2*n9-n8-n10) mod 7;
  n12 := trunc((n1+11*n8+22*n11)/451);

  mes := trunc((n8+n11-7*n12+114)/31);
  dia := (n8+n11-7*n12+114) mod 31;

  Result := IncDay(StrToDateTime(IntToStr(dia) + '/' + IntToStr(mes) + '/' + IntToStr(ano)),1);

end;
function Feriado(Data: TDateTime): string;
var
  dia, mes, ano: Word;
  pascoa, carnaval, paixao, corpus: TDate;
begin
  Result := EmptyStr;

  dia := DayOf(Data);
  mes := MonthOf(Data);

  // Feriados Fixos
  if ((dia = 1) and (mes = 1)) then
    Result := 'Ano Novo'
  else if ((dia = 21) and (mes = 4)) then
    Result := 'Tiradentes'
  else if ((dia = 1) and (mes = 5)) then
    Result := 'Dia Trabalho'
  else if ((dia = 7) and (mes = 9)) then
    Result := 'Independência'
  else if ((dia = 12) and (mes = 10)) then
    Result := 'Nossa Sra. Aparecida'
  else if ((dia = 2) and (mes = 11)) then
    Result := 'Finados'
  else if ((dia = 15) and (mes = 11)) then
    Result := 'Procl. República'
  else if ((dia = 25) and (mes = 12)) then
    Result := 'Natal';

  ano := YearOf(Data);

  // feriados móveis
  pascoa := BuscaPascoa(ano);
  carnaval := IncDay(pascoa, -47);
  paixao := IncDay(pascoa, -2);
  corpus := IncDay(pascoa, 60);

  if Data = pascoa then
    Result := 'Páscoa'
  else if Data = carnaval then
    Result := 'Carnaval'
  else if Data = paixao then
    Result := 'Paixão de Cristo'
  else if Data = corpus then
    Result := 'Corpus Christi';

  if Result = EmptyStr then
    if DayOfWeek(Data) = 1 then
      Result := 'Domingo'
    else if DayOfWeek(Data) = 7 then
      Result := 'Sábado';
end;


Function Unformatv(const value:String):String;
var x:Cardinal;
Begin
  Result := '';
  For x:=1 To Length(value) do
      If value[x] in ['0'..'9'] Then
         Result := Result + value[x]
      else
      if value[x]='-' then
        Result := Result + value[x];

End;

Function DecodeData(const data:String;Hora:Boolean=False):TDateTime;
var aux,aux1: string;
    jdx: Integer;
Begin
  jdx := Pos('T',data);
  if jdx = 0 then
   jdx := Length(data)+1;

  aux := Copy(data,1,jdx-1);
  aux := Unformat(aux);
  aux1 := Copy(data,1,jdx+1);
  aux1 := Unformat(aux1);

  Result := EncodeDate(StrToInt(copy(aux,1,4)),StrToInt(copy(aux,5,2)),StrToInt(copy(aux,7,2)));

  if Hora then
  Begin
    jdx := Pos(':',data);
    if jdx>=0 then
    Begin
      Result := Result + EncodeTime(StrToInt(Copy(data,jdx-2,2)),
                                    StrToInt(Copy(data,jdx+1,2)),
                                    StrToInt(Copy(data,jdx+4,2)),
                                    StrToInt(Copy(data,jdx+7,3)));
    End;
  End;
End;
var DataI,DataF:TDateTime;
    Contador,numeroProducaoHomologacao,numeroProducaoHomologacaoP0,
    numeroProducaoHomologacaoP1,numeroProducaoHomologacaoP2,numeroProducaoHomologacaoP3:Integer;
    fimFila,erro:Boolean;
    millen,url:string;
begin
  RESTClient := TRESTClient.Create('');
  erro:=False;
  try
    edtMediaTotal.Text := '';
    edtQtdTotal.Text := '';
    edtP0_Tempo.Text := '';
    edtP0_qtd.Text := '';
    edtP1_Tempo.Text := '';
    edtP1_qtd.Text := '';
    edtP2_Tempo.Text := '';
    edtP2_qtd.Text := '';
    edtP3_Tempo.Text := '';
    edtP3_qtd.Text := '';

    RESTClient.Headers := 'Authorization: Basic '+encoderBase64('rodrigo.porcari:51513703@Ss');
    if edt1_url.Text = '' then
      Exit;

    try
      lbl4_relatorio.Caption := 'Feito pela URL';
      lbl4_relatorio.Show;
      fimFila := false;
      numeroProducaoHomologacao := 0;
      numeroProducaoHomologacaoP0 := 0;
      numeroProducaoHomologacaoP1 := 0;
      numeroProducaoHomologacaoP2 := 0;
      numeroProducaoHomologacaoP3 := 0;
      numeroProducao := 0;
      numeroProducaoP0 := 0;
      numeroProducaoP1 := 0;
      numeroProducaoP2 := 0;
      numeroProducaoP3 := 0;
      tempoEntrega := 0;
      tempoEntregaP0 := 0;
      tempoEntregap1 := 0;
      tempoEntregaP2 := 0;
      tempoEntregaP3 := 0;
      tempoEntregaProducao := 0;
      tempoEntregaProducaoP0 := 0;
      tempoEntregaProducaoP1 := 0;
      tempoEntregaProducaoP2 := 0;
      tempoEntregaProducaoP3 := 0;
      try
        while not fimFila do
        begin
          url :=  edt1_url.Text;

          mmo1.Text := url;
          sres := RESTClient.Get('https://jira.linx.com.br/rest/api/2/search?fields=priority,customfield_10205,customfield_10119,resolutiondate,created&startAt='+IntToStr(numeroProducaoHomologacao)+'&jql='+
                                     PChar(HTTPEncode(utf8.UTF8Encode(url))));

          jarr := ParseJSON(PChar(AnsiString(utf8.UTF8ToString(sres))));
          try
            pb1_progress.Max := jarr.Field['total'].Value;

            fimFila := jarr.Field['issues'].Count=0;
            for I := 0 to jarr.Field['issues'].Count - 1 do
            begin
              pb1_progress.Position := numeroProducaoHomologacao+1;
              pb1_progress.Show;
              millen := jarr.Field['issues'].Child[i].Field['key'].Value;
              inc(numeroProducaoHomologacao);

              if (jarr.Field['issues'].Child[i].Field['fields'].Field['priority'].Field['name'].Value='P0 - Altissimo') then
                inc(numeroProducaoHomologacaoP0);

              if (jarr.Field['issues'].Child[i].Field['fields'].Field['priority'].Field['name'].Value='P1 - Alto') then
                inc(numeroProducaoHomologacaoP1);

              if (jarr.Field['issues'].Child[i].Field['fields'].Field['priority'].Field['name'].Value='P2 - Médio') then
                inc(numeroProducaoHomologacaoP2);

              if (jarr.Field['issues'].Child[i].Field['fields'].Field['priority'].Field['name'].Value='3 - Baixo') then
                inc(numeroProducaoHomologacaoP3);


              Contador := 0;
              DataI := DecodeData(jarr.Field['issues'].Child[i].Field['fields'].Field['created'].Value);
              DataF := DecodeData(jarr.Field['issues'].Child[i].Field['fields'].Field['resolutiondate'].Value);

              while (DataI <= DataF) do
              begin
                if ((DayOfWeek(DataI) <> 1) and (DayOfWeek(DataI) <> 7)) and not (Feriado(DataI) <> EmptyStr) then
                  Inc(Contador);

                DataI := DataI + 1
              end;

              if (jarr.Field['issues'].Child[i].Field['fields'].Field['customfield_10205']<>nil) and
                 (jarr.Field['issues'].Child[i].Field['fields'].Field['customfield_10205'].SelfType <> jsNull) and
                 (jarr.Field['issues'].Child[i].Field['fields'].Field['customfield_10205'].Field['value'].Value = 'Produção') then
              begin
                inc(numeroProducao);
                tempoEntregaProducao := tempoEntregaProducao+Contador;

                if (jarr.Field['issues'].Child[i].Field['fields'].Field['priority'].Field['name'].Value='P0 - Altissimo') then
                begin
                  inc(numeroProducaoP0);
                  tempoEntregaProducaoP0 := tempoEntregaProducaoP0+Contador;
                end;

                if (jarr.Field['issues'].Child[i].Field['fields'].Field['priority'].Field['name'].Value='P1 - Alto') then
                begin
                  inc(numeroProducaoP1);
                  tempoEntregaProducaoP1 := tempoEntregaProducaoP1+Contador;
                end;

                if (jarr.Field['issues'].Child[i].Field['fields'].Field['priority'].Field['name'].Value='P2 - Médio') then
                begin
                  inc(numeroProducaoP2);
                  tempoEntregaProducaoP2 := tempoEntregaProducaoP2+Contador;
                end;

                if (jarr.Field['issues'].Child[i].Field['fields'].Field['priority'].Field['name'].Value='3 - Baixo') then
                begin
                  inc(numeroProducaoP3);
                  tempoEntregaProducaoP3 := tempoEntregaProducaoP3+Contador;
                end;
              end;

              tempoEntrega := tempoEntrega+Contador;

              if (jarr.Field['issues'].Child[i].Field['fields'].Field['priority'].Field['name'].Value='P0 - Altissimo') then
              begin
                tempoEntregaP0 := tempoEntregaP0+Contador;
              end;

              if (jarr.Field['issues'].Child[i].Field['fields'].Field['priority'].Field['name'].Value='P1 - Alto') then
              begin
                tempoEntregaP1 := tempoEntregaP1+Contador;
              end;

              if (jarr.Field['issues'].Child[i].Field['fields'].Field['priority'].Field['name'].Value='P2 - Médio') then
              begin
                tempoEntregaP2 := tempoEntregaP2+Contador;
              end;

              if (jarr.Field['issues'].Child[i].Field['fields'].Field['priority'].Field['name'].Value='3 - Baixo') then
              begin
                tempoEntregaP3 := tempoEntregaP3+Contador;;
              end;
            end;
          finally
            FreeAndNil(jarr);
          end;
        end;
        edtMediaTotal.Text := 'Produção:'+VarToStr(RoundFloat(tempoEntregaProducao/numeroProducao,True,2))+' Produção/Homologação:'+VarToStr(RoundFloat(tempoEntrega/numeroProducaoHomologacao,True,2));
        edtQtdTotal.Text := 'Produção:'+VarToStr(RoundFloat(numeroProducao,True,2))+' Produção/Homologação:'+VarToStr(RoundFloat(numeroProducaoHomologacao,True,2));

        edtP0_Tempo.Text := 'Produção:'+VarToStr(RoundFloat(tempoEntregaProducaoP0/numeroProducaoP0,True,2))+' Produção/Homologação:'+VarToStr(RoundFloat(tempoEntregaP0/numeroProducaoHomologacaoP0,True,2));
        edtP0_qtd.Text := 'Produção:'+VarToStr(RoundFloat(numeroProducaoP0,True,2))+' Produção/Homologação:'+VarToStr(RoundFloat(numeroProducaoHomologacaoP0,True,2));

        edtP1_Tempo.Text := 'Produção:'+VarToStr(RoundFloat(tempoEntregaProducaoP1/numeroProducaoP1,True,2))+' Produção/Homologação:'+VarToStr(RoundFloat(tempoEntregaP1/numeroProducaoHomologacaoP1,True,2));
        edtP1_qtd.Text := 'Produção:'+VarToStr(RoundFloat(numeroProducaoP1,True,2))+' Produção/Homologação:'+VarToStr(RoundFloat(numeroProducaoHomologacaoP1,True,2));

        edtP2_Tempo.Text := 'Produção:'+VarToStr(RoundFloat(tempoEntregaProducaoP2/numeroProducaoP2,True,2))+' Produção/Homologação:'+VarToStr(RoundFloat(tempoEntregaP2/numeroProducaoHomologacaoP2,True,2));
        edtP2_qtd.Text := 'Produção:'+VarToStr(RoundFloat(numeroProducaoP2,True,2))+' Produção/Homologação:'+VarToStr(RoundFloat(numeroProducaoHomologacaoP2,True,2));

        edtP3_Tempo.Text := 'Produção:'+VarToStr(RoundFloat(tempoEntregaProducaoP3/numeroProducaoP3,True,2))+' Produção/Homologação:'+VarToStr(RoundFloat(tempoEntregaP3/numeroProducaoHomologacaoP3,True,2));
        edtP3_qtd.Text := 'Produção:'+VarToStr(RoundFloat(numeroProducaoP3,True,2))+' Produção/Homologação:'+VarToStr(RoundFloat(numeroProducaoHomologacaoP3,True,2));
      except
        edtMediaTotal.Text := '';
        edtQtdTotal.Text := '';
        edtP0_Tempo.Text := '';
        edtP0_qtd.Text := '';
        edtP1_Tempo.Text := '';
        edtP1_qtd.Text := '';
        edtP2_Tempo.Text := '';
        edtP2_qtd.Text := '';
        edtP3_Tempo.Text := '';
        edtP3_qtd.Text := '';
        erro:=true;
      end;
    finally
      FreeAndNil(jarr);
      FreeAndNil(jarr2);
    end;
  finally
    FreeAndNil(RESTClient);
  end;

  if erro then
    ShowMessage('ERRO')
  else
    ShowMessage('SUCESSO');

  pb1_progress.Position := 0;
  pb1_progress.Show;
end;

procedure TForm1.chkP0Click(Sender: TObject);
var url:string;
begin
   edt1_url.Text := StringReplace(edt1_url.Text,' AND priority in (','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P0 - Altissimo",','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P0 - Altissimo")','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P1 - Alto",','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P1 - Alto")','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P2 - Médio",','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P2 - Médio")','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P3 - Baixo",','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P3 - Baixo")','',[rfReplaceAll]);
   if chkP0.Checked or
      chkP1.Checked or
      chkP2.Checked or
      chkP3.Checked  then
   begin
     url := ' AND priority in (';

     if chkP0.Checked then
       url := url+ '"P0 - Altissimo",';
     if chkP1.Checked then
       url := url+ '"P1 - Alto",';
     if chkP2.Checked then
       url := url+ '"P2 - Médio",';
     if chkP3.Checked then
       url := url+ '"P3 - Baixo",';

     SetLength(url,length(url)-1);
     edt1_url.Text := edt1_url.Text+url+ ')';
   end;
end;

procedure TForm1.chkP1Click(Sender: TObject);
var url:string;
begin
   edt1_url.Text := StringReplace(edt1_url.Text,' AND priority in (','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P0 - Altissimo",','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P0 - Altissimo")','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P1 - Alto",','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P1 - Alto")','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P2 - Médio",','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P2 - Médio")','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P3 - Baixo",','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P3 - Baixo")','',[rfReplaceAll]);
   if chkP0.Checked or
      chkP1.Checked or
      chkP2.Checked or
      chkP3.Checked  then
   begin
     url := ' AND priority in (';

     if chkP0.Checked then
       url := url+ '"P0 - Altissimo",';
     if chkP1.Checked then
       url := url+ '"P1 - Alto",';
     if chkP2.Checked then
       url := url+ '"P2 - Médio",';
     if chkP3.Checked then
       url := url+ '"P3 - Baixo",';

     SetLength(url,length(url)-1);
     edt1_url.Text := edt1_url.Text+url+ ')';
   end;
end;

procedure TForm1.chkP2Click(Sender: TObject);
var url:string;
begin
   edt1_url.Text := StringReplace(edt1_url.Text,' AND priority in (','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P0 - Altissimo",','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P0 - Altissimo")','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P1 - Alto",','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P1 - Alto")','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P2 - Médio",','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P2 - Médio")','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P3 - Baixo",','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P3 - Baixo")','',[rfReplaceAll]);
   if chkP0.Checked or
      chkP1.Checked or
      chkP2.Checked or
      chkP3.Checked  then
   begin
     url := ' AND priority in (';

     if chkP0.Checked then
       url := url+ '"P0 - Altissimo",';
     if chkP1.Checked then
       url := url+ '"P1 - Alto",';
     if chkP2.Checked then
       url := url+ '"P2 - Médio",';
     if chkP3.Checked then
       url := url+ '"P3 - Baixo",';

     SetLength(url,length(url)-1);
     edt1_url.Text := edt1_url.Text+url+ ')';
   end;
end;

procedure TForm1.chkP3Click(Sender: TObject);
var url:string;
begin
   edt1_url.Text := StringReplace(edt1_url.Text,' AND priority in (','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P0 - Altissimo",','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P0 - Altissimo")','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P1 - Alto",','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P1 - Alto")','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P2 - Médio",','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P2 - Médio")','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P3 - Baixo",','',[rfReplaceAll]);
   edt1_url.Text := StringReplace(edt1_url.Text,'"P3 - Baixo")','',[rfReplaceAll]);

   if chkP0.Checked or
      chkP1.Checked or
      chkP2.Checked or
      chkP3.Checked  then
   begin
     url := ' AND priority in (';

     if chkP0.Checked then
       url := url+ '"P0 - Altissimo",';
     if chkP1.Checked then
       url := url+ '"P1 - Alto",';
     if chkP2.Checked then
       url := url+ '"P2 - Médio",';
     if chkP3.Checked then
       url := url+ '"P3 - Baixo",';

     SetLength(url,length(url)-1);
     edt1_url.Text := edt1_url.Text+url+ ')';
   end;
end;


procedure TForm1.btn2Click(Sender: TObject);
var RESTClient: TRESTClient;
    sres:String;
    jarr2: TJSONarray;
begin
  if edt1_relatorio.Text = '' then
    Exit;

  lbl4_relatorio.Caption := '';
  pb1_progress.Min := 0;
  pb1_progress.Max := 3;
  RESTClient := TRESTClient.Create('');
  try
    pb1_progress.Position := 1;
    pb1_progress.Show;

    RESTClient.Headers := 'Authorization: Basic '+encoderBase64('rodrigo.porcari:51513703@Ss');
    sres := RESTClient.Get(PChar('https://jira.linx.com.br/rest/api/2/filter/'+edt1_relatorio.Text));

    pb1_progress.Position := 2;
    pb1_progress.Refresh;

    jarr2 := ParseJSON(PChar(AnsiString(utf8.UTF8ToString(sres))));
    try
      lbl4_relatorio.Caption := VarToStr(jarr2.Field['name'].Value);
      lbl4_relatorio.Show;

      edt1_url.Text := jarr2.Field['jql'].Value;
    finally
      FreeAndNil(jarr2);
    end;
    pb1_progress.Position := 3;
    pb1_progress.Refresh;
  finally
    FreeAndNil(RESTClient);
  end;

  pb1_progress.Position := 0;
  pb1_progress.Refresh;
end;

procedure TForm1.btnDevCarregarURLClick(Sender: TObject);
var RESTClient: TRESTClient;
    sres:String;
    jarr2: TJSONarray;
begin
  if edt1_relatorio.Text = '' then
    Exit;

  pbDev.Min := 0;
  pbDev.Max := 3;
  RESTClient := TRESTClient.Create('');
  try
    pbDev.Position := 1;
    pbDev.Show;

    RESTClient.Headers := 'Authorization: Basic '+encoderBase64('rodrigo.porcari:51513703@Ss');
    sres := RESTClient.Get(PChar('https://jira.linx.com.br/rest/api/2/filter/'+edtDevdFiltro.Text));

    pbDev.Position := 2;
    pbDev.Refresh;

    jarr2 := ParseJSON(PChar(AnsiString(utf8.UTF8ToString(sres))));
    try
      mmoDevURL.Text := jarr2.Field['jql'].Value;
    finally
      FreeAndNil(jarr2);
    end;
    pbDev.Position := 3;
    pbDev.Refresh;
  finally
    FreeAndNil(RESTClient);
  end;

  pbDev.Position := 0;
  pbDev.Refresh;
end;

procedure TForm1.btn3Click(Sender: TObject);
begin
  edt1_url.Text := 'project = MILLEN AND issuetype = Bug AND status = Done';
  chkP0.Checked := False;
  chkP1.Checked := False;
  chkP2.Checked := False;
  chkP3.Checked := False;
  lbl4_relatorio.Caption := '';

end;

procedure TForm1.edtDiasExit(Sender: TObject);
var url:string;
    posi,posf:Integer;
begin
   url := edt1_url.Text;
   posi :=  pos(' AND resolved >= -',url);
   if posi>0 then
   begin
     posf :=  pos('d ',url)+10-posi;
     url := copy(url,posi,posf);
     url := edt1_url.Text;
     edt1_url.Text := StringReplace(url,copy(url,posi,posf),'',[rfReplaceAll]);
   end;  

   if edtDias.Text<>''  then
   begin
     edt1_url.Text := edt1_url.Text+' AND resolved >= -'+edtDias.Text+'d ';
   end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  lbl4_relatorio.Caption := '';
end;

procedure TForm1.btnDevCarregarEmailsClick(Sender: TObject);
var RESTClient: TRESTClient;
    sres:String;
    jarr: TJSONarray;
    i,x,z,numeroPag,PosDados,PosUsuario,indexList:Integer;
    fimFila,erro:Boolean;
    url:string;

begin
  RESTClient := TRESTClient.Create('');
  try

    RESTClient.Headers := 'Authorization: Basic '+encoderBase64('rodrigo.porcari:51513703@Ss');
    if mmoDevURL.Text = '' then
      Exit;

    fimFila := false;
    numeroPag := 0;
    pbDev.Max := 0;
    mmoDevLog.Text := '';

    lstDevDesenvi.Items.Clear;
    try
      while not fimFila do
      begin
        url := 'https://jira.linx.com.br/rest/api/2/search?expand=changelog&fields=priority,timeoriginalestimate,timeestimate,worklog,customfield_10205,customfield_10119,resolutiondate,created&startAt='+IntToStr(numeroPag)+'&jql='+
               PChar(HTTPEncode(utf8.UTF8Encode(mmoDevURL.Text)));

        mmoDevLog.Text := mmoDevLog.Text+url+#13#10;
        sres := RESTClient.Get(url);
        mmoDevLog.Text := mmoDevLog.Text+sres+#13#10;
        jarr := ParseJSON(PChar(AnsiString(utf8.UTF8ToString(sres))));
        try
          if pbDev.Max = 0 then          
            pbDev.Max := jarr.Field['total'].Value;

          fimFila := jarr.Field['issues'].Count=0;
          for i := 0 to jarr.Field['issues'].Count - 1 do
          begin
            pbDev.Position := numeroPag+1;
            pbDev.Refresh;


            SetLength(Adados,Length(Adados)+1);
            PosDados := length(Adados)-1;

            Adados[PosDados].pendencia := jarr.Field['issues'].Child[i].Field['key'].Value;

            if jarr.Field['issues'].Child[i].Field['fields'].Field['timeestimate'].SelfType = jsNull then
              Adados[PosDados].tempoEstimado := '0'
            else
              Adados[PosDados].tempoEstimado := VarToStr((VarToFloat(jarr.Field['issues'].Child[i].Field['fields'].Field['timeoriginalestimate'].Value)/60)/60);

            for x := 0 to jarr.Field['issues'].Child[i].Field['fields'].Field['worklog'].Field['worklogs'].Count - 1 do
            begin

              PosUsuario := MaxInt;
              for z := 0 to Length(Adados[PosDados].usuarios) - 1 do
              begin
                if Adados[PosDados].usuarios[z].email=jarr.Field['issues'].Child[i].Field['fields'].Field['worklog'].Field['worklogs'].Child[x].Field['author'].Field['emailAddress'].Value then
                begin
                  PosUsuario := z;
                  Break;
                end;
              end;

              if PosUsuario=MaxInt then
              begin
                SetLength(Adados[PosDados].usuarios,Length(Adados[PosDados].usuarios)+1);
                PosUsuario := length(Adados[PosDados].usuarios)-1;
                SetLength(Adados[PosDados].usuarios[PosUsuario].apontamentos,Length(Adados[PosDados].usuarios[PosUsuario].apontamentos)+1);
                Adados[PosDados].usuarios[PosUsuario].email := jarr.Field['issues'].Child[i].Field['fields'].Field['worklog'].Field['worklogs'].Child[x].Field['author'].Field['emailAddress'].Value;

                indexList := MaxInt;
                for z := 0 to lstDevDesenvi.Items.Count - 1 do
                begin
                  if lstDevDesenvi.Items[z]=Adados[PosDados].usuarios[PosUsuario].email then
                  begin
                    indexList := z;
                    Break;
                  end;
                end;


                if indexList=MaxInt then
                begin
                  lstDevDesenvi.Items.Add(Adados[PosDados].usuarios[PosUsuario].email);
                end;
              end;

              Adados[PosDados].usuarios[PosUsuario].apontamentos[0].tempo := VarToStr(((VarToFloat(jarr.Field['issues'].Child[i].Field['fields'].Field['worklog'].Field['worklogs'].Child[x].Field['timeSpentSeconds'].Value)/60)/60)+
                                                                                                 VarToFloat(Adados[PosDados].usuarios[PosUsuario].apontamentos[0].tempo));
              Adados[PosDados].usuarios[PosUsuario].apontamentos[0].comantario := '';
            end;

            inc(numeroPag);
          end;
        finally
          FreeAndNil(jarr);
        end;
      end;
    except
      on e: Exception do
      begin
        erro:=true;
        mmoDevResultado.Text := e.Message;
      end;
    end;
  finally
    FreeAndNil(RESTClient);
  end;

  if erro then
    ShowMessage('ERRO')
  else
    ShowMessage('SUCESSO');

  pbDev.Position := 0;
  pbDev.Show;
end;

procedure TForm1.btnDevCarregarRelatorioClick(Sender: TObject);
var i,x,z:Integer;
    millen,resultAux,resultAux2,resultAux3:string;
    isDev:Boolean;
    AdadosExcel:array of dadosExcel;
begin

  for I := 0 to length(Adados) - 1 do
  begin
    setlength(AdadosExcel,Length(AdadosExcel)+1);

    AdadosExcel[Length(AdadosExcel)-1].pendencia := Adados[i].pendencia;
    AdadosExcel[Length(AdadosExcel)-1].tempoEstimado := Adados[i].tempoEstimado;


    resultAux2 := resultAux;
    for x := 0 to length(Adados[i].usuarios) - 1 do
    begin
      if (x>0) and not chk1.Checked then
      begin
        setlength(AdadosExcel,Length(AdadosExcel)+1);

        AdadosExcel[Length(AdadosExcel)-1].pendencia := Adados[i].pendencia;
        AdadosExcel[Length(AdadosExcel)-1].tempoEstimado := Adados[i].tempoEstimado;
      end;


      isDev := False;
      for z := 0 to lstDevDesenvi.Items.Count - 1 do
      begin
        if (lstDevDesenvi.Selected[z]) and (lstDevDesenvi.Items[z]=Adados[i].usuarios[x].email) then
        begin
          isDev := True;
          Break;
        end;
      end;

      if isDev or not chk1.Checked then
      begin
        AdadosExcel[Length(AdadosExcel)-1].emailDev := AdadosExcel[Length(AdadosExcel)-1].emailDev+' '+Adados[i].usuarios[x].email;
        for z := 0 to length(Adados[i].usuarios[x].apontamentos) - 1 do
        begin
          AdadosExcel[Length(AdadosExcel)-1].tempoDev := VarToStr(VarToFloat(AdadosExcel[Length(AdadosExcel)-1].tempoDev) +VarToFloat(Adados[i].usuarios[x].apontamentos[z].tempo));
        end;
      end
      else
      begin
        AdadosExcel[Length(AdadosExcel)-1].emailQual := Adados[i].usuarios[x].email;
        for z := 0 to length(Adados[i].usuarios[x].apontamentos) - 1 do
        begin
          AdadosExcel[Length(AdadosExcel)-1].tempoQual := VarToStr(VarToFloat(AdadosExcel[Length(AdadosExcel)-1].tempoQual) +VarToFloat(Adados[i].usuarios[x].apontamentos[z].tempo));
        end;
      end;
    end;
  end;
  mmoDevResultado.Text := '';
  millen := 'key';
  millen := millen+';'+'timeoriginalestimate';
  millen := millen+';'+'e-mail';
  millen := millen+';'+'comment';
  millen := millen+';'+'timeSpent';
  if chk1.Checked then
  begin
    millen := 'key';
    millen := millen+';'+'timeoriginalestimate';
    millen := millen+';'+'e-mail Dev';
    millen := millen+';'+'comment';
    millen := millen+';'+'timeSpent';
    millen := millen+';'+'e-mail Qual';
    millen := millen+';'+'comment';
    millen := millen+';'+'timeSpent';
  end;

  millen := millen+#13#10;
  for I := 0 to length(AdadosExcel) - 1 do
  begin
    millen := millen+AdadosExcel[i].pendencia;
    millen := millen+';'+AdadosExcel[i].tempoEstimado;
    millen := millen+';'+AdadosExcel[i].emailDev;
    millen := millen+';'+'';
    millen := millen+';'+AdadosExcel[i].tempoDev;
    if chk1.Checked then
    begin
      millen := millen+';'+AdadosExcel[i].emailQual;
      millen := millen+';'+'';
      millen := millen+';'+AdadosExcel[i].tempoQual;
    end;
    millen := millen+#13#10;
  end;
  mmoDevResultado.Text := millen;
end;

end.
