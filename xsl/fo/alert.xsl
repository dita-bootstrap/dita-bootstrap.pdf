<?xml version="1.0" encoding="UTF-8"?>
<!--
	This file is part of the DITA Bootstrap PDF plug-in for DITA Open Toolkit.
	See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  xmlns:bs="https://dita-bootstrap.github.io/pdf"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="bs xs"
  version="2.0"
>

  <!-- Alert Support -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/alert ') or (exists(tokenize(@outputclass, ' ')[. = 'alert' or starts-with(., 'alert-')]) and (contains(@class, ' topic/section ') or contains(@class, ' topic/div ') or contains(@class, ' topic/bodydiv ')) and not(tokenize(@outputclass, ' ') = ('accordion', 'accordion-flush', 'card', 'carousel', 'drawer', 'offcanvas')))]"
    priority="5"
  >
    <xsl:variable name="glow-theme">
      <xsl:variable name="gt"><xsl:call-template name="get-theme-color"/></xsl:variable>
      <xsl:value-of
        select="if ($gt != '') then $gt else substring-after(tokenize(@outputclass, ' ')[starts-with(., 'alert-')][1], 'alert-')"
      />
    </xsl:variable>
    <xsl:variable name="glow-out">
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
              <xsl:with-param
                name="variant"
                select="if ($isSubtle and not($bootstrap-alert-solid)) then 'subtle' else ''"
              />
              <xsl:with-param name="theme" select="$theme"/>
              <xsl:with-param name="defaultRounded" select="true()"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:if test="not($isBorderOnly)"><xsl:call-template name="bootstrap.surface.image"/></xsl:if>
      <xsl:if
          test="$isSubtle and not($isBorderOnly) and not($bootstrap-alert-solid) and string($bootstrap-surface-image) = ''"
        >
        <xsl:call-template name="bootstrap.surface">
          <xsl:with-param name="theme" select="$theme"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="string($bootstrap-surface-image) != '' and not($isBorderOnly)">
        <xsl:attribute name="border-left-width" select="$bootstrap-note-border-width"/>
        <xsl:attribute name="border-left-style">solid</xsl:attribute>
        <xsl:variable name="image-bar">
          <xsl:call-template name="getBootstrapAttrValue">
            <xsl:with-param name="attrSet" select="concat('__bg__', (if ($theme != '') then $theme else 'secondary'))"/>
            <xsl:with-param name="attrName" select="'background-color'"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:attribute
            name="border-left-color"
            select="bs:darken($image-bar, xs:double($bootstrap-surface-image-bar-factor))"
          />
      </xsl:if>

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
    </xsl:variable>
    <xsl:call-template name="apply-glow-wrapper">
      <xsl:with-param name="inner" select="$glow-out"/>
      <xsl:with-param name="color"><xsl:call-template name="glow-color"><xsl:with-param
            name="theme"
            select="$glow-theme"
          /></xsl:call-template></xsl:with-param>

    </xsl:call-template>
  </xsl:template>

  <xsl:template
    match="*[not(contains(@class, ' topic/note ')) and (contains(@class, ' bootstrap-d/alert ') or (exists(tokenize(@outputclass, ' ')[starts-with(., 'alert-') or starts-with(., 'theme-')]) and not(tokenize(@outputclass, ' ') = ('accordion', 'accordion-flush', 'card', 'carousel', 'drawer', 'offcanvas'))) or tokenize(@outputclass, ' ') = 'alert')]/*[contains(@class, ' topic/title ')]"
    priority="10"
  >
    <fo:block font-weight="{$bootstrap-heading-font-weight}" font-size="12pt" space-after="4pt">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
</xsl:stylesheet>
