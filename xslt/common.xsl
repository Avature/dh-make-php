<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output omit-xml-declaration="yes" indent="no" method="text"/>
<xsl:param name="inputFile">-</xsl:param>
<xsl:param name="Element"/>
<xsl:template match="/">
  <xsl:call-template name="t1"/>
</xsl:template>
<xsl:template name="t1">
  <xsl:value-of select="$Element"/>
</xsl:template>
</xsl:stylesheet>
