Q=$(if $(V),,@)

DOTNET_VERSION=6.0.300-rtm.22220.25
CUSTOM_DOTNET_VERSION=6.0.0-dev
DOTNET_TARBALL=https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$(DOTNET_VERSION)/dotnet-sdk-$(DOTNET_VERSION)-osx-x64.tar.gz
DOTNET_TARBALL_NAME=$(notdir $(DOTNET_TARBALL))
DOTNET_INVOCATION=/downloads/$(basename $(basename $(DOTNET_TARBALL_NAME)))/dotnet

donut.sh::
	$(Q) sed 's#PATH_TO_REPLACE#$(DOTNET_INVOCATION)#' template > $@.tmp
	$(Q) chmod +x $@.tmp
	$(Q) mv $@.tmp $@

install:: workloads

clean::
	-$(Q) rm -r ./downloads
	-$(Q) rm ./donut.sh
	-$(Q) rm ./dotnet-install.sh

workloads:: downloads/$(basename $(basename $(DOTNET_TARBALL_NAME)))
	$(Q) downloads/$(basename $(basename $(DOTNET_TARBALL_NAME)))/dotnet workload install ios

downloads/$(basename $(basename $(DOTNET_TARBALL_NAME))): dotnet-install.sh
	$(Q) echo "Downloading and installing .NET $(DOTNET_VERSION) into $@..."
	$(Q) ./dotnet-install.sh --install-dir "$@.tmp" --version "$(DOTNET_VERSION)" --architecture x64 --no-path $$DOTNET_INSTALL_EXTRA_ARGS
	$(Q) rm -Rf "$@"
	$(Q) mv "$@.tmp" "$@"
	$(Q) echo "Downloaded and installed .NET $(DOTNET_VERSION) into $@."

dotnet-install.sh: Makefile
	$(Q) curl --retry 20 --retry-delay 2 --connect-timeout 15 -S -L $(if $(V),-v,-s) https://dot.net/v1/dotnet-install.sh --output $@.tmp
	$(Q) chmod +x $@.tmp
	$(Q) mv $@.tmp $@

