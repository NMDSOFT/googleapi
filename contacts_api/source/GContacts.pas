unit GContacts;

interface

uses NativeXML, strUtils, httpsend, GHelper,Classes,SysUtils,
GDataCommon,Generics.Collections,Dialogs,jpeg, Graphics, typinfo,
IOUtils;

// 1. ��������� ������������ ������� ������� �� �������
// 2. ������ ����������� �������
// 3. ������� �� TCotsct �������� ����� � ������������ ����� TOwner


const
  {$REGION '���������'}
   CpProtocolVer = '3.0';
   CpNodeAlias = 'gContact:';
   CpAtomAlias = 'atom:';
   CpRootNodeName= 'feed';
   CpGroupLink='http://www.google.com/m8/feeds/groups/%s/full';
   CpContactsLink='http://www.google.com/m8/feeds/contacts/default/full';
   CpPhotoLink = 'http://schemas.google.com/contacts/2008/rel#photo';
   CpDefoultEncoding = 'utf-8';
   CpXMLHeader = '<?xml version="1.0" encoding="UTF-8" ?>';
   CpDefaultCName = 'NoName Contact';
   CpImgRel = 'image/*';
  {$ENDREGION}

type
  TcpTagEnum = (cp_billingInformation,cp_birthday,cp_calendarLink,
  cp_directoryServer,cp_event,cp_externalId,cp_gender,
  cp_groupMembershipInfo,cp_hobby, cp_initials,
  cp_jot,cp_language,cp_maidenName,cp_mileage,cp_nickname,
  cp_occupation,cp_priority,cp_relation,cp_sensitivity,cp_shortName,
  cp_subject,cp_userDefinedField,cp_website,cp_systemGroup,cp_None);

type
  TcpBillingInformation = TTextTag;

type
  TcpBirthday =class
  private
    FYear  : word;
    FMonth : word;
    FDay   : word;
    FShortFormat: boolean;//���������� ������ ��� �������� --MM-DD
  public
    constructor Create(const byNode: TXmlNode=nil);
    destructor Destroy;override;
    function IsEmpty: boolean;
    //ToDate - ������� � ������ TDate; ���� ����� ���������� ������, ��
    //����� ����� �������
    function ToDate:TDate;
    procedure ParseXML(const Node: TXmlNode);
    function AddToXML(Root: TXMLNode):TXMLNode;
    property ShotrFormat: boolean read FShortFormat;
    property Year: word read FYear write FYear;
    property Month: word read FMonth write FMonth;
    property Day: word read FDay write FDay;
end;

type
  TcpCalendarLink = class
  private         { TODO -o� -c������� : ���������� �� ���������� ���� }
    FDescr: string;//�������� ���� �������� �������� rel ���� label
    FPrimary: boolean;
    FHref: string;
    const RelValues: array [0..2] of string = ('work','home','free-busy');
  public
    constructor Create(const byNode: TXMLNode=nil);
    procedure ParseXML(const Node: TXmlNode);
    function  AddToXML(Root:TXmlNode):TXmlNode;
    function isEmpty:boolean;
    property Description: string read FDescr write FDescr;
    property Primary: boolean read FPrimary write FPrimary;
    property Href: string read FHref write FHref;
end;

type
  TcpDirectoryServer = TTextTag;


type
  TEventRel = (teNone,teAnniversary,teOther);
  TcpEvent = class
  private
    FEventType: TEventRel;
    Flabel: string;
    FWhen: TgdWhen;
  public
    constructor Create(const byNode: TXmlNode=nil);
    procedure ParseXML(const Node: TXMLNode);
    function IsEmpty: boolean;
    function AddToXML(Root: TXmlNode):TXmlNode;
    property EventType: TEventRel read FEventType write FEventType;
    property Labl:string read Flabel write Flabel;
 end;

type
  TExternalIdType = (tiNone,tiAccount,tiCustomer,tiNetwork,tiOrganization);
  TcpExternalId = class
  private
    Frel: TExternalIdType;
    FLabel: string;
    FValue: string;
  public
    constructor Create(const ByNode: TXMLNode=nil);
    procedure ParseXML(const Node: TXmlNode);
    function IsEmpty:boolean;
    function AddToXML(Root: TXmlNode):TXmlNode;
    property Rel: TExternalIdType read Frel write FRel;
    property Labl: string read FLabel write FLabel;
    property Value: string read FValue write FValue;
end;


type
  TGenderType = (none,male,female);
  TcpGender = class
  private
    FValue: TGenderType;
  public
    constructor Create(const ByNode: TXMLNode=nil);
    function IsEmpty:boolean;
    procedure ParseXML(const Node: TXmlNode);
    function AddToXML(Root: TXmlNode):TXmlNode;
    property Value: TGenderType read FValue write FValue;
end;

type
  TcpGroupMembershipInfo = class
  private
    FDeleted: boolean;
    FHref: string;
  public
    constructor Create(const ByNode: TXMLNode=nil);
    procedure ParseXML(const Node: TXmlNode);
    function IsEmpty: boolean;
    function AddToXML(Root: TXmlNode):TXmlNode;
    property Href: string read FHref write FHref;
    property Deleted:boolean read FDeleted write FDeleted;
end;

type
  TcpHobby = TTextTag;
  TcpInitials = TTextTag;

type
  TJotRel = (TjNone,Tjhome, Tjwork, Tjother, Tjkeywords, Tjuser);
  TcpJot = class
  private
    FRel: TJotRel;
    FText: string;
  public
    constructor Create(const ByNode: TXMLNode=nil);
    procedure ParseXML(const Node: TXmlNode);
    function IsEmpty: boolean;
    function AddToXML(Root: TXmlNode):TXmlNode;
    property Rel: TJotRel read FRel write FRel;
    property Text:string read FText write FText;
end;

type
  TcpLanguage = class
  private
    Fcode: string;
    Flabel: string;
  public
    constructor Create(const ByNode: TXMLNode=nil);
    function IsEmpty: boolean;
    procedure ParseXML(const Node: TXmlNode);
    function AddToXML(Root: TXmlNode):TXmlNode;
    property Code: string read Fcode write Fcode;
    property Labl:string read Flabel write Flabel;
end;

type
  TcpMaidenName = TTextTag;
  TcpMileage = TTextTag;
  TcpNickname = TTextTag;
  TcpOccupation = TTextTag;

type
  TPriotityRel = (TpNone,Tplow,Tpnormal,Tphigh);
  TcpPriority = class
  private
    FRel: TPriotityRel;
  public
    constructor Create(const ByNode: TXMLNode=nil);
    function IsEmpty:boolean;
    procedure ParseXML(const Node: TXmlNode);
    function AddToXML(Root: TXmlNode):TXmlNode;
    property Rel: TPriotityRel read FRel write FRel;
end;

type
  TRelationType = (trNone,trAssistant,trBrother,trChild,
                   trDomesticPartner,trFather,trFriend,
                   trManager,trMother,trParent,trPartner,
                   trReferredBy,trRelative,trSister,trSpouse);

type
  TcpRelation = class
  private
    FDescr: string;//������� rel ��� label
    FValue: string;
    FRealition:TRelationType;
    const
      RelValues: array [0..13]of string =('assistant','brother','child','domestic-partner','father','friend','manager','mother','parent',
'partner','referred-by','relative','sister','spouse');
    procedure SetRel(aRel:TRelationType);
    procedure SetDescr(const aDescr:string);
  public
    constructor Create(const ByNode: TXMLNode=nil);
    function IsEmpty:boolean;
    procedure ParseXML(const Node: TXmlNode);
    function AddToXML(Root: TXmlNode):TXmlNode;
    property Description: string read FDescr write SetDescr;
    property Realition:TRelationType read FRealition write SetRel;
    property Value: string read FValue write FValue;
end;

type
  TSensitivityRel = (TsNone,Tsconfidential,Tsnormal,Tspersonal,Tsprivate);
  TcpSensitivity = class
  private
    FRel: TSensitivityRel;
  public
    constructor Create(const ByNode: TXMLNode=nil);
    function IsEmpty:boolean;
    procedure ParseXML(const Node: TXmlNode);
    function AddToXML(Root: TXmlNode):TXmlNode;
    property Rel: TSensitivityRel read FRel write FRel;
end;

type
  TcpShortName = TTextTag;
  TcpSubject = TTextTag;

type
  TcpSystemGroup = class
  private
    Fid: string;   { TODO -o� -c������� : ���������� �� ���������� ���� }
    const IDValues: array [0..3]of string=('Contacts','Friends','Family','Coworkers');
    procedure SetId(aId:string);
  public
    constructor Create(const ByNode: TXMLNode=nil);
    function IsEmpty:boolean;
    procedure ParseXML(const Node: TXmlNode);
    function  AddToXML(Root: TXmlNode):TXmlNode;
    property  ID: string read Fid write SetId;
end;

type
  TcpUserDefinedField = class
  private
    FKey: string;
    FValue: string;
  public
    constructor Create(const ByNode: TXMLNode=nil);
    function IsEmpty: boolean;
    procedure ParseXML(const Node: TXmlNode);
    function  AddToXML(Root: TXmlNode):TXmlNode;
    property  Key: string read FKey write FKey;
    property  Value: string read FValue write FValue;
end;

type
  TWebSiteType = (twHomePage,twBlog,twProfile,twHome,twWork,twOther,twFtp);
  TcpWebsite = class
  private  { TODO -o� -c������� : ���������� �� ���������� ���� }
    FHref: string;
    FPrimary:boolean;
    Flabel: string;
    FRel: string;
    FWebSiteType: TWebSiteType;
    const RelValues: array[0..6]of string=('home-page','blog','profile',
    'home','work','other','ftp');
    procedure SetRel(aRel:TWebSiteType);
  public
    constructor Create(const ByNode: TXMLNode=nil);
    function IsEmpty:boolean;
    procedure ParseXML(const Node: TXmlNode);
    function  AddToXML(Root: TXmlNode):TXmlNode;
    property  Href: string read FHref write FHref;
    property  Primary: boolean read FPrimary write FPrimary;
    property  Labl: string read Flabel write Flabel;
    //property  Rel: string read FRel write SetRel;
    property SiteType: TWebSiteType read FWebSiteType write SetRel;
end;

type
  TGoogleContact = class;
  TContactGroup = class;

  TFileType = (tfAtom, tfXML);
  TContact = class
  private
    FEtag: string;
    FId: string;
    FUpdated: TDateTime;
    FTitle: TTextTag;
    FContent:TTextTag;
    FLinks:TList<TEntryLink>;
    FName: TgdName;
    FNickName: TcpNickname;
    FBirthDay: TcpBirthday;
    FOrganization: TgdOrganization;
    FEmails: TList<TgdEmail>;
    FPhones: TList<TgdPhoneNumber>;
    FPostalAddreses: TList<TgdStructuredPostalAddress>;
    FEvents : TList<TcpEvent>;
    FRelations: TList<TcpRelation>;
    FUserFields: TList<TcpUserDefinedField>;
    FWebSites: TList<TcpWebsite>;
    FGroupMemberships: TList<TcpGroupMembershipInfo>;
    FIMs:TList<TgdIm>;
    function GetPrimaryEmail: string;
    procedure SetPrimaryEmail(aEmail:string);
//    function GetName : TgdName;
    function GetOrganization:TgdOrganization;
    function GetContactName:string;
    function GenerateText(TypeFile:TFileType): string;
  public
    constructor Create(byNode: TXMLNode);
    destructor Destroy; override;
    function IsEmpty: boolean;

    procedure ParseXML(Node: TXMLNode);overload;
    procedure ParseXML(Stream:TStream);overload;
    function FindEmail(const aEmail:string; out Index:integer):TgdEmail;

    procedure SaveToFile(const FileName:string; FileType:TFileType=tfAtom);
    procedure LoadFromFile(const FileName:string);

    property TagTitle: TTextTag read FTitle write FTitle;
    property TagContent:TTextTag read FContent write FContent;
    property TagName: TgdName read FName write FName;
    property TagNickName: TcpNickname read FNickName write FNickName;
    property TagBirthDay: TcpBirthday read FBirthDay write FBirthDay;
    property TagOrganization: TgdOrganization read GetOrganization write FOrganization;

    property Etag: string read FEtag write FEtag;
    property Id: string read FId write FId;
    property Updated: TDateTime read FUpdated write FUpdated;

    property Links:TList<TEntryLink> read FLinks write FLinks;
    property Emails: TList<TgdEmail> read FEmails write FEmails;
    property Phones: TList<TgdPhoneNumber> read FPhones write FPhones;
    property PostalAddreses: TList<TgdStructuredPostalAddress> read FPostalAddreses write FPostalAddreses;
    property Events : TList<TcpEvent> read FEvents write FEvents;
    property Relations: TList<TcpRelation> read FRelations write FRelations;
    property UserFields: TList<TcpUserDefinedField> read FUserFields write FUserFields;
    property WebSites: TList<TcpWebsite> read FWebSites write FWebSites;
    property GroupMemberships: TList<TcpGroupMembershipInfo> read FGroupMemberships write FGroupMemberships;
    property IMs:TList<TgdIm> read FIMs write FIMs;

    property PrimaryEmail:string read GetPrimaryEmail write SetPrimaryEmail;
    property ContactName: string Read GetContactName;
    property ToXMLText[XMLType:TFileType]: string read GenerateText;
end;

//type
  TContactGroup = class
  private
    FEtag: string;
    Fid: string;
    FLinks: TList<TEntryLink>;
    FUpdate: TDateTime;
    FTitle: TTextTag;
    FContent: TTextTag;
    FSystemGroup: TcpSystemGroup;
  public
    constructor Create(const ByNode: TXMLNode);
    procedure ParseXML(Node: TXmlNode);
    function CreateContact(const aContact: TContact):boolean;
    property Etag: string read FEtag write FEtag;
    property id: string read Fid write Fid;
    property Links: TList<TEntryLink> read FLinks write FLinks;
    property Update: TDateTime read FUpdate write FUpdate;
    property Title: TTextTag read FTitle write FTitle;
    property Content: TTextTag read FContent write FContent;
    property SystemGroup: TcpSystemGroup read FSystemGroup write FSystemGroup;
end;

//type
  TGoogleContact = class(TComponent)
  private
    FAuth: string; //AUTH ��� ������� � API
    FEmail:string; //����������� GMAIL!
    FGroups: TList<TContactGroup>;
    FContacts: TList<TContact>;
    function GetNextLink(Stream:TStream):string;overload;
    function GetNextLink(aXMLDoc:TNativeXml):string;overload;
    function GetContactsByGroup(GroupName:string):TList<TContact>;
    function GroupLink(const aGroupName:string):string;
    procedure ParseXMLContacts(const Data: TStream);
    function GetEditLink(aContact:TContact):string;
    function InsertPhotoEtag(aContact: TContact; const Response:TStream):boolean;
  public
    constructor Create(AOwner:TComponent; const aAuth,aEmail: string);
    destructor Destroy;override;
    function RetriveGroups:integer;
    function RetriveContacts: integer;
    //�������� ��������
    function DeleteContact(index:integer):boolean;overload;
    function DeleteContact(aContact:TContact):boolean;overload;
    //���������� ��������
    function AddContact(aContact:TContact):boolean;
    //���������� ���������� � ��������
    function UpdateContact(aContact:TContact):boolean;overload;
    function UpdateContact(index:integer):boolean;overload;
    //��������� ���������� ��������
    function RetriveContactPhoto(index:integer):TJPEGImage;overload;
    function RetriveContactPhoto(aContact:TContact):TJPEGImage;overload;
    //���������� ���� ��������
    function UpdatePhoto(index:integer; const PhotoFile: TFileName):boolean;overload;
    function UpdatePhoto(aContact:TContact; const PhotoFile: TFileName):boolean;overload;
    //�������� ���������� ��������
    function DeletePhoto(aContact:TContact):boolean;overload;
    function DeletePhoto(index:integer):boolean;overload;
    //����������/�������� ��������� �/�� ����/-�
    procedure SaveContactsToFile(const FileName:string);
    procedure LoadContactsFromFile(const FileName:string);

    property Groups: TList<TContactGroup> read FGroups write FGroups;

    property Contacts:TList<TContact> read FContacts write FContacts;
    property ContactsByGroup[GroupName:string]:TList<TContact> read GetContactsByGroup;
 end;


function GetContactNodeType(const NodeName: string):TcpTagEnum;
function GetContactNodeName(const NodeType:TcpTagEnum):string;

implementation

function GetContactNodeName(const NodeType:TcpTagEnum):string;
begin
    Result:=GetEnumName(TypeInfo(TcpTagEnum),ord(NodeType));
    Delete(Result,1,3);
    Result:=CpNodeAlias+Result;
end;

function GetContactNodeType(const NodeName: string):TcpTagEnum;
var i: integer;
begin
  if pos(CpNodeAlias,NodeName)>0 then
    begin
      i:=GetEnumValue(TypeInfo(TcpTagEnum),
                      Trim(ReplaceStr(NodeName,CpNodeAlias,'cp_')));
      if i>-1 then
        Result := TcpTagEnum(i)
      else
        Result:=cp_None;
    end
  else
    Result:=cp_None;
end;

{ TcpBirthday }

function TcpBirthday.AddToXML(Root: TXMLNode):TXmlNode;
var When: string;
    NodeName: string;
begin
if (Root=nil)or IsEmpty then Exit;

if (Month>0)and(Day>0) then
  begin
    Result:=Root.NodeNew(GetContactNodeName(cp_Birthday));
    if FShortFormat then //����������� ������ ����
      When:=FormatDateTime('--mm-dd',EncodeDate(1898,Month,Day))
    else
      When:=FormatDateTime('yyyy-mm-dd',EncodeDate(Year,Month,Day));
    Result.AttributeAdd('when',When);
  end;
end;

constructor TcpBirthday.Create(const byNode: TXmlNode);
begin
  inherited Create;
  FYear:=0;
  FMonth:=0;
  FDay:=0;
  if byNode<>nil then
    ParseXML(byNode);
end;

destructor TcpBirthday.Destroy;
begin
  inherited Destroy;
end;

function TcpBirthday.IsEmpty: boolean;
begin
  Result:=(Year<=0)and(Month<=0)and(Day<=0);
end;

procedure TcpBirthday.ParseXML(const Node: TXmlNode);
var DateStr: string;
begin
  if GetContactNodeType(Node.Name) <> cp_Birthday then
      raise Exception.Create
        (Format(rcErrCompNodes, [GetContactNodeName(cp_Birthday)]));
  try
    DateStr:= Node.ReadAttributeString('when');
    if (Length(Trim(DateStr))>0)then
      begin
        if (pos('--',DateStr)>0) then//����������� ������ - ������ ����� � ����� ��������
          begin
            FYear:=0;
            Delete(DateStr,1,2);
            FMonth:=StrToInt(copy(DateStr,1,2));
            Delete(DateStr,1,3);
            FDay:=StrToInt(copy(DateStr,1,2));
            FShortFormat:=true;
          end
        else
          begin
            FYear:=StrToInt(copy(DateStr,1,4));
            Delete(DateStr,1,5);
            FMonth:=StrToInt(copy(DateStr,1,2));
            Delete(DateStr,1,3);
            FDay:=StrToInt(copy(DateStr,1,2));
            FShortFormat:=false
          end;
      end;
  except
    Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

function TcpBirthday.ToDate: TDate;
var aYear, aMonth, aDay: word;
begin
  if FShortFormat then //����������� ������
    begin
      DecodeDate(Now,aYear,aMonth,aDay);
      Result:=EncodeDate(aYear,FMonth,FDay);
    end
  else
    Result:=EncodeDate(FYear,FMonth,FDay)
end;

{ TcpCalendarLink }

function TcpCalendarLink.AddToXML(Root: TXmlNode): TXmlNode;
begin
  if (Root=nil)or isEmpty then Exit;
  Result:=Root.NodeNew(GetContactNodeName(cp_CalendarLink));
  if AnsiIndexStr(FDescr,RelValues)>=0 then
    Result.AttributeAdd('rel',FDescr)
  else
    Result.AttributeAdd('label',FDescr);
  Result.AttributeAdd('href',FHref);
  if FPrimary then
    Result.WriteAttributeBool('primary',FPrimary);
end;

constructor TcpCalendarLink.Create(const byNode: TXMLNode);
begin
  inherited Create;
  FDescr:='';
  FHref:='';
  if byNode<>nil then
    ParseXML(byNode);
end;

function TcpCalendarLink.isEmpty: boolean;
begin
  Result:=(Length(Trim(FDescr))=0)and(Length(Trim(FHref))=0);
end;

procedure TcpCalendarLink.ParseXML(const Node: TXmlNode);
begin
  if GetContactNodeType(Node.Name) <> cp_CalendarLink then
     raise Exception.Create
        (Format(rcErrCompNodes, [GetContactNodeName(cp_CalendarLink)]));
  try
    FPrimary:=false;
    if Length(Trim(Node.AttributeByName['rel']))>0 then
      FDescr:=Trim(Node.AttributeByName['rel'])
    else
      FDescr:=Trim(Node.AttributeByName['label']);
    if Node.HasAttribute('primary') then
      FPrimary:=Node.ReadAttributeBool('primary');
    FHref:=Node.ReadAttributeString('href');
  except
    Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

{ TcpEvent }

function TcpEvent.AddToXML(Root: TXmlNode): TXmlNode;
var sRel: string;
begin
  if (Root=nil)or IsEmpty then Exit;
  Result:=Root.NodeNew(GetContactNodeName(cp_Event));
  if Ord(FEventType)>-1 then
    begin
      sRel:=GetEnumName(TypeInfo(TEventRel),ord(FEventType));
      Delete(sRel,1,2);
      Result.WriteAttributeString('rel',sRel);
    end
  else
    begin
      sRel:=GetEnumName(TypeInfo(TEventRel),ord(teOther));
      Delete(sRel,1,2);
      Result.WriteAttributeString('rel',sRel);
    end;
  if length(Flabel)>0 then
    Result.WriteAttributeString('label',Flabel);
  FWhen.AddToXML(Result,tdDate);
end;

constructor TcpEvent.Create(const byNode: TXmlNode);
begin
  inherited Create;
  FEventType:=teNone;
  Flabel:='';
  FWhen:=TgdWhen.Create;
  if byNode<>nil then
    ParseXML(byNode);
end;

function TcpEvent.IsEmpty: boolean;
begin
  Result:=(FEventType=teNone)and(Length(Trim(Flabel))=0)and(FWhen.isEmpty)
end;

procedure TcpEvent.ParseXML(const Node: TXMLNode);
var WhenNode: TXmlNode;
    S:String;
begin
  if GetContactNodeType(Node.Name) <> cp_Event then
     raise Exception.Create
           (Format(rcErrCompNodes, [GetContactNodeName(cp_Event)]));
  try
    if Node.HasAttribute('label') then
      Flabel:=Trim(Node.ReadAttributeString('label'));
    if Node.HasAttribute('rel') then
      begin
        S:=Trim(Node.ReadAttributeString('rel'));
        S:=StringReplace(S,SchemaHref,'',[rfIgnoreCase]);
        FEventType:=TEventRel(GetEnumValue(TypeInfo(TEventRel),s));
      end;

    WhenNode:=Node.FindNode(cGDTagNames[ord(egdWhen)]);
    if WhenNode<>nil then
       FWhen:=TgdWhen.Create(WhenNode)
    else
      Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  except
    Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

{ TcpExternalId }

function TcpExternalId.AddToXML(Root: TXmlNode): TXmlNode;
var sRel:string;
begin
  if (Root=nil)or IsEmpty then Exit;
  if ord(Frel)<0 then
    raise Exception.Create
        (Format(rcErrWriteNode, [GetContactNodeName(cp_ExternalId)])+' '+Format(rcWrongAttr,['rel']));
  Result:=Root.NodeNew(GetContactNodeName(cp_ExternalId));
  if Trim(Flabel)<>'' then
    Result.WriteAttributeString('label',FLabel);
  sRel:=GetEnumName(TypeInfo(TExternalIdType),Ord(FRel));
  Delete(sRel,1,2);
  Result.WriteAttributeString('rel',sRel);
  Result.WriteAttributeString('value',FValue);
end;

constructor TcpExternalId.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  Frel:=tiNone;
  FLabel:='';
  FValue:='';
  if ByNode<>nil then
    ParseXML(ByNode);
end;

function TcpExternalId.IsEmpty: boolean;
begin
  Result:=(Frel=tiNone)and(Length(Trim(FLabel))=0)and(Length(Trim(FValue))=0);
end;

procedure TcpExternalId.ParseXML(const Node: TXmlNode);
begin
  if Node=nil then Exit;
  if GetContactNodeType(Node.Name) <> cp_ExternalId then
     raise Exception.Create
          (Format(rcErrCompNodes, [GetContactNodeName(cp_ExternalId)]));
  try
    if Node.HasAttribute('label') then
      FLabel:=Node.ReadAttributeString('label');
    Frel:=TExternalIdType(GetEnumValue(TypeInfo(TExternalIdType),'ti'+Node.ReadAttributeString('rel')));
    FValue:=Node.ReadAttributeString('value');
  except
    Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

{ TcpGender }

function TcpGender.AddToXML(Root: TXmlNode): TXmlNode;
begin
if (Root=nil)or IsEmpty then Exit;
  if Ord(FValue)<0 then
    raise Exception.Create
        (Format(rcErrWriteNode, [GetContactNodeName(cp_Gender)])+' '+Format(rcWrongAttr,['value']));
  Result:=Root.NodeNew(GetContactNodeName(cp_Gender));
  Result.WriteAttributeString('value',GetEnumName(TypeInfo(TGenderType),Ord(FValue)));
end;

constructor TcpGender.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  FValue:=none;
  if ByNode<>nil then
    ParseXML(ByNode);
end;

function TcpGender.IsEmpty: boolean;
begin
  Result:=FValue=none;
end;

procedure TcpGender.ParseXML(const Node: TXmlNode);
begin
  if Node=nil then Exit;
  if GetContactNodeType(Node.Name) <> cp_Gender then
     raise Exception.Create
     (Format(rcErrCompNodes, [GetContactNodeName(cp_Gender)]));
  try
    FValue:=TGenderType(GetEnumValue(TypeInfo(TGenderType),Node.ReadAttributeString('value')));
  except
    Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

{ TcpGroupMembershipInfo }

function TcpGroupMembershipInfo.AddToXML(Root: TXmlNode): TXmlNode;
begin
 if (Root=nil)or(IsEmpty) then Exit;
 Result:=Root.NodeNew(GetContactNodeName(cp_GroupMembershipInfo));
 Result.WriteAttributeString('href',FHref);
 Result.WriteAttributeBool('deleted',FDeleted);
end;

constructor TcpGroupMembershipInfo.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  FHref:='';
  if ByNode<>nil then
    ParseXML(ByNode);
end;

function TcpGroupMembershipInfo.IsEmpty: boolean;
begin
Result:=Length(Trim(FHref))=0
end;

procedure TcpGroupMembershipInfo.ParseXML(const Node: TXmlNode);
begin
 if Node=nil then Exit;
  if GetContactNodeType(Node.Name) <> cp_GroupMembershipInfo then
     raise Exception.Create
          (Format(rcErrCompNodes, [GetContactNodeName(cp_GroupMembershipInfo)]));
  try
    FHref:=Node.ReadAttributeString('href');
    FDeleted:=Node.ReadAttributeBool('deleted')
  except
    Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

{ TcpJot }

function TcpJot.AddToXML(Root: TXmlNode): TXmlNode;
var sRel: string;
begin
 sRel:='';
 if (Root=nil)or IsEmpty then Exit;
 Result:=Root.NodeNew(GetContactNodeName(cp_Jot));
 if FRel<>TjNone then
   begin
     sRel:=GetEnumName(TypeInfo(TJotRel),ord(FRel));
     Delete(sRel,1,2);
     Result.WriteAttributeString('rel',sRel);
   end;
 Result.ValueAsString:=FText;
end;

constructor TcpJot.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  FRel:=TjNone;
  FText:='';
  if ByNode<>nil then
    ParseXML(ByNode);
end;

function TcpJot.IsEmpty: boolean;
begin
  Result:=(FRel=TjNone)and(Length(Trim(FText))=0);
end;

procedure TcpJot.ParseXML(const Node: TXmlNode);
begin
  if Node=nil then Exit;
  if GetContactNodeType(Node.Name) <> cp_Jot then
     raise Exception.Create
          (Format(rcErrCompNodes, [GetContactNodeName(cp_Jot)]));
  try
    FRel:=TJotRel(GetEnumValue(TypeInfo(TJotRel),'Tj'+Node.ReadAttributeString('rel')));
    FText:=Node.ValueAsString;
  except
    Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

{ TcpLanguage }

function TcpLanguage.AddToXML(Root: TXmlNode): TXmlNode;
begin
  if (Root=nil)or IsEmpty then Exit;
    Result:=Root.NodeNew(GetContactNodeName(cp_Language));
  Result.WriteAttributeString('code',Fcode);
  Result.WriteAttributeString('label',Flabel);
end;

constructor TcpLanguage.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  Fcode:='';
  Flabel:='';
  if ByNode<>nil then
    ParseXML(ByNode);
end;

function TcpLanguage.IsEmpty: boolean;
begin
  Result:=(Length(Trim(Fcode))=0)and(length(Trim(Flabel))=0);
end;

procedure TcpLanguage.ParseXML(const Node: TXmlNode);
begin
 if Node=nil then Exit;
  if GetContactNodeType(Node.Name) <> cp_Language then
     raise Exception.Create
          (Format(rcErrCompNodes, [GetContactNodeName(cp_Language)]));
  try
    Fcode:=Node.ReadAttributeString('code');
    Flabel:=Node.ReadAttributeString('label');
  except
    Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

{ TcpPriority }

function TcpPriority.AddToXML(Root: TXmlNode): TXmlNode;
var sRel: string;
begin
  if (Root=nil)or IsEmpty then Exit;
  Result:=Root.NodeNew(GetContactNodeName(cp_Priority));
  sRel:=GetEnumName(TypeInfo(TPriotityRel),ord(FRel));
  Delete(sRel,1,2);
  Result.WriteAttributeString('rel',sRel);
end;

constructor TcpPriority.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  FRel:=tpNone;
  if ByNode<>nil then
    ParseXML(ByNode);
end;

function TcpPriority.IsEmpty: boolean;
begin
  Result:=FRel=TpNone;
end;

procedure TcpPriority.ParseXML(const Node: TXmlNode);
begin
  if Node=nil then Exit;
  if GetContactNodeType(Node.Name) <> cp_Priority then
     raise Exception.Create
     (Format(rcErrCompNodes, [GetContactNodeName(cp_Priority)]));
  try
    FRel:=TPriotityRel(GetEnumValue(TypeInfo(TPriotityRel),'Tp'+Node.ReadAttributeString('rel')));
  except
    Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

{ TcpRelation }

function TcpRelation.AddToXML(Root: TXmlNode): TXmlNode;
begin
if (Root=nil)or IsEmpty then Exit;
Result:=Root.NodeNew(GetContactNodeName(cp_Relation));
if FRealition=trNone then
  Result.WriteAttributeString('label',FDescr)
else
   Result.WriteAttributeString('rel',FDescr);
Result.ValueAsString:=FValue;
end;

constructor TcpRelation.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  FDescr:='';
  FValue:='';
  FRealition:=trNone;
  if ByNode<>nil then
    ParseXML(ByNode);
end;

function TcpRelation.IsEmpty: boolean;
begin
Result:=(Length(Trim(FDescr))=0)and(Length(Trim(FValue))=0)and(FRealition=trNone);
end;

procedure TcpRelation.ParseXML(const Node: TXmlNode);
begin
 if Node=nil then Exit;
  if GetContactNodeType(Node.Name) <> cp_Relation then
     raise Exception.Create
     (Format(rcErrCompNodes, [GetContactNodeName(cp_Relation)]));
  try
    if Node.HasAttribute('rel') then
      begin
        FDescr:=Node.ReadAttributeString('rel');
        FDescr:=StringReplace(FDescr,SchemaHref,'',[rfIgnoreCase]);
        if AnsiIndexStr(FDescr,RelValues)>-1 then
          FRealition:=TRelationType(AnsiIndexStr(FDescr,RelValues)+1)
        else
          FRealition:=trRelative;
      end
    else
      begin
        FDescr:=Node.ReadAttributeString('label');
        FRealition:=trNone;
      end;
    FValue:=Node.ValueAsString;
  except
    Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

procedure TcpRelation.SetDescr(const aDescr: string);
begin
  if AnsiIndexStr(aDescr,RelValues)>-1 then
    FRealition:=TRelationType(AnsiIndexStr(aDescr,RelValues)+1)
  else
    FRealition:=trNone;
FDescr:=aDescr;
end;

procedure TcpRelation.SetRel(aRel: TRelationType);
begin
  FRealition:=aRel;
  if aRel<>trNone then
    FDescr:=RelValues[Ord(aRel)-1];
end;

{ TcpSensitivity }

function TcpSensitivity.AddToXML(Root: TXmlNode): TXmlNode;
var sRel: string;
begin
 if (Root=nil)or IsEmpty then Exit;
  if Ord(Frel)<0 then
    raise Exception.Create
    (Format(rcErrWriteNode, [GetContactNodeName(cp_Sensitivity)])+' '+Format(rcWrongAttr,['rel']));
  Result:=Root.NodeNew(GetContactNodeName(cp_Sensitivity));
  sRel:=GetEnumName(TypeInfo(TSensitivityRel),ord(FRel));
  Delete(sRel,1,2);
  Result.WriteAttributeString('rel',sRel);
end;

constructor TcpSensitivity.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  FRel:=TsNone;
  if ByNode<>nil then
    ParseXML(ByNode);
end;

function TcpSensitivity.IsEmpty: boolean;
begin
  Result:=FRel=TsNone;
end;

procedure TcpSensitivity.ParseXML(const Node: TXmlNode);
begin
if Node=nil then Exit;
  if GetContactNodeType(Node.Name) <> cp_Sensitivity then
     raise Exception.Create
             (Format(rcErrCompNodes, [GetContactNodeName(cp_Sensitivity)]));
  try
    FRel:=TSensitivityRel(GetEnumValue(TypeInfo(TSensitivityRel),'Ts'+Node.ReadAttributeString('rel')));
  except
    Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

{ TsystemGroup }

function TcpsystemGroup.AddToXML(Root: TXmlNode): TXmlNode;
begin
 if Root=nil then Exit;
  if AnsiIndexStr(Fid,IDValues)<0 then
    raise Exception.Create
    (Format(rcErrWriteNode, [GetContactNodeName(cp_systemGroup)])+' '+Format(rcWrongAttr,['id']));
Result:=Root.NodeNew(GetContactNodeName(cp_systemGroup));
  Result.WriteAttributeString('id',Fid);
end;

constructor TcpsystemGroup.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  Fid:='';
  if ByNode<>nil then
    ParseXML(ByNode);
end;

function TcpSystemGroup.IsEmpty: boolean;
begin
  Result:=Length(Trim(Fid))=0
end;

procedure TcpsystemGroup.ParseXML(const Node: TXmlNode);
begin
  if (Node=nil)or IsEmpty then Exit;
  if GetContactNodeType(Node.Name) <> cp_SystemGroup then
     raise Exception.Create
     (Format(rcErrCompNodes, [GetContactNodeName(cp_systemGroup)]));
  try
      Fid:=Node.ReadAttributeString('id')
  except
    Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

procedure TcpsystemGroup.SetId(aId: string);
begin
if AnsiIndexStr(Fid,IDValues)<0 then
  raise Exception.Create
  (Format(rcErrWriteNode, [GetContactNodeName(cp_systemGroup)])+' '+Format(rcWrongAttr,['id']));
Fid:=aId;
end;

{ TcpUserDefinedField }

function TcpUserDefinedField.AddToXML(Root: TXmlNode): TXmlNode;
begin
  if (Root=nil)or IsEmpty then Exit;
  Result:=Root.NodeNew(GetContactNodeName(cp_UserDefinedField));
  Result.WriteAttributeString('key',FKey);
  Result.WriteAttributeString('value',FValue);
end;

constructor TcpUserDefinedField.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  FKey:='';
  FValue:='';
  if ByNode<>nil then
    ParseXML(ByNode);
end;

function TcpUserDefinedField.IsEmpty: boolean;
begin
 Result:=(Length(Trim(FKey))=0)and(Length(Trim(FValue))=0)
end;

procedure TcpUserDefinedField.ParseXML(const Node: TXmlNode);
begin
  if Node=nil then Exit;
  if GetContactNodeType(Node.Name) <> cp_UserDefinedField then
     raise Exception.Create
     (Format(rcErrCompNodes, [GetContactNodeName(cp_UserDefinedField)]));
  try
    FKey:=Node.ReadAttributeString('key');
    FValue:=Node.ReadAttributeString('value');
  except
    Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

{ TcpWebsite }

function TcpWebsite.AddToXML(Root: TXmlNode): TXmlNode;
begin
  if (Root=nil)or IsEmpty then Exit;
  if AnsiIndexStr(FRel,RelValues)<0 then
    raise Exception.Create
    (Format(rcErrWriteNode, [GetContactNodeName(cp_Website)])+' '+Format(rcWrongAttr,['rel']));
  Result:=Root.NodeNew(GetContactNodeName(cp_Website));
  Result.WriteAttributeString('href',FHref);
  Result.WriteAttributeString('rel',FRel);
  if FPrimary then
    Result.WriteAttributeBool('primary',FPrimary);
  if Trim(Flabel)<>'' then
    Result.WriteAttributeString('label',Flabel);
end;

constructor TcpWebsite.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  FHref:='';
  Flabel:='';
  FRel:='';
  FWebSiteType:=twOther;
  if ByNode<>nil then
    ParseXML(ByNode);
end;

function TcpWebsite.IsEmpty: boolean;
begin
  Result:=(Length(Trim(FHref))=0)and(Length(Trim(FRel))=0)and(Length(Trim(Flabel))=0)and(FWebSiteType=twOther)
end;

procedure TcpWebsite.ParseXML(const Node: TXmlNode);
begin
  if (Node=nil) then Exit;
  if GetContactNodeType(Node.Name) <> cp_Website then
     raise Exception.Create
     (Format(rcErrCompNodes, [GetContactNodeName(cp_Website)]));
  try
    FHref:=Node.ReadAttributeString('href');
    FRel:=Node.ReadAttributeString('rel');
    FRel:=StringReplace(FRel,SchemaHref,'',[rfIgnoreCase]);

    if AnsiIndexText(Frel,RelValues)>-1 then
      FWebSiteType:=TWebsiteType(AnsiIndexText(Frel,RelValues))
    else
      FWebSiteType:=twOther;

    if Node.HasAttribute('label') then
      Flabel:=Node.ReadAttributeString('label');
    if Node.HasAttribute('primary') then
      FPrimary:=Node.ReadAttributeBool('primary');
  except
    Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

procedure TcpWebsite.SetRel(aRel: TWebSiteType);
begin
FRel:=RelValues[ord(aRel)];
FWebSiteType:=aRel;
end;

{ TContact }

constructor TContact.Create(byNode: TXMLNode);
begin
  inherited Create();
  FLinks:=TList<TEntryLink>.Create;
  FEmails:= TList<TgdEmail>.Create;
  FPhones:= TList<TgdPhoneNumber>.Create;
  FPostalAddreses:= TList<TgdStructuredPostalAddress>.Create;
  FEvents := TList<TcpEvent>.Create;
  FRelations:= TList<TcpRelation>.Create;
  FUserFields:= TList<TcpUserDefinedField>.Create;
  FWebSites:= TList<TcpWebsite>.Create;
  FIms:=TList<TgdIm>.Create;
  FGroupMemberships:= TList<TcpGroupMembershipInfo>.Create;
  FOrganization:=TgdOrganization.Create();
  FTitle:=TTextTag.Create();
  FContent:=TTextTag.Create();
  FName:=TgdName.Create();
  FNickName:=TTextTag.Create();
  FBirthDay:=TcpBirthday.Create(nil);
  if byNode<>nil then
    ParseXML(byNode);
end;

destructor TContact.Destroy;
begin
  FreeAndNil(FTitle);
  FreeAndNil(FContent);
  FreeAndNil(FLinks);
  FreeAndNil(FName);
  FreeAndNil(FNickName);
  FreeAndNil(FBirthDay);
  FreeAndNil(FOrganization);
  FreeAndNil(FEmails);
  FreeAndNil(FPhones);
  FreeAndNil(FPostalAddreses);
  FreeAndNil(FEvents);
  FreeAndNil(FRelations);
  FreeAndNil(FUserFields);
  FreeAndNil(FWebSites);
  FreeAndNil(FGroupMemberships);
  FreeAndNil(FIMs);
  inherited Destroy;
end;

function TContact.FindEmail(const aEmail:string; out Index:integer):TgdEmail;
var i:integer;
begin
  Result:=nil;
  for i:=0 to FEmails.Count - 1 do
    begin
      if UpperCase(aEmail)=UpperCase(FEmails[i].Address) then
        begin
          Result:=FEmails[i];
          Index:=i;
          break;
        end;
    end;
end;

function TContact.GenerateText(TypeFile:TFileType): string;
var Doc: TNativeXml;
    I: Integer;
    url:string;
    Node:TXMLNode;
begin
try
 if IsEmpty then Exit;
 Doc:=TNativeXml.Create;
 Doc.EncodingString:=CpDefoultEncoding;
 case TypeFile of
   tfAtom:begin
            Doc.CreateName(CpAtomAlias+EntryNodeName);
            Doc.Root.WriteAttributeString('xmlns:atom','http://www.w3.org/2005/Atom');
            Node:=Doc.Root.NodeNew(CpAtomAlias+'category');
            FTitle.AddToXML(Doc.Root);
          end;
   tfXML:begin
           Doc.CreateName(EntryNodeName);
           Doc.Root.WriteAttributeString('xmlns','http://www.w3.org/2005/Atom');
           Node:=Doc.Root.NodeNew('category');
           FTitle.AddToXML(Doc.Root);
         end;
 end;
 Doc.Root.WriteAttributeString('xmlns:gd','http://schemas.google.com/g/2005');
 Doc.Root.WriteAttributeString('xmlns:gContact','http://schemas.google.com/contact/2008');
 Node.WriteAttributeString('scheme','http://schemas.google.com/g/2005#kind');
 Node.WriteAttributeString('term','http://schemas.google.com/contact/2008#contact');

 for I := 0 to FLinks.Count - 1 do
   FLinks[i].AddToXML(Doc.Root);
 for I := 0 to FEmails.Count - 1 do
   FEmails[i].AddToXML(Doc.Root);
 for I := 0 to FPhones.Count - 1 do
   FPhones[i].AddToXML(Doc.Root);
 for I := 0 to FPostalAddreses.Count - 1 do
   FPostalAddreses[i].AddToXML(Doc.Root);
 for I := 0 to FIMs.Count - 1 do
   FIMs[i].AddToXML(Doc.Root);
 //GContact
 for I := 0 to FEvents.Count - 1 do
   FEvents[i].AddToXML(Doc.Root);
 for I := 0 to FRelations.Count - 1 do
   FRelations[i].AddToXML(Doc.Root);
 for I := 0 to FUserFields.Count - 1 do
   FUserFields[i].AddToXML(Doc.Root);
 for I := 0 to FWebSites.Count - 1 do
   FWebSites[i].AddToXML(Doc.Root);
 for I := 0 to FGroupMemberships.Count - 1 do
   FGroupMemberships[i].AddToXML(Doc.Root);

 FContent.AddToXML(Doc.Root);
 FName.AddToXML(Doc.Root);
 FNickName.AddToXML(Doc.Root);
 FOrganization.AddToXML(Doc.Root);
 FBirthDay.AddToXML(Doc.Root);

 Result:=Doc.Root.WriteToString;
 Doc.SaveToFile('ChangedContact.xml');
finally
  FreeAndNil(Doc)
end;
end;

function TContact.GetContactName: string;
begin
if FTitle.IsEmpty then
  if PrimaryEmail<>'' then
    Result:=PrimaryEmail
  else
    Result:=CpDefaultCName
else
  Result:=FTitle.Value
end;

//function TContact.GetName: TgdName;
//begin
//Result:=TgdName.Create();
//if FName<>nil then
//  Result:=FName
//end;

function TContact.GetOrganization: TgdOrganization;
begin
  Result:=TgdOrganization.Create();
  if FOrganization<>nil then
    Result:=FOrganization
  else
    begin
      Result.OrgName:=TTextTag.Create();
      Result.OrgTitle:=TTextTag.Create();
    end;
end;

function TContact.GetPrimaryEmail: string;
var i:integer;
begin
Result:='';
if FEmails=nil then Exit;
if FEmails.Count=0 then Exit;
for i:=0 to FEmails.Count - 1 do
  begin
    if FEmails[i].Primary then
      begin
        Result:=FEmails[i].Address;
        break;
      end;
  end;
end;

function TContact.IsEmpty: boolean;
begin
Result:=FTitle.IsEmpty and
        FContent.IsEmpty and
        FName.IsEmpty and
        FNickName.IsEmpty and
        FBirthDay.IsEmpty and
        FOrganization.IsEmpty and
        (FEmails.Count=0) and
        (FPhones.Count=0) and
        (FPostalAddreses.Count=0) and
        (FEvents.Count=0) and
        (FRelations.Count=0) and
        (FUserFields.Count=0) and
        (FWebSites.Count=0) and
        (FGroupMemberships.Count=0)and
        (FIMs.Count=0);
end;

procedure TContact.LoadFromFile(const FileName: string);
var XML: TNativeXML;
begin
try
  XML:=TNativeXml.Create;
  XML.LoadFromFile(FileName);
  if (not XML.IsEmpty)and
     ((LowerCase(XML.Root.Name)=LowerCase(CpAtomAlias+EntryNodeName))
     or(LowerCase(XML.Root.Name)=LowerCase(EntryNodeName))) then
       ParseXML(XML.Root);
finally
  FreeAndNil(XML)
end;
end;

procedure TContact.ParseXML(Stream: TStream);
var XMLDoc: TNativeXML;
begin
  if Stream=nil then Exit;
  if Stream.Size=0 then Exit;
  XMLDoc:=TNativeXml.Create;
  try
  try
    XMLDoc.LoadFromStream(Stream);
    ParseXML(XMLDoc.Root);
  except
    Exit;
  end;
  finally
    FreeAndNil(XMLDoc)
  end;
end;

procedure TContact.ParseXML(Node: TXMLNode);
var i:integer;
    List: TXmlNodeList;
begin
try
 if Node=nil then Exit;
 FEtag:=Node.ReadAttributeString('gd:etag');
 List:=TXmlNodeList.Create;
 Node.NodesByName('id',List);
 for I := 0 to List.Count - 1 do
   FId:=List.Items[i].ValueAsString;
 //������� ��������� ��� ������
 Node.NodesByName(cGDTagNames[ord(egdEmail)],List);
 for i:=0 to List.Count-1 do
   FEmails.Add(TgdEmail.Create(List.Items[i]));
 Node.NodesByName(cGDTagNames[ord(egdPhoneNumber)],List);
 for i:=0 to List.Count-1 do
    FPhones.Add(TgdPhoneNumber.Create(List.Items[i]));
 Node.NodesByName(cGDTagNames[ord(egdIm)],List);
 for i:=0 to List.Count-1 do
    FIMs.Add(TgdIM.Create(List.Items[i]));
 Node.NodesByName(cGDTagNames[ord(egdStructuredPostalAddress)],List);
 for i:=0 to List.Count-1 do
   FPostalAddreses.Add(TgdStructuredPostalAddress.Create(List.Items[i]));
 Node.NodesByName(GetContactNodeName(cp_Event),List);
 for i:=0 to List.Count-1 do
   FEvents.Add(TcpEvent.Create(List.Items[i]));
 Node.NodesByName(GetContactNodeName(cp_Relation),List);
 for i:=0 to List.Count-1 do
   FRelations.Add(TcpRelation.Create(List.Items[i]));
 Node.NodesByName(GetContactNodeName(cp_UserDefinedField),List);
 for i:=0 to List.Count-1 do
   FUserFields.Add(TcpUserDefinedField.Create(List.Items[i]));
 Node.NodesByName(GetContactNodeName(cp_Website),List);
 for i:=0 to List.Count-1 do
   FWebSites.Add(TcpWebsite.Create(List.Items[i]));
 Node.NodesByName(GetContactNodeName(cp_GroupMembershipInfo),List);
 for i:=0 to List.Count-1 do
   FGroupMemberships.Add(TcpGroupMembershipInfo.Create(List.Items[i]));
 Node.NodesByName('link',List);
 for i:=0 to List.Count-1 do
   FLinks.Add(TEntryLink.Create(List.Items[i]));
 for i:=0 to Node.NodeCount - 1 do
   begin
   //CpAtomAlias
     if (LowerCase(Node.Nodes[i].Name)='updated')or
        (LowerCase(Node.Nodes[i].Name)=LowerCase(CpAtomAlias+'updated')) then
         FUpdated:=ServerDateToDateTime(Node.Nodes[i].ValueAsString)
     else
       if (LowerCase(Node.Nodes[i].Name)='title')or
          (LowerCase(Node.Nodes[i].Name)=LowerCase(CpAtomAlias+'title')) then
         FTitle:=TTextTag.Create(Node.Nodes[i])
       else
         if (LowerCase(Node.Nodes[i].Name)='content')or
            (LowerCase(Node.Nodes[i].Name)=LowerCase(CpAtomAlias+'content')) then
           FContent:=TTextTag.Create(Node.Nodes[i])
         else
           if LowerCase(Node.Nodes[i].Name)=LowerCase(cGDTagNames[ord(egdName)]) then
             FName:=TgdName.Create(Node.Nodes[i])
           else
             if LowerCase(Node.Nodes[i].Name)=LowerCase(cGDTagNames[ord(egdOrganization)]) then
               FOrganization:=TgdOrganization.Create(Node.Nodes[i])
             else
                if LowerCase(Node.Nodes[i].Name)=LowerCase(GetContactNodeName(cp_Birthday)) then
                 FBirthDay:=TcpBirthday.Create(Node.Nodes[i])
               else
                   if LowerCase(Node.Nodes[i].Name)=LowerCase(GetContactNodeName(cp_Nickname)) then
                   FNickName:=TTextTag.Create(Node.Nodes[i]);
   end;
finally
  FreeAndNil(List)
end;
end;

procedure TContact.SaveToFile(const FileName: string; FileType: TFileType);
begin
  TFile.WriteAllText(FileName,GenerateText(FileType));
end;

procedure TContact.SetPrimaryEmail(aEmail: string);
var index,i:integer;
    NewEmail: TgdEmail;
begin
  if FindEmail(aEmail,index)=nil then
    begin
      NewEmail:=TgdEmail.Create();
      NewEmail.Address:=aEmail;
      NewEmail.Primary:=true;
      NewEmail.EmailType:=ttOther;
      FEmails.Add(NewEmail);
    end;
 for i:=0 to FEmails.Count - 1 do
   FEmails[i].Primary:=(i=index);
end;

{ TContactGroup }

constructor TContactGroup.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  FLinks:=TList<TEntryLink>.Create;
  if ByNode<>nil then
    ParseXML(ByNode);
end;

function TContactGroup.CreateContact(const aContact: TContact): boolean;
begin

end;

procedure TContactGroup.ParseXML(Node: TXmlNode);
var i:integer;
begin
  if Node=nil then Exit;
  FEtag:=Node.ReadAttributeString('gd:etag');
  for i:=0 to Node.NodeCount-1 do
    begin
      if Node.Nodes[i].Name='id' then
        Fid:=Node.Nodes[i].ValueAsString
      else
        if Node.Nodes[i].Name='updated' then
          FUpdate:=ServerDateToDateTime(Node.Nodes[i].ValueAsString)
        else
          if Node.Nodes[i].Name='title' then
            FTitle:=TTextTag.Create(Node.Nodes[i])
          else
            if Node.Nodes[i].Name='content' then
              FContent:=TTextTag.Create(Node.Nodes[i])
            else
              if Node.Nodes[i].Name=GetContactNodeName(cp_SystemGroup) then
                FSystemGroup:=TcpSystemGroup.Create(Node.Nodes[i])
              else
                if Node.Nodes[i].Name='link' then
                  FLinks.Add(TEntryLink.Create(Node.Nodes[i]));
    end;
end;

{ TGoogleContact }

function TGoogleContact.AddContact(aContact: TContact): boolean;
var XML: TNativeXML;
begin
Result:=false;
if (aContact=nil) Or aContact.IsEmpty  then Exit;
try
  XML:=TNativeXml.Create;
  XML.ReadFromString(aContact.GenerateText(tfAtom));
  with THTTPSend.Create do
    begin
     Headers.Add('GData-Version: '+CpProtocolVer);
     Headers.Add('Authorization: GoogleLogin auth=' + FAuth);
     MimeType := 'application/atom+xml';
     XML.SaveToStream(Document);
     if HTTPMethod('POST',CpContactsLink) then
       begin
         Result:=(ResultCode=201);
         if Result then
           begin
             XML.Clear;
             XML.LoadFromStream(Document);
             FContacts.Add(TContact.Create(XML.Root))
           end;
         {TODO -oVlad -c������� : ���������� ���������� ��������� ����������}
//         Document.SaveToFile('G:\delphicelendar\contacts_api\node_atom.xml');
       end
     else
       ShowMessage(IntToStr(ResultCode)+' '+ResultString)
    end;
finally
  FreeAndNil(XML)
end;
end;

constructor TGoogleContact.Create(AOwner:TComponent;const aAuth,aEmail: string);
begin
  if Trim(aAuth)='' then
    raise Exception.Create(rcErrNullAuth);
  inherited Create(AOwner);
  FEmail:=aEmail;
  FAuth:=aAuth;
  FGroups:=TList<TContactGroup>.Create;
  FContacts:=TList<TContact>.Create;
end;

function TGoogleContact.DeleteContact(index: integer): boolean;
begin
try
  Result:=false;
  if (Index<0)or(Index>=FContacts.Count) then Exit;
  Result:=DeleteContact(FContacts[index]);
except
  Result:=false;
end;
end;

function TGoogleContact.DeleteContact(aContact: TContact): boolean;
var i:integer;
begin
try
if aContact=nil then Exit;

if Length(aContact.Etag)>0 then
 begin
 for I := 0 to aContact.FLinks.Count - 1 do
   begin
     if LowerCase(aContact.FLinks[i].Rel)='edit' then
       begin
         with THTTPSend.Create do
           begin
             Headers.Add('GData-Version: '+CpProtocolVer);
             Headers.Add('Authorization: GoogleLogin auth=' + Self.FAuth);
             MimeType := 'application/atom+xml';
             Headers.Add('If-Match: '+aContact.Etag);
             if HTTPMethod('DELETE',aContact.FLinks[i].Href) then
               begin
         {TODO -oVlad -c������� : ���������� ���������� ��������� ����������}
//         Document.SaveToFile('G:\delphicelendar\contacts_api\node_response.xml');
               end
             else
               ShowMessage(IntToStr(ResultCode)+' '+ResultString)
         end;
         break;
       end;
   end;
 end;
  aContact.Destroy;//������� �� ������

  for I := 0 to FContacts.Count - 1 do
    if FContacts[i]=nil then
      begin
        FContacts.DeleteRange(i,1);//������� ��������� ������� �� ������
        break;
      end;
  Result:=true;
except
  Result:=false;
end;
end;

function TGoogleContact.DeletePhoto(index: integer):boolean;
begin
  if (index>=FContacts.Count)or(index<0) then Exit;
  Result:=DeletePhoto(FContacts[index])
end;

function TGoogleContact.DeletePhoto(aContact: TContact):boolean;
var i:integer;
begin
Result:=false;
if aContact=nil then Exit;
  for I := 0 to aContact.FLinks.Count - 1 do
    begin
      if (LowerCase(aContact.FLinks[i].Ltype)=CpImgRel)and
        (Length(aContact.FLinks[i].Etag)>0)  then
        begin
          with THTTPSend.Create do
            begin
              Headers.Add('GData-Version: '+CpProtocolVer);
              Headers.Add('Authorization: GoogleLogin auth=' + FAuth);
              MimeType := CpImgRel;
              Headers.Add('If-Match: *');
              if HTTPMethod('DELETE',aContact.FLinks[i].Href) then
                begin
                  Result:=ResultCode=200;
                  if Result then
                    aContact.FLinks[i].Etag:='';
                 end
              else
                ShowMessage(IntToStr(ResultCode)+' '+ResultString)
            end;
         break;
       end;
   end;
end;

destructor TGoogleContact.Destroy;
var c: TContact;
    g: TContactGroup;
begin
  for g in FGroups do g.Destroy;
  for c in FContacts do c.Destroy;
  FContacts.Free;
  FGroups.Free;
  inherited Destroy;
end;

function TGoogleContact.GetContactsByGroup(GroupName: string): TList<TContact>;
var i,j:integer;
    GrupLink:string;
begin
  Result:=TList<TContact>.Create;
  GrupLink:=GroupLink(GroupName);
  if GrupLink<>'' then
    begin
      for i:=0 to FContacts.Count - 1 do
        for j:=0 to FContacts[i].FGroupMemberships.Count-1 do
          begin
            if FContacts[i].FGroupMemberships[j].FHref=GrupLink then
              Result.Add(FContacts[i])
          end;
    end;
end;

function TGoogleContact.GetEditLink(aContact: TContact): string;
var i:integer;
begin
Result:='';
  for i:= 0 to aContact.FLinks.Count - 1 do
    if aContact.FLinks[i].Rel='edit' then
      begin
        Result:=aContact.FLinks[i].Href;
        break;
      end;
end;

function TGoogleContact.GetNextLink(aXMLDoc: TNativeXml): string;
var i:integer;
    List: TXmlNodeList;
begin
try
 if aXMLDoc=nil then Exit;
 Result:='';
 List:=TXmlNodeList.Create;
 aXMLDoc.Root.NodesByName('link',List);
 for i:=0 to List.Count-1 do
   begin
     if List.Items[i].ReadAttributeString('rel')='next' then
       begin
         Result:=List.Items[i].ReadAttributeString('href');
         break;
       end;
   end;
finally
  FreeAndNil(List);
end;
end;

function TGoogleContact.GetNextLink(Stream: TStream): string;
var i:integer;
    List: TXmlNodeList;
    XML: TNativeXml;
begin
try
 if Stream=nil then Exit;
 XML:=TNativeXml.Create;
 XML.LoadFromStream(Stream);
 Result:='';
 List:=TXmlNodeList.Create;
 XML.Root.NodesByName('link',List);
 for i:=0 to List.Count-1 do
   begin
     if List.Items[i].ReadAttributeString('rel')='next' then
       begin
         Result:=List.Items[i].ReadAttributeString('href');
         break;
       end;
   end;
finally
  FreeAndNil(List);
  FreeAndNil(XML);
end;
end;

function TGoogleContact.GroupLink(const aGroupName: string): string;
var i:integer;
begin
  Result:='';
  for i:=0 to FGroups.Count - 1 do
    begin
      if UpperCase(aGroupName)=UpperCase(FGroups[i].FTitle.Value) then
        begin
          Result:=FGroups[i].Fid;
          break
        end;
    end;
end;

function TGoogleContact.InsertPhotoEtag(aContact: TContact;
  const Response: TStream):boolean;
var XML: TNativeXML;
    i:integer;
    etag: string;
begin
Result:=false;
try
  if Response=nil then Exit;
  XML:=TNativeXml.Create;
  try
    XML.LoadFromStream(Response);
  except
    Exit;
  end;
  etag:=XML.Root.ReadAttributeString('gd:etag');
  for I := 0 to aContact.FLinks.Count - 1 do
    begin
      if aContact.FLinks[i].Ltype=CpImgRel then
        begin
          aContact.FLinks[i].Etag:=Etag;
          Result:=true;
          break;
        end;
    end;
finally
  FreeAndNil(XML)
end;
end;

procedure TGoogleContact.LoadContactsFromFile(const FileName: string);
var XML: TStringStream;
    i:integer;
begin
  try
    XML:=TStringStream.Create('',TEncoding.UTF8);
    XML.LoadFromFile(FileName);
    ParseXMLContacts(XML);
  finally
    FreeAndNil(XML)
  end;
end;

procedure TGoogleContact.ParseXMLContacts(const Data: TStream);
var XMLDoc: TNativeXML;
    i:integer;
begin
try
  if (Data=nil) then Exit;
  XMLDoc:=TNativeXml.Create;
  XMLDoc.LoadFromStream(Data);
  for i:=0 to XMLDoc.Root.NodeCount - 1 do
    if LowerCase(XMLDoc.Root.Nodes[i].Name)=LowerCase(EntryNodeName) then
      FContacts.Add(TContact.Create(XMLDoc.Root.Nodes[i]));
finally
  FreeAndNil(XMLDoc)
end;
end;

function TGoogleContact.RetriveContactPhoto(index: integer): TJPEGImage;
begin
  Result:=nil;
  if (index>=FContacts.Count)or(index<0) then Exit;
    Result:=RetriveContactPhoto(FContacts[index])
end;

function TGoogleContact.RetriveContactPhoto(aContact: TContact): TJPEGImage;
var i:integer;
begin
Result:=nil;
if aContact=nil then Exit;

  for i:=0 to aContact.FLinks.Count - 1 do
    begin
      if aContact.FLinks[i].Rel=CpPhotoLink then
        begin
          if Length(aContact.FLinks[i].Etag)>0 then
            begin
              Result:=TJPEGImage.Create;
              Result.LoadFromStream(SendRequest('GET',aContact.FLinks[i].Href,FAuth,CpProtocolVer,nil,nil));
              break;
            end;
        end;
    end;
end;

function TGoogleContact.RetriveContacts: integer;
var XMLDoc: TStringStream;
    i:integer;
    NextLink: string;
begin
try
 NextLink:=CPContactsLink;
 XMLDoc:=TStringStream.Create('',TEncoding.UTF8);
 repeat
   inc(i);
   XMLDoc.LoadFromStream(SendRequest('GET',NextLink,FAuth,CpProtocolVer, nil, nil));
   ParseXMLContacts(XMLDoc);
   XMLDoc.SaveToFile('Retrive'+IntToStr(i)+'.xml');
   NextLink:=GetNextLink(XMLDoc);
  until NextLink='';
Result:=FContacts.Count;
finally
  FreeAndNil(XMLDoc);
end;

end;

function TGoogleContact.RetriveGroups: integer;
var XMLDoc: TNativeXML;
    i:integer;
    NextLink: string;
begin
try
 NextLink:=Format(CpGroupLink,[FEmail]);
 XMLDoc:=TNativeXml.Create;
 repeat
   XMLDoc.LoadFromStream(SendRequest('GET',NextLink,FAuth,CpProtocolVer, nil, nil));
   for i:=0 to XMLDoc.Root.NodeCount - 1 do
     if XMLDoc.Root.Nodes[i].Name=EntryNodeName then
       FGroups.Add(TContactGroup.Create(XMLDoc.Root.Nodes[i]));
    NextLink:=GetNextLink(XMLDoc);
  until NextLink='';
Result:=FGroups.Count;
finally
  FreeAndNil(XMLDoc);
end;

end;

procedure TGoogleContact.SaveContactsToFile(const FileName: string);
var i:integer;
    Stream:TStringStream;
begin
  try
    Stream:=TStringStream.Create('',TEncoding.UTF8);
    Stream.WriteString('<?xml version="1.0" encoding="UTF-8" ?>');
    Stream.WriteString('<feed ');
    Stream.WriteString('xmlns="http://www.w3.org/2005/Atom" ');
    Stream.WriteString('xmlns:gd="http://schemas.google.com/g/2005" ');
    Stream.WriteString('xmlns:gContact="http://schemas.google.com/contact/2008"');
    Stream.WriteString('>');
    for I := 0 to Contacts.Count - 1 do
       Stream.WriteString(Contacts[i].GenerateText(tfXML));
    Stream.WriteString('</feed>');
    Stream.SaveToFile(FileName);
  finally
    FreeAndNil(Stream)
  end;
end;

function TGoogleContact.UpdateContact(index: integer): boolean;
begin
  Result:=false;
  if (Index>FContacts.Count)Or (FContacts[index].IsEmpty)or(Index<0) then Exit;
  UpdateContact(FContacts[index]);
  Result:=true;
end;

function TGoogleContact.UpdatePhoto(aContact: TContact;
  const PhotoFile: TFileName):boolean;
var
  i: Integer;
begin
Result:=false;
  for i:= 0 to aContact.FLinks.Count - 1 do
    begin
      if aContact.FLinks[i].Ltype=CpImgRel then
        begin
           with THTTPSend.Create do
             begin
               Headers.Add('GData-Version: '+CpProtocolVer);
               Headers.Add('Authorization: GoogleLogin auth=' + FAuth);
               MimeType := 'image/*';
               Headers.Add('If-Match: *');
               Document.LoadFromFile(PhotoFile);
               if HTTPMethod('PUT',aContact.FLinks[i].Href) then
                  Result:=InsertPhotoEtag(aContact, Document)
               else
                ShowMessage(IntToStr(ResultCode)+' '+ResultString)
             end;
          break;
        end;
    end;
end;

function TGoogleContact.UpdatePhoto(index: integer;
  const PhotoFile: TFileName):boolean;
begin
if (index>=FContacts.Count)or(index<0) then Exit;
  Result:=UpdatePhoto(FContacts[index],PhotoFile);
end;

function TGoogleContact.UpdateContact(aContact: TContact): boolean;
var Doc:TNativeXml;
begin
  Result:=false;
  if (aContact=nil)Or aContact.IsEmpty then Exit;
  if (Length(aContact.Etag)=0)  then Exit;
try
 Doc:=TNativeXml.Create;
 Doc.ReadFromString(aContact.GenerateText(tfXML));
 with THTTPSend.Create do
   begin
     Headers.Add('GData-Version: '+CpProtocolVer);
     Headers.Add('Authorization: GoogleLogin auth=' + FAuth);
     MimeType := 'application/atom+xml';
     Headers.Add('If-Match: *'{+aContact.Etag});
     Doc.SaveToStream(Document);
     if HTTPMethod('PUT',GetEditLink(aContact)) then
       begin
         Result:=ResultCode=200;
         if Result then
           aContact.ParseXML(Document);
         Document.SaveToFile('Response.xml');
       end
     else
       ShowMessage(IntToStr(ResultCode)+' '+ResultString)
   end;
finally
  FreeAndNil(Doc)
end;
end;

end.