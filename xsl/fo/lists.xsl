<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  version="2.0"
>

  <!-- Mirrors org.dita.pdf2/xsl/fo/lists.xsl: overrides for the base DITA list
       elements (ul, ol, li). Bootstrap's list-group is a separate specialized
       element and lives in list-group.xsl. -->

  <!-- Unstyled List Support (ul and ol) -->
  <xsl:template
    match="*[contains(@class, ' topic/ul ') or contains(@class, ' topic/ol ')][tokenize(@outputclass, ' ') = 'list-unstyled']"
  >
    <fo:block margin-bottom="12pt">
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="processBootstrapDirection"/>
      <xsl:apply-templates select="*[contains(@class, ' topic/li ')]" mode="list-unstyled"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/li ')]" mode="list-unstyled">
    <fo:block margin-left="0pt" margin-bottom="3pt">
      <xsl:call-template name="commonattributes"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- Inline List Support (ul and ol) -->
  <xsl:template
    match="*[contains(@class, ' topic/ul ') or contains(@class, ' topic/ol ')][tokenize(@outputclass, ' ') = 'list-inline']"
  >
    <fo:block margin-bottom="12pt">
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="processBootstrapDirection"/>
      <xsl:apply-templates select="*[contains(@class, ' topic/li ')]" mode="list-inline"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/li ')]" mode="list-inline">
    <fo:inline padding-right="8pt">
      <xsl:call-template name="commonattributes"/>
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>

</xsl:stylesheet>
