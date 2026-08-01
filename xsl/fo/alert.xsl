<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  version="2.0"
>

  <!-- Alert Support -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/alert ') or (exists(tokenize(@outputclass, ' ')[starts-with(., 'alert-') or starts-with(., 'theme-')]) and (contains(@class, ' topic/section ') or contains(@class, ' topic/div ') or contains(@class, ' topic/bodydiv ')) and not(tokenize(@outputclass, ' ') = ('accordion', 'accordion-flush', 'card', 'carousel', 'drawer', 'offcanvas')))]"
    priority="5"
  >
    <fo:block xsl:use-attribute-sets="section">
      <xsl:call-template name="commonattributes"/>
      
      <xsl:variable name="theme">
        <xsl:choose>
          <xsl:when test="@color"><xsl:value-of select="@color"/></xsl:when>
          <xsl:when test="exists(tokenize(@outputclass, ' ')[starts-with(., 'theme-')])">
            <xsl:value-of select="substring-after(tokenize(@outputclass, ' ')[starts-with(., 'theme-')][1], 'theme-')"/>
          </xsl:when>
          <xsl:when test="exists(tokenize(@outputclass, ' ')[starts-with(., 'alert-')])">
            <xsl:value-of select="substring-after(tokenize(@outputclass, ' ')[starts-with(., 'alert-')][1], 'alert-')"/>
          </xsl:when>
          <xsl:otherwise>secondary</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <!-- 1. Background & Spacing Defaults -->
      <xsl:call-template name="bootstrap.decoration">
          <xsl:with-param name="variant" select="'subtle'"/>
          <xsl:with-param name="theme" select="$theme"/>
          <xsl:with-param name="defaultRounded" select="true()"/>
      </xsl:call-template>

      <!-- 2. Set default padding (p-3) if not overridden -->
      <xsl:if test="not(@padding or exists(tokenize(@outputclass, ' ')[starts-with(., 'p-')]))">
        <xsl:call-template name="processBootstrapSpacing">
          <xsl:with-param name="attrValue" select="'3'"/>
          <xsl:with-param name="prefix" select="'p'"/>
        </xsl:call-template>
      </xsl:if>

      <!-- 3. Final default layout adjustments -->
      <xsl:if test="not(@margin)">
        <xsl:attribute name="margin-bottom">10pt</xsl:attribute>
      </xsl:if>
      <xsl:attribute name="keep-together.within-page">always</xsl:attribute>

      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' bootstrap-d/alert ') or (exists(tokenize(@outputclass, ' ')[starts-with(., 'alert-') or starts-with(., 'theme-')]) and not(tokenize(@outputclass, ' ') = ('accordion', 'accordion-flush', 'card', 'carousel', 'drawer', 'offcanvas'))) or tokenize(@outputclass, ' ') = 'alert']/*[contains(@class, ' topic/title ')]"
    priority="10"
  >
    <xsl:variable name="ctx" select=".."/>
    <xsl:variable name="theme">
      <xsl:choose>
        <xsl:when test="$ctx/@color"><xsl:value-of select="$ctx/@color"/></xsl:when>
        <xsl:when test="exists(tokenize($ctx/@outputclass, ' ')[starts-with(., 'theme-')])">
          <xsl:value-of
            select="substring-after(tokenize($ctx/@outputclass, ' ')[starts-with(., 'theme-')][1], 'theme-')"
          />
        </xsl:when>
        <xsl:when test="exists(tokenize($ctx/@outputclass, ' ')[starts-with(., 'alert-')])">
          <xsl:value-of
            select="substring-after(tokenize($ctx/@outputclass, ' ')[starts-with(., 'alert-')][1], 'alert-')"
          />
        </xsl:when>
        <xsl:otherwise>secondary</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <fo:block font-weight="bold" font-size="12pt" space-after="4pt">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
</xsl:stylesheet>
