; ----------------------------------------------------------------------------
; "LICENCE BEERWARE" (Révision 42):
; La Communauté Française a créé ce fichier. Tant que vous conservez cet avertissement,
; vous pouvez faire ce que vous voulez de ce truc. Si on se rencontre un jour et
; que vous pensez que ce truc vaut le coup, vous pouvez me payer une bière en
; retour.
; ----------------------------------------------------------------------------
;
; Basé sur le travail de la communauté pour le Mod en version 1.5.3
;

#define GameVersion "1.5.3"
#define MinorVersion "0"
#define MyAppName "Traduction Française de Mount & Blade 2 Bannerlord"
#define MyAppPublisher "Communauté Française de Mount & Blade"
#define MyAppURL "https://www.nexusmods.com/mountandblade2bannerlord/mods/2051?tab=description"



[Setup]
AppId={{6FD55994-A440-41A0-91C7-8003E4AB602D}
VersionInfoVersion={#GameVersion}.{#MinorVersion}
AppName={#MyAppName}
AppVersion={#GameVersion}.{#MinorVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL=https://www.nexusmods.com/mountandblade2bannerlord/mods/2051
AppUpdatesURL={#MyAppURL}
DefaultDirName={code:MNBDIR}
DirExistsWarning=no
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputBaseFilename=MNB II MOD FR {#GameVersion}.{#MinorVersion}
SetupIconFile=MNB2.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
LicenseFile=Licence.txt
UninstallFilesDir={app}\Modules\FrenchTranslation
UsePreviousAppDir=false

[Languages]
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Files]
Source: "{app}\GUI\GauntletUI\Fonts\Languages.xml"; DestDir: "{app}\GUI\GauntletUI\Fonts\";DestName: "Languages.xml.ori"; Flags: external skipifsourcedoesntexist onlyifdoesntexist uninsneveruninstall
Source: "GUI\*"; DestDir: "{app}\GUI"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "Modules\*"; DestDir: "{app}\Modules"; Flags: ignoreversion recursesubdirs createallsubdirs

[UninstallDelete]
Type: filesandordirs; Name: "{app}\Modules\FrenchTranslation"
Type: dirifempty; Name: "{app}\Modules\Native\ModuleData\Languages\FR"
Type: dirifempty; Name: "{app}\Modules\SandBox\ModuleData\Languages\FR"
Type: dirifempty; Name: "{app}\Modules\SandBoxCore\ModuleData\Languages\FR"
Type: dirifempty; Name: "{app}\Modules\StoryMode\ModuleData\Languages\FR"

[Code]
function GetEpicDir(const FileName, Section: string): string;
var
  LineCount: Integer;
  SectionLine: Integer;    
  Lines: TArrayOfString;
  TempString: String;
  FinalString: String;
  DividerPosition: Integer;
  I,bscount   : Integer;
begin
  Result := '';
  if LoadStringsFromFile(FileName, Lines) then
  begin
    LineCount := GetArrayLength(Lines);
    for SectionLine := 0 to LineCount - 1 do
    begin
      if (pos('"InstallLocation":', Lines[SectionLine]) <> 0) then
      begin
        DividerPosition := Pos(':', Lines[SectionLine]);
        TempString := Copy(Lines[SectionLine],DividerPosition+3,Length(Lines[SectionLine])-(DividerPosition+4));
        TempString := ExpandConstant(TempString);
        StringChangeEx(TempString, '\\', '\', True);
        bscount := 0;
        for I := Length(TempString) downto 1 do begin
         if TempString[I] = '\' then
          begin
          Inc(bscount);
          if bscount = 1 then
            begin
            TempString := Copy(TempString,1,I-1);
            break;
            end;
          end;
        end;
        FinalString := TempString + '\Chickadee';
        Result := FinalString;
        Exit;
      end;
    end;
  end;
end;

function GetNumber(var temp: String): Integer;
var
  part: String;
  pos1: Integer;
begin
  if Length(temp) = 0 then
  begin
    Result := -1;
    Exit;
  end;
    pos1 := Pos('.', temp);
    if (pos1 = 0) then
    begin
      Result := StrToInt(temp);
    temp := '';
    end
    else
    begin
    part := Copy(temp, 1, pos1 - 1);
      temp := Copy(temp, pos1 + 1, Length(temp));
      Result := StrToInt(part);
    end;
end;
 
function CompareInner(var temp1, temp2: String): Integer;
var
  num1, num2: Integer;
begin
    num1 := GetNumber(temp1);
  num2 := GetNumber(temp2);
  if (num1 = -1) or (num2 = -1) then
  begin
    Result := 0;
    Exit;
  end;
      if (num1 > num2) then
      begin
        Result := 1;
      end
      else if (num1 < num2) then
      begin
        Result := -1;
      end
      else
      begin
        Result := CompareInner(temp1, temp2);
      end;
end;

function MNBDIR( Default: String): String;
var
  Path: String;
  EpicConfig: String;
  EpicBaseDir: String;
  StrValue: String;
begin
Result := ExpandConstant( '{autopf}' )
  if RegKeyExists(HKLM64, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 261550') then
    begin
     if RegQueryStringValue(HKLM64, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 261550', 'InstallLocation', Path) then
      begin
        Result := Path;
      end
      else
        begin
        EpicConfig := 'C:\ProgramData\Epic\UnrealEngineLauncher\LauncherInstalled.dat';
        if FileOrDirExists( EpicConfig ) then
          begin
          EpicBaseDir := GetEpicDir(EpicConfig, StrValue);   
          if Not(VarIsNull(EpicBaseDir)) then
            begin
            Result := EpicBaseDir;
            end;
          end;
        end;
    end;
end;

function VersionCheck (const MNBVersionFile: string): Integer;
var
  LineCount: Integer;
  SectionLine: Integer;    
  Lines: TArrayOfString;
  FinalString: String;
  DividerPosition: Integer;
  CurrentMNDVersion,CurrentVersion: String;
begin
    Result := -1;
    if LoadStringsFromFile(MNBVersionFile, Lines) then
      begin
      LineCount := GetArrayLength(Lines);
      for SectionLine := 0 to LineCount - 1 do
        begin
        Log('File line ' + lines[SectionLine] );
        if (pos('Version value', Lines[SectionLine]) <> 0) then
          begin
          DividerPosition := Pos('=', Lines[SectionLine]);
          FinalString := Copy(Lines[SectionLine],DividerPosition+4,Length(Lines[SectionLine])-(DividerPosition+6));
          Log('Version = ' +FinalString );
          CurrentVersion := ExpandConstant('{#GameVersion}') ;
          Log('Version = ' +CurrentVersion );
          Result := CompareInner(FinalString,CurrentVersion);
          Exit;
          end;
        end;
      end;
end;

function IsModable(const FileName: string): Boolean;
var
  StrValue: Integer;
begin
  StrValue := VersionCheck(FileName);
  if ( StrValue = 1 ) then
  begin
     Log ( 'Patch non applicable' );
     Result := false;
     exit;
  end;
  Result := true;
end;


function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  VersionFile: string;
begin
  VersionFile := ExpandConstant('{app}') + '\Modules\Native\SubModule.xml' ;
  Log( 'Fichier = ' + VersionFile );
  if FileOrDirExists( VersionFile ) then
    begin
     Log( 'Fichier2 = ' + VersionFile );
    if Not IsModable(VersionFile) then
      begin
      if SuppressibleMsgBox('Attention, La traduction est dans une version anterieure à celle du jeu, voulez vous arreter l`installation ?', mbConfirmation, MB_YESNO, IDNO) = IDYES then
        Result := 'Arreté par l`utilisateur, Veuillez verifier la version du jeu ou téléchargez une version plus récente de la traduction sur Nexusmods';
      end;
    end
    else
      begin
        Result := 'Verification de la version du jeu impossible. Il faut selectionner la racine du jeu.' + #13#10 +#13#10 +'Exemple : C:\Program Files (x86)\Steam\steamapps\common\Mount & Blade II Bannerlord' + #13#10 + #13#10 +'Debug : ' + ExpandConstant('{app}');
      end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  OldFile: string;
begin
  case CurUninstallStep of    
    usPostUninstall:
      begin
        OldFile := ExpandConstant('{app}\GUI\GauntletUI\Fonts\Languages.xml.ori');
        if FileExists(OldFile) then
          RenameFile(OldFile, ExpandConstant('{app}\GUI\GauntletUI\Fonts\Languages.xml'));
      end;
  end;
end;