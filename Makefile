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
			Oxygen/oxygenengine/source/oxygen/application/mainview \
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
			Oxygen/oxygenengine/source/oxygen/network \
			Oxygen/oxygenengine/source/oxygen/devmode \
			Oxygen/oxygenengine/source/oxygen/network/netplay \
			Oxygen/sonic3air/source/sonic3air \
			Oxygen/sonic3air/source/sonic3air/_nativized \
			Oxygen/sonic3air/source/sonic3air/platform \
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
			librmx/source/rmxbase/data \
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
			librmx/source/rmxmedia/threads 

INCLUDES  += \
				/Oxygen/lemonscript/source \
				/Oxygen/oxygenengine/source \
				/Oxygen/sonic3air/source \
				/librmx/source 

PKGFILES	:=	../pkgfiles1
ICON0		:=	$(PKGFILES)/ICON0.PNG
SFOXML		:=	../sfo1.xml

TITLE		:=	Sonic 3 A.I.R
APPID		:=	SNC300AIR
CONTENTID	:=	UP0001-$(APPID)_00-SNC3ANGELINSLAND

CFLAGS		=	-g3 -MMD -MP -mcpu=cell -Wall -D__PS3__ -DPLATFORM_PS3 $(MACHDEP) -static
CXXFLAGS	=	$(CFLAGS) -std=c++17 -Wno-psabi

LDFLAGS		=	$(MACHDEP) -Wl,-Map,$(notdir $@).map -static

LIBS		+=	$(shell pkg-config --libs sdl2 ogg vorbis theora vorbisfile theoradec zlib minizip) -lnet -lsysutil -lsysmodule -lGL -lEGL -lrsx -lgcm_sys -lio -lrt -llv2

LIBDIRS	:=	$(PORTLIBS)

#---------------------------------------------------------------------------------
# automatically build a list of object files for our project
#---------------------------------------------------------------------------------
CFILES_W_PATHS		:=	$(foreach dir,$(SOURCES),$(wildcard $(dir)/*.c))
CPPFILES_W_PATHS	:=	$(foreach dir,$(SOURCES),$(wildcard $(dir)/*.cpp))
sFILES_W_PATHS		:=	$(foreach dir,$(SOURCES),$(wildcard $(dir)/*.s))
SFILES_W_PATHS		:=	$(foreach dir,$(SOURCES),$(wildcard $(dir)/*.S))

EXCLUDE_C_FILES		:=	%/iowin32.c %/miniunz.c %/minizip.c %/PublicFunctions.c
EXCLUDE_CPP_FILES	:=	%/xmltest.cpp

CFILES			:=	$(filter-out $(EXCLUDE_C_FILES),$(CFILES_W_PATHS))
CPPFILES		:=	$(filter-out $(EXCLUDE_CPP_FILES),$(CPPFILES_W_PATHS))
sFILES			:=	$(sFILES_W_PATHS)
SFILES			:=	$(SFILES_W_PATHS)

OFILES			:=	$(addprefix $(BUILD)/,$(CFILES:.c=.o)) \
					$(addprefix $(BUILD)/,$(CPPFILES:.cpp=.o)) \
					$(addprefix $(BUILD)/,$(sFILES:.s=.o)) \
					$(addprefix $(BUILD)/,$(SFILES:.S=.o))

DEPENDS			:=	$(OFILES:.o=.d)

#---------------------------------------------------------------------------------
# use CXX for linking C++ projects, CC for standard C
#---------------------------------------------------------------------------------
ifeq ($(strip $(CPPFILES)),)
	LD	:=	$(CC)
else
	LD	:=	$(CXX)
endif

#---------------------------------------------------------------------------------
# build a list of include paths
#---------------------------------------------------------------------------------
INCLUDE	:=	$(foreach dir,$(INCLUDES), -I$(CURDIR)/$(dir)) \
			$(foreach dir,$(LIBDIRS),-I$(dir)/include) \
			$(LIBPSL1GHT_INC) \
			-I$(CURDIR)/$(BUILD)

#---------------------------------------------------------------------------------
# build a list of library paths
#---------------------------------------------------------------------------------
LIBPATHS	:=	$(foreach dir,$(LIBDIRS),-L$(dir)/lib) \
				$(LIBPSL1GHT_LIB)

OUTPUT	:=	$(CURDIR)/$(TARGET)

.PHONY: all clean pkg

all: $(OUTPUT).self

$(OUTPUT).self: $(BUILD)/$(TARGET).elf
	@echo "CEX self ... $(notdir $@)"
	@mkdir -p $(BUILD)
	@$(STRIP) $< -o $(BUILD)/$(notdir $<)
	@$(SPRX) $(BUILD)/$(notdir $<)
	@$(SELF) $(BUILD)/$(notdir $<) $@
	@$(FSELF) $(BUILD)/$(notdir $<) $(basename $@).fake.self

$(BUILD)/$(TARGET).elf: $(OFILES)
	@echo "Linking... $(notdir $@)"
	@mkdir -p $(dir $@)
	$(LD) $(LDFLAGS) $(LIBPATHS) -o $@ $(OFILES) $(LIBS)

$(BUILD)/%.o: %.cpp
	@echo "Compiling... $(notdir $<)"
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(INCLUDE) -c $< -o $@

$(BUILD)/%.o: %.c
	@echo "Compiling... $(notdir $<)"
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

$(BUILD)/%.o: %.s
	@echo "Assembling... $(notdir $<)"
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

$(BUILD)/%.o: %.S
	@echo "Assembling... $(notdir $<)"
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

#---------------------------------------------------------------------------------
pkg: $(OUTPUT).self
	@echo "building pkg ... $(notdir $@)"
	@mkdir -p $(BUILD)/pkg/USRDIR
	@cp $(ICON0) $(BUILD)/pkg/ICON0.PNG
	@$(SELF_NPDRM) $(BUILD)/$(basename $(notdir $<)).elf $(BUILD)/pkg/USRDIR/EBOOT.BIN $(CONTENTID) >> /dev/null
	@$(SFO) --title "$(TITLE)" --appid "$(APPID)" -f $(SFOXML) $(BUILD)/pkg/PARAM.SFO
	@if [ -n "$(PKGFILES)" -a -d "$(PKGFILES)" ]; then cp -rf $(PKGFILES)/* $(BUILD)/pkg/; fi
	@$(PKG) --contentid $(CONTENTID) $(BUILD)/pkg/ $@ >> /dev/null
	@cp $@ $(basename $@).gnpdrm.pkg
	@$(PACKAGE_FINALIZE) $(basename $@).gnpdrm.pkg

#---------------------------------------------------------------------------------
clean:
	@echo "clean ..."
	@rm -fr $(BUILD) $(TARGET).elf $(TARGET).self $(TARGET).fake.self $(TARGET).pkg

-include $(DEPENDS)