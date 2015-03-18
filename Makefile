VERSION = $(shell defaults read `pwd`/AppGrid/AppGrid-Info CFBundleVersion)
APPFILE = AppGrid.app
TGZFILE = AppGrid-$(VERSION).tgz
ZIPFILE = AppGrid-$(VERSION).zip

release: $(TGZFILE) $(ZIPFILE)

$(APPFILE): AppGrid AppGrid.xcodeproj
	rm -rf $@
	xcodebuild clean build > /dev/null
	cp -R build/Release/AppGrid.app $@

$(TGZFILE): $(APPFILE)
	tar -czf $@ $<

$(ZIPFILE): $(APPFILE)
	zip -qr $@ $<

clean:
	rm -rf $(APPFILE) $(TGZFILE) $(ZIPFILE)

.PHONY: release clean
