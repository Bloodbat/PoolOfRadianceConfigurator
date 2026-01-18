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

unit MainWnd;

{$IFDEF MSDOS}
{$DEFINE DOSPROGRAM}
{$ENDIF}

{$IFDEF GO32V2}
{$DEFINE DOSPROGRAM}
{$ENDIF}

interface

uses
  Drivers, Objects, Views, Dialogs;

const
  cmSaveAndQuit = 100;
  cmSave = 1000;

type
  PMainWindow = ^TMainWindow;

  { TMainWindow }

  TMainWindow = object(TDialog)
    btnCancel: PButton;
    btnOk: PButton;
    txtSavedDir: PInputLine;
    txtDataDir: PInputLine;
    radgrpSound: PRadioButtons;
    radgrpGraphics: PRadioButtons;
    chkbxsFullIntro: PCheckBoxes;
    constructor Init(var Bounds: TRect; ATitle: TTitleStr);
    procedure HandleEvent(var Event: TEvent); virtual;
  end;

implementation

constructor TMainWindow.Init(var Bounds: TRect; ATitle: TTitleStr);
var
  Control: PView;
  R: TRect;
begin
  inherited Init(Bounds, ATitle);
  Flags := 0; { None, we want nothing. }

  Options := Options and (not ofFramed);

  R.Assign(3, 4, 33, 5);
  Control := New(PRadioButtons,
    Init(R, NewSItem('~C~GA', NewSItem('~E~GA', NewSItem('~T~andy', nil)))));
  Insert(Control);
  radgrpGraphics := PRadioButtons(Control);
  radgrpGraphics^.Options := radgrpGraphics^.Options or ofFramed;

  R.Assign(2, 2, 17, 3);
  Control := New(PLabel, Init(R, '~G~raphics Mode', Control));
  Insert(Control);

  R.Assign(55, 4, 77, 5);
  Control := New(PCheckBoxes, Init(R, NewSItem('Play ~F~ull Intro', nil)));
  Control^.Options := Control^.Options or (ofFramed);
  Insert(Control);
  chkbxsFullIntro := PCheckBoxes(Control);

  R.Assign(54, 2, 69, 3);
  Control := New(PLabel, Init(R, '~I~ntro Control', Control));
  Insert(Control);

  R.Assign(3, 10, 52, 11);
  Control := New(PRadioButtons,
    Init(R, NewSItem('~3~ Voice Tandy', NewSItem('~P~C Speaker',
    NewSItem('~N~o Sound', nil)))));
  Insert(Control);
  radgrpSound := PRadioButtons(Control);
  radgrpSound^.Options := radgrpSound^.Options or ofFramed;

  R.Assign(2, 8, 16, 9);
  Control := New(PLabel, Init(R, 'Sound ~O~utput', Control));
  Insert(Control);

  R.Assign(3, 14, 78, 15);
  Control := New(PInputLine, Init(R, 255));
  Insert(Control);
  txtDataDir := PInputLine(Control);

  R.Assign(2, 13, 18, 14);
  Control := New(PLabel, Init(R, '~D~ata Directory', Control));
  Insert(Control);

  R.Assign(3, 17, 78, 18);
  Control := New(PInputLine, Init(R, 255));
  Insert(Control);
  txtSavedDir := PInputLine(Control);

  R.Assign(2, 16, 24, 17);
  Control := New(PLabel, Init(R, '~S~aved Game Directory', Control));
  Insert(Control);

  R.Assign(38, 20, 58, 22);
  Control := New(PButton, Init(R, 'Abort and ~Q~uit', cmCancel, bfNormal));
  Insert(Control);
  btnCancel := PButton(Control);

  R.Assign(58, 20, 78, 22);
  Control := New(PButton, Init(R, '~W~rite and Exit', cmSaveAndQuit, bfNormal));
  Insert(Control);
  btnOk := PButton(Control);

  radgrpGraphics^.Select;
end;

procedure TMainWindow.HandleEvent(var Event: TEvent);
var
  SaveEvent: TEvent;
begin
  inherited HandleEvent(Event);
  case Event.What of
    evCommand:
      case Event.Command of
        cmCancel: EndModal(cmQuit);
        cmSaveAndQuit:
        begin
          SaveEvent.What := evCommand;
          SaveEvent.Command := cmSave;
          SaveEvent.InfoPtr := nil;
          PutEvent(SaveEvent);
        end;
      end;
  end;
end;

end.
