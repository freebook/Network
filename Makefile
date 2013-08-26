XSLTPROC = /usr/bin/xsltproc
DSSSL = ../docbook-xsl/docbook.xsl
TMPDIR = $(shell mktemp -d --suffix=.tmp -p /tmp centos.html.XXXXXX)
DOCBOOK='.'
PUBLIC_HTML=/home/neo/workspace/public_html/centos

define reset
	@mkdir -p ${PUBLIC_HTML}/$(1)
	@find ${PUBLIC_HTML}/$(1) -type f -iname "*.html" -exec rm -rf {} \;
endef

define book
	@rsync -au ../common/docbook.css $(PUBLIC_HTML)/$(1)/
	@$(XSLTPROC) -o $(PUBLIC_HTML)/ $(DSSSL) $(DOCBOOK)/book.xml
	@$(shell test -d $(PUBLIC_HTML)/images && find $(PUBLIC_HTML)/images/ -type f -exec rm -rf {} \;)
	@$(shell test -d $(1)/images && rsync -au --exclude=.svn $(DOCBOOK)/images $(PUBLIC_HTML)/)
endef

define test
        @$(XSLTPROC) -o $(TMPDIR)/ $(DSSSL) $(DOCBOOK)/book.xml
endef


all: centos

clean:
	@rm -rf $(PUBLIC_HTML)/$@

centos:
	$(call reset)
	$(call book) 

test:
	$(call test)

