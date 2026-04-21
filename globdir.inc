  { --- Special OS settings --- }
  {$ifdef Go32V2}
  {$DEFINE NOVESA}
  { NOVESA conditional avoids use of
    vesa unit, it also disables USE_GRAPH_SWITCH
    conditional, in order to obtain a go32v2 excutable that
    doesn't require full screen switching
    at startup on Windows OS }
  {$ifndef NOVESA}
  {$define SUPPORTVESA}
  {$endif ndef NOVESA}
  {$define FSCaseInsensitive}
  {$ifndef NOVESA}
  {$define USE_GRAPH_SWITCH}
  {$endif not NOVESA}
  {$endif}

  {$ifdef Linux}
  {$undef SUPPORTVESA}
  {$endif}

  {$ifdef FreeBSD}
  {$undef SUPPORTVESA}
  {$endif}

  {$ifdef NetBSD}
  {$undef SUPPORTVESA}
  {$endif}

  {$ifdef OpenBSD}
  {$undef SUPPORTVESA}
  {$endif}

  {$ifdef Windows}
  {$undef SUPPORTVESA}
  {$define FSCaseInsensitive}
  {$endif}

  {$ifdef OS2}
  {$define FSCaseInsensitive}
  {$endif}

  {$ifdef Amiga}
  {$define FSCaseInsensitive}
  {$endif}

  {$ifdef MorphOS}
  {$define FSCaseInsensitive}
  {$endif}

  {$ifdef AROS}
  {$define FSCaseInsensitive}
  {$endif}

  { --- Include VESA support --- }
  {$ifdef SUPPORTVESA}
  {$ifndef FV20}
  {$define VESA}
  {$endif}
  {$endif}

  { ----------- define DOS for DOS targets ---------- }
  {$ifdef GO32V2}{$define DOS}{$endif}

  {$define Undo}

  {$ifndef ver2_0}
  {$define USERESSTRINGS}
  {$endif}
  {$define USE_FREEVISION}
  {$define HASOUTLINE}

  { Use inlining for small functions }
  {$inline on}
  {.$define USEINLINE}

  {$define TEST_PARTIAL_SYNTAX}

  {$ifdef SUPPORTVESA}
  {$define VESA}
  {$endif}

  {$ifdef FPC_ARMEL}
  {$define FPC_ARMEL32}
  {$endif FPC_ARMEL}
  {$ifdef FPC_ARMEB}
  {$define FPC_ARMEB32}
  {$endif FPC_ARMEB}
  {$ifdef FPC_OARM}
  {$define FPC_ARMEL32}
  {$endif FPC_OARM}
  {$ifdef FPC_ARMHF}
  {$define FPC_ARMEL32}
  {$endif FPC_ARMHF}
