<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output omit-xml-declaration="yes" indent="no" method="text"/>
<xsl:param name="inputFile">-</xsl:param>
<xsl:template match="/">
  <xsl:call-template name="t1"/>
</xsl:template>
<xsl:template name="t1">
	<xsl:for-each select="/package/maintainers/maintainer">
  	<xsl:value-of select="concat(name,' &lt;',email,'&gt;')"/>
		<xsl:value-of select="'; '"/>
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
