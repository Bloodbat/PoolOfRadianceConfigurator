unit DosUtil;

{$IFDEF FPC}
{$mode fpc}
{$ENDIF}

interface

uses
  Dos;

type
  TVideoCards = (vcNone, vcMda, vcCga, vcEgaMono, vcEgaColor, vcVgaMono,
    vcVgaColor, vcMcgaMono, vcMcgaColor, vcTandy);

function DetectVideoCard: TVideoCards;

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

end.
