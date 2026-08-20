<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  version="2.0"
>

  <!-- Alert Support -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/alert ') or (exists(tokenize(@outputclass, ' ')[. = 'alert' or starts-with(., 'alert-')]) and (contains(@class, ' topic/section ') or contains(@class, ' topic/div ') or contains(@class, ' topic/bodydiv ')) and not(tokenize(@outputclass, ' ') = ('accordion', 'accordion-flush', 'card', 'carousel', 'drawer', 'offcanvas')))]"
    priority="5"
  >
    <fo:block xsl:use-attribute-sets="section">
      <xsl:call-template name="commonattributes"/>
      <xsl:variable name="explicitThemeColor">
        <xsl:call-template name="get-theme-color"/>
      </xsl:variable>
      <xsl:variable name="themeSuffix">
        <xsl:if test="$explicitThemeColor != ''">
          <xsl:call-template name="get-theme-suffix"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="theme">
        <xsl:choose>
          <xsl:when test="$explicitThemeColor != ''"><xsl:value-of select="$explicitThemeColor"/></xsl:when>
          <xsl:when test="exists(tokenize(@outputclass, ' ')[starts-with(., 'alert-')])">
            <xsl:value-of select="substring-after(tokenize(@outputclass, ' ')[starts-with(., 'alert-')][1], 'alert-')"/>
          </xsl:when>
          <xsl:otherwise>secondary</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="suffixTokens" select="if ($themeSuffix != '') then tokenize($themeSuffix, '-') else ()"/>
      <xsl:variable name="isMuted" select="$suffixTokens = 'muted'"/>
      <xsl:variable name="isSubtle" select="$themeSuffix = '' or $suffixTokens = 'subtle'"/>
      <!-- '-border' on its own sets only a border color, no background. -->
      <xsl:variable name="isBorderOnly" select="$themeSuffix = 'border'"/>

      <!-- 1. Background & Spacing Defaults -->
      <xsl:choose>
        <xsl:when test="$isMuted">
          <xsl:call-template name="bootstrap.decoration">
              <xsl:with-param name="theme" select="$theme"/>
              <xsl:with-param name="prefix" select="'__muted__'"/>
              <xsl:with-param name="defaultRounded" select="true()"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$isBorderOnly">
          <xsl:call-template name="bootstrap.decoration">
              <xsl:with-param name="theme" select="$theme"/>
              <xsl:with-param name="skipBackground" select="true()"/>
              <xsl:with-param name="defaultRounded" select="true()"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="bootstrap.decoration">
              <xsl:with-param name="variant" select="if ($isSubtle) then 'subtle' else ''"/>
              <xsl:with-param name="theme" select="$theme"/>
              <xsl:with-param name="defaultRounded" select="true()"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

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

      <xsl:variable name="ancestorStartPad">
        <xsl:call-template name="get-ancestor-padding-indent">
          <xsl:with-param name="side" select="'start'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="ancestorEndPad">
        <xsl:call-template name="get-ancestor-padding-indent">
          <xsl:with-param name="side" select="'end'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="number($ancestorStartPad) > 0">
        <xsl:attribute name="start-indent" select="concat($ancestorStartPad, 'pt + from-parent(start-indent)')"/>
      </xsl:if>
      <xsl:if test="number($ancestorEndPad) > 0">
        <xsl:attribute name="end-indent" select="concat($ancestorEndPad, 'pt + from-parent(end-indent)')"/>
      </xsl:if>

      <xsl:variable name="widthVal">
        <xsl:choose>
          <xsl:when test="@width != ''"><xsl:value-of select="@width"/></xsl:when>
          <xsl:when test="exists(tokenize(@outputclass, ' ')[starts-with(., 'w-')])">
            <xsl:value-of select="substring-after(tokenize(@outputclass, ' ')[starts-with(., 'w-')][1], 'w-')"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="totalPad" select="number($ancestorStartPad) + number($ancestorEndPad)"/>
      <xsl:if test="$widthVal = ('25', '50', '75', '100') and $totalPad > 0">
        <xsl:attribute name="width" select="concat($widthVal, '% - ', $totalPad, 'pt')"/>
        <xsl:attribute name="inline-progression-dimension" select="concat($widthVal, '% - ', $totalPad, 'pt')"/>
      </xsl:if>

      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' bootstrap-d/alert ') or (exists(tokenize(@outputclass, ' ')[starts-with(., 'alert-') or starts-with(., 'theme-')]) and not(tokenize(@outputclass, ' ') = ('accordion', 'accordion-flush', 'card', 'carousel', 'drawer', 'offcanvas'))) or tokenize(@outputclass, ' ') = 'alert']/*[contains(@class, ' topic/title ')]"
    priority="10"
  >
    <fo:block font-weight="bold" font-size="12pt" space-after="4pt">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
</xsl:stylesheet>
