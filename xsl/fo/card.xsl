<?xml version="1.0" encoding="UTF-8"?>
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

  <xsl:template
    match="*[self::card or contains(@class, ' bootstrap-d/card ') or (tokenize(@outputclass, ' ') = 'card' and (contains(@class, ' topic/section ') or contains(@class, ' topic/div ') or contains(@class, ' topic/bodydiv ')))]"
    priority="5"
  >

    <fo:block>
      <xsl:call-template name="processBootstrapDirection"/>
      <xsl:variable name="direction">
        <xsl:choose>
          <xsl:when test="@dir"><xsl:value-of select="@dir"/></xsl:when>
          <xsl:when test="ancestor::*[@dir]"><xsl:value-of select="ancestor::*[@dir][1]/@dir"/></xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="card-pct">
        <xsl:choose>
          <xsl:when test="@width = '25'">25</xsl:when>
          <xsl:when test="@width = '50'">50</xsl:when>
          <xsl:when test="@width = '75'">75</xsl:when>
          <xsl:when test="@width = '100'">100</xsl:when>
          <xsl:otherwise>70</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="gap-pct" select="100 - number($card-pct)"/>

      <fo:table table-layout="fixed" width="100%" space-before="10pt" space-after="10pt">
        <xsl:call-template name="processBootstrapDirection"/>

        <xsl:choose>
          <!-- Fixed width Card (e.g. 70%) with a Gap (e.g. 30%) -->
          <xsl:when test="$card-pct &lt; 100">
             <fo:table-column column-width="proportional-column-width({$card-pct})"/>
             <fo:table-column column-width="proportional-column-width({$gap-pct})"/>
          </xsl:when>
          <!-- Full width Card -->
          <xsl:otherwise>
             <fo:table-column column-width="proportional-column-width(1)"/>
          </xsl:otherwise>
        </xsl:choose>

        <fo:table-body>
          <fo:table-row>
             <!-- Column 1: Always contains the Card content -->
             <!-- In RTL, Column 1 is on the Right. In LTR, Column 1 is on the Left. -->
             <fo:table-cell>
                <xsl:variable name="effective-shadow">
                   <xsl:call-template name="get-effective-shadow-value"/>
                </xsl:variable>
                <xsl:choose>
                   <xsl:when
                  test="$effective-shadow != '' and $effective-shadow != 'none' and $effective-shadow != 'no'"
                >
                      <xsl:variable name="card-content">
                         <xsl:call-template name="renderCardInternal"/>
                      </xsl:variable>
                      <xsl:call-template name="apply-shadow-wrapper">
                         <xsl:with-param name="inner" select="$card-content"/>
                         <xsl:with-param name="shadow-val" select="$effective-shadow"/>
                         <xsl:with-param name="margin-val" select="''"/>
                         <xsl:with-param name="reset-indent" select="true()"/>
                      </xsl:call-template>
                   </xsl:when>
                   <xsl:otherwise>
                      <xsl:call-template name="renderCardInternal"/>
                   </xsl:otherwise>
                </xsl:choose>
             </fo:table-cell>

             <!-- Column 2: Always contains the empty Gap (if any) -->
             <xsl:if test="$card-pct &lt; 100">
               <fo:table-cell>
                  <fo:block/>
               </fo:table-cell>
             </xsl:if>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block>
  </xsl:template>

  <xsl:template name="corner-mask">
    <xsl:param name="corner"/>
    <xsl:param name="radius"/>
    <xsl:variable name="is-top" select="$corner = 'tl' or $corner = 'tr'"/>
    <xsl:variable name="is-left" select="$corner = 'tl' or $corner = 'bl'"/>
    <xsl:variable name="radius-num" select="number(substring-before(concat($radius, 'pt'), 'pt'))"/>
    <xsl:variable name="border-num" select="number(substring-before(concat($bootstrap-border-width, 'pt'), 'pt'))"/>
    <xsl:variable name="inset" select="concat($radius-num - $border-num - 1.05, 'pt')"/>
    <fo:block-container position="absolute" width="{$radius}" height="{$radius}" overflow="hidden">
      <xsl:attribute name="top">
        <xsl:choose>
          <xsl:when test="$is-top"><xsl:value-of select="concat('-', (2 * $border-num) + 0.95, 'pt')"/></xsl:when>
          <xsl:otherwise>0pt</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="$is-left">
          <xsl:attribute name="left">
            <xsl:choose>
              <xsl:when test="$is-top"><xsl:value-of select="concat('-', $border-num + 0.45, 'pt')"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="concat('-', $bootstrap-border-width)"/></xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="left">
            <xsl:choose>
              <xsl:when test="$is-top"><xsl:value-of
                  select="concat('100% - ', $radius-num - $border-num - 0.45, 'pt')"
                /></xsl:when>
              <xsl:otherwise><xsl:value-of select="concat('100% - ', $inset)"/></xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <fo:block>
        <fo:instream-foreign-object>
          <svg:svg
            xmlns:svg="http://www.w3.org/2000/svg"
            width="{$radius}"
            height="{$radius}"
            viewBox="0 0 1 1"
            preserveAspectRatio="none"
          >
            <xsl:variable name="cx" select="if ($is-left) then 1 else 0"/>
            <xsl:variable name="oy" select="if ($is-top) then 0 else 1"/>
            <xsl:variable name="t" select="0.585786"/>
            <xsl:variable name="edge-x" select="(1 - $cx) + $t * ((2 * $cx) - 1)"/>
            <xsl:variable name="edge-y" select="$oy + $t * (1 - (2 * $oy))"/>
            <svg:path
              fill="white"
              d="{concat('M', 1 - $cx, ',', $oy, ' L', $edge-x, ',', $oy, ' L', 1 - $cx, ',', $edge-y, ' Z')}"
            />
          </svg:svg>
        </fo:instream-foreign-object>
      </fo:block>
    </fo:block-container>
  </xsl:template>

  <xsl:template name="renderCardInternal">
      <xsl:variable name="radius-probe">
        <fo:block-container><xsl:call-template name="bootstrap.decoration"/></fo:block-container>
      </xsl:variable>
      <xsl:variable name="card-radius-raw" select="normalize-space($radius-probe/*/@fox:border-radius)"/>
      <xsl:variable name="card-radius" select="if (ends-with($card-radius-raw, 'pt')) then $card-radius-raw else ''"/>

      <fo:block-container xsl:use-attribute-sets="section" position="relative">
        <xsl:call-template name="commonattributes"/>

        <!-- Start-aligned within its cell -->
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
        <xsl:attribute name="end-indent">0pt</xsl:attribute>

        <!-- Frame Border: Uses @theme if present, falls back to light gray -->
        <xsl:attribute name="border">
          <xsl:value-of select="concat($bootstrap-border-width, ' solid')"/>
        </xsl:attribute>
        <xsl:variable name="theme">
          <xsl:call-template name="get-theme-color"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$theme != ''">
            <xsl:call-template name="processBootstrapBorderColor">
              <xsl:with-param name="attrValue" select="$theme"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="border-style">solid</xsl:attribute>
            <xsl:attribute name="border-width"><xsl:value-of select="$bootstrap-border-width"/></xsl:attribute>
            <xsl:attribute name="border-color"><xsl:value-of select="$bootstrap-border-color"/></xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <!-- Ensure the entire card stays on one page -->
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:variable name="effective-shadow">
          <xsl:call-template name="get-effective-shadow-value"/>
        </xsl:variable>
        <xsl:if test="$effective-shadow != '' and $effective-shadow != 'none' and $effective-shadow != 'no'">
          <xsl:attribute name="background-color">white</xsl:attribute>
        </xsl:if>
        <xsl:attribute name="overflow">hidden</xsl:attribute>
        <xsl:call-template name="bootstrap.decoration"/>
        <xsl:if test="$card-radius != ''">
          <xsl:attribute name="fox:border-radius" select="$card-radius"/>
        </xsl:if>

      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="proportional-column-width(1)"/>
        <fo:table-body>

          <!-- Element Selection -->
          <xsl:variable name="all-images" select="*[self::image or contains(@class, ' topic/image ')]"/>
          <xsl:variable
            name="top-images"
            select="$all-images[contains(@outputclass, 'card-img-top')] | ($all-images[1][not(contains(@outputclass, 'card-img-bottom'))])"
          />
          <xsl:variable
            name="header"
            select="*[self::card-header or contains(@class, ' bootstrap-d/card-header ') or contains(@outputclass, 'card-header')]"
          />
          <xsl:variable
            name="footer"
            select="*[self::card-footer or contains(@class, ' bootstrap-d/card-footer ') or contains(@outputclass, 'card-footer')]"
          />
          <xsl:variable name="title" select="*[self::title or contains(@class, ' topic/title ')]"/>

          <!-- 1. Card Header Row -->
          <xsl:if test="$header">
            <fo:table-row>
              <fo:table-cell padding="8pt 15pt">
                 <xsl:choose>
                    <xsl:when test="$theme != ''">
                       <xsl:call-template name="processBootstrapAttrSetReflection">
                          <xsl:with-param name="attrSet" select="concat('__bg__', $theme)"/>
                       </xsl:call-template>
                       <xsl:attribute name="border-bottom">
                          <xsl:value-of select="concat($bootstrap-border-width, ' solid')"/>
                       </xsl:attribute>
                       <xsl:attribute name="border-bottom-color">
                          <xsl:call-template name="getBootstrapAttrValue">
                             <xsl:with-param name="attrSet" select="concat('border-', $theme)"/>
                             <xsl:with-param name="attrName" select="'border-color'"/>
                          </xsl:call-template>
                       </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                       <xsl:call-template name="processBootstrapAttrSetReflection">
                          <xsl:with-param name="attrSet" select="'__bg__secondary'"/>
                       </xsl:call-template>
                       <xsl:attribute name="border-bottom">
                          <xsl:value-of select="concat($bootstrap-border-width, ' solid ', $bootstrap-border-color)"/>
                       </xsl:attribute>
                    </xsl:otherwise>
                 </xsl:choose>
                 <xsl:call-template name="processBootstrapDirection"/>
                 <fo:block>
                    <xsl:call-template name="processBootstrapDirection"/>
                    <xsl:apply-templates select="$header"/>
                 </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 2. Image Row (Image moved down by 4pt) -->
          <xsl:if test="$top-images">
            <fo:table-row line-height="0">
              <fo:table-cell padding="4pt 0 0 0">
                 <fo:block>
                    <xsl:apply-templates select="$top-images"/>
                 </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <!-- 3. Title Row -->
          <xsl:if test="$title">
            <fo:table-row>
              <fo:table-cell padding="10pt 15pt 0 15pt">
                 <xsl:call-template name="processBootstrapDirection"/>
                 <fo:block>
                    <xsl:call-template name="processBootstrapDirection"/>
                        <xsl:apply-templates select="$title"/>
                 </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

          <fo:table-row>
            <fo:table-cell padding="10pt 15pt">
               <xsl:call-template name="processBootstrapDirection"/>
               <fo:block>
                  <xsl:call-template name="processBootstrapDirection"/>
                  <xsl:apply-templates
                  select="node() except (
                     $title |
                     $top-images |
                     $header |
                     $footer |
                     processing-instruction('ditaot')
                  )"
                />
               </fo:block>
            </fo:table-cell>
          </fo:table-row>

          <!-- 5. Card Footer Row -->
          <xsl:if test="$footer">
            <fo:table-row>
              <fo:table-cell padding="8pt 15pt">
                 <xsl:choose>
                    <xsl:when test="$theme != ''">
                       <xsl:call-template name="processBootstrapAttrSetReflection">
                          <xsl:with-param name="attrSet" select="concat('__bg__', $theme, '-subtle')"/>
                       </xsl:call-template>
                       <xsl:attribute name="border-top">
                          <xsl:value-of select="concat($bootstrap-border-width, ' solid')"/>
                       </xsl:attribute>
                       <xsl:attribute name="border-top-color">
                          <xsl:call-template name="getBootstrapAttrValue">
                             <xsl:with-param name="attrSet" select="concat('border-', $theme)"/>
                             <xsl:with-param name="attrName" select="'border-color'"/>
                          </xsl:call-template>
                       </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                       <xsl:call-template name="processBootstrapAttrSetReflection">
                          <xsl:with-param name="attrSet" select="'__bg__secondary-subtle'"/>
                       </xsl:call-template>
                       <xsl:attribute name="border-top">
                          <xsl:value-of select="concat($bootstrap-border-width, ' solid ', $bootstrap-border-color)"/>
                       </xsl:attribute>
                    </xsl:otherwise>
                 </xsl:choose>
                 <xsl:call-template name="processBootstrapDirection"/>
                 <fo:block>
                    <xsl:call-template name="processBootstrapDirection"/>
                    <xsl:apply-templates select="$footer"/>
                   </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:if>

        </fo:table-body>
      </fo:table>

      <!-- Corner masks -->
      <xsl:if test="$card-radius != ''">
        <xsl:variable
          name="has-top-content"
          select="boolean(
          *[self::card-header or contains(@class, ' bootstrap-d/card-header ') or contains(@outputclass, 'card-header')]
          | *[self::image or contains(@class, ' topic/image ')]
        )"
        />
        <xsl:variable
          name="has-footer"
          select="boolean(*[self::card-footer or contains(@class, ' bootstrap-d/card-footer ') or contains(@outputclass, 'card-footer')])"
        />
        <xsl:if test="$has-top-content">
          <xsl:call-template name="corner-mask">
            <xsl:with-param name="corner" select="'tl'"/>
            <xsl:with-param name="radius" select="$card-radius"/>
          </xsl:call-template>
          <xsl:call-template name="corner-mask">
            <xsl:with-param name="corner" select="'tr'"/>
            <xsl:with-param name="radius" select="$card-radius"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$has-footer">
          <xsl:variable name="strip-radius-num" select="number(substring-before(concat($card-radius, 'pt'), 'pt'))"/>
          <xsl:variable
            name="strip-border-num"
            select="number(substring-before(concat($bootstrap-border-width, 'pt'), 'pt'))"
          />
          <fo:block-container
            height="{$card-radius}"
            margin-top="-{$strip-radius-num - (2 * $strip-border-num) - 2}pt"
            position="relative"
          >
            <xsl:call-template name="corner-mask">
              <xsl:with-param name="corner" select="'bl'"/>
              <xsl:with-param name="radius" select="$card-radius"/>
            </xsl:call-template>
            <xsl:call-template name="corner-mask">
              <xsl:with-param name="corner" select="'br'"/>
              <xsl:with-param name="radius" select="$card-radius"/>
            </xsl:call-template>
          </fo:block-container>
        </xsl:if>
      </xsl:if>
      </fo:block-container>
  </xsl:template>

  <!-- Card Title specialized rendering (Removes extra section margins) -->
  <xsl:template
    match="*[self::card or contains(@class, ' bootstrap-d/card ') or (tokenize(@outputclass, ' ') = 'card' and (contains(@class, ' topic/section ') or contains(@class, ' topic/div ') or contains(@class, ' topic/bodydiv ')))]/*[self::title or contains(@class, ' topic/title ')]"
    priority="5"
  >
    <fo:block font-size="14pt" font-weight="bold" margin-bottom="8pt">
       <xsl:call-template name="processBootstrapDirection"/>
       <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- Card Images (Ensure 100% width scaling within the row) -->
  <xsl:template
    match="*[self::card or contains(@class, ' bootstrap-d/card ') or (tokenize(@outputclass, ' ') = 'card' and (contains(@class, ' topic/section ') or contains(@class, ' topic/div ') or contains(@class, ' topic/bodydiv ')))]//*[self::image or contains(@class, ' topic/image ')]"
    priority="5"
  >
    <fo:block text-align="center">
      <xsl:call-template name="processBootstrapDirection"/>
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

  <!-- Card Header/Footer internal blocks -->
  <xsl:template
    match="*[self::card-header or self::card-footer or contains(@class, ' bootstrap-d/card-header ') or contains(@class, ' bootstrap-d/card-footer ') or contains(@outputclass, 'card-header') or contains(@outputclass, 'card-footer')]"
    priority="5"
  >
     <fo:block font-weight="bold">
        <xsl:call-template name="processBootstrapDirection"/>
        <xsl:apply-templates/>
     </fo:block>
  </xsl:template>

  <!-- Card bootstrapDecoration override (forces transparent background for the card body) -->
  <xsl:template
    match="*[self::card or contains(@class, ' bootstrap-d/card ') or (tokenize(@outputclass, ' ') = 'card' and (contains(@class, ' topic/section ') or contains(@class, ' topic/div ') or contains(@class, ' topic/bodydiv ')))]"
    mode="bootstrapDecoration"
    priority="5"
  >
      <xsl:param name="variant" select="''"/>
      <xsl:param name="theme" select="''"/>
      <xsl:param name="prefix" select="''"/>
      <xsl:param name="defaultRounded" select="false()"/>

      <xsl:call-template name="processBootstrapSpacing">
          <xsl:with-param name="node" select="."/>
          <xsl:with-param name="prefix" select="'p'"/>
      </xsl:call-template>
      <xsl:call-template name="processBootstrapSpacing">
          <xsl:with-param name="node" select="."/>
          <xsl:with-param name="prefix" select="'m'"/>
      </xsl:call-template>
      <xsl:call-template name="processBootstrapWidth">
          <xsl:with-param name="node" select="."/>
      </xsl:call-template>
      <xsl:call-template name="processBootstrapBorder">
          <xsl:with-param name="attrValue" select="@border"/>
      </xsl:call-template>
      <xsl:call-template name="processBootstrapRounded">
          <xsl:with-param name="node" select="."/>
          <xsl:with-param name="isDefault" select="true()"/>
      </xsl:call-template>
      <xsl:call-template name="processBootstrapOutputClass">
          <xsl:with-param name="attrValue" select="@outputclass"/>
      </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
