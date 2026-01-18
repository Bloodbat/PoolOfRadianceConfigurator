# Pool of Radiance Configurator

A configuration editor for the DOS version of Pool of Radiance.

Almost every game in the Gold Box series can be reconfigured by deleting the main configuration file or using a dedicated program; this is not so for the first game: Pool of Radiance, it has to either be reinstalled (not that easy considering the CD-ROM or online releases don't include floppy images to actually install the game from scratch and do a proper configuration) or the simple text file must be edited by hand (easy; but a bit opaque what the letters do and what they control).

The Wizardworks version includes a conf.exe program that selects inconvenient defaults and, also, produces broken configuration files: the way resources are located by the game does not append a directory separator to the directories set in the configuration file, so the game fails to load saved games or asks for non-existant floppy disks when using such a broken file.

The recent online releases don't include a configuration editor at all, that makes moving installations or selecting better options (such as Tandy sound) inconvenient.

Enter Pool of Radiance Configurator.

![Pool of Radiance Configurator](pics/screenie.png)

This simple program offers a mouse or keyboard driven TUI to create or edit the Pool of Radiance configuration file.

# Usage

Just drop config.exe into your Pool of Radiance directory and run it.

- If an existing configuration file is found, it is loaded and game options can be edited to taste.

- If no configuration file exists, the program tries to detect good defaults for your machine and selects them. The defaults set by the program can be easily edited.

- If you forgot to add a path separator: "\" to the paths you set in the "Data Directory" and "Saved Game Directory" boxes, make sure to add it!

- The program will write the config file when the "Write and Exit" button is clicked, or the Alt-W keys are pressed.

- The program will exit without saving changes when the "Abort and Quit" button is clicked, or the Alt-Q or ESC keys are pressed.

- The GOG version (and probably others from internet vendors) just dump the saved games along with the game files, so you probably want to remove the "\SAVE" portion of the "Saved Game Directory" box.

# Compiling

The program is written in Free Pascal (almost like the original game!) and Free / Turbo Vision (unlike the original game).

Several options for compiling exist:

- The program can be cross-compiled for real mode DOS using Windows or Linux (this is a limitation of the Free Pascal compiler), the compiled version available in the Releases page here was produced using this method.

- The program can be compiled using actual or emulated DOS with the Free Pascal compiler; but it will produce a protected mode executable that requires cwsdpmi.exe and emu387.dxe for machines without a math co-processor (again, a Free Pascal compiler limitation).

- The program can also be compiled using Turbo Pascal 7 or Borland Pascal 7 without changes (Turbo Vision 2 is required, Turbo Pascal 7 and Borland Pascal 7 include it)

As you can see, there are options aplenty.

- Convenient batch files and makefiles are included:

  - makefprm.bat calls GNU make with makefile.i86 and produces a cross-compiled real mode executable using the Windows DOS real mode cross-compiler.

  - makego32.bat calls GNU make with makefile.go3 and produces a protected mode executable from the DOS Free Pascal compiler or a Windows cross-compiler.
 
  - makeborl.bat calls Borland make with makefile.mak and produces a real mode executable using the Borland Pascal command line compiler.
 
  - The batch files are a convenience: the make files can be used by calling make directly from, say, Linux.

  - Linux shell scripts for cross-compiling will be added later.
 
  - Take a look in the make files for some additional options such as using the Turbo Pascal command line compiler instead of the Borland Pascal one.
 
 - A Lazarus project is also included, it contains convenient build modes for compiling DOS targets (real and protected mode); editing the sources, and debugging the non-DOS exclusive parts of the program easily under Windows or Linux.
