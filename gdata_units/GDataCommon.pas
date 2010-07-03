unit GDataCommon;
{ TODO : ��������� ��� ������ �� �������, ����� ��������� ��������� ���������� ������ }
interface

uses NativeXML, Classes, StrUtils, SysUtils, GHelper, Variants;

const
  cGDTagNames: array [0 .. 49] of string = ('gd:country', 'gd:additionalName',
    'gd:name', 'gd:email', 'gd:extendedProperty', 'gd:geoPt', 'gd:im',
    'gd:orgName', 'gd:orgTitle', 'gd:organization', 'gd:originalEvent',
    'gd:phoneNumber', 'gd:postalAddress', 'gd:rating', 'gd:recurrence',
    'gd:reminder', 'gd:resourceId', 'gd:when', 'gd:agent', 'gd:housename',
    'gd:street', 'gd:pobox', 'gd:neighborhood', 'gd:city', 'gd:subregion',
    'gd:region', 'gd:postcode', 'gd:formattedAddress',
    'gd:structuredPostalAddress', 'gd:entryLink', 'gd:where', 'gd:familyName',
    'gd:givenName', 'gd:namePrefix', 'gd:nameSuffix', 'gd:fullName',
    'gd:orgDepartment', 'gd:orgJobDescription', 'gd:orgSymbol',
    'gd:famileName', 'gd:eventStatus', 'gd:visibility', 'gd:transparency',
    'gd:attendeeType', 'gd:attendeeStatus', 'gd:comments', 'gd:deleted',
    'gd:feedLink', 'gd:who', 'gd:recurrenceException');

type
  TgdEnum = (egdCountry, egdAdditionalName, egdName, egdEmail,
    egdExtendedProperty, egdGeoPt, egdIm, egdOrgName, egdOrgTitle,
    egdOrganization, egdOriginalEvent, egdPhoneNumber, egdPostalAddress,
    egdRating, egdRecurrence, egdReminder, egdResourceId, egdWhen, egdAgent,
    egdHousename, egdStreet, egdPobox, egdNeighborhood, egdCity, egdSubregion,
    egdRegion, egdPostcode, egdFormattedAddress, egdStructuredPostalAddress,
    egdEntryLink, egdWhere, egdFamilyName, egdGivenName, egdNamePrefix,
    egdNameSuffix, egdFullName, egdOregdepartment, egdOrgJobDescription,
    egdOrgSymbol, egdFamileName, egdEventStatus, egdVisibility,
    egdTransparency, egdAttendeeType, egdAttendeeStatus, egdComments,
    egdDeleted, egdFeedLink, egdWho, egdRecurrenceException);

type
  TGDataTags = set of TgdEnum;

type
  TEventStatus = (esCanceled, esConfirmed, esTentative);

{ DONE -o� -c������� : ��������� � ����� }
type
  TgdEventStatus = class(TPersistent)
    private
      FValue: string;
      FStatus: TEventStatus;
      const
        RelValues: array [0..2]of string=(
       'event.canceled','event.confirmed','event.tentative');
      procedure SetStatus(aStatus:TEventStatus);
    public
      Constructor Create(const ByNode:TXMLNode=nil);
      procedure ParseXML(Node: TXMLNode);
      function AddToXML(Root:TXMLNode):TXMLNode;
      property Status:TEventStatus read FStatus write SetStatus;
  end;

type
  TVisibility = (vConfidential, vDefault, vPrivate, vPublic);

{ DONE -o� -c������� : ��������� � ����� }
type
  TgdVisibility = class
    private
      FValue: string;
      FVisible: TVisibility;
      const
        RelValues: array [0..3]of string = (
    'event.confidential','event.default','event.private','event.public');
      procedure SetVisible(aVisible:TVisibility);
    public
      Constructor Create(const ByNode:TXMLNode=nil);
      procedure ParseXML(Node: TXMLNode);
      function AddToXML(Root:TXMLNode):TXMLNode;
      property Visibility: TVisibility read FVisible write SetVisible;
  end;

type
  TTransparency = (tOpaque, tTransparent);

{ DONE -o� -c������� : ��������� � ����� }
type
  TgdTransparency = class(TPersistent)
    private
      FValue: string;
      FTransparency: TTransparency;
      const
        RelValues: array [0 .. 1] of string = ('event.opaque','event.transparent');
//      procedure SetValue(aValue:string);
      procedure SetTransp(aTransp:TTransparency);
    public
      Constructor Create(const ByNode:TXMLNode=nil);
      procedure ParseXML(Node: TXMLNode);
      function AddToXML(Root:TXMLNode):TXMLNode;
//      property Value: string read FValue write SetValue;
      property Transparency: TTransparency read FTransparency write SetTransp;
  end;

type
  TAttendeeType = (aOptional, aRequired);

{ DONE -o� -c������� : ��������� � ����� }
type
  TgdAttendeeType = class
    private
      FValue: string;
      FAttType: TAttendeeType;
      const RelValues: array [0 .. 1] of string =
      ('event.optional','event.required');
//      procedure SetValue(aValue:string);
      procedure SetType(aStatus:TAttendeeType);
    public
      Constructor Create(const ByNode:TXMLNode);
      function IsEmpty:boolean;
      procedure ParseXML(Node: TXMLNode);
      function AddToXML(Root:TXMLNode):TXMLNode;
//      property Value: string read FValue write SetValue;
      property AttendeeType: TAttendeeType read FAttType write SetType;
  end;

type
  TAttendeeStatus = (asAccepted, asDeclined, asInvited, asTentative);

{ DONE -o� -c������� : ��������� � ����� }
type
  TgdAttendeeStatus = class(TPersistent)
    private
      FValue: string;
      FAttendeeStatus: TAttendeeStatus;
      const
        RelValues: array [0 .. 3] of string = (
    'event.accepted','event.declined','event.invited','event.tentative');
 //     procedure SetValue(aValue:string);
      procedure SetStatus(aStatus:TAttendeeStatus);
    public
      Constructor Create(const ByNode:TXMLNode);
      function isEmpty: boolean;
      procedure ParseXML(Node: TXMLNode);
      function AddToXML(Root:TXMLNode):TXMLNode;
//      property Value: string read FValue write SetValue;
      property Status: TAttendeeStatus read FAttendeeStatus write SetStatus;
  end;

type
  TEntryTerms = (ttAny, ttContact, ttEvent, ttMessage, ttType);

type
  TgdCountry = class(TPersistent)
    private
     FCode: string;
     FValue: string;
    public
     Constructor Create(const ByNode:TXMLNode=nil);
     function IsEmpty: boolean;
     procedure   ParseXML(Node: TXMLNode);
     function    AddToXML(Root:TXMLNode):TXMLNode;
     property Code: string read FCode write FCode;
     property Value: string read FValue write FValue;
  end;

type
  TgdAdditionalNameStruct = TTextTag;

type
  TgdFamilyName = TTextTag;
  TgdGivenName = TTextTag;
//  TgdFamileNameStruct = string;
  TgdNamePrefix = TTextTag;
  TgdNameSuffix = TTextTag;
  TgdFullName = TTextTag;
  TgdOrgDepartment = TTextTag;
  TgdOrgJobDescription = TTextTag;
  TgdOrgSymbol = TTextTag;

type
  TgdName = class
  private
    FGivenName: TTextTag;
    FAdditionalName: TTextTag;
    FFamilyName: TTextTag;
    FNamePrefix: TTextTag;
    FNameSuffix: TTextTag;
    FFullName: TTextTag;
    function GetFullName:string;
    procedure SetFullName(aFullName: TTextTag);
    procedure SetGivenName(aGivenName: TTextTag);
    procedure SetAdditionalName(aAdditionalName: TTextTag);
    procedure SetFamilyName(aFamilyName: TTextTag);
    procedure SetNamePrefix(aNamePrefix: TTextTag);
    procedure SetNameSuffix(aNameSuffix: TTextTag);
  public
    constructor Create(ByNode: TXMLNode=nil);
    procedure   ParseXML(const Node: TXmlNode);
    function IsEmpty:boolean;
    function AddToXML(Root:TXMLNode):TXmlNode;
    property GivenName: TTextTag read FGivenName write SetGivenName;
    property AdditionalName: TTextTag read FAdditionalName write SetAdditionalName;
    property FamilyName: TTextTag read FFamilyName write SetFamilyName;
    property NamePrefix: TTextTag read FNamePrefix write SetNamePrefix;
    property NameSuffix: TTextTag read FNameSuffix write FNameSuffix;
    property FullName: TTextTag read FFullName write SetFullName;
    property FullNameString: string read GetFullName;
end;

type
  TTypeElement = (ttHome,ttOther, ttWork);

type
  TgdEmail = class(TPersistent)
    private
      FAddress: string;
      FEmailType: TTypeElement;
      FLabel: string;
      FRel: string;
      FPrimary: boolean;
      FDisplayName:string;
      const RelValues: array[0..2]of string=('home','other','work');
      procedure SetRel(const aRel:string);
      procedure SetEmailType(aType:TTypeElement);
    public
      constructor Create(ByNode: TXMLNode=nil);
      procedure   ParseXML(const Node: TXmlNode);
      function AddToXML(Root:TXMLNode):TXmlNode;
      property Address : string read FAddress write FAddress;
      property Labl:string read FLabel write FLabel;
      property Rel: string read FRel write SetRel;
      property DisplayName: string read FDisplayName write FDisplayName;
      property Primary: boolean read FPrimary write FPrimary;
      property EmailType:TTypeElement read FEmailType write SetEmailType;
  end;

type
  TgdExtendedPropertyStruct = record
    Name: string;
    Value: string;
  end;

type
  TgdGeoPtStruct = record
    Elav: extended;
    Labels: string;
    Lat: extended;
    Lon: extended;
    Time: TDateTime;
  end;

type
  TIMProtocol = (tiAIM,tiMSN,tiYAHOO,tiSKYPE,tiQQ,tiGOOGLE_TALK,tiICQ,tiJABBER);
  TIMtype = (timHome,timNetmeeting,timOther,timWork);

type
  TgdIm = class(TPersistent)
  private  { DONE -o� -c������� : �������� ���� ������ �� �������� � ������� Rel, ���������� �� ������� string }
    FAddress: string;
    FLabel: string;
    FPrimary: boolean;
    FIMProtocol:TIMProtocol;
    FIMType:TIMtype;
    const
      RelValues: array[0..3]of string=('home','netmeeting','other','work');
      ProtocolValues:array[0..7]of string=('AIM','MSN','YAHOO','SKYPE','QQ','GOOGLE_TALK','ICQ','JABBER');
  public
    constructor Create(ByNode: TXMLNode=nil);
    procedure   ParseXML(const Node: TXmlNode);
    function IsEmpty: boolean;
    function AddToXML(Root:TXMLNode):TXmlNode;
    property Address: string read FAddress write FAddress;
    property iLabel: string read FLabel write FLabel;
    property ImType: TIMtype read FIMType write FIMType;
    property Protocol: TIMProtocol read FIMProtocol write FIMProtocol;
    property Primary: boolean read FPrimary write FPrimary;
end;

  TgdOrgName = TTextTag;
  TgdOrgTitle = TTextTag;

type
  TgdOrganization = class(TPersistent)
  private
     FLabel: string;
     Frel: string;
     Fprimary: boolean;
     ForgName: TgdOrgName;
     ForgTitle: TgdOrgTitle;
  public
    constructor Create(ByNode: TXMLNode=nil);
    procedure   ParseXML(const Node: TXmlNode);
    function AddToXML(Root:TXMLNode):TXmlNode;
    function IsEmpty:boolean;
    property Labl: string read FLabel write FLabel;
    property Rel: string Read FRel write FRel;
    property Primary: boolean read Fprimary write Fprimary;
    property OrgName: TgdOrgName read ForgName write ForgName;
    property OrgTitle: TgdOrgTitle read ForgTitle write ForgTitle;
end;

type
  TgdOriginalEventStruct = record
    id: string;
    href: string;
  end;

type
  TPhonesRel=(tpAssistant,tpCallback,tpCar,TpCompany_main,tpFax,
      tpHome,tpHome_fax,tpIsdn,tpMain,tpMobile,tpOther,tpOther_fax,
      tpPager,tpRadio,tpTelex,tpTty_tdd,TpWork,tpWork_fax,
      tpWork_mobile,tpWork_pager);
type
  TgdPhoneNumber = class(TPersistent)
    private     { DONE -o� -c������� : ������ ��������� ���� FRel - ��������� �������� � ����������� �� ���� }
      FPrimary: boolean;
      FPhoneType: TPhonesRel;
      FLabel: string;
    //  Frel: string;
      FUri: string;
      FValue: string;
      const RelValues: array[0..19]of string=('assistant','callback','car','company_main','fax',
      'home','home_fax','isdn','main','mobile','other','other_fax','pager',
      'radio','telex','tty_tdd','work','work_fax','work_mobile','work_pager');
  //    procedure SetRel(aPhoneRel:TPhonesRel);
    public
      constructor Create(ByNode: TXMLNode=nil);
      function IsEmpty: boolean;
      procedure   ParseXML(const Node: TXmlNode);
      function AddToXML(Root:TXMLNode):TXmlNode;
      property PhoneType: TPhonesRel read FPhoneType write FPhoneType;
      property Primary: boolean read FPrimary write FPrimary;
      property Labl: string read FLabel write FLabel;
//      property Rel: string read Frel write Frel;
      property Uri: string read FUri write FUri;
      property Text: string read FValue write FValue;
  end;

type
  TgdPostalAddressStruct = record
    Labels: string;
    rel: string;
    primary: boolean;
    Text: string;
  end;

type
  TgdRatingStruct = record
    Average: extended;
    Max: integer;
    Min: integer;
    numRaters: integer;
    rel: string;
    Value: integer;
  end;

type
  TgdRecurrence = class(TPersistent)
  private
    FText: TStringList;
  public
    Constructor Create(const ByNode:TXMLNode=nil);
    procedure ParseXML(Node: TXMLNode);
    function AddToXML(Root:TXMLNode):TXMLNode;
    property Text: TStringList read FText write FText;
end;

const
  cMethods : array [0..2]of string =('alert','email','sms');
type
  TMethod = (tmAlert, tmEmail, tmSMS);
  TRemindPeriod = (tpDays, tpHours, tpMinutes);

type
  TgdReminder = class (TPersistent)
    private
      FabsoluteTime: TDateTime;
      Fmethod:       TMethod;
      FPeriod:       TRemindPeriod;
      FPeriodValue:  integer;
    public
      Constructor Create(const ByNode:TXMLNode);
      procedure ParseXML(Node: TXMLNode);
      function  AddToXML(Root:TXMLNode):TXMLNode;
      property  AbsTime: TDateTime read FabsoluteTime write FabsoluteTime;
      property  Method: TMethod read Fmethod write Fmethod;
      property  Period: TRemindPeriod read FPeriod write FPeriod;
      property  PeriodValue:integer read FPeriodValue write FPeriodValue;
  end;

type
  TgdResourceIdStruct = string;

type
  TDateFormat = (tdDate, tdServerDate);

type
  TgdWhen = class
    private
      FendTime: TDateTime;
      FstartTime: TDateTime;
      FvalueString: string;
    public
      Constructor Create(const ByNode:TXMLNode=nil);
      function isEmpty:boolean;
      procedure ParseXML(Node: TXMLNode);
      function AddToXML(Root:TXMLNode;DateFormat:TDateFormat):TXMLNode;
      property endTime: TDateTime read FendTime write FendTime;
      property startTime: TDateTime read FstartTime write FstartTime;
      property valueString: string read FvalueString write FvalueString;
  end;

type
  TgdAgent = TTextTag;
  TgdHousename = TTextTag;
  TgdStreet = TTextTag;
  TgdPobox = TTextTag;
  TgdNeighborhood = TTextTag;
  TgdCity = TTextTag;
  TgdSubregion = TTextTag;
  TgdRegion = TTextTag;
  TgdPostcode = TTextTag;
  TgdFormattedAddress = TTextTag;

type
  TgdStructuredPostalAddress = class(TPersistent)
    private
     FRel: string;
     FMailClass: string;
     FUsage: string;
     Flabel: string;
     Fprimary: boolean;
     FAgent: TgdAgent;
     FHouseName: TgdHousename;
     FStreet: TgdStreet;
     FPobox: TgdPobox;
     FNeighborhood: TgdNeighborhood;
     FCity: TgdCity;
     FSubregion: TgdSubregion;
     FRegion: TgdRegion;
     FPostcode: TgdPostcode;
     FCountry: TgdCountry;
     FFormattedAddress: TgdFormattedAddress;
    public
      Constructor Create(const ByNode:TXMLNode=nil);
      procedure ParseXML(Node: TXMLNode);
      function AddToXML(Root:TXMLNode):TXMLNode;
      function IsEmpty: boolean;
      property Rel: string read FRel write FRel;
      property MailClass: string read FMailClass write FMailClass;
      property Usage: string read FUsage write FUsage;
      property Labl: string read Flabel write Flabel;
      property Primary: boolean read FPrimary write FPrimary;
      property Agent: TgdAgent read FAgent write FAgent;
      property HouseName: TgdHousename read FHouseName write FHouseName;
      property Street: TgdStreet read FStreet write FStreet;
      property Pobox: TgdPobox read FPobox write FPobox;
      property Neighborhood: TgdNeighborhood read FNeighborhood write FNeighborhood;
      property City: TgdCity read FCity write FCity;
      property Subregion: TgdSubregion read FSubregion write FSubregion;
      property Region: TgdRegion read FRegion write FRegion;
      property Postcode: TgdPostcode read FPostcode write FPostcode;
      property Coutry: TgdCountry read FCountry write FCountry;
      property FormattedAddress: TgdFormattedAddress read FFormattedAddress write FFormattedAddress;
  end;

type
  TgdEntryLink = class(TPersistent)
    private
      Fhref: string;
      FReadOnly: boolean;
      Frel: string;
      FAtomEntry: TXMLNode;
    public
      Constructor Create(const ByNode:TXMLNode);
      procedure ParseXML(Node: TXMLNode);
      function IsEmpty:boolean;
      function AddToXML(Root:TXMLNode):TXMLNode;
      property Href: string read Fhref write Fhref;
      property OnlyRead: boolean read FReadOnly write FReadOnly;
      property Rel: string read Frel write Frel;
  end;

type
  TgdWhere = class(TPersistent)
    private
     Flabel: string;
     Frel: string;
     FvalueString: string;
     FEntryLink: TgdEntryLink;
    public
      Constructor Create(const ByNode:TXMLNode=nil);
      procedure ParseXML(Node: TXMLNode);
      function AddToXML(Root:TXMLNode):TXMLNode;
      property Labl:string read Flabel write Flabel;
      property Rel:string read FRel write FRel;
      property valueString: string read FvalueString write FvalueString;
      property EntryLink: TgdEntryLink read FEntryLink write FEntryLink;
  end;

type
  TWhoRel = (twAttendee,twOrganizer,twPerformer,twSpeaker,twBcc,twCc,twFrom,twReply,twTo);
{ DONE -o� -c������� : ��������� ��������� � ����� }
type
  TgdWho = class(TPersistent)
  private  { DONE -o� -c������� : ���������� �� ��������� ������� }
    FEmail: string;
    Frel: string;
    FRelValue: TWhoRel;
    FvalueString: string;
    FAttendeeStatus: TgdAttendeeStatus;
    FAttendeeType: TgdAttendeeType;
    FEntryLink: TgdEntryLink;
    const
      RelValues: array [0..8] of string = (
    'event.attendee','event.organizer','event.performer','event.speaker',
    'message.bcc','message.cc','message.from','message.reply-to','message.to');
//    procedure SetRel(aRel:string);
//    procedure SetRelValue(aRelValue:TWhoRel);
  public
    Constructor Create(const ByNode:TXMLNode=nil);
    procedure ParseXML(Node: TXMLNode);
    function AddToXML(Root:TXMLNode):TXMLNode;
    property Email: string read FEmail write FEmail;
//    property Rel: string read Frel write SetRel;
    property RelValue: TWhoRel read FRelValue write FRelValue;
    property valueString: string read FvalueString write FvalueString;
    property AttendeeStatus: TgdAttendeeStatus read FAttendeeStatus write FAttendeeStatus;
    property AttendeeType: TgdAttendeeType read FAttendeeType write FAttendeeType;
    property EntryLink: TgdEntryLink read FEntryLink write FEntryLink;
end;

function GetGDNodeType(cName: string): integer;

function gdAttendeeStatus(aXMLNode: TXMLNode): TgdAttendeeStatus;
function gdAttendeeType(aXMLNode: TXMLNode): TgdAttendeeType;
function gdTransparency(aXMLNode: TXMLNode): TgdTransparency;
function gdVisibility(aXMLNode: TXMLNode): TgdVisibility;
function gdEventStatus(aXMLNode: TXMLNode): TgdEventStatus;
function gdWhere(aXMLNode: TXMLNode):TgdWhere;
function gdWhen(aXMLNode: TXMLNode):TgdWhen;
function gdWho(aXMLNode: TXMLNode):TgdWho;
function gdRecurrence(aXMLNode: TXMLNode):TgdRecurrence;
function gdReminder(aXMLNode: TXMLNode):TgdReminder;

implementation

function gdReminder(aXMLNode: TXMLNode):TgdReminder;
begin
  Result:=TgdReminder.Create(aXMLNode);
end;

function gdRecurrence(aXMLNode: TXMLNode):TgdRecurrence;
begin
  Result:=TgdRecurrence.Create(aXMLNode);
end;

function gdWho(aXMLNode: TXMLNode):TgdWho;
begin
  Result:=TgdWho.Create(aXMLNode);
end;

function gdWhen(aXMLNode: TXMLNode):TgdWhen;
begin
  Result:=TgdWhen.Create(aXMLNode);
end;

function gdWhere(aXMLNode: TXMLNode):TgdWhere;
begin
  Result:=TgdWhere.Create(aXMLNode);
end;

function gdEventStatus(aXMLNode: TXMLNode): TgdEventStatus;
begin
  Result:=TgdEventStatus.Create(aXMLNode);
end;

function gdVisibility(aXMLNode: TXMLNode): TgdVisibility;
begin
  Result:=TgdVisibility.Create(aXMLNode);
end;

function gdTransparency(aXMLNode: TXMLNode): TgdTransparency;
begin
  Result:=TgdTransparency.Create(aXMLNode);
end;

function GetGDNodeType(cName: string): integer;
begin
  Result := AnsiIndexStr(cName, cGDTagNames);
end;

function gdAttendeeType(aXMLNode: TXMLNode): TgdAttendeeType;
begin
  Result:=TgdAttendeeType.Create(aXMLNode);
end;

function gdAttendeeStatus(aXMLNode: TXMLNode): TgdAttendeeStatus;
begin
  Result:=TgdAttendeeStatus.Create(aXMLNode);
end;

{ TgdWhere }

function TgdWhere.AddToXML(Root: TXMLNode): TXMLNode;
begin
  //��������� ����
  if Root=nil then Exit;
  Result:=Root.NodeNew(cgdTagNames[ord(egdWhere)]);
  if Length(Flabel)>0 then
    Result.WriteAttributeString('label',Flabel);
  if Length(Frel)>0 then
    Result.WriteAttributeString('rel',Frel);
  if Length(FvalueString)>0 then
    Result.WriteAttributeString('valueString',FvalueString);
  if FEntryLink<>nil then
    if (FEntryLink.FAtomEntry<>nil)or(Length(FEntryLink.Fhref)>0) then
      FEntryLink.AddToXML(Result);
end;

constructor TgdWhere.Create(const ByNode: TXMLNode);
begin
inherited Create;
if ByNode=nil then Exit;
FEntryLink:=TgdEntryLink.Create(nil);
ParseXML(ByNode);
end;

procedure TgdWhere.ParseXML(Node: TXMLNode);
begin
if GetGDNodeType(Node.Name) <> ord(egdWhere) then
    raise Exception.Create(Format(rcErrCompNodes,
        [cGDTagNames[ord(egdWhere)]]));
  try
    Flabel:=Node.ReadAttributeString('label');
    if Length(FLabel)=0 then
      Flabel:=Node.ReadAttributeString('rel');
    FvalueString:=Node.ReadAttributeString('valueString');
    if Node.NodeCount>0 then //���� �������� ���� � EntryLink
      begin
        FEntryLink.ParseXML(Node.FindNode('gd:entry'));
      end;
  except
    Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

{ TgdEntryLinkStruct }

function TgdEntryLink.AddToXML(Root: TXMLNode): TXMLNode;
begin
if (Root=nil)or IsEmpty then Exit;
 Result:=Root.NodeNew(cgdTagNames[ord(egdEntryLink)]);
 if Length(Trim(Fhref))>0 then
   Result.WriteAttributeString('href',Fhref);
 if Length(Trim(Frel))>0 then
   Result.WriteAttributeString('rel',Frel);
 Result.WriteAttributeBool('readOnly',FReadOnly);
 if FAtomEntry<>nil then
   Result.NodeAdd(FAtomEntry);
end;

constructor TgdEntryLink.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  Fhref:='';
  Frel:='';
  if ByNode=nil then Exit;
  ParseXML(ByNode);
end;

function TgdEntryLink.IsEmpty: boolean;
begin
  Result:=(Length(Trim(Fhref))=0)and(Length(Trim(Frel))=0)
end;

procedure TgdEntryLink.ParseXML(Node: TXMLNode);
begin
if GetGDNodeType(Node.Name) <> ord(egdEntryLink) then
    raise Exception.Create(Format(rcErrCompNodes,
        [cGDTagNames[ord(egdEntryLink)]]));
  try
//    if Node.Attributes['href']<>null then
      Fhref:=Node.ReadAttributeString('href');
//    if Node.Attributes['rel']<>null then
      Frel:=Node.ReadAttributeString('rel');
//    if Node.Attributes['readOnly']<>null then
      FReadOnly:=Node.ReadAttributeBool('readOnly');
    if Node.NodeCount>0 then //���� �������� ���� � EntryLink
       FAtomEntry:=Node.FindNode('entry');
  except
    Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

{ TgdEventStatus }

function TgdEventStatus.AddToXML(Root: TXMLNode): TXMLNode;
begin
if Root=nil then Exit;
  Result:=Root.NodeNew(cgdTagNames[ord(egdEventStatus)]);
  Result.WriteAttributeString('value',SchemaHref+FValue);
end;

constructor TgdEventStatus.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  if ByNode=nil then Exit;
  ParseXML(ByNode);
end;

procedure TgdEventStatus.ParseXML(Node: TXMLNode);
begin
  if Node=nil then Exit;
  if GetGDNodeType(Node.Name) <> ord(egdEventStatus) then
    raise Exception.Create(Format(rcErrCompNodes,
        [cGDTagNames[ord(egdEventStatus)]]));
  try
  //  ShowMessage(Node.Attributes['value']);
    FValue:=Node.ReadAttributeString('value');
    FValue:=StringReplace(FValue,SchemaHref,'',[rfIgnoreCase]);
    FStatus:=TEventStatus(AnsiIndexStr(FValue, RelValues));
  except
    raise Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

procedure TgdEventStatus.SetStatus(aStatus: TEventStatus);
begin
  FStatus:=aStatus;
  FValue:=RelValues[ord(aStatus)]
end;

//procedure TgdEventStatus.SetValue(aValue: string);
//begin
//  if AnsiIndexStr(aValue, RelValues)<=0 then
//    raise Exception.Create(Format(rcErrMissValue, [cGDTagNames[ord(egdEventStatus)]]));
//  FStatus:=TEventStatus(AnsiIndexStr(aValue, RelValues));
//  FValue:=aValue;
//end;

{ TgdWhen }

function TgdWhen.AddToXML(Root: TXMLNode;DateFormat:TDateFormat): TXMLNode;
begin
  if (Root=nil)or isEmpty then Exit;
  Result:=Root.NodeNew(cgdTagNames[ord(egdWhen)]);
  case DateFormat of
    tdDate:Result.WriteAttributeString('startTime',FormatDateTime('yyyy-mm-dd',FstartTime));
    tdServerDate:Result.WriteAttributeString('startTime',DateTimeToServerDate(FstartTime));
  end;

  if FendTime>0 then
    Result.WriteAttributeString('endTime',DateTimeToServerDate(FendTime));
  if length(Trim(FvalueString))>0 then
    Result.WriteAttributeString('valueString',FvalueString);
end;

constructor TgdWhen.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  FendTime:=0;
  FstartTime:=0;
  FvalueString:='';
  if ByNode=nil then Exit;
  ParseXML(ByNode);
end;

function TgdWhen.isEmpty: boolean;
begin
  Result:=(FendTime<=0)and(FstartTime<=0)and(length(Trim(FvalueString))=0);
end;

procedure TgdWhen.ParseXML(Node: TXMLNode);
begin
if Node=nil then Exit;
  if GetGDNodeType(Node.Name) <> ord(egdWhen) then
    raise Exception.Create(Format(rcErrCompNodes,
        [cGDTagNames[ord(egdWhen)]]));
  try
    FendTime:=0;
    FstartTime:=0;
    FvalueString:='';
    if Node.HasAttribute('endTime') then
      FendTime:=ServerDateToDateTime(Node.ReadAttributeString('endTime'));
    FstartTime:=ServerDateToDateTime(Node.ReadAttributeString('startTime'));
    if Node.HasAttribute('valueString') then
      FvalueString:=Node.ReadAttributeString('valueString');
  except
    raise Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

{ TgdAttendeeStatus }

function TgdAttendeeStatus.AddToXML(Root: TXMLNode): TXMLNode;
begin
  if Root=nil then Exit;
  Result:=Root.NodeNew(cgdTagNames[ord(egdAttendeeStatus)]);
  Result.WriteAttributeString('value',SchemaHref+FValue);
end;

constructor TgdAttendeeStatus.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  if ByNode=nil then Exit;
  ParseXML(ByNode);
end;

function TgdAttendeeStatus.isEmpty: boolean;
begin
  Result:=Length(Trim(FValue))=0
end;

procedure TgdAttendeeStatus.ParseXML(Node: TXMLNode);
begin
if (Node=nil)or isEmpty then Exit;
  if GetGDNodeType(Node.Name) <> ord(egdAttendeeStatus) then
    raise Exception.Create(Format(rcErrCompNodes,
        [cGDTagNames[ord(egdAttendeeStatus)]]));
  try
    FValue := Node.ReadAttributeString('value');
    FValue:=StringReplace(FValue,SchemaHref,'',[rfIgnoreCase]);
    FAttendeeStatus := TAttendeeStatus(AnsiIndexStr(FValue, RelValues));
  except
    raise Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

procedure TgdAttendeeStatus.SetStatus(aStatus: TAttendeeStatus);
begin
  FAttendeeStatus:=aStatus;
  FValue:=RelValues[ord(aStatus)]
end;

//procedure TgdAttendeeStatus.SetValue(aValue: string);
//begin
//  if AnsiIndexStr(aValue, cAttendeeStatus)<=0 then
//    raise Exception.Create(Format(rcErrMissValue, [cGDTagNames[ord(egdAttendeeStatus)]]));
//  FAttendeeStatus:=TAttendeeStatus(AnsiIndexStr(aValue, cAttendeeStatus));
//  FValue:=aValue;
//end;

{ TgdAttendeeType }

function TgdAttendeeType.AddToXML(Root: TXMLNode): TXMLNode;
begin
 if (Root=nil)or IsEmpty then Exit;
  Result:=Root.NodeNew(cgdTagNames[ord(egdAttendeeType)]);
  Result.WriteAttributeString('value',SchemaHref+FValue);
end;

constructor TgdAttendeeType.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  FValue:='';
  if ByNode=nil then Exit;
  ParseXML(ByNode);
end;

function TgdAttendeeType.IsEmpty: boolean;
begin
Result:=Length(Trim(FValue))=0;
end;

procedure TgdAttendeeType.ParseXML(Node: TXMLNode);
begin
  if Node=nil then Exit;
  if GetGDNodeType(Node.Name) <> ord(egdAttendeeType) then
    raise Exception.Create(Format(rcErrCompNodes,
        [cGDTagNames[ord(egdAttendeeType)]]));
  try
    FValue:=Node.ReadAttributeString('value');
    FValue:=StringReplace(FValue,SchemaHref,'',[rfIgnoreCase]);
    FAttType := TAttendeeType(AnsiIndexStr(FValue, RelValues));
  except
    raise Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

procedure TgdAttendeeType.SetType(aStatus: TAttendeeType);
begin
  FAttType:=aStatus;
  FValue:=RelValues[ord(aStatus)]
end;

//procedure TgdAttendeeType.SetValue(aValue: string);
//begin
//  if AnsiIndexStr(aValue, cAttendeeType)<=0 then
//    raise Exception.Create(Format(rcErrMissValue, [cGDTagNames[ord(egdAttendeeType)]]));
//  FAttType:=TAttendeeType(AnsiIndexStr(aValue, cAttendeeType));
//  FValue:=aValue;
//end;

{ TgdWho }

function TgdWho.AddToXML(Root: TXMLNode): TXMLNode;
begin
  if Root=nil then Exit;
  Result:=Root.NodeNew(cgdTagNames[ord(egdWho)]);
  if Length(Trim(FEmail))>0 then
    Result.WriteAttributeString('email',FEmail);
  if Length(Trim(Frel))>0 then
    Result.WriteAttributeString('rel',SchemaHref+RelValues[ord(FRelValue)]);
  if Length(Trim(FvalueString))>0 then
    Result.WriteAttributeString('valueString',FvalueString);
    FAttendeeStatus.AddToXML(Result);
    FAttendeeType.AddToXML(Result);
    FEntryLink.AddToXML(Result);
end;

constructor TgdWho.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  FEmail:='';
//  Frel:='';
  FvalueString:='';
  if ByNode=nil then Exit;
  ParseXML(ByNode);
end;

procedure TgdWho.ParseXML(Node: TXMLNode);
var i:integer;
    s:string;
begin
  if Node=nil then Exit;
  if GetGDNodeType(Node.Name) <> ord(egdWho) then
    raise Exception.Create(Format(rcErrCompNodes,
        [cGDTagNames[ord(egdWho)]]));
  try
//    if Node.Attributes['email']<>null then
      FEmail:=Node.ReadAttributeString('email');
    if Length(Node.ReadAttributeString('rel'))>0 then
      begin
        S:=Node.ReadAttributeString('rel');
        S:=StringReplace(S,SchemaHref,'',[rfIgnoreCase]);
        FRelValue:=TWhoRel(AnsiIndexStr(S, RelValues));
      end;
    FvalueString:=Node.ReadAttributeString('valueString');
    if Node.NodeCount>0 then
      begin
        for I := 0 to Node.NodeCount-1 do
          case GetGDNodeType(Node.Nodes[i].Name) of
            ord(egdAttendeeStatus):
              FAttendeeStatus:=TgdAttendeeStatus.Create(Node.Nodes[i]);
            ord(egdAttendeeType):
              FAttendeeType:=TgdAttendeeType.Create(Node.Nodes[i]);
            ord(egdEntryLink):
              FEntryLink:=TgdEntryLink.Create(Node.Nodes[i]);
          end;
      end;
  except
    raise Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

//procedure TgdWho.SetRel(aRel: string);
//begin
//if AnsiIndexStr(aRel, cWhoRel)<=0 then
//    raise Exception.Create(Format(rcErrMissValue, [cGDTagNames[ord(egdWho)]]));
//  FRelValue:=TWhoRel(AnsiIndexStr(aRel, cWhoRel));
//  Frel:=aRel;
//end;

//procedure TgdWho.SetRelValue(aRelValue: TWhoRel);
//begin
//  FRelValue:=aRelValue;
// // Frel:=cWhoRel[ord(aRelValue)]
//end;

{ TgdRecurrence }

function TgdRecurrence.AddToXML(Root: TXMLNode): TXMLNode;
begin
if Root=nil then Exit;
  Result:=Root.NodeNew(cgdTagNames[ord(egdRecurrence)]);
  Result.ValueAsString:=FText.Text;
end;

constructor TgdRecurrence.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  FText:=TStringList.Create;
  if ByNode=nil then Exit;
  ParseXML(ByNode);
end;

procedure TgdRecurrence.ParseXML(Node: TXMLNode);
begin
if Node=nil then Exit;
  if GetGDNodeType(Node.Name) <> ord(egdRecurrence) then
    raise Exception.Create(Format(rcErrCompNodes,
        [cGDTagNames[ord(egdRecurrence)]]));
  try
    FText.Text:=Node.ValueAsString;
  except
    raise Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

{ TgdReminder }

function TgdReminder.AddToXML(Root:TXMLNode): TXMLNode;
begin
  if Root=nil then Exit;
  Result:=Root.NodeNew(cgdTagNames[ord(egdReminder)]);
  Result.WriteAttributeString('method',cMethods[ord(Fmethod)]);
  case FPeriod of
    tpDays: Result.WriteAttributeInteger('days',FPeriodValue);
    tpHours: Result.WriteAttributeInteger('hours',FPeriodValue);
    tpMinutes: Result.WriteAttributeInteger('minutes',FPeriodValue);
  end;
  if FabsoluteTime>0 then
    Result.WriteAttributeString('absoluteTime',DateTimeToServerDate(FabsoluteTime))
end;

constructor TgdReminder.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  FabsoluteTime:=0;
  if ByNode=nil then Exit;
  ParseXML(ByNode);
end;

procedure TgdReminder.ParseXML(Node: TXMLNode);
begin
if Node=nil then Exit;
  if GetGDNodeType(Node.Name) <> ord(egdReminder) then
    raise Exception.Create(Format(rcErrCompNodes,
        [cGDTagNames[ord(egdReminder)]]));
  try
    if Length(Node.ReadAttributeString('absoluteTime'))>0 then
      FabsoluteTime:=ServerDateToDateTime(Node.ReadAttributeString('absoluteTime'));
    if length(Node.ReadAttributeString('method'))>0 then
       Fmethod:=TMethod(AnsiIndexStr(Node.ReadAttributeString('method'), cMethods));
    if Node.AttributeIndexByname('days')>=0 then
       FPeriod:=tpDays;
    if Node.AttributeIndexByname('hours')>=0 then
       FPeriod:=tpHours;
    if Node.AttributeIndexByname('minutes')>=0 then
       FPeriod:=tpMinutes;
    case FPeriod of
      tpDays: FPeriodValue:=Node.ReadAttributeInteger('days');
      tpHours: FPeriodValue:=Node.ReadAttributeInteger('hours');
      tpMinutes: FPeriodValue:=Node.ReadAttributeInteger('minutes');
    end;

  except
    raise Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

{ TgdTransparency }

function TgdTransparency.AddToXML(Root: TXMLNode): TXMLNode;
begin
if Root=nil then Exit;
Result:=Root.NodeNew(cgdTagNames[ord(egdTransparency)]);
Result.WriteAttributeString('value',SchemaHref+FValue);
end;

constructor TgdTransparency.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  if ByNode=nil then Exit;
  ParseXML(ByNode);
end;

procedure TgdTransparency.ParseXML(Node: TXMLNode);
begin
 if Node=nil then Exit;
  if GetGDNodeType(Node.Name) <> ord(egdTransparency) then
    raise Exception.Create(Format(rcErrCompNodes,
        [cGDTagNames[ord(egdTransparency)]]));
  try
    FValue := Node.ReadAttributeString('value');
    FValue:=StringReplace(FValue,SchemaHref,'',[rfIgnoreCase]);
    FTransparency := TTransparency(AnsiIndexStr(FValue, RelValues));
  except
    raise Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

procedure TgdTransparency.SetTransp(aTransp: TTransparency);
begin
  FTransparency:=aTransp;
  FValue:=RelValues[ord(aTransp)]
end;

//procedure TgdTransparency.SetValue(aValue: string);
//begin
//if AnsiIndexStr(aValue, cTransparency)<=0 then
//    raise Exception.Create(Format(rcErrMissValue, [cGDTagNames[ord(egdTransparency)]]));
//  FTransparency:=TTransparency(AnsiIndexStr(aValue, cTransparency));
//  FValue:=aValue;
//end;

{ TgdVisibility }

function TgdVisibility.AddToXML(Root: TXMLNode): TXMLNode;
begin
if Root=nil then Exit;
Result:=Root.NodeNew(cgdTagNames[ord(egdVisibility)]);
Result.WriteAttributeString('value',SchemaHref+FValue);
end;

constructor TgdVisibility.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  if ByNode=nil then Exit;
  ParseXML(ByNode);
end;

procedure TgdVisibility.ParseXML(Node: TXMLNode);
begin
 if Node=nil then Exit;
  if GetGDNodeType(Node.Name) <> ord(egdVisibility) then
    raise Exception.Create(Format(rcErrCompNodes,
        [cGDTagNames[ord(egdVisibility)]]));
  try
    FValue := Node.ReadAttributeString('value');
    FValue:=StringReplace(FValue,SchemaHref,'',[rfIgnoreCase]);
    FVisible := TVisibility(AnsiIndexStr(FValue, RelValues));
  except
    raise Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

//procedure TgdVisibility.SetValue(aValue: string);
//begin
//if AnsiIndexStr(aValue, RelValues)<=0 then
//    raise Exception.Create(Format(rcErrMissValue, [cGDTagNames[ord(egdVisibility)]]));
//  FVisible:=TVisibility(AnsiIndexStr(aValue, RelValues));
//  FValue:=aValue;
//end;

procedure TgdVisibility.SetVisible(aVisible: TVisibility);
begin
  FVisible:=aVisible;
  FValue:=RelValues[ord(aVisible)]
end;

{ TgdOrganization }

function TgdOrganization.AddToXML(Root: TXMLNode): TXmlNode;
begin
if (Root=nil)or IsEmpty then Exit;


Result:=Root.NodeNew(cGDTagNames[ord(egdOrganization)]);
if Trim(FRel)<>'' then
  Result.WriteAttributeString('rel',FRel);
if Trim(FLabel)<>'' then
  Result.WriteAttributeString('label',FLabel);
if FPrimary then
  Result.WriteAttributeBool('primary',Fprimary);
if Trim(ForgName.Value)<>'' then
  ForgName.AddToXML(Result);
if Trim(ForgTitle.Value)<>'' then
  ForgTitle.AddToXML(Result);
end;

constructor TgdOrganization.Create(ByNode: TXMLNode);
begin
  inherited Create;
   ForgName:=TgdOrgName.Create;
   ForgTitle:=TgdOrgTitle.Create;
   FLabel:='';
   Frel:='';
  if ByNode<>nil then
    ParseXML(ByNode);

end;

function TgdOrganization.IsEmpty: boolean;
begin
   Result:=(Length(Trim(FLabel))=0)and(Length(Trim(Frel))=0)and(ForgName.IsEmpty)and(ForgTitle.IsEmpty)
end;

procedure TgdOrganization.ParseXML(const Node: TXmlNode);
var i:integer;
begin
if (Node=nil)or IsEmpty then Exit;
  if GetGDNodeType(Node.Name) <> ord(egdOrganization) then
    raise Exception.Create(Format(rcErrCompNodes,
        [cGDTagNames[ord(egdOrganization)]]));
  try
    Frel:=Node.ReadAttributeString('rel');
    if Node.HasAttribute('primary') then
      Fprimary:=Node.ReadAttributeBool('primary');
    if Node.HasAttribute('label') then
      FLabel:=Node.ReadAttributeString('label');
    for i:=0 to Node.NodeCount-1 do
      begin
        if LowerCase(Node.Nodes[i].Name)=LowerCase(cGDTagNames[ord(egdOrgName)]) then
          ForgName:=TgdOrgName.Create(Node.Nodes[i])
        else
          if LowerCase(Node.Nodes[i].Name)=LowerCase(cGDTagNames[ord(egdOrgTitle)]) then
            ForgTitle:=TgdOrgTitle.Create(Node.Nodes[i]);
      end;
  except
    raise Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

{ TgdEmailStruct }

function TgdEmail.AddToXML(Root: TXMLNode): TXmlNode;
begin
  if Root=nil then Exit;
  Result:=Root.NodeNew(cGDTagNames[ord(egdEmail)]);
  if Trim(FRel)<>'' then
    Result.WriteAttributeString('rel',FRel);
  if Trim(FLabel)<>'' then
    Result.WriteAttributeString('label',FLabel);
  if Trim(FLabel)<>'' then
    Result.WriteAttributeString('displayName',FDisplayName);
  if FPrimary then
    Result.WriteAttributeBool('primary',FPrimary);
  Result.WriteAttributeString('address',FAddress);
end;

constructor TgdEmail.Create(ByNode: TXMLNode);
begin
  inherited Create;
  if ByNode<>nil then
    ParseXML(ByNode);
end;

procedure TgdEmail.ParseXML(const Node: TXmlNode);
begin
  if Node=nil then Exit;
  if GetGDNodeType(Node.Name) <> ord(egdEmail) then
    raise Exception.Create(Format(rcErrCompNodes,
        [cGDTagNames[ord(egdEmail)]]));
  try
    Frel:=Node.ReadAttributeString('rel');
    if Node.HasAttribute('primary') then
      Fprimary:=Node.ReadAttributeBool('primary');
    if Node.HasAttribute('label') then
      FLabel:=Node.ReadAttributeString('label');
    if Node.HasAttribute('displayName') then
      FDisplayName:=Node.ReadAttributeString('displayName');
    FAddress:=Node.ReadAttributeString('address');
  except
    raise Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

procedure TgdEmail.SetEmailType(aType: TTypeElement);
begin
FEmailType:=aType;
SetRel(RelValues[ord(aType)]);
end;

procedure TgdEmail.SetRel(const aRel: string);
begin
  if AnsiIndexStr(aRel,RelValues)<0 then
   raise Exception.Create
      (Format(rcErrWriteNode, [cGDTagNames[ord(egdEmail)]])+' '+Format(rcWrongAttr,['rel']));
  FRel:=SchemaHref+aRel;
end;

{ TgdNameStruct }

function TgdName.AddToXML(Root: TXMLNode): TXmlNode;
begin
  if (Root=nil)or IsEmpty then Exit;

  Result:=Root.NodeNew(cGDTagNames[ord(egdName)]);
  if (AdditionalName<>nil)and(not AdditionalName.IsEmpty) then
    AdditionalName.AddToXML(Result);

  if (GivenName<>nil)and(not GivenName.IsEmpty) then
    GivenName.AddToXML(Result);
  if (FamilyName<>nil)and(not FamilyName.IsEmpty) then
    FamilyName.AddToXML(Result);
  if (not NamePrefix.IsEmpty) then
    NamePrefix.AddToXML(Result);
  if not NameSuffix.IsEmpty then
    NameSuffix.AddToXML(Result);
  if not FullName.IsEmpty then
    FullName.AddToXML(Result);
end;

constructor TgdName.Create(ByNode: TXMLNode);
begin
  inherited Create;
  FGivenName:=TgdGivenName.Create('gd:givenName');
  FAdditionalName:=TgdAdditionalNameStruct.Create('gd:additionalName');
  FFamilyName:=TgdFamilyName.Create('gd:familyName');
  FNamePrefix:=TgdNamePrefix.Create('gd:namePrefix');
  FNameSuffix:=TgdNameSuffix.Create('gd:nameSuffix');
  FFullName:=TgdFullName.Create('gd:fullName');
  if ByNode<>nil then
    ParseXML(ByNode);
end;

function TgdName.GetFullName: string;
begin
  if FFullName<>nil then
    Result:=FFullName.Value;
end;

function TgdName.IsEmpty: boolean;
begin
Result:= FGivenName.IsEmpty and FAdditionalName.IsEmpty and
         FFamilyName.IsEmpty and FNamePrefix.IsEmpty and
         FNameSuffix.IsEmpty and FFullName.IsEmpty;
end;

procedure TgdName.ParseXML(const Node: TXmlNode);
var i:integer;
begin
  if Node=nil then Exit;
  if GetGDNodeType(Node.Name) <> ord(egdName) then
    raise Exception.Create(Format(rcErrCompNodes,
        [cGDTagNames[ord(egdName)]]));
  try
    for i:=0 to Node.NodeCount-1 do
      begin
        case GetGDNodeType(Node.Nodes[i].Name) of
          ord(egdGivenName):FGivenName.ParseXML(Node.Nodes[i]);
          ord(egdAdditionalName):FAdditionalName.ParseXML(Node.Nodes[i]);
          ord(egdFamilyName):FFamilyName.ParseXML(Node.Nodes[i]);
          ord(egdNamePrefix):FNamePrefix.ParseXML(Node.Nodes[i]);
          ord(egdNameSuffix):FNameSuffix.ParseXML(Node.Nodes[i]);
          ord(egdFullName):FFullName.ParseXML(Node.Nodes[i]);
        end;
      end;
  except
    raise Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

procedure TgdName.SetAdditionalName(aAdditionalName: TTextTag);
begin
if aAdditionalName=nil then Exit;
if length(FAdditionalName.Name)=0 then
  FAdditionalName.Name:='gd:additionalName';
FAdditionalName.Value:=aAdditionalName.Value;
end;

procedure TgdName.SetFamilyName(aFamilyName: TTextTag);
begin
if aFamilyName=nil then Exit;
if length(FFamilyName.Name)=0 then
  FFamilyName.Name:='gd:familyName';
FFamilyName.Value:=aFamilyName.Value;
end;

procedure TgdName.SetFullName(aFullName: TTextTag);
begin
if aFullName=nil then Exit;
if length(FFullName.Name)=0 then
  FFullName.Name:='gd:fullName';
FFullName.Value:=aFullName.Value;
end;

procedure TgdName.SetGivenName(aGivenName: TTextTag);
begin
if aGivenName=nil then Exit;
if length(FGivenName.Name)=0 then
  FGivenName.Name:='gd:givenName';
FFullName.Value:=aGivenName.Value;
end;

procedure TgdName.SetNamePrefix(aNamePrefix: TTextTag);
begin
if aNamePrefix=nil then Exit;
if length(FNamePrefix.Name)=0 then
  FNamePrefix.Name:='gd:namePrefix';
FNamePrefix.Value:=aNamePrefix.Value;
end;

procedure TgdName.SetNameSuffix(aNameSuffix: TTextTag);
begin
 if aNameSuffix=nil then Exit;
if length(FNameSuffix.Name)=0 then
  FNameSuffix.Name:='gd:nameSuffix';
FNameSuffix.Value:=aNameSuffix.Value;
end;

{ TgdPhoneNumber }

function TgdPhoneNumber.AddToXML(Root: TXMLNode): TXmlNode;
begin
  if (Root=nil)or IsEmpty then Exit;
  Result:=Root.NodeNew(cGDTagNames[ord(egdPhoneNumber)]);
  Result.WriteAttributeString('rel',SchemaHref+RelValues[ord(FPhoneType)]);
  Result.ValueAsString:=FValue;
  if Trim(FLabel)<>'' then
    Result.WriteAttributeString('label',FLabel);
  if Trim(FUri)<>'' then
    Result.WriteAttributeString('uri',FUri);
  if FPrimary then
    Result.WriteAttributeBool('primary',FPrimary);
end;

constructor TgdPhoneNumber.Create(ByNode: TXMLNode);
begin
  inherited Create;
  FLabel:='';
  FUri:='';
  FValue:='';
  if ByNode<>nil then
    ParseXML(ByNode);
end;

function TgdPhoneNumber.IsEmpty: boolean;
begin
  Result:=(Length(Trim(FLabel))=0)and(Length(Trim(FUri))=0)and(Length(Trim(FValue))=0)
end;

procedure TgdPhoneNumber.ParseXML(const Node: TXmlNode);
var s:string;
begin
  if Node=nil then Exit;
  if GetGDNodeType(Node.Name) <> ord(egdPhoneNumber) then
    raise Exception.Create(Format(rcErrCompNodes,
        [cGDTagNames[ord(egdPhoneNumber)]]));
  try
    s:=Node.ReadAttributeString('rel');
    s:=StringReplace(s,SchemaHref,'',[rfIgnoreCase]);
    if AnsiIndexStr(s,RelValues)>-1 then
      FPhoneType:=TPhonesRel(AnsiIndexStr(s,RelValues))
    else
      FPhoneType:=tpOther;
    if Node.HasAttribute('primary') then
      Fprimary:=Node.ReadAttributeBool('primary');
    if Node.HasAttribute('label') then
      FLabel:=Node.ReadAttributeString('label');
    if Node.HasAttribute('uri') then
      FUri:=Node.ReadAttributeString('uri');
    FValue:=Node.ValueAsString;
  except
    raise Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

//procedure TgdPhoneNumber.SetRel(aPhoneRel: TPhonesRel);
//begin
//  FPhoneType:=aPhoneRel;
//end;

{ TgdCountry }

function TgdCountry.AddToXML(Root: TXMLNode): TXMLNode;
begin
 if (Root=nil)or IsEmpty then Exit;
 Result:=Root.NodeNew(cGDTagNames[ord(egdCountry)]);
 if Trim(FCode)<>'' then
   Result.WriteAttributeString('code',FCode);
 Result.ValueAsString:=FValue;
end;

constructor TgdCountry.Create(const ByNode: TXMLNode);
begin
  inherited Create;
  FCode:='';
  FValue:='';
  if ByNode<>nil then
    ParseXML(ByNode);
end;

function TgdCountry.IsEmpty: boolean;
begin
Result:=(Length(Trim(FCode))=0)and (Length(Trim(FValue))=0);
end;

procedure TgdCountry.ParseXML(Node: TXMLNode);
begin
  if Node=nil then Exit;
  if GetGDNodeType(Node.Name) <> ord(egdCountry) then
    raise Exception.Create(Format(rcErrCompNodes,
        [cGDTagNames[ord(egdCountry)]]));
  try
    FCode:=Node.ReadAttributeString('rel');
    FValue:=Node.ValueAsString;
  except
    raise Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

{ TgdStructuredPostalAddressStruct }

function TgdStructuredPostalAddress.AddToXML(Root: TXMLNode): TXMLNode;
begin
  if (Root=nil) or IsEmpty then Exit;
  Result:=Root.NodeNew(cGDTagNames[ord(egdStructuredPostalAddress)]);
  if Trim(FRel)<>'' then
     Result.WriteAttributeString('rel',FRel);
  if Trim(FMailClass)<>'' then
     Result.WriteAttributeString('mailClass',FMailClass);
  if Trim(Flabel)<>'' then
     Result.WriteAttributeString('label',Flabel);
  if Trim(FUsage)<>'' then
     Result.WriteAttributeString('Usage',FUsage);
  if Fprimary then
     Result.WriteAttributeBool('primary',Fprimary);
  if FAgent<>nil then
     FAgent.AddToXML(Result);
  if FHousename<>nil then
     FHousename.AddToXML(Result);
  if FStreet<>nil then
     FStreet.AddToXML(Result);
  if FPobox<>nil then
     FPobox.AddToXML(Result);
  if FNeighborhood<>nil then
     FNeighborhood.AddToXML(Result);
  if FCity<>nil then
     FCity.AddToXML(Result);
  if FSubregion<>nil then
     FSubregion.AddToXML(Result);
  if FRegion<>nil then
     FRegion.AddToXML(Result);
  if FPostcode<>nil then
     FPostcode.AddToXML(Result);
  if FCountry<>nil then
     FCountry.AddToXML(Result);
  if FFormattedAddress<>nil then
     FFormattedAddress.AddToXML(Result);
end;

constructor TgdStructuredPostalAddress.Create(const ByNode: TXMLNode);
begin
 inherited Create;
 FRel:='';
 FMailClass:='';
 FUsage:='';
 Flabel:='';
 FAgent:=TgdAgent.Create;
 FHouseName:=TgdHousename.Create;
 FStreet:=TgdStreet.Create;
 FPobox:=TgdPobox.Create;
 FNeighborhood:=TgdNeighborhood.Create;
 FCity:=TgdCity.Create;
 FSubregion:=TgdSubregion.Create;
 FRegion:=TgdRegion.Create;
 FPostcode:=TgdPostcode.Create;
 FCountry:=TgdCountry.Create;
 FFormattedAddress:=TgdFormattedAddress.Create;
 if ByNode<>nil then
   ParseXML(ByNode);
end;

function TgdStructuredPostalAddress.IsEmpty: boolean;
begin
Result:=(Length(Trim(FRel))=0)and (Length(Trim(FMailClass))=0)and
(Length(Trim(FUsage))=0)and(Length(Trim(Flabel))=0)and
FAgent.IsEmpty and
FHouseName.IsEmpty and
FStreet.IsEmpty and
FPobox.IsEmpty and
FNeighborhood.IsEmpty and
FCity.IsEmpty and
FSubregion.IsEmpty and
FRegion.IsEmpty and
FPostcode.IsEmpty and
FCountry.IsEmpty and
FFormattedAddress.IsEmpty;
end;

procedure TgdStructuredPostalAddress.ParseXML(Node: TXMLNode);
var i:integer;
begin
if Node=nil then Exit;
  if GetGDNodeType(Node.Name) <> ord(egdStructuredPostalAddress) then
    raise Exception.Create(Format(rcErrCompNodes,
        [cGDTagNames[ord(egdStructuredPostalAddress)]]));
  try
    FRel:=Node.ReadAttributeString('rel');
    FMailClass:=Node.ReadAttributeString('mailClass');
    Flabel:=Node.ReadAttributeString('label');
    if Node.HasAttribute('primaty') then
      Fprimary:=Node.ReadAttributeBool('primary');
    FUsage:=Node.ReadAttributeString('Usage');
  except
    raise Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
  for I := 0 to Node.NodeCount - 1 do
    begin
      case GetGDNodeType(Node.Nodes[i].Name) of
        ord(egdAgent):FAgent.ParseXML(Node.Nodes[i]);
        ord(egdHousename):FHousename.ParseXML(Node.Nodes[i]);
        ord(egdStreet):FStreet.ParseXML(Node.Nodes[i]);
        ord(egdPobox):FPobox.ParseXML(Node.Nodes[i]);
        ord(egdNeighborhood):FNeighborhood.ParseXML(Node.Nodes[i]);
        ord(egdCity):FCity.ParseXML(Node.Nodes[i]);
        ord(egdSubregion):FSubregion.ParseXML(Node.Nodes[i]);
        ord(egdRegion):FRegion.ParseXML(Node.Nodes[i]);
        ord(egdPostcode):FPostcode.ParseXML(Node.Nodes[i]);
        ord(egdCountry):FCountry.ParseXML(Node.Nodes[i]);
        ord(egdFormattedAddress):FFormattedAddress.ParseXML(Node.Nodes[i]);
      end;
    end;
end;

{ TgdIm }

function TgdIm.AddToXML(Root: TXMLNode): TXmlNode;
begin
  if (Root=nil)or IsEmpty then Exit;
  Result:=Root.NodeNew(cGDTagNames[ord(egdIm)]);

  Result.WriteAttributeString('rel',SchemaHref+RelValues[ord(FIMType)]);
  Result.WriteAttributeString('address',FAddress);
  Result.WriteAttributeString('label',FLabel);
  Result.WriteAttributeString('protocol',SchemaHref+ProtocolValues[ord(FIMProtocol)]);
  if FPrimary then
    Result.WriteAttributeBool('primary',FPrimary);
end;

constructor TgdIm.Create(ByNode: TXMLNode);
begin
  inherited Create;
  FAddress:='';
  FLabel:='';
  if ByNode<>nil then
    ParseXML(ByNode);
end;

function TgdIm.IsEmpty: boolean;
begin
  Result:=(Length(Trim(FAddress))=0)and(Length(Trim(FLabel))=0)
end;

procedure TgdIm.ParseXML(const Node: TXmlNode);
var s:string;
begin
if Node=nil then Exit;
  if GetGDNodeType(Node.Name) <> ord(egdIm) then
    raise Exception.Create(Format(rcErrCompNodes,[cGDTagNames[ord(egdIm)]]));
  try
    s:=Node.ReadAttributeString('rel');
    s:=StringReplace(s,SchemaHref,'',[rfIgnoreCase]);
    FIMType:=TImtype(AnsiIndexStr(s,RelValues));
    FLabel:=Node.ReadAttributeString('label');
    FAddress:=Node.ReadAttributeString('address');
    s:=Node.ReadAttributeString('protocol');
    s:=StringReplace(s,SchemaHref,'',[rfIgnoreCase]);
    if AnsiIndexStr(s,ProtocolValues)>-1 then
      FIMProtocol:=TIMProtocol(AnsiIndexStr(s,ProtocolValues))
    else
      FIMProtocol:=tiGOOGLE_TALK;
    if Node.HasAttribute('primary') then
      FPrimary:=Node.ReadAttributeBool('primary');
  except
     raise Exception.Create(Format(rcErrPrepareNode, [Node.Name]));
  end;
end;

end.
