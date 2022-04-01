$(info Variables check:)

ifndef ORIGINAL_VDFS_LIB_PATH
$(error [E] ORIGINAL_VDFS_LIB_PATH is not set, terminating build)
else
$(info [I] ORIGINAL_VDFS_LIB_PATH is set to "$(ORIGINAL_VDFS_LIB_PATH)")
endif

ifndef DLL_EXPORTER
$(error [E] DLL_EXPORTER is not set, terminating build)
else
$(info [I] DLL_EXPORTER is set to "$(DLL_EXPORTER)")
endif

ifndef TARGET_VERSION
$(warning [W] TARGET_VERSION is not set, ignoring)
else
$(info [I] TARGET_VERSION is set to "$(TARGET_VERSION)")
endif

ifndef EXE_CURRENT
$(info [I] EXE_CURRENT is not set, falling back to preset value)
else
$(info [I] EXE_CURRENT is set to "$(EXE_CURRENT)")
endif

ifndef APP_ID
$(info [I] APP_ID is not set, falling back to preset value)
else
$(info [I] APP_ID is set to "$(APP_ID)")
endif

$(info -----)


all: liborgvdfs32g.a vdfs32g.dll


output/libdiscord-rpc.dll:
	cmake libs/discord-rpc -D BUILD_SHARED_LIBS=TRUE -B"output/discord-rpc" -G "MinGW Makefiles"
	cmake -LA -N output/discord-rpc | for /f "tokens=1,* delims==" %%a in ('findstr CMAKE_CXX_STANDARD_LIBRARIES') do @echo %%b | cmake output/discord-rpc -D CMAKE_CXX_STANDARD_LIBRARIES="%%b -static-libgcc -static-libstdc++"
	cmake output/discord-rpc -D CMAKE_SHARED_LINKER_FLAGS="-Wl,-Bstatic,--whole-archive -lwinpthread -Wl,--no-whole-archive"
	cmake --build output/discord-rpc --config Release
	copy output\discord-rpc\src\libdiscord-rpc.dll output\libdiscord-rpc.dll


# always force remake for versatility
# can keep "output/" if always building for the same platform
# output/liborgvdfs32g.a:
liborgvdfs32g.a:
	if not exist "output" mkdir "output"
ifeq ($(DLL_EXPORTER),expdef)
	expdef "$(ORIGINAL_VDFS_LIB_PATH)" -d"output/vdfs32g.def" -p
else ifeq ($(DLL_EXPORTER),gendef)
	gendef - "$(ORIGINAL_VDFS_LIB_PATH)" > "output/vdfs32g.def"
else ifeq ($(DLL_EXPORTER),pexports)
	pexports -o "$(ORIGINAL_VDFS_LIB_PATH)" > "output/vdfs32g.def"
else
	$(error Unrecognized DLL_EXPORTER value)
endif
	if not exist "go.mod" go mod init github.com/helpo1/GDRPC
	go get github.com/Szmyk/go-utils/files
	go mod tidy
	go run tools/prepareDef.go $(DLL_EXPORTER)
	dlltool -d output/vdfs32g.def -l output/liborgvdfs32g.a


vdfs32g.dll: output/libdiscord-rpc.dll liborgvdfs32g.a
	if not exist "output/bin/$(TARGET_VERSION)" mkdir "output/bin/$(TARGET_VERSION)"
	g++ -c src/main.cpp -o output/main.o
	g++ -c src/rpc.cpp -o output/rpc.o
ifdef APP_ID
	g++ -D APP_ID=\"$(APP_ID)\" -c src/discord.cpp -o output/discord.o
else
	g++ -c src/discord.cpp -o output/discord.o
endif
ifdef EXE_CURRENT
	g++ -D EXE_CURRENT=$(EXE_CURRENT) -c src/hooks.cpp -o output/hooks.o
	g++ -D EXE_CURRENT=$(EXE_CURRENT) -std=c++11 -c src/api.cpp -o output/api.o
else
	g++ -c src/hooks.cpp -o output/hooks.o
	g++ -std=c++11 -c src/api.cpp -o output/api.o
endif
	g++ -std=c++11 -c src/utils.cpp -o output/utils.o
	gcc -c libs/inih/ini.c -o output/ini.o
	g++ -std=c++11 -c libs/inih/cpp/INIReader.cpp -o output/INIReader.o
	g++ -std=c++11 -c src/config.cpp -o output/config.o
	dllwrap -o output/bin/$(TARGET_VERSION)/vdfs32g.dll -def output/vdfs32g.def output/*.o -lstdc++ output/liborgvdfs32g.a -static output/libdiscord-rpc.dll
	strip output/bin/$(TARGET_VERSION)/vdfs32g.dll
	copy "$(ORIGINAL_VDFS_LIB_PATH)" "output\bin\$(TARGET_VERSION)\orgVdfs32g.dll"
	copy "output\libdiscord-rpc.dll" "output\bin\$(TARGET_VERSION)\libdiscord-rpc.dll"


output/bin/GDRPC.ini:
	copy "input\ini-defaults\GDRPC.ini" "output\bin\GDRPC.ini"


clean:
	if exist output rmdir output /s /q
