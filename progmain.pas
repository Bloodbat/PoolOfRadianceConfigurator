(*                          Pool of Radiance Config                           *)

(* Copyright 2026 Bloodbat / La Serpiente y la Rosa Producciones              *)

(* Pool of Radiance Config is free software: you can redistribute it and/or
   modify it under the terms of the GNU General Public License as published
   by the Free Software Foundation, either version 3 of the License, or (at
   your option) any later version.                                            *)

(* Pool of Radiance Config is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
   Public License for more details.                                           *)

(* You should have received a copy of the GNU General Public License along
   with Pool of Radiance Config. If not, see <http://www.gnu.org/licenses/>.  *)

unit ProgMain;

{$IFDEF MSDOS}
{$DEFINE DOSPROGRAM}
{$ENDIF}

{$IFDEF GO32V2}
{$DEFINE DOSPROGRAM}
{$ENDIF}

interface

uses
  Drivers, App;

type
  { TPoolRadConfig }

  TPoolRadConfig = object(TApplication)
    constructor Init;
    function ConfigFileExists: boolean;
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure InitDesktop; virtual;
    procedure InitMenuBar; virtual;
    procedure InitStatusLine; virtual;
    procedure ParseConfigFile;
    function SaveConfigFile: boolean;
    procedure SetDefaults;
  end;

implementation

uses
  Objects, Views, MainWnd, Dos, MsgBox, DosUtil;

const
  sPoolConfigFile = 'POOL.CFG';
  sProgramVersion = 'V.1.2';

  iVideoCga = 0;
  iVideoEga = 1;
  iVideoTandy = 2;

  iSoundTandy = 0;
  iSoundSpeaker = 1;
  iSoundNone = 2;

  iFullIntroCheckbox = 0;

  cPathSeparator = '\';

var
  MainWindow: PMainWindow;

  { TPoolRadConfig }

  { #todo : It would be useful adding some dialog stating config file read
    and write errors or letting the program die gracelessly on IO errors;
    but that is a task for future me. }

constructor TPoolRadConfig.Init;
var
  R: TRect;
begin
  inherited Init;
  {$IFDEF FPC}
  R := Default(TRect);
  {$ENDIF}
  GetExtent(R);
  New(MainWindow, Init(R, 'Pool of Radiance Config ' + sProgramVersion));
  InsertWindow(MainWindow);

  if ConfigFileExists then
    ParseConfigFile
  else
    SetDefaults;
end;

function TPoolRadConfig.ConfigFileExists: boolean;
begin
  ConfigFileExists := FSearch(sPoolConfigFile, '') <> '';
end;

procedure TPoolRadConfig.HandleEvent(var Event: TEvent);
begin
  begin
    case Event.What of
      evCommand:
        case Event.Command of
          cmSave:
          begin
            if SaveConfigFile then
              Message(@Self, evCommand, cmQuit, @Self);
          end;
        end;
    end;
    inherited HandleEvent(Event);
  end;
end;

procedure TPoolRadConfig.InitDesktop;
var
  R: TRect;
begin
  { Encompass the whole screen. }
  {$IFDEF FPC}
  R := Default(TRect);
  {$ENDIF}
  GetExtent(R);
  New(Desktop, Init(R));
  Desktop^.Background^.Pattern := ' ';
end;

procedure TPoolRadConfig.InitMenuBar;
begin
  { This should be empty so the menu bar is not drawn. }
end;

procedure TPoolRadConfig.InitStatusLine;
begin
  { This should be empty so the status bar is not drawn. }
end;

procedure TPoolRadConfig.ParseConfigFile;
var
  ConfigFile: Text;
  OptionChar: char;
  OptionString: string;
begin
  Assign(ConfigFile, sPoolConfigFile);
  {$I-}
  Reset(ConfigFile);
  ReadLn(ConfigFile, OptionChar);
  if IOResult = 0 then
  begin
    case OptionChar of
      'E':
      begin
        { Work around what I believe is a FreeVision bug... }
        MainWindow^.radgrpGraphics^.Sel := iVideoEga;
        MainWindow^.radgrpGraphics^.Press(iVideoEga);
      end;
      'T':
      begin
        MainWindow^.radgrpGraphics^.Sel := iVideoTandy;
        MainWindow^.radgrpGraphics^.Press(iVideoTandy);
      end;
      else
      begin
        MainWindow^.radgrpGraphics^.Sel := iVideoCga;
        MainWindow^.radgrpGraphics^.Press(iVideoCga);
      end;
    end;
    { Turbo Vision doesn't seem to like updating this with DrawView from the
      main App. }
    MainWindow^.radgrpGraphics^.DrawView;
  end;

  ReadLn(ConfigFile, OptionChar);
  if IOResult = 0 then
  begin
    case OptionChar of
      'T':
      begin
        MainWindow^.radgrpSound^.Sel := iSoundTandy;
        MainWindow^.radgrpSound^.Press(iSoundTandy);
      end;
      'P':
      begin
        MainWindow^.radgrpSound^.Sel := iSoundSpeaker;
        MainWindow^.radgrpSound^.Press(iSoundSpeaker);
      end
      else
      begin
        MainWindow^.radgrpSound^.Sel := iSoundNone;
        MainWindow^.radgrpSound^.Press(iSoundNone);
      end;
    end;
    MainWindow^.radgrpSound^.DrawView;
  end;

  ReadLn(ConfigFile, OptionString);
  if IOResult = 0 then
  begin
    MainWindow^.txtDataDir^.Data^ := OptionString;
    MainWindow^.txtDataDir^.DrawView;
  end;

  ReadLn(ConfigFile, OptionString);
  if IOResult = 0 then
  begin
    MainWindow^.txtSavedDir^.Data^ := OptionString;
    MainWindow^.txtSavedDir^.DrawView;
  end;

  ReadLn(ConfigFile, OptionChar);
  if IOResult = 0 then
  begin
    if OptionChar = 'F' then
    begin
      MainWindow^.chkbxsFullIntro^.Sel := iFullIntroCheckbox;
      MainWindow^.chkbxsFullIntro^.Press(iFullIntroCheckbox);
      MainWindow^.chkbxsFullIntro^.DrawView;
    end;
  end;
  {$IFDEF DEBUG}
  {$I+}
  {$ENDIF}
  Close(ConfigFile);
end;

function TPoolRadConfig.SaveConfigFile: boolean;
type
  TInvalidInfo = record
    Character: longint;
    Position: longint;
  end;
const
  ArrayVideoModes: array[iVideoCga..iVideoTandy] of char = (
    'C',
    'E',
    'T'
    );
  ArraySoundModes: array[iSoundTandy..iSoundNone] of char = (
    'T',
    'P',
    'S'
    );
  ArrayIntroTypes: array[0..1] of char = (
    'N',
    'F'
    );

  sErrorEmptyDataDir = 'Data directory cannot be empty!';
  sErrorEmptySavedDir = 'Saved game directory cannot be empty!';
  sErrorInvalidDataDir = 'Invalid data directory!'#13#10'Invalid character: %c'#13#10'Invalid position: %d';
  sErrorInvalidSaveDir = 'Invalid saved game directory!'#13#10'Invalid character: %c'#13#10'Invalid position: %d';
var
  ConfigFile: Text;
  SelectedOption: integer;
  OptionChar: char;

  InvalidInfo: TInvalidInfo;

  DataDir: string;
  SavedGameDir: string;
begin
  SaveConfigFile := True;

  DataDir := MainWindow^.txtDataDir^.Data^;
  SavedGameDir := MainWindow^.txtSavedDir^.Data^;

  if DataDir[Length(DataDir)] <> cPathSeparator then
    DataDir := DataDir + cPathSeparator;

  if SavedGameDir[Length(SavedGameDir)] <> cPathSeparator then
    SavedGameDir := SavedGameDir + cPathSeparator;

  if DataDir = '' then
  begin
    MessageBox(sErrorEmptyDataDir, nil, mfError or mfOKButton);
    SaveConfigFile := False;
    Exit;
  end;

  if SavedGameDir = '' then
  begin
    MessageBox(sErrorEmptySavedDir, nil, mfError or mfOKButton);
    SaveConfigFile := False;
    Exit;
  end;

  {$IFDEF FPC}
  InvalidInfo := Default(TInvalidInfo);
  {$ENDIF}

  if not IsDirNameValid(DataDir, InvalidInfo.Position, InvalidInfo.Character) then
  begin
    MessageBox(sErrorInvalidDataDir, @InvalidInfo, mfError or mfOKButton);
    SaveConfigFile := False;
    Exit;
  end;

  if not IsDirNameValid(SavedGameDir, InvalidInfo.Position,
    InvalidInfo.Character) then
  begin
    MessageBox(sErrorInvalidSaveDir, @InvalidInfo, mfError or mfOKButton);
    SaveConfigFile := False;
    Exit;
  end;

  Assign(ConfigFile, sPoolConfigFile);
  Rewrite(ConfigFile);

  SelectedOption := MainWindow^.radgrpGraphics^.Value;
  OptionChar := ArrayVideoModes[SelectedOption];
  WriteLn(ConfigFile, OptionChar);

  SelectedOption := MainWindow^.radgrpSound^.Value;
  OptionChar := ArraySoundModes[SelectedOption];
  WriteLn(ConfigFile, OptionChar);

  WriteLn(ConfigFile, DataDir);
  WriteLn(ConfigFile, SavedGameDir);

  SelectedOption := MainWindow^.chkbxsFullIntro^.Value;
  OptionChar := ArrayIntroTypes[SelectedOption];
  WriteLn(ConfigFile, OptionChar);

  Close(ConfigFile);
end;

procedure TPoolRadConfig.SetDefaults;
const
  sSuffixSavePath = 'SAVE\';

  iCurrentDrive = 0;
var
  {$IFDEF FPC}
  CurrentDir: string = '';
  OptionGraphics: byte = iVideoCga;
  OptionSound: byte = iSoundSpeaker;
  {$ELSE}
  CurrentDir: string;
  OptionGraphics: byte;
  OptionSound: byte;
  {$ENDIF}

  {$IFDEF DOSPROGRAM}
  VideoCard: TVideoCards;
  {$ENDIF}
begin
  {$IFNDEF FPC}
  OptionGraphics := iVideoCga;
  OptionSound := iSoundSpeaker;
  {$ENDIF}

  {$IFDEF DOSPROGRAM}
  VideoCard := DetectVideoCard;

  case VideoCard of
    vcEgaColor, vcVgaMono, vcVgaColor, vcMcgaMono,
    vcMcgaColor: OptionGraphics := iVideoEga;
    vcTandy:
    begin
      OptionGraphics := iVideoTandy;
      OptionSound := iSoundTandy;
    end;
    else
      OptionGraphics := iVideoCga;
  end;
  {$ENDIF}

  MainWindow^.radgrpGraphics^.Sel := OptionGraphics;
  MainWindow^.radgrpGraphics^.Press(OptionGraphics);
  MainWindow^.radgrpGraphics^.DrawView;

  MainWindow^.radgrpSound^.Sel := OptionSound;
  MainWindow^.radgrpSound^.Press(OptionSound);
  MainWindow^.radgrpSound^.DrawView;

  GetDir(iCurrentDrive, CurrentDir);
  if CurrentDir[Length(CurrentDir)] <> cPathSeparator then
    CurrentDir := CurrentDir + cPathSeparator;
  MainWindow^.txtDataDir^.Data^ := CurrentDir;
  MainWindow^.txtDataDir^.DrawView;

  CurrentDir := CurrentDir + sSuffixSavePath;
  MainWindow^.txtSavedDir^.Data^ := CurrentDir;
  MainWindow^.txtSavedDir^.DrawView;

  MainWindow^.chkbxsFullIntro^.Sel := iFullIntroCheckbox;
  MainWindow^.chkbxsFullIntro^.Press(iFullIntroCheckbox);
  MainWindow^.chkbxsFullIntro^.DrawView;
end;

end.
