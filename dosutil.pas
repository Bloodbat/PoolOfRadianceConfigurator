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

unit DosUtil;

interface

uses
  Dos;

type
  TVideoCards = (vcNone, vcMda, vcCga, vcEgaMono, vcEgaColor, vcVgaMono,
    vcVgaColor, vcMcgaMono, vcMcgaColor, vcTandy);

function DetectVideoCard: TVideoCards;
function IsDirNameValid(const DirName: string; var InvalidPosition: longint;
  var InvalidChar: longint): boolean;

implementation

function DetectVideoCard: TVideoCards;
const
  bBiosVideoGetEgaInfo = $10;
  bBiosVideoInterrupt = $10; { BIOS video interrupt. }
  bBiosGetEquipmentList = $11;
  bBiosVideoAlternateFunction = $12; { BIOS video alternate function select. }
  bVGAIdentifyAdapter = $1A; { VGA identify adapter function. }
  bTandyRomBiosId = $21;
var
  EquipmentCode: byte;
  Regs: Registers;
begin
  if mem[$F000:$C000] = bTandyRomBiosId then
    DetectVideoCard := vcTandy
  else
  begin
    Regs.AH := bVGAIdentifyAdapter;
    Regs.AL := $00;
    Intr(bBiosVideoInterrupt, Regs);
    if Regs.AL = bVGAIdentifyAdapter then
    begin
      case Regs.BL of
        $00: DetectVideoCard := vcNone;
        $01: DetectVideoCard := vcMda;
        $02: DetectVideoCard := vcCga;
        $04: DetectVideoCard := vcEgaColor;
        $05: DetectVideoCard := vcEgaMono;
        $07: DetectVideoCard := vcVgaMono;
        $08: DetectVideoCard := vcVgaColor;
        $0A, $0C: DetectVideoCard := vcMcgaColor;
        $0B: DetectVideoCard := vcMcgaMono;
        else
          DetectVideoCard := vcCga;
      end;
    end
    else
    begin
      Regs.AH := bBiosVideoAlternateFunction;
      Regs.BX := bBiosVideoGetEgaInfo;
      Intr(bBiosVideoInterrupt, Regs);
      if Regs.BX <> bBiosVideoGetEgaInfo then  { Unchanged BX means no EGA. }
      begin
        Regs.AH := bBiosVideoAlternateFunction;
        Regs.BL := bBiosVideoGetEgaInfo;
        Intr(bBiosVideoInterrupt, Regs);
        if Regs.BH = 0 then
          DetectVideoCard := vcEgaColor
        else
          DetectVideoCard := vcEgaMono;
      end
      else
      begin
        Intr(bBiosGetEquipmentList, Regs);
        EquipmentCode := (Regs.AL and $30) shr $04;
        if (EquipmentCode = $03) then
          DetectVideoCard := vcMda
        else
          DetectVideoCard := vcCga;
      end;
    end;
  end;
end;

function IsDirNameValid(const DirName: string; var InvalidPosition: longint;
  var InvalidChar: longint): boolean;
type
  TCharacters = set of char;
const
  InvalidCharacters: TCharacters =
    [#0, ' ', '"', '*', '+', ',', '/', ';', '<', '=', '>', '?', '[',
    ']', '|', #128..#255];
  cColon = ':';
var
  CurrentChar: char;
  i: integer;
begin
  IsDirNameValid := True;
  for i := 1 to Length(DirName) do
  begin
    CurrentChar := DirName[i];
    if (i > 2) and (CurrentChar = cColon) then
    begin
      InvalidPosition := i;
      InvalidChar := Ord(cColon);
      IsDirNameValid := False;
      Break;
    end;

    if CurrentChar in InvalidCharacters then
    begin
      InvalidPosition := i;
      InvalidChar := Ord(CurrentChar);
      IsDirNameValid := False;
      Break;
    end;
  end;
end;

end.
