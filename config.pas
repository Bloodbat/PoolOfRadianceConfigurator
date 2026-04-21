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

program Config;

uses
  {$IFDEF FPC}
  {$IFDEF GO32V2}
  dpmiexcp,
  {$ENDIF}
  {$ENDIF}
  FPUsrScr,
  ProgMain;

var
  PoolRadConfig: TPoolRadConfig;

begin
  {$IFDEF GO32V2}
  djgpp_set_ctrl_c(False);
  {$ENDIF}
  {$IFDEF FPC}
  {$IFNDEF MSDOS}
  InitUserScreen;
  {$ENDIF}
  {$ENDIF}
  PoolRadConfig.Init;
  PoolRadConfig.Run;
  PoolRadConfig.Done;
  {$IFDEF FPC}
  {$IFNDEF MSDOS}
  DoneUserScreen;
  {$ENDIF}
  {$ENDIF}
  {$IFDEF GO32V2}
  djgpp_set_ctrl_c(True);
  {$ENDIF}
end.
