<?xml version="1.0" encoding="UTF-8"?>
<!--
	This file is part of the DITA Bootstrap PDF plug-in for DITA Open Toolkit.
	See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  exclude-result-prefixes="xs opentopic-func dita-ot"
  version="2.0"
>

  <!-- Figure Component Handling -->
  <xsl:template match="*[contains(@class, ' topic/fig ')]" priority="5">
    <fo:block xsl:use-attribute-sets="fig">
      <xsl:call-template name="commonattributes"/>

      <!-- Standard Bootstrap-like Figure spacing (approx 1rem / 16pt) -->
      <xsl:attribute name="margin-top">16pt</xsl:attribute>
      <xsl:attribute name="margin-bottom">16pt</xsl:attribute>

      <!-- Apply Figure specific outputclass utilities if present -->
      <xsl:call-template name="processBootstrapOutputClass">
        <xsl:with-param name="attrValue" select="@outputclass"/>
      </xsl:call-template>

      <xsl:call-template name="processBootstrapWidth">
        <xsl:with-param name="attrValue" select="@width"/>
      </xsl:call-template>
      <xsl:call-template name="processBootstrapBorder">
        <xsl:with-param name="attrValue" select="@border"/>
      </xsl:call-template>
      <xsl:call-template name="processBootstrapFrame">
        <xsl:with-param name="attrValue" select="@frame"/>
      </xsl:call-template>

      <xsl:attribute name="text-align">
        <xsl:choose>
          <xsl:when test="contains(@outputclass, 'text-end')">right</xsl:when>
          <xsl:when test="contains(@outputclass, 'text-center')">center</xsl:when>
          <xsl:otherwise>left</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <!-- A <fig> wrapping an <lq> -->
      <xsl:variable name="lqChild" select="*[contains(@class, ' topic/lq ')][1]"/>
      <xsl:if test="$lqChild">
        <xsl:variable name="lqThemeColor">
          <xsl:call-template name="get-theme-color">
            <xsl:with-param name="node" select="$lqChild"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$lqThemeColor = ''">
          <xsl:call-template name="apply-default-blockquote-border"/>
        </xsl:if>
      </xsl:if>

      <!-- Layout order: Image/Content first, Title (caption) below -->
      <xsl:apply-templates select="node() except *[contains(@class, ' topic/title ')]"/>
      <xsl:apply-templates select="*[contains(@class, ' topic/title ')]"/>
    </fo:block>
  </xsl:template>

  <!-- Force Scalefit for Images within Figures -->
  <xsl:template match="*[contains(@class, ' topic/fig ')]//*[contains(@class, ' topic/image ')]" priority="5">
    <fo:block text-align="center">
      <xsl:variable name="resolved-href">
        <xsl:choose>
          <xsl:when test="@scope = 'external' or opentopic-func:isAbsolute(@href)">
            <xsl:value-of select="@href"/>
          </xsl:when>
          <!-- Using standard job mapping for local images -->
          <xsl:when test="exists(key('jobFile', @href, $job))">
            <xsl:value-of select="key('jobFile', @href, $job)/@src"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($input.dir.url, @href)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <fo:external-graphic
        src="url('{$resolved-href}')"
        content-width="scale-to-fit"
        width="100%"
        height="auto"
        scaling="uniform"
      >
        <xsl:call-template name="commonattributes"/>
      </fo:external-graphic>
    </fo:block>
  </xsl:template>

  <!-- Figure Title (Caption): a <fig> wrapping an <lq> is a blockquote
       attribution -->
  <xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]" priority="5">
    <xsl:variable name="isBlockquoteFooter" select="exists(../*[contains(@class, ' topic/lq ')])"/>
    <fo:block xsl:use-attribute-sets="fig.title">
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="processBootstrapDirection"/>

      <xsl:choose>
        <xsl:when test="$isBlockquoteFooter">
          <xsl:attribute name="font-size">10.5pt</xsl:attribute>
          <xsl:attribute name="color"><xsl:value-of select="$bootstrap-secondary"/></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="font-size">0.9em</xsl:attribute>
          <xsl:attribute name="color"><xsl:value-of select="$bootstrap-secondary-subtle-text"/></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:attribute name="margin-top">8pt</xsl:attribute>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- Only render the first image within a picture element -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/picture ') or tokenize(@outputclass, ' ') = 'd-picture']"
    priority="6"
  >
    <fo:block>
      <xsl:call-template name="commonattributes"/>
      <xsl:apply-templates select="*[contains(@class, ' topic/image ')][1]"/>
    </fo:block>
  </xsl:template>

  <!-- Thumbnail Support -->
  <xsl:template match="*[contains(@class, ' bootstrap-d/thumbnail ')]" priority="6">
    <xsl:variable name="resolved-href">
      <xsl:choose>
        <xsl:when test="@scope = 'external' or opentopic-func:isAbsolute(@href)">
          <xsl:value-of select="@href"/>
        </xsl:when>
        <xsl:when test="exists(key('jobFile', @href, $job))">
          <xsl:value-of select="key('jobFile', @href, $job)/@src"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($input.dir.url, @href)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="theme" select="if (contains(@theme, '-')) then substring-before(@theme, '-') else @theme"/>
    <xsl:choose>
      <xsl:when test="@placement = 'break'">
        <fo:block margin-top="{$bootstrap-spacing-3}" margin-bottom="{$bootstrap-spacing-3}" text-align="center">
          <fo:external-graphic
            src="url('{$resolved-href}')"
            content-width="scale-to-fit"
            scaling="uniform"
            padding="{$bootstrap-spacing-1}"
            vertical-align="middle"
          >
            <xsl:call-template name="processBootstrapRounded">
              <xsl:with-param name="attrValue" select="(@rounded, '2')[1]"/>
            </xsl:call-template>
            <xsl:attribute name="border">
              <xsl:value-of select="concat($bootstrap-border-width, ' solid')"/>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="$theme">
                <xsl:call-template name="processBootstrapBorderColor">
                  <xsl:with-param name="attrValue" select="$theme"/>
                </xsl:call-template>
                <xsl:call-template name="processBootstrapAttrSetReflection">
                  <xsl:with-param name="attrSet" select="concat('__bg__', $theme, '-subtle')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="border-color"><xsl:value-of select="$bootstrap-border-color"/></xsl:attribute>
                <xsl:attribute name="background-color">#ffffff</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="commonattributes"/>
            <xsl:if test="@height"><xsl:attribute name="height" select="@height"/></xsl:if>
            <xsl:if test="@width"><xsl:attribute name="width" select="@width"/></xsl:if>
          </fo:external-graphic>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:external-graphic
          src="url('{$resolved-href}')"
          content-width="scale-to-fit"
          scaling="uniform"
          padding="{$bootstrap-spacing-1}"
          vertical-align="middle"
        >
          <xsl:call-template name="processBootstrapRounded">
            <xsl:with-param name="attrValue" select="(@rounded, '2')[1]"/>
          </xsl:call-template>
          <xsl:attribute name="border">
            <xsl:value-of select="concat($bootstrap-border-width, ' solid')"/>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="$theme">
              <xsl:call-template name="processBootstrapBorderColor">
                <xsl:with-param name="attrValue" select="$theme"/>
              </xsl:call-template>
              <xsl:call-template name="processBootstrapAttrSetReflection">
                <xsl:with-param name="attrSet" select="concat('__bg__', $theme, '-subtle')"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="border-color"><xsl:value-of select="$bootstrap-border-color"/></xsl:attribute>
              <xsl:attribute name="background-color">#ffffff</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:call-template name="commonattributes"/>
          <xsl:if test="@height"><xsl:attribute name="height" select="@height"/></xsl:if>
          <xsl:if test="@width"><xsl:attribute name="width" select="@width"/></xsl:if>
        </fo:external-graphic>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
