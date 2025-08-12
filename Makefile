#---------------------------------------------------------------------------------
# Clear the implicit built in rules
#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------
ifeq ($(strip $(PSL1GHT)),)
$(error "Please set PSL1GHT in your environment. export PSL1GHT=<path>")
endif

include $(PSL1GHT)/ppu_rules

#---------------------------------------------------------------------------------
# TARGET is the name of the output
# BUILD is the directory where object files & intermediate files will be placed
# SOURCES is a list of directories containing source code
# INCLUDES is a list of directories containing extra header files
# PKGFILES is directories containing files for pkg
# ICON0 the image for XMB
# SFOXML for build PARAM.SFO
#---------------------------------------------------------------------------------
TARGET		:=	SNC3
BUILD		:=	build
SOURCES	+=	\
			Oxygen/lemonscript/source/lemon \
			Oxygen/lemonscript/source/lemon/compiler \
			Oxygen/lemonscript/source/lemon/compiler/backend \
			Oxygen/lemonscript/source/lemon/compiler/frontend \
			Oxygen/lemonscript/source/lemon/compiler/parser \
			Oxygen/lemonscript/source/lemon/program \
			Oxygen/lemonscript/source/lemon/runtime \
			Oxygen/lemonscript/source/lemon/runtime/provider \
			Oxygen/lemonscript/source/lemon/translator \
			Oxygen/lemonscript/source/lemon/utility \
			Oxygen/oxygenengine/source/oxygen \
			Oxygen/oxygenengine/source/oxygen/application \
			Oxygen/oxygenengine/source/oxygen/application/audio \
			Oxygen/oxygenengine/source/oxygen/application/input \
			Oxygen/oxygenengine/source/oxygen/application/gameview \
			Oxygen/oxygenengine/source/oxygen/application/menu \
			Oxygen/oxygenengine/source/oxygen/application/modding \
			Oxygen/oxygenengine/source/oxygen/application/overlays \
			Oxygen/oxygenengine/source/oxygen/application/video \
			Oxygen/oxygenengine/source/oxygen/download \
			Oxygen/oxygenengine/source/oxygen/drawing \
			Oxygen/oxygenengine/source/oxygen/drawing/opengl \
			Oxygen/oxygenengine/source/oxygen/drawing/software \
			Oxygen/oxygenengine/source/oxygen/file \
			Oxygen/oxygenengine/source/oxygen/helper \
			Oxygen/oxygenengine/source/oxygen/platform \
			Oxygen/oxygenengine/source/oxygen/rendering \
			Oxygen/oxygenengine/source/oxygen/rendering/opengl \
			Oxygen/oxygenengine/source/oxygen/rendering/opengl/shaders \
			Oxygen/oxygenengine/source/oxygen/rendering/parts/palette \
			Oxygen/oxygenengine/source/oxygen/rendering/parts \
			Oxygen/oxygenengine/source/oxygen/rendering/software \
			Oxygen/oxygenengine/source/oxygen/rendering/sprite \
			Oxygen/oxygenengine/source/oxygen/rendering/utils \
			Oxygen/oxygenengine/source/oxygen/resources \
			Oxygen/oxygenengine/source/oxygen/simulation \
			Oxygen/oxygenengine/source/oxygen/simulation/analyse \
			Oxygen/oxygenengine/source/oxygen/simulation/bindings \
			Oxygen/oxygenengine/source/oxygen/simulation/debug \
			Oxygen/oxygenengine/source/oxygen/simulation/sound \
			Oxygen/oxygenengine/source/oxygen_netcore \
			Oxygen/oxygenengine/source/oxygen_netcore/network \
			Oxygen/oxygenengine/source/oxygen_netcore/network/internal \
			Oxygen/sonic3air/source/sonic3air \
			Oxygen/sonic3air/source/sonic3air/_nativized \
			Oxygen/sonic3air/source/sonic3air/audio \
			Oxygen/sonic3air/source/sonic3air/client \
			Oxygen/sonic3air/source/sonic3air/client/crowdcontrol \
			Oxygen/sonic3air/source/sonic3air/data \
			Oxygen/sonic3air/source/sonic3air/generator \
			Oxygen/sonic3air/source/sonic3air/helper \
			Oxygen/sonic3air/source/sonic3air/menu \
			Oxygen/sonic3air/source/sonic3air/menu/context \
			Oxygen/sonic3air/source/sonic3air/menu/entries \
			Oxygen/sonic3air/source/sonic3air/menu/helper \
			Oxygen/sonic3air/source/sonic3air/menu/mods \
			Oxygen/sonic3air/source/sonic3air/menu/options \
			Oxygen/sonic3air/source/sonic3air/menu/overlays \
			Oxygen/sonic3air/source/sonic3air/resources \
			Oxygen/sonic3air/source/sonic3air/scriptimpl \
			librmx/source/rmxbase/_jsoncpp \
			librmx/source/rmxbase \
			librmx/source/rmxbase/base \
			librmx/source/rmxbase/bitmap \
			librmx/source/rmxbase/file \
			librmx/source/rmxbase/math \
			librmx/source/rmxbase/memory \
			librmx/source/rmxbase/tools \
			librmx/source/rmxext_oggvorbis \
			librmx/source/rmxmedia \
			librmx/source/rmxmedia/audiovideo \
			librmx/source/rmxmedia/file \
			librmx/source/rmxmedia/font \
			librmx/source/rmxmedia/framework \
			librmx/source/rmxmedia/opengl \
			librmx/source/rmxmedia/threads \
			framework/external/zlib/zlib \
			framework/external/zlib/zlib/contrib/minizip
INCLUDES  += \
				/Oxygen/lemonscript/source \
				/Oxygen/oxygenengine/source \
				/Oxygen/sonic3air/source \
				/librmx/source \
			    /framework/external/zlib/zlib \
			    /framework/external/zlib/zlib/contrib/minizip
PKGFILES	:=	../pkgfiles1
ICON0		:=	$(PKGFILES)/ICON0.PNG
SFOXML		:=	../sfo1.xml

TITLE		:=	Sonic 3 A.I.R
APPID		:=	SNC300AIR
CONTENTID	:=	UP0001-$(APPID)_00-SNC3ANGELINSLAND

CFLAGS		=	-D__PS3__ -Wall -mcpu=cell $(MACHDEP) $(INCLUDE) $(INCLUDE)
CXXFLAGS	=	$(CFLAGS) -std=c++17 -Wno-psabi

LDFLAGS		=	-Wl,--gc-sections -s -Wl,--strip-all -Wl,--sort-common=descending $(MACHDEP) -Wl,-Map,$(notdir $@).map

#---------------------------------------------------------------------------------
# any extra libraries we wish to link with the project
#---------------------------------------------------------------------------------
LIBS		+=	$(shell pkg-config --libs sdl2 ogg vorbis theora vorbisfile theoradec) -lnet -lsysutil -lsysmodule

#---------------------------------------------------------------------------------
# list of directories containing libraries, this must be the top level containing
# include and lib
#---------------------------------------------------------------------------------
LIBDIRS	:=	$(PORTLIBS)

#---------------------------------------------------------------------------------
# no real need to edit anything past this point unless you need to add additional
# rules for different file extensions
#---------------------------------------------------------------------------------
ifneq ($(BUILD),$(notdir $(CURDIR)))
#---------------------------------------------------------------------------------

export OUTPUT	:=	$(CURDIR)/$(TARGET)

export VPATH	:=	$(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) \

export DEPSDIR	:=	$(CURDIR)/$(BUILD)

export BUILDDIR	:=	$(CURDIR)/$(BUILD)

#---------------------------------------------------------------------------------
# automatically build a list of object files for our project
#---------------------------------------------------------------------------------
CFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(subst PublicFunctions.c,,${wildcard $(dir)/*.c})))
CPPFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(subst xmltest.cpp,,${wildcard $(dir)/*.cpp})))
sFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
SFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.S)))

#---------------------------------------------------------------------------------
# use CXX for linking C++ projects, CC for standard C
#---------------------------------------------------------------------------------
ifeq ($(strip $(CPPFILES)),)
	export LD	:=	$(CC)
else
	export LD	:=	$(CXX)
endif

export OFILES	:=	$(addsuffix .o,$(BINFILES)) \
					$(CPPFILES:.cpp=.o) $(CFILES:.c=.o) \
					$(sFILES:.s=.o) $(SFILES:.S=.o)

#---------------------------------------------------------------------------------
# build a list of include paths
#---------------------------------------------------------------------------------
export INCLUDE	:=	$(foreach dir,$(INCLUDES), -I$(CURDIR)/$(dir)) \
					$(foreach dir,$(LIBDIRS),-I$(dir)/include) \
					$(LIBPSL1GHT_INC) \
					-I$(CURDIR)/$(BUILD)

#---------------------------------------------------------------------------------
# build a list of library paths
#---------------------------------------------------------------------------------
export LIBPATHS	:=	$(foreach dir,$(LIBDIRS),-L$(dir)/lib) \
					$(LIBPSL1GHT_LIB)

export OUTPUT	:=	$(CURDIR)/$(TARGET)
.PHONY: $(BUILD) clean

#---------------------------------------------------------------------------------
$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

#---------------------------------------------------------------------------------
clean:
	@echo clean ...
	@rm -fr $(BUILD) *.elf *.self *.pkg

#---------------------------------------------------------------------------------
pkg:	$(BUILD) $(OUTPUT).pkg

#---------------------------------------------------------------------------------
else

DEPENDS	:=	$(OFILES:.o=.d)

#---------------------------------------------------------------------------------
# main targets
#---------------------------------------------------------------------------------
$(OUTPUT).self: $(OUTPUT).elf
$(OUTPUT).elf:	$(OFILES)

#---------------------------------------------------------------------------------
# This rule links in binary data with the .bin extension
#---------------------------------------------------------------------------------
%.bin.o	:	%.bin
#---------------------------------------------------------------------------------
	@echo $(notdir $<)
	@$(bin2o)

-include $(DEPENDS)
#---------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------