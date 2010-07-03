unit GMailSMTP;

interface

uses mimemess, mimepart, smtpsend, ssl_openssl,classes, sysutils,controls;

const
  {$REGION '���������'}
    GmailHost = 'smtp.gmail.com';
     GmailPort = 587;
 {$ENDREGION}

type
  TGMailSMTP = class(TComponent)
  private
    FPort      : integer;    //����
    FLogin     : string;  //����� ��� smtp-�������
    FPassword  : string; //������
    FEmail     : string;     //�������� ���� � �������� ������������ ������
    FFromName  : string; //�� ����� ����� ������������ ������
    FHost      : string; //���� (smtp-������)
    FFiles     : TStrings; //������������� �����
    FRecipients: TStrings;//����������
    FMsg       : TMimeMess;
    FMIMEPart  : TMimePart;
    procedure SetFiles(Value: TStrings);
    procedure SetRecepients(Value: TStrings);
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    function AddText(const aText: string):boolean;
    function AddHTML(const aHTML: string):boolean;
    function SendMessage(const aSubject:string; aClear:boolean=true):boolean;
    procedure Clear;
    //��� ������ c ��������� Synapse
    property GMessage:TMimeMess read FMsg write FMsg;
    property MIMEPart:TMimePart read FMIMEPart write FMIMEPart;
  published
    property Login: string read FLogin write FLogin;
    property Password: string read FPassword write FPassword;
    property Host: string read FHost write FHost;
    property FromEmail: string read FEmail write FEmail;
    property FromName: string read FFromName write FFromName;
    property Port: integer read FPort write FPort;
    property AttachFiles: TStrings read FFiles write SetFiles;
    property Recipients: TStrings read FRecipients write SetRecepients;
end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('WebDelphi.ru',[TGMailSMTP]);
end;

{ TGMailSMTP }

function TGMailSMTP.AddHTML(const aHTML: string): boolean;
var s:TStringList;
begin
Result:=false;
try
  S:=TStringList.Create;
  S.Text:=aHTML;
  FMsg.AddPartHTML(S, FMIMEPart);
  Result:=true;
finally
  S.Free;
end;
end;

function TGMailSMTP.AddText(const aText: string): boolean;
var s:TStringList;
begin
Result:=false;
try
  S:=TStringList.Create;
  S.Text:=aText;
  FMsg.AddPartText(S, FMIMEPart);
  Result:=true;
finally
  S.Free;
end;
end;

procedure TGMailSMTP.Clear;
begin
  FMsg.Clear;
  FMIMEPart.Clear;
  FFiles.Clear;
  FRecipients.Clear;
end;

constructor TGMailSMTP.Create(AOwner: TComponent);
begin
  inherited;
  FFiles:=TStringList.Create;
  FRecipients:=TStringList.Create;
  FMsg:=TMimeMess.Create;
  FMIMEPart:=FMsg.AddPartMultipart('alternate',nil);
  FHost:=GmailHost;
  FPort:=GmailPort;
end;

destructor TGMailSMTP.Destroy;
begin
  FFiles.Free;
  FRecipients.Free;
  inherited;
end;

function TGMailSMTP.SendMessage(const aSubject: string; aClear:boolean): boolean;
var i:integer;
    MailTo: string;
    MailFrom: string;
begin
try
  if Length(Trim(FFromName))>0 then
    MailFrom:='"'+FFromName+'" <'+FEmail+'>'
  else
    MailFrom:=FEmail;
  //��������� ���������
  FMsg.Header.Subject:=aSubject;
  FMsg.Header.From:=MailFrom;
  FMsg.Header.ToList.Assign(FRecipients);
  //��������� �����
  for i:=0 to FFiles.Count - 1 do
     FMsg.AddPartBinaryFromFile(FFiles[i],FMIMEPart);
  MailTo:='';
  for I := 0 to FRecipients.Count-1 do
    MailTo:=MailTo+FRecipients[i]+',';

  FMsg.EncodeMessage;
  if FPort=0 then
    smtpsend.SendToRaw(MailFrom, MailTo, FHost, FMsg.Lines, FLogin, FPassword)
  else
    smtpsend.SendToRaw(MailFrom, MailTo, FHost+':'+IntToStr(FPort), FMsg.Lines, FLogin, FPassword);
  if aClear then
    Clear;
  Result:=true;
except
  Result:=false;
  Exception.Create('������ �������� ������');
end;
end;

procedure TGMailSMTP.SetFiles(Value: TStrings);
begin
  FFiles.Assign(Value)
end;

procedure TGMailSMTP.SetRecepients(Value: TStrings);
begin
  FRecipients.Assign(Value);
end;

end.
