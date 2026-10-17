<?xml version="1.0" encoding="UTF-8"?>
<!--
	This file is part of the DITA Bootstrap PDF plug-in for DITA Open Toolkit.
	See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  version="2.0"
>

  <!-- Matches accordion specialized elements or bodydiv with accordion outputclass -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/accordion ') or (contains(@class, ' topic/bodydiv ') and (tokenize(@outputclass, ' ') = ('accordion', 'accordion-flush') or contains(@outputclass, 'accordion')))]"
    priority="5"
  >
    <xsl:variable name="glow-theme">
      <xsl:call-template name="get-theme-color"/>
    </xsl:variable>
    <xsl:variable name="glow-out">
    <fo:block>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="processBootstrapDirection"/>
      <xsl:call-template name="processBootstrapSpacing">
        <xsl:with-param name="attrValue" select="@margin"/>
        <xsl:with-param name="prefix" select="'m'"/>
      </xsl:call-template>
      <xsl:call-template name="processBootstrapWidth">
        <xsl:with-param name="attrValue" select="@width"/>
      </xsl:call-template>

      <!-- Border and rounding for the accordion container if not flushed -->
      <xsl:variable name="is-flush" select="@flush = 'yes' or tokenize(@outputclass, ' ') = 'accordion-flush'"/>

      <xsl:variable name="accordion-radius">
        <xsl:if test="not($is-flush)">
          <xsl:call-template name="get-accordion-radius">
            <xsl:with-param name="node" select="."/>
          </xsl:call-template>
        </xsl:if>
      </xsl:variable>

      <xsl:variable name="is-small" select="@size = 'small' or tokenize(@outputclass, ' ') = 'accordion-sm'"/>
      <xsl:variable
          name="is-gap"
          select="not($is-flush) and (@gap = 'yes' or tokenize(@outputclass, ' ') = 'accordion-gap')"
        />
      <xsl:call-template name="accordion-frames">
        <xsl:with-param name="items" select="*[contains(@class, ' topic/section ')]"/>
        <xsl:with-param name="is-flush" select="$is-flush"/>
        <xsl:with-param name="is-gap" select="$is-gap"/>
        <xsl:with-param name="accordion-radius" select="string($accordion-radius)"/>
        <xsl:with-param name="glow-theme" select="string($glow-theme)"/>
      </xsl:call-template>
    </fo:block>
    </xsl:variable>
    <xsl:choose>
      <xsl:when
        test="not(@flush = 'yes' or tokenize(@outputclass, ' ') = 'accordion-flush') and (@gap = 'yes' or tokenize(@outputclass, ' ') = 'accordion-gap')"
      >
        <xsl:copy-of select="$glow-out"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="apply-glow-wrapper">
          <xsl:with-param name="inner" select="$glow-out"/>
          <xsl:with-param name="color">
            <xsl:if test="not(@flush = 'yes' or tokenize(@outputclass, ' ') = 'accordion-flush')">
              <xsl:call-template name="glow-color"><xsl:with-param
                  name="theme"
                  select="$glow-theme"
                /></xsl:call-template>
            </xsl:if>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Gap mode renders each item as its own framed card, otherwise all items share one frame -->
  <xsl:template name="accordion-frames">
    <xsl:param name="items"/>
    <xsl:param name="is-flush"/>
    <xsl:param name="is-gap"/>
    <xsl:param name="accordion-radius"/>
    <xsl:param name="glow-theme"/>
    <xsl:choose>
      <xsl:when test="$is-gap">
        <xsl:if test="exists($items)">
          <xsl:variable name="item-out">
            <fo:block>
              <xsl:call-template name="accordion-frame">
                <xsl:with-param name="items" select="$items[1]"/>
                <xsl:with-param name="is-flush" select="$is-flush"/>
                <xsl:with-param name="accordion-radius" select="$accordion-radius"/>
                <xsl:with-param name="glow-theme" select="$glow-theme"/>
              </xsl:call-template>
            </fo:block>
          </xsl:variable>
          <xsl:call-template name="apply-glow-wrapper">
            <xsl:with-param name="inner" select="$item-out"/>
            <xsl:with-param name="color">
              <xsl:call-template name="glow-color"><xsl:with-param
                  name="theme"
                  select="$glow-theme"
                /></xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
          <xsl:if test="count($items) gt 1">
            <fo:block-container height="6pt"><fo:block/></fo:block-container>
          </xsl:if>
          <xsl:call-template name="accordion-frames">
            <xsl:with-param name="items" select="$items[position() gt 1]"/>
            <xsl:with-param name="is-flush" select="$is-flush"/>
            <xsl:with-param name="is-gap" select="$is-gap"/>
            <xsl:with-param name="accordion-radius" select="$accordion-radius"/>
            <xsl:with-param name="glow-theme" select="$glow-theme"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="accordion-frame">
          <xsl:with-param name="items" select="$items"/>
          <xsl:with-param name="is-flush" select="$is-flush"/>
          <xsl:with-param name="accordion-radius" select="$accordion-radius"/>
          <xsl:with-param name="glow-theme" select="$glow-theme"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="accordion-frame">
    <xsl:param name="items"/>
    <xsl:param name="is-flush"/>
    <xsl:param name="accordion-radius"/>
    <xsl:param name="glow-theme"/>
      <!-- table-cell wrapper: gives the masked container correct ancestor-padding inset
           while keeping its own start-indent/end-indent at a literal 0pt (like card.xsl) -->
      <!-- keep-together: fragmenting across a page break drops the border/mask entirely -->
      <fo:table table-layout="fixed" width="100%" keep-together.within-page="always">
         <fo:table-column column-width="proportional-column-width(1)"/>
         <fo:table-body>
            <fo:table-row>
               <fo:table-cell>
                  <fo:block-container position="relative">
                     <xsl:attribute name="start-indent">0pt</xsl:attribute>
                     <xsl:attribute name="end-indent">0pt</xsl:attribute>
                     <xsl:if test="not($is-flush)">
                        <xsl:attribute name="border">
                          <xsl:value-of select="concat($bootstrap-border-width, ' solid ', $bootstrap-border-color)"/>
                        </xsl:attribute>
                        <xsl:attribute name="overflow">hidden</xsl:attribute>
                        <xsl:if test="$accordion-radius != ''">
                          <xsl:attribute name="fox:border-radius" select="$accordion-radius"/>
                        </xsl:if>
                     </xsl:if>

                     <xsl:if test="not($is-flush) and string($bootstrap-card-fill) != ''">
                        <xsl:attribute name="background-color" select="$bootstrap-card-fill"/>
                     </xsl:if>
                     <xsl:if test="not($is-flush)"><xsl:call-template name="bootstrap.surface.image"/></xsl:if>
                     <xsl:if test="not($is-flush)"><xsl:call-template name="bootstrap.surface"/></xsl:if>
                     <xsl:if test="not($is-flush) and $glow-theme != ''">
                        <xsl:attribute name="border-color">
                           <xsl:call-template name="getBootstrapAttrValue">
                              <xsl:with-param
                      name="attrSet"
                      select="concat('border-', replace($glow-theme, '-.*$', ''))"
                    />
                              <xsl:with-param name="attrName" select="'border-color'"/>
                           </xsl:call-template>
                        </xsl:attribute>
                     </xsl:if>
                     <xsl:apply-templates select="$items" mode="accordion"/>
                     <xsl:if test="not($is-flush) and $accordion-radius != ''">
                        <xsl:call-template name="corner-mask">
                           <xsl:with-param name="corner" select="'tl'"/>
                           <xsl:with-param name="radius" select="$accordion-radius"/>
                        </xsl:call-template>
                        <xsl:call-template name="corner-mask">
                           <xsl:with-param name="corner" select="'tr'"/>
                           <xsl:with-param name="radius" select="$accordion-radius"/>
                        </xsl:call-template>
                     </xsl:if>
                  </fo:block-container>
               </fo:table-cell>
            </fo:table-row>
         </fo:table-body>
      </fo:table>
  </xsl:template>

  <!-- Corner radius for the accordion's outer frame; themes can override (see sketchy) -->
  <xsl:template name="get-accordion-radius">
    <xsl:param name="node" select="."/>
    <xsl:variable name="radius-probe">
      <fo:block-container>
        <xsl:call-template name="processBootstrapRounded">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="attrValue" select="($node/@rounded, 'yes')[1]"/>
        </xsl:call-template>
      </fo:block-container>
    </xsl:variable>
    <xsl:variable name="radius-raw" select="normalize-space($radius-probe/*/@fox:border-radius)"/>
    <xsl:value-of select="$radius-raw"/>
  </xsl:template>

  <!-- Matches accordion items -->
  <xsl:template match="*[contains(@class, ' topic/section ')]" mode="accordion">
    <xsl:variable name="parent-color">
      <xsl:call-template name="get-theme-color">
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="is-flush" select="../@flush = 'yes' or tokenize(../@outputclass, ' ') = 'accordion-flush'"/>
    <xsl:variable name="is-small" select="../@size = 'small' or tokenize(../@outputclass, ' ') = 'accordion-sm'"/>
    <xsl:variable name="cell-padding" select="if ($is-small) then '5pt 10pt' else '10pt 15pt'"/>

    <fo:table table-layout="fixed" width="100%">
      <xsl:if test="$is-small">
        <xsl:attribute name="font-size">90%</xsl:attribute>
      </xsl:if>
      <xsl:attribute name="border-bottom">
        <xsl:value-of
          select="concat($bootstrap-border-width, ' solid ', if (not($is-flush) and string($bootstrap-surface-border) != '') then $bootstrap-surface-border else $bootstrap-border-color)"
        />
      </xsl:attribute>
      <xsl:if test="position() = last()">
         <xsl:attribute name="border-bottom">none</xsl:attribute>
      </xsl:if>
      
      <!-- Ensure the entire accordion item stays on one page -->
      <xsl:attribute name="keep-together.within-page">always</xsl:attribute>

      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-body>
        <!-- Accordion Header -->
        <fo:table-row>
          <fo:table-cell padding="{$cell-padding}">
            <xsl:call-template name="processBootstrapDirection"/>
            <xsl:choose>
               <xsl:when
                test="$is-flush and (string($bootstrap-surface-image) != '' or string($bootstrap-surface-bg) != '')"
              >
                  <xsl:attribute name="color" select="$bootstrap-body-color"/>
               </xsl:when>
               <xsl:when test="string($parent-color) != ''">
                  <xsl:call-template name="processBootstrapAttrSetReflection">
                     <xsl:with-param name="attrSet" select="concat('__bg__', $parent-color, '-subtle')"/>
                  </xsl:call-template>
                  <xsl:call-template name="card.cap.colors">
                     <xsl:with-param name="theme" select="replace($parent-color, '-.*$', '')"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="string($bootstrap-surface-image) != ''">
                  <xsl:if test="string($bootstrap-surface-accordion-header-bg) != ''">
                     <xsl:attribute name="background-color" select="$bootstrap-surface-accordion-header-bg"/>
                  </xsl:if>
                  <xsl:attribute
                  name="color"
                  select="($bootstrap-surface-accordion-header-color[. != ''], $bootstrap-surface-image-text)[1]"
                />
               </xsl:when>
               <xsl:when test="string($bootstrap-surface-bg) != ''">
                  <xsl:attribute
                  name="background-color"
                  select="($bootstrap-surface-accordion-header-bg[. != ''], $bootstrap-surface-header-bg)[1]"
                />
                  <xsl:attribute
                  name="color"
                  select="($bootstrap-surface-accordion-header-color[. != ''], $bootstrap-surface-text)[1]"
                />
               </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="background-color" select="$bootstrap-accordion-active-bg"/>
                  <xsl:attribute name="color" select="$bootstrap-accordion-active-color"/>
                </xsl:otherwise>
            </xsl:choose>
            <fo:block font-weight="{$bootstrap-heading-font-weight}">
               <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="accordion-header"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>

        <!-- Accordion Body -->
        <fo:table-row>
          <fo:table-cell padding="{$cell-padding}">
            <xsl:call-template name="processBootstrapDirection"/>
            <fo:block>
               <xsl:apply-templates select="node() except *[contains(@class, ' topic/title ')]"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>

  <!-- Title in accordion header -->
  <xsl:template match="*[contains(@class, ' topic/title ')]" mode="accordion-header">
     <fo:block>
        <xsl:apply-templates/>
     </fo:block>
  </xsl:template>

</xsl:stylesheet>
