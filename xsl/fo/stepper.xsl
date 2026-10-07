<?xml version="1.0" encoding="UTF-8"?>
<!--
	This file is part of the DITA Bootstrap PDF plug-in for DITA Open Toolkit.
	See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  exclude-result-prefixes="fox"
  version="2.0"
>

  <xsl:variable name="stepper-marker-size">18pt</xsl:variable>
  <xsl:variable name="stepper-inactive-bg">#e9ecef</xsl:variable>
  <xsl:variable name="stepper-inactive-color">#6c757d</xsl:variable>

  <xsl:template
    match="*[contains(@class, ' topic/ol ')][contains(@class, ' bootstrap-d/stepper ') or tokenize(@outputclass, ' ') = 'stepper']"
    priority="5"
  >
    <xsl:variable
      name="horizontal"
      select="@orientation = 'horizontal' or exists(tokenize(@outputclass, ' ')[ends-with(., 'stepper-horizontal')])"
    />
    <xsl:variable name="items" select="*[contains(@class, ' topic/li ')]"/>

    <fo:table table-layout="fixed" width="100%" margin-bottom="{$bootstrap-spacing-3}">
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="processBootstrapSpacing">
        <xsl:with-param name="attrValue" select="@margin"/>
        <xsl:with-param name="prefix" select="'m'"/>
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="$horizontal">
          <xsl:for-each select="$items">
            <fo:table-column column-width="proportional-column-width(1)"/>
          </xsl:for-each>
          <fo:table-body>
            <fo:table-row>
              <xsl:for-each select="$items">
                <fo:table-cell text-align="center" padding="3pt">
                  <xsl:call-template name="renderStepperMarker"/>
                  <fo:block margin-top="3pt" font-size="10.5pt">
                    <xsl:apply-templates select="node()" mode="bootstrap-label"/>
                  </fo:block>
                </fo:table-cell>
              </xsl:for-each>
            </fo:table-row>
          </fo:table-body>
        </xsl:when>
        <xsl:otherwise>
          <fo:table-column column-width="{$stepper-marker-size}"/>
          <fo:table-column column-width="proportional-column-width(1)"/>
          <fo:table-body>
            <xsl:for-each select="$items">
              <fo:table-row>
                <fo:table-cell>
                  <xsl:call-template name="renderStepperMarker"/>
                </fo:table-cell>
                <fo:table-cell padding-left="9pt" display-align="center">
                  <fo:block>
                    <xsl:apply-templates select="node()" mode="bootstrap-label"/>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
              <xsl:if test="position() != last()">
                <fo:table-row height="9pt">
                  <fo:table-cell padding-left="8pt">
                    <fo:block
                      border-left="2pt solid {if (@active = 'yes' or tokenize(@outputclass, ' ') = 'active') then $bootstrap-link else $stepper-inactive-bg}"
                      line-height="9pt"
                    >&#160;</fo:block>
                  </fo:table-cell>
                  <fo:table-cell><fo:block/></fo:table-cell>
                </fo:table-row>
              </xsl:if>
            </xsl:for-each>
          </fo:table-body>
        </xsl:otherwise>
      </xsl:choose>
    </fo:table>
  </xsl:template>

  <!-- Numbered circle for the current stepper-item/li. -->
  <xsl:template name="renderStepperMarker">
    <xsl:variable name="active" select="@active = 'yes' or tokenize(@outputclass, ' ') = 'active'"/>
    <xsl:variable name="themeColor">
      <xsl:call-template name="get-theme-color"/>
    </xsl:variable>
    <xsl:variable name="activeBg">
      <xsl:choose>
        <xsl:when test="$themeColor != ''">
          <xsl:call-template name="getBootstrapAttrValue">
            <xsl:with-param name="attrSet" select="concat('__color__', $themeColor)"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$bootstrap-link"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:block line-height="{$stepper-marker-size}" font-size="9pt" font-weight="bold">
      <fo:inline
        padding="4pt 6pt"
        background-color="{if ($active) then $activeBg else $stepper-inactive-bg}"
        color="{if ($active) then '#ffffff' else $stepper-inactive-color}"
        fox:border-before-start-radius="9pt"
        fox:border-after-start-radius="9pt"
        fox:border-before-end-radius="9pt"
        fox:border-after-end-radius="9pt"
      >
        <xsl:value-of select="count(preceding-sibling::*[contains(@class, ' topic/li ')]) + 1"/>
      </fo:inline>
    </fo:block>
  </xsl:template>

</xsl:stylesheet>
