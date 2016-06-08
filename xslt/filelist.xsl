<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output omit-xml-declaration="yes" indent="no" method="text"/>
<xsl:param name="inputFile">-</xsl:param>
<xsl:param name="filetype"/>
<xsl:template match="/">
  <xsl:call-template name="t1"/>
</xsl:template>
<xsl:template name="t1">
	<xsl:for-each select="/package/release/filelist/file[@role=$filetype]">
		<xsl:value-of select="@name"/>
		<xsl:value-of select="' '"/>
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
