<?xml version="1.0" encoding="UTF-8"?>
<!--
	This file is part of the DITA Bootstrap PDF plug-in for DITA Open Toolkit.
	See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
  exclude-result-prefixes="opentopic-func fox"
  version="2.0"
>

  <!-- Pagination Support. -->
  <xsl:template match="*[contains(@class, ' bootstrap-d/pagination ')]" priority="5">
    <fo:block>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="processBootstrapSpacing">
        <xsl:with-param name="attrValue" select="@margin"/>
        <xsl:with-param name="prefix" select="'m'"/>
      </xsl:call-template>
      <xsl:apply-templates select="*[contains(@class, ' topic/ol ')]"/>
    </fo:block>
  </xsl:template>

  <!-- Suppress <title> -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/pagination ')]/*[contains(@class, ' topic/title ')]"
    priority="5"
  />

  <xsl:template
    match="*[contains(@class, ' topic/ol ')][parent::*[contains(@class, ' bootstrap-d/pagination ')] or tokenize(@outputclass, ' ') = 'pagination']"
    priority="5"
  >
    <xsl:variable name="pagContainer" select="parent::*[contains(@class, ' bootstrap-d/pagination ')]"/>
    
    <xsl:variable name="parentTheme" select="$pagContainer/@theme"/>
    <xsl:variable name="themeColor">
      <xsl:choose>
        <xsl:when test="$parentTheme">
          <xsl:value-of
            select="if (contains($parentTheme, '-')) then substring-before($parentTheme, '-') else $parentTheme"
          />
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="get-theme-color"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="alignOutputclass" select="(@outputclass, $pagContainer/@outputclass)[1]"/>
    <xsl:variable
      name="textAlign"
      select="
        if (tokenize($alignOutputclass, ' ') = 'justify-content-center') then 'center'
        else if (tokenize($alignOutputclass, ' ') = 'justify-content-end') then 'right'
        else 'left'"
    />

    <xsl:variable
      name="size"
      select="
        ($pagContainer/@size,
         if (tokenize(@outputclass, ' ') = 'pagination-lg') then 'large'
         else if (tokenize(@outputclass, ' ') = 'pagination-sm') then 'small'
         else ())[1]"
    />

    <fo:block text-align="{$textAlign}" margin-bottom="{$bootstrap-spacing-3}">
      <xsl:call-template name="commonattributes"/>
      <xsl:for-each select="*[contains(@class, ' topic/li ')]">
        <xsl:call-template name="renderPaginationItem">
          <xsl:with-param name="themeColor" select="$themeColor"/>
          <xsl:with-param name="size" select="$size"/>
          <xsl:with-param name="isFirst" select="position() = 1"/>
          <xsl:with-param name="isLast" select="position() = last()"/>
        </xsl:call-template>
      </xsl:for-each>
    </fo:block>
  </xsl:template>

  <!-- One page-item/page-link segment. -->
  <xsl:template name="renderPaginationItem">
    <xsl:param name="themeColor" select="''"/>
    <xsl:param name="size" select="''"/>
    <xsl:param name="isFirst" select="false()"/>
    <xsl:param name="isLast" select="false()"/>

    <xsl:variable name="xref" select="*[contains(@class, ' topic/xref ')][1]"/>

    <!-- Link-colored text (themed or the default link color), matching the
         HTML reference: theming only recolors the text, not the border. -->
    <xsl:variable name="color">
      <xsl:choose>
        <xsl:when test="$themeColor != ''">
          <xsl:call-template name="getBootstrapAttrValue">
            <xsl:with-param name="attrSet" select="concat('__color__', $themeColor)"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$bootstrap-link"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="padding">
      <xsl:choose>
        <xsl:when test="$size = 'large'">6pt 12pt</xsl:when>
        <xsl:when test="$size = 'small'">3pt 7.5pt</xsl:when>
        <xsl:otherwise>4.5pt 9pt</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="radius">
      <xsl:choose>
        <xsl:when test="$size = 'large'">9pt</xsl:when>
        <xsl:otherwise>6pt</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Only wrap in fo:basic-link when a destination actually resolves - FOP
         rejects fo:basic-link outright if internal-destination/
         external-destination end up empty (e.g. a placeholder href="#" that
         doesn't resolve to a real key/topic id, as used throughout the
         pagination samples), which would otherwise abort the whole build. -->
    <xsl:variable
      name="is-external"
      select="boolean($xref) and (($xref/@scope = 'external') or not(empty($xref/@format) or $xref/@format = 'dita'))"
    />
    <xsl:variable
      name="internal-dest-id"
      select="if (boolean($xref) and not($is-external) and $xref/@href) then opentopic-func:getDestinationId($xref/@href) else ''"
    />
    <xsl:variable
      name="has-destination"
      select="boolean($xref) and (($is-external and $xref/@href) or ($internal-dest-id != ''))"
    />

    <xsl:element name="{if ($has-destination) then 'fo:basic-link' else 'fo:inline'}">
      <xsl:call-template name="commonattributes"/>
      <xsl:attribute name="padding"><xsl:value-of select="$padding"/></xsl:attribute>
      <xsl:attribute name="border-style">solid</xsl:attribute>
      <xsl:attribute name="border-width"><xsl:value-of select="$bootstrap-border-width"/></xsl:attribute>
      <xsl:attribute name="border-color"><xsl:value-of select="$bootstrap-border-color"/></xsl:attribute>
      <xsl:attribute name="color"><xsl:value-of select="$color"/></xsl:attribute>
      <xsl:if test="$size = 'small'">
        <xsl:attribute name="font-size">10.5pt</xsl:attribute>
      </xsl:if>

      <xsl:if test="$isFirst">
        <xsl:attribute name="fox:border-before-start-radius"><xsl:value-of select="$radius"/></xsl:attribute>
        <xsl:attribute name="fox:border-after-start-radius"><xsl:value-of select="$radius"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="$isLast">
        <xsl:attribute name="fox:border-before-end-radius"><xsl:value-of select="$radius"/></xsl:attribute>
        <xsl:attribute name="fox:border-after-end-radius"><xsl:value-of select="$radius"/></xsl:attribute>
      </xsl:if>

      <xsl:if test="$has-destination">
        <xsl:choose>
          <xsl:when test="$is-external">
            <xsl:attribute name="external-destination">url('<xsl:value-of select="$xref/@href"/>')</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="internal-destination" select="$internal-dest-id"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="$xref">
          <xsl:apply-templates select="$xref/node()" mode="bootstrap-label"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="node()" mode="bootstrap-label"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
