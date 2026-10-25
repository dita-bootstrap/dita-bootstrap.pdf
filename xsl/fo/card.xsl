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

  <!-- Match both specialized card elements and sections/divs with @outputclass='card' -->
  <!-- Aggressive priority="100" to override any other plugin or base templates. -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/card ') or (tokenize(@outputclass, ' ') = 'card' and (contains(@class, ' topic/section ') or contains(@class, ' topic/div ') or contains(@class, ' topic/bodydiv ')))]"
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

      <!-- Positioning Table Wrapper: Using Natural FO Flow -->
      <!-- The table writing-mode matches the component's direction, forcing Column 1 to the correct side. -->
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
                <xsl:choose>
                   <xsl:when test="@shadow and @shadow != 'none'">
                      <xsl:variable name="card-content">
                         <xsl:call-template name="renderCardInternal"/>
                      </xsl:variable>
                      <xsl:call-template name="apply-shadow-wrapper">
                         <xsl:with-param name="inner" select="$card-content"/>
                         <xsl:with-param name="shadow-val" select="@shadow"/>
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
    <xsl:param name="top" select="''"/>
    <xsl:param name="left" select="''"/>
    <xsl:param name="plain" select="false()"/>
    <xsl:variable name="glow"/>
    <xsl:variable name="is-top" select="$corner = 'tl' or $corner = 'tr'"/>
    <xsl:variable name="is-left" select="$corner = 'tl' or $corner = 'bl'"/>
    <xsl:variable name="radius-num" select="number(substring-before(concat($radius, 'pt'), 'pt'))"/>
    <xsl:variable name="border-num" select="number(substring-before(concat($bootstrap-border-width, 'pt'), 'pt'))"/>
    <xsl:variable name="inset" select="concat($radius-num - $border-num - 1.05, 'pt')"/>
    <fo:block-container position="absolute" width="{$radius}" height="{$radius}" overflow="hidden">
      <xsl:attribute name="top">
        <xsl:choose>
          <xsl:when test="$top != ''"><xsl:value-of select="$top"/></xsl:when>
          <xsl:when test="$border-num = 0 and $is-top">0pt</xsl:when>
          <xsl:when test="$is-top"><xsl:value-of
              select="concat('-', max((2 * $border-num, 2)) + 0.95, 'pt')"
            /></xsl:when>
          <xsl:otherwise>0pt</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="$left != ''">
          <xsl:attribute name="left" select="$left"/>
        </xsl:when>
        <xsl:when test="$border-num = 0">
          <xsl:attribute name="left" select="if ($is-left) then '0pt' else concat('100% - ', $radius-num, 'pt')"/>
        </xsl:when>
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
        <xsl:if test="$border-num = 0">
          <xsl:attribute name="font-size">0pt</xsl:attribute>
          <xsl:attribute name="line-height">0pt</xsl:attribute>
        </xsl:if>
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
            <xsl:variable
              name="arc"
              select="if ($corner = 'tl') then 'M0,0 L1,0 A1,1 0 0 0 0,1 Z'
                      else if ($corner = 'tr') then 'M1,0 L0,0 A1,1 0 0 1 1,1 Z'
                      else if ($corner = 'bl') then 'M0,1 L1,1 A1,1 0 0 1 0,0 Z'
                      else 'M1,1 L0,1 A1,1 0 0 0 1,0 Z'"
            />
            <svg:path
              fill="white"
              d="{if ($border-num = 0 or $radius-num gt 12) then $arc else concat('M', 1 - $cx, ',', $oy, ' L', $edge-x, ',', $oy, ' L', 1 - $cx, ',', $edge-y, ' Z')}"
            />
          </svg:svg>
        </fo:instream-foreign-object>
      </fo:block>
    </fo:block-container>
  </xsl:template>

  <xsl:template name="renderCardInternal">
      <xsl:variable name="radius-probe">
        <fo:block-container>
          <xsl:call-template name="bootstrap.decoration">
            <xsl:with-param name="defaultRounded" select="true()"/>
          </xsl:call-template>
        </fo:block-container>
      </xsl:variable>
      <xsl:variable name="card-radius-raw" select="normalize-space($radius-probe/*/@fox:border-radius)"/>
      <xsl:variable name="card-radius-first" select="tokenize($card-radius-raw, '\s+')[1]"/>
      <xsl:variable
      name="card-radius"
      select="if (ends-with($card-radius-first, 'px')) then concat(number(substring-before($card-radius-first, 'px')) * 0.75, 'pt') else $card-radius-first"
    />
      <fo:block-container xsl:use-attribute-sets="section" position="relative">
        <xsl:call-template name="commonattributes"/>
        
        <!-- Start-aligned within its cell -->
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
        <xsl:attribute name="end-indent">0pt</xsl:attribute>
        
        <!-- Frame Border: Uses @color theme if present, falls back to light gray -->
        <xsl:attribute name="border">
          <xsl:value-of select="concat($bootstrap-border-width, ' solid')"/>
        </xsl:attribute>
        <xsl:variable name="theme" select="@color"/>
        <xsl:choose>
          <xsl:when test="$theme">
            <xsl:call-template name="processBootstrapBorderColor">
              <xsl:with-param name="attrValue" select="$theme"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="border-color"><xsl:value-of select="$bootstrap-border-color"/></xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <!-- Ensure the entire card stays on one page -->
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:call-template name="bootstrap.decoration"/>
        <xsl:attribute name="overflow">hidden</xsl:attribute>
        <xsl:if test="$card-radius != ''">
          <xsl:attribute name="fox:border-radius" select="$card-radius"/>
        </xsl:if>

      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="proportional-column-width(1)"/>
        <fo:table-body>
          
          <!-- Element Selection -->
          <xsl:variable name="all-images" select="*[contains(@class, ' topic/image ')]"/>
          <xsl:variable
            name="top-images"
            select="$all-images[contains(@outputclass, 'card-img-top')] | ($all-images[1][not(contains(@outputclass, 'card-img-bottom'))])"
          />
          <xsl:variable
            name="header"
            select="*[contains(@class, ' bootstrap-d/card-header ') or contains(@outputclass, 'card-header')]"
          />
          <xsl:variable
            name="footer"
            select="*[contains(@class, ' bootstrap-d/card-footer ') or contains(@outputclass, 'card-footer')]"
          />
          <xsl:variable name="title" select="*[contains(@class, ' topic/title ')]"/>

          <!-- 1. Card Header Row -->
          <xsl:if test="$header">
            <fo:table-row>
              <fo:table-cell padding="8pt 15pt">
                 <xsl:choose>
                    <xsl:when test="$theme">
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
                       <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-light"/></xsl:attribute>
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
                 <xsl:if test="$theme">
                    <xsl:call-template name="processBootstrapAttrSetReflection">
                       <xsl:with-param name="attrSet" select="concat('__bg__', $theme, '-subtle')"/>
                    </xsl:call-template>
                 </xsl:if>
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
               <xsl:if test="$theme">
                  <xsl:call-template name="processBootstrapAttrSetReflection">
                     <xsl:with-param name="attrSet" select="concat('__bg__', $theme, '-subtle')"/>
                  </xsl:call-template>
               </xsl:if>
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
                 <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-light"/></xsl:attribute>
                 <xsl:attribute name="border-top">
                    <xsl:value-of select="concat($bootstrap-border-width, ' solid ', $bootstrap-border-color)"/>
                 </xsl:attribute>
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
        <xsl:if test="$has-footer and number(substring-before(concat($bootstrap-border-width, 'pt'), 'pt')) != 0">
          <xsl:variable name="strip-radius-num" select="number(substring-before(concat($card-radius, 'pt'), 'pt'))"/>
          <xsl:variable
            name="strip-border-num"
            select="number(substring-before(concat($bootstrap-border-width, 'pt'), 'pt'))"
          />
          <fo:block-container height="{$card-radius}" margin-top="-{$strip-radius-num}pt" position="relative">
            <xsl:variable name="arc-mask" select="$strip-radius-num gt 12"/>
            <xsl:call-template name="corner-mask">
              <xsl:with-param name="corner" select="'bl'"/>
              <xsl:with-param name="radius" select="$card-radius"/>
              <xsl:with-param name="top" select="if ($arc-mask) then concat($strip-border-num, 'pt') else ''"/>
              <xsl:with-param name="left" select="if ($arc-mask) then concat('-', $strip-border-num, 'pt') else ''"/>
            </xsl:call-template>
            <xsl:call-template name="corner-mask">
              <xsl:with-param name="corner" select="'br'"/>
              <xsl:with-param name="radius" select="$card-radius"/>
              <xsl:with-param name="top" select="if ($arc-mask) then concat($strip-border-num, 'pt') else ''"/>
              <xsl:with-param
                name="left"
                select="if ($arc-mask) then concat('100% - ', $strip-radius-num - $strip-border-num, 'pt') else ''"
              />
            </xsl:call-template>
          </fo:block-container>
        </xsl:if>
      </xsl:if>
      </fo:block-container>
  </xsl:template>

  <!-- Card Title specialized rendering (Removes extra section margins) -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/card ') or (tokenize(@outputclass, ' ') = 'card' and (contains(@class, ' topic/section ') or contains(@class, ' topic/div ') or contains(@class, ' topic/bodydiv ')))]/*[contains(@class, ' topic/title ')]"
    priority="5"
  >
    <xsl:variable name="theme" select="../@color"/>
    <xsl:variable name="title-color">
      <xsl:if test="$theme">
         <xsl:call-template name="getBootstrapAttrValue">
           <xsl:with-param name="attrSet" select="concat('__bg__', $theme, '-subtle')"/>
         </xsl:call-template>
      </xsl:if>
    </xsl:variable>

    <fo:block font-size="14pt" font-weight="bold" margin-bottom="8pt">
       <xsl:if test="$theme">
          <xsl:attribute name="color"><xsl:value-of select="$title-color"/></xsl:attribute>
       </xsl:if>
       <xsl:call-template name="processBootstrapDirection"/>
       <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- Card Images (Ensure 100% width scaling within the row) -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/card ') or (tokenize(@outputclass, ' ') = 'card' and (contains(@class, ' topic/section ') or contains(@class, ' topic/div ') or contains(@class, ' topic/bodydiv ')))]//*[contains(@class, ' topic/image ')]"
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
    match="*[contains(@class, ' bootstrap-d/card-header ') or contains(@outputclass, 'card-header')]"
    priority="5"
  >
     <fo:block font-weight="bold">
        <xsl:call-template name="processBootstrapDirection"/>
        <xsl:apply-templates/>
     </fo:block>
  </xsl:template>

</xsl:stylesheet>
