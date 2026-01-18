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

# Makefile for  Pool of Radiance Config Borland version.
# REQUIRES Borland make, it WON'T work with GNU make.
# REQUIRES the following folders to be present:
#          bin
#          lib

# Binary target:
#   config.exe : builds the program, this is the default target.

# Other targets:
#   clean      : deletes the compiled units from the LIB folder.

#   cleanall   : implies clean; implies cleanall;
#                deletes the generated .exe file as well.

# Program generation can be controlled from the command line:

# make -DTPC         : the program is compiled using the Turbo Pascal command
#                      line compiler instead of the Borland Pascal command 
#                      line compiler.
# make -DDEBUG       : compiles a version with debug information for the
#                      IDE.
# make -DDEBUGALL    : compiles a version with debug information for the
#                      IDE. It includes Range, Stack and
#                      I/O checks (implies DEBUG).
# make -DDEBUGEXT    : compiles a version with debug information for
#                      Turbo Debugger.
# make -DDEBUGEXTALL : compiles a version with debug information for the
#                      Turbo Debugger. It includes Range, Stack and
#                      I/O checks (implies DEBUGEXT).

# Definitions can be mixed, e.g.
# make -DTPC -DEBUG
# Compiles a version with debug information for the IDE using tpc.

PATHBIN = bin
PATHLIB = lib

COMPILERCOMMON = -$E-,G-,N-,O-,B-,P+,X+,F-
DEBUGCOMMON = -$D+,L+
DEBUGALLCOMMON = -$I+,R+,S+

!if $d(DEBUGEXTALL)
COMPILERFLAGS = -E$(PATHLIB) -V -DDEBUGALL -DDEBUG $(COMPILERCOMMON) $(DEBUGCOMMON) $(DEBUGALLCOMMON)
!elif $d(DEBUGALL)
COMPILERFLAGS = -E$(PATHLIB) -DDEBUG -DDEBUGALL $(COMPILERCOMMON) $(DEBUGCOMMON) $(DEBUGALLCOMMON)
!elif $d(DEBUGEXT)
COMPILERFLAGS = -E$(PATHLIB) -V -DDEBUG $(COMPILERCOMMON) $(DEBUGCOMMON)
!elif $d(DEBUG)
!if !$d(TPC)
BROWSEREXTRA = -$Y+
!endif
COMPILERFLAGS = -E$(PATHLIB) -DDEBUG $(COMPILERCOMMON) $(DEBUGCOMMON) $(BROWSEREXTRA)
!else
!if !$d(TPC)
BROWSEREXTRA = -$Y-
!endif
COMPILERFLAGS = -E$(PATHLIB) $(COMPILERCOMMON) $(BROWSEREXTRA) -$L-,I-,R-,S-
!endif

!if $d(TPC)
COMPILER = tpc
!else
COMPILER = bpc
!endif

# Add or override commands to compiler by uncommenting the macro below
# and adding parameters to it.

#EXTRAFLAGS =

.path.inc = .
.path.pas = .
.path.exe = $(PATHBIN)
.path.tpu = $(PATHLIB)

.pas.tpu:
	$(COMPILER) $(COMPILERFLAGS) $(EXTRAFLAGS) $&.pas

.precious: config.exe

CONFIGEXEDEPENDENCIES = progmain.tpu

config.exe :: $(CONFIGEXEDEPENDENCIES)
	$(COMPILER) $(COMPILERFLAGS) $(EXTRAFLAGS) config.pas
	@copy $(PATHLIB)\config.exe $(PATHBIN)
	@del $(PATHLIB)\config.exe

progmain.tpu: mainwnd.tpu dosutil.tpu

clean:
	@del $(PATHLIB)\*.tpu

cleanall: clean
	@del $(PATHBIN)\config.exe