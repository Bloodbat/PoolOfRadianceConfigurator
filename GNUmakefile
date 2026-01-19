#                      Pool of Radiance Config

# Copyright 2026 Bloodbat / La Serpiente y la Rosa Producciones

# Pool of Radiance Config is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.

# Pool of Radiance Config is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
# Public License for more details.

# You should have received a copy of the GNU General Public License along
# with Pool of Radiance Config. If not, see <http://www.gnu.org/licenses/>.

# Makefile for Pool of Radiance Config for Free Pascal for GO32V2.
# Some quick edits will configure it to build for other platforms.

# REQUIRES Free Pascal compiler or crosscompiler for GO32V2.
# REQUIRES GNU Make: this makefile WON'T work with Borland Make.

# Binary target
#   bin/config.exe : builds the program, this is the default
#                    target.

# Other targets:
#   clean          : deletes the compiled units from the LIB
#                    folder.

#   cleanall       : implies clean; deletes the generated binary
#                    as well.

# Program generation can be controlled from the command line:
# Available platforms: DOS, WINDOWS, NIX.

# * The NIX platform stands in for both Linux and Unix.

# make             :  attempts to detect the current architecture and
#                  :  build a binary for it.
# make DOS=1       :  tries to build a go32v2 protected mode binary.
# make WINDOWS=1   :  tries to build a binary for 32-bit Windows.
# make NIX=1       :  tries to build a binary for Linux or UNIX
#                  :  (depends on the host platform for the compiler).

# Generation of debug information can be controlled by the make file as well:

# DEBUG=1    : compiles a version with debug information for GDB.
# DEBUGALL=1 : implies DEBUG=1 and also includes Range, Stack and
#              I/O checks.

#Examples
# make DEBUG=1
# Tries to detect the current architecture and compiles a version with debug
# information for GDB for it.

# make WINDOWS=1 DEBUGALL=1
# Compiles a version with GDB debug information, Stack, Range and
# I/O checks for Windows 32-bit.

# ---------------------------------------------------------------------------

# Don't override command line!
ifneq ($(or $(DOS),$(WINDOWS),$(NIX)),1)

# Try to figure out host OS
ISWINDOWS := $(findstring Windows,$(MAKE_HOST))
ISDOS := $(findstring msdos,$(MAKE_HOST))

ifeq ($(ISDOS), msdos)
undefine WINDOWS
DOS = 1
undefine NIX
else
ifeq ($(ISWINDOWS), Windows)
undefine DOS
WINDOWS = 1
undefine NIX
else
undefine DOS
undefine WINDOWS
NIX = 1
endif
endif

endif

ifdef DOS
.SUFFIXES: .ppu .pas .exe
DOSPATHS = 1
BINARYNAME = config.exe
else
ifdef WINDOWS
.SUFFIXES: .ppu .pas .exe
DOSPATHS = 1
BINARYNAME = config.exe
else
.SUFFIXES: .ppu .pas
undefine DOSPATHS
BINARYNAME = config
endif
endif

PATHBIN = bin
PATHLIB = lib

#Set environment variable EXTRAFLAGS with any options you'd like to add

PFLAGS = -FE$(PATHBIN) -FU$(PATHLIB) -Fu$(PATHLIB) -FcCP437 -Mfpc -Sgi

ifdef DOS
PFLAGS += -Cp80386
endif

COMPILEROPTS = -CPPACKENUM=1 -Si -Rintel

BINDIR = $(addsuffix /, $(PATHBIN))
LIBDIR = $(addsuffix /, $(PATHLIB))

fixpaths = $(subst /,/,$1)
ifdef DOSPATHS
fixpaths = $(subst /,\,$1)
EXEEXTENSION = .exe
endif

PC = fpc$(EXEEXTENSION)

ifdef DEBUG
PFLAGS += -O1 -gl
WITHDEBUG = 1
endif

ifdef DEBUGALL
PFLAGS += -CirotR
WITHDEBUG = 1
endif

ifndef WITHDEBUG
PFLAGS += -CX -O3 -Xs -XX
endif

$(LIBDIR)%.ppu : %.pas
	$(PC) $(PFLAGS) $(EXTRAFLAGS) $<

UNITEXTENSION = ppu

PFLAGS += $(COMPILEROPTS)

$(BINDIR)$(BINARYNAME): config.pas $(LIBDIR)progmain.$(UNITEXTENSION) | $(PATHBIN)	
	$(PC) $(PFLAGS) $(EXTRAFLAGS) -o$(BINARYNAME) config.pas
	$(copydata)

$(LIBDIR)progmain.ppu: $(LIBDIR)mainwnd.ppu $(LIBDIR)dosutil.ppu | $(PATHLIB)

$(PATHBIN):
	-mkdir bin

$(PATHLIB):
	-mkdir lib

.PHONY: clean
clean:
	-rm $(LIBDIR)*.ppu
	-rm $(LIBDIR)*.o
	-rm $(LIBDIR)*.or

.PHONY: cleanall
cleanall: clean
	-rm $(BINDIR)$(BINARYNAME)

.PHONY: makezip
makezip: $(BINDIR)$(BINARYNAME)
	cp README.TXT bin
	cd $(PATHBIN) && zip -9 -X poolcfg.zip $(BINARYNAME) README.TXT && rm README.TXT