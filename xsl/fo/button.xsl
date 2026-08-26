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

  <!-- Button Toolbar Support (Single Row Block) -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/button-toolbar ') or (tokenize(@outputclass, ' ') = 'btn-toolbar' and (contains(@class, ' topic/div ') or contains(@class, ' topic/bodydiv ')))]"
    priority="5"
  >
    <fo:block margin-top="6pt" margin-bottom="6pt" wrap-option="no-wrap" keep-together.within-line="always">
      <xsl:call-template name="commonattributes"/>
      <xsl:apply-templates mode="toolbar-child"/>
    </fo:block>
  </xsl:template>

  <!-- Skip group containers in toolbars, just process buttons -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/button-group ') or (tokenize(@outputclass, ' ') = 'btn-group' and (contains(@class, ' topic/div ') or contains(@class, ' topic/bodydiv ')))]"
    mode="toolbar-child"
  >
    <xsl:apply-templates mode="toolbar-child"/>
  </xsl:template>

  <!-- Process buttons directly in toolbar -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/button ') or (exists(tokenize(@outputclass, ' ')[starts-with(., 'btn')]) and (contains(@class, ' topic/xref ') or contains(@class, ' topic/ph ')))]"
    mode="toolbar-child"
  >
    <xsl:apply-templates select="."/>
  </xsl:template>

  <xsl:template match="text()" mode="toolbar-child"/>

  <!-- Button Group Support (Standard) -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/button-group ') or (tokenize(@outputclass, ' ') = 'btn-group' and (contains(@class, ' topic/div ') or contains(@class, ' topic/bodydiv ')))]"
    priority="5"
  >
    <xsl:variable name="is-vertical" select="@vertical = 'yes'"/>
    <xsl:choose>
        <xsl:when test="$is-vertical">
          <!-- Width calculation based on string length -->
          <xsl:variable name="max-chars">
             <xsl:variable
            name="lengths"
            select="for $b in *[contains(@class, ' bootstrap-d/button ') or exists(tokenize(@outputclass, ' ')[starts-with(., 'btn')])] return string-length(normalize-space($b))"
          />
             <xsl:value-of select="if (empty($lengths)) then 0 else max($lengths)"/>
          </xsl:variable>
          
          <xsl:variable name="has-icon" select="boolean(descendant::*[contains(@class, ' bootstrap-d/icon ')])"/>
          <!-- 0.1em per char + 1em for icon + 0.5em for minimum margin -->
          <xsl:variable name="width-em" select="($max-chars * 0.1) + (if ($has-icon) then 1.5 else 0) + 0.5"/>

          <fo:block margin-top="6pt" margin-bottom="6pt">
             <xsl:call-template name="commonattributes"/>
             <fo:inline-container width="{$width-em}em" vertical-align="middle">
                <fo:table table-layout="fixed" width="{$width-em}em">
                   <fo:table-column column-width="{$width-em}em"/>
                   <fo:table-body>
                      <xsl:apply-templates mode="vertical-button-group"/>
                   </fo:table-body>
                </fo:table>
             </fo:inline-container>
          </fo:block>
        </xsl:when>
       <xsl:otherwise>
          <fo:inline>
             <xsl:call-template name="commonattributes"/>
             <xsl:apply-templates/>
          </fo:inline>
       </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Special processing for buttons in vertical groups -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/button ') or (exists(tokenize(@outputclass, ' ')[starts-with(., 'btn')]) and (contains(@class, ' topic/xref ') or contains(@class, ' topic/ph ')))]"
    mode="vertical-button-group"
  >
     <fo:table-row>
        <fo:table-cell>
           <fo:block>
              <xsl:apply-templates select="."/>
           </fo:block>
        </fo:table-cell>
     </fo:table-row>
  </xsl:template>

  <!-- Button Support -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/button ') or (exists(tokenize(@outputclass, ' ')[starts-with(., 'btn')]) and (contains(@class, ' topic/xref ') or contains(@class, ' topic/ph ')))]"
    priority="20"
  >
    <xsl:variable
      name="is-vertical"
      select="ancestor::*[contains(@class, ' bootstrap-d/button-group ') or tokenize(@outputclass, ' ') = 'btn-group'][1]/@vertical = 'yes'"
    />
    <xsl:variable name="element" select="if ($is-vertical) then 'fo:block' else 'fo:inline'"/>
    <xsl:variable
      name="is-external"
      select="boolean(@href) and ((@scope = 'external') or not(empty(@format) or @format = 'dita'))"
    />
    <xsl:variable
      name="internal-dest-id"
      select="if (@href and not($is-external)) then opentopic-func:getDestinationId(@href) else ''"
    />
    <xsl:variable name="has-destination" select="$is-external or ($internal-dest-id != '')"/>

    <xsl:variable name="button-content" as="node()*">
      <xsl:element name="{$element}">
        <xsl:call-template name="commonattributes"/>
        <xsl:variable name="rawTheme">
          <xsl:choose>
            <xsl:when test="@style = 'none'"/>
            <xsl:when test="@theme"><xsl:value-of select="@theme"/></xsl:when>
            <xsl:when test="exists(tokenize(@outputclass, ' ')[starts-with(., 'theme-')])">
              <xsl:value-of
                select="substring-after(tokenize(@outputclass, ' ')[starts-with(., 'theme-')][1], 'theme-')"
              />
            </xsl:when>
            <xsl:when
              test="exists(tokenize(@outputclass, ' ')[starts-with(., 'btn-') and not(. = ('btn-lg', 'btn-sm', 'btn-xs', 'btn-toolbar', 'btn-group', 'btn-solid', 'btn-outline', 'btn-subtle', 'btn-text', 'btn-link', 'btn-styled'))])"
            >
              <xsl:variable
                name="token"
                select="tokenize(@outputclass, ' ')[starts-with(., 'btn-') and not(. = ('btn-lg', 'btn-sm', 'btn-xs', 'btn-toolbar', 'btn-group', 'btn-solid', 'btn-outline', 'btn-subtle', 'btn-text', 'btn-link', 'btn-styled'))][1]"
              />
              <xsl:value-of
                select="substring-after($token, if (contains($token, 'outline-')) then 'btn-outline-' else 'btn-')"
              />
            </xsl:when>
            <xsl:otherwise>primary</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable
          name="theme"
          select="if (contains($rawTheme, '-')) then substring-before($rawTheme, '-') else $rawTheme"
        />
        <xsl:variable
          name="themeSuffix"
          select="if (contains($rawTheme, '-')) then substring-after($rawTheme, '-') else ''"
        />

        <xsl:variable name="size">
          <xsl:choose>
            <xsl:when test="@size"><xsl:value-of select="@size"/></xsl:when>
            <xsl:when test="tokenize(@outputclass, ' ') = 'btn-lg'">large</xsl:when>
            <xsl:when test="tokenize(@outputclass, ' ') = 'btn-sm'">small</xsl:when>
            <xsl:when test="tokenize(@outputclass, ' ') = 'btn-xs'">xs</xsl:when>
            <xsl:otherwise>default</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- Style variant: none | solid (default) | outline | subtle | text. -->
        <xsl:variable
          name="is-outline"
          select="@style = 'outline' or $themeSuffix = 'outline' or $themeSuffix = 'outline-styled' or exists(tokenize(@outputclass, ' ')[. = 'btn-outline' or starts-with(., 'btn-outline-')])"
        />
        <xsl:variable
          name="is-subtle"
          select="@style = 'subtle' or $themeSuffix = 'subtle' or $themeSuffix = 'subtle-styled' or exists(tokenize(@outputclass, ' ')[. = 'btn-subtle'])"
        />
        <xsl:variable
          name="is-text"
          select="@style = 'text' or $themeSuffix = 'text' or exists(tokenize(@outputclass, ' ')[. = 'btn-text'])"
        />
        <xsl:variable name="is-none" select="@style = 'none'"/>

        <!-- Background & Text Colors -->
        <xsl:choose>
          <xsl:when test="$is-none or $theme = ''"/>
          <xsl:when test="$is-subtle">
            <xsl:call-template name="bootstrap.decoration">
                <xsl:with-param name="theme" select="concat($theme, '-subtle')"/>
                <xsl:with-param name="prefix" select="'__bg__'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$is-outline or $is-text">
            <xsl:call-template name="processBootstrapAttrSetReflection">
              <xsl:with-param name="attrSet" select="concat('__color__', $theme)"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="processBootstrapAttrSetReflection">
              <xsl:with-param name="attrSet" select="concat('__btn__', $theme)"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>

        <!-- Borders: text, subtle, and bare ("none") buttons have no border, matching the HTML look -->
        <xsl:if test="not($is-text or $is-subtle or $is-none)">
          <xsl:attribute name="border-style">solid</xsl:attribute>
          <xsl:attribute name="border-width">
             <xsl:choose>
               <!-- Outline buttons require a border to be visible; enforce 1pt if theme globally suppresses borders -->
               <xsl:when
                test="$is-outline and normalize-space($bootstrap-border-width) = ('0', '0pt', '0px', 'none', '')"
              >1pt</xsl:when>
               <xsl:otherwise><xsl:value-of select="$bootstrap-border-width"/></xsl:otherwise>
             </xsl:choose>
          </xsl:attribute>
          <xsl:if test="$theme != ''">
            <xsl:call-template name="processBootstrapBorderColor">
              <xsl:with-param name="attrValue" select="$theme"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:if>
        
        <!-- Size-dependent Padding & Font Size -->
        <xsl:choose>
          <xsl:when test="$size = 'xs'">
            <xsl:attribute name="font-size">7.5pt</xsl:attribute>
            <xsl:attribute name="padding">1pt 3pt</xsl:attribute>
          </xsl:when>
          <xsl:when test="$size = 'small'">
            <xsl:attribute name="font-size">9pt</xsl:attribute>
            <xsl:attribute name="padding">1.5pt 4pt</xsl:attribute>
          </xsl:when>
          <xsl:when test="$size = 'large'">
            <xsl:attribute name="font-size">14pt</xsl:attribute>
            <xsl:attribute name="padding">6pt 12pt</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="font-size">11pt</xsl:attribute>
            <xsl:choose>
               <xsl:when test="contains(@outputclass, 'btn-icon')">
                  <xsl:attribute name="padding">7.5pt 4pt 4.5pt 2pt</xsl:attribute>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:attribute name="padding">3pt 8pt</xsl:attribute>
               </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>

        <!-- Override padding if specified -->
        <xsl:if test="@padding">
          <xsl:call-template name="processBootstrapSpacing">
            <xsl:with-param name="attrValue" select="@padding"/>
            <xsl:with-param name="prefix" select="'p'"/>
          </xsl:call-template>
        </xsl:if>
        
        <!-- Rounding (Default to '2' (4pt) instead of 'yes' (6pt)) -->
        <xsl:call-template name="processBootstrapRounded">
          <xsl:with-param name="attrValue" select="(@rounded, if ($size = ('xs', 'small')) then '1' else '2')[1]"/>
        </xsl:call-template>
        
        <!-- Legacy / Spacing utility support -->
        <xsl:call-template name="processBootstrapSpacing">
          <xsl:with-param name="attrValue" select="@margin"/>
          <xsl:with-param name="prefix" select="'m'"/>
        </xsl:call-template>

        <xsl:call-template name="processBootstrapOutputClass">
          <xsl:with-param name="attrValue" select="@outputclass"/>
        </xsl:call-template>

        <xsl:call-template name="processBootstrapDirection"/>

        <!-- Button Group Position Awareness  -->
        <xsl:variable
          name="group"
          select="ancestor::*[contains(@class, ' bootstrap-d/button-group ') or tokenize(@outputclass, ' ') = 'btn-group'][1]"
        />
        <xsl:if test="$group">
          <xsl:variable
            name="is-first"
            select="not(preceding-sibling::*[contains(@class, ' bootstrap-d/button ') or exists(tokenize(@outputclass, ' ')[starts-with(., 'btn')])])"
          />
          <xsl:variable
            name="is-last"
            select="not(following-sibling::*[contains(@class, ' bootstrap-d/button ') or exists(tokenize(@outputclass, ' ')[starts-with(., 'btn')])])"
          />
          <xsl:variable name="is-vertical" select="$group/@vertical = 'yes'"/>
          <xsl:choose>
            <!-- Single item: Keep all rounding, zero margins -->
            <xsl:when test="$is-first and $is-last">
              <xsl:attribute name="margin">0pt</xsl:attribute>
            </xsl:when>
            <!-- Vertical Orientation -->
            <xsl:when test="$is-vertical">
              <xsl:attribute name="width">100%</xsl:attribute>
              <xsl:attribute name="text-align">center</xsl:attribute>
              <xsl:choose>
                <xsl:when test="not($is-first) and not($is-last)">
                  <xsl:attribute name="fox:border-radius">0</xsl:attribute>
                  <xsl:attribute name="margin-top">-1pt</xsl:attribute>
                  <xsl:attribute name="margin-bottom">-1pt</xsl:attribute>
                </xsl:when>
                <xsl:when test="$is-first">
                  <xsl:attribute name="fox:border-after-start-radius">0</xsl:attribute>
                  <xsl:attribute name="fox:border-after-end-radius">0</xsl:attribute>
                  <xsl:attribute name="margin-top">0pt</xsl:attribute>
                  <xsl:attribute name="margin-bottom">-1pt</xsl:attribute>
                </xsl:when>
                <xsl:when test="$is-last">
                  <xsl:attribute name="fox:border-before-start-radius">0</xsl:attribute>
                  <xsl:attribute name="fox:border-before-end-radius">0</xsl:attribute>
                  <xsl:attribute name="margin-top">-1pt</xsl:attribute>
                  <xsl:attribute name="margin-bottom">0pt</xsl:attribute>
                </xsl:when>
              </xsl:choose>
            </xsl:when>
            <!-- Horizontal Orientation (Default) -->
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="not($is-first) and not($is-last)">
                  <xsl:attribute name="fox:border-radius">0</xsl:attribute>
                  <xsl:attribute name="margin-left">-1pt</xsl:attribute>
                  <xsl:attribute name="margin-right">-1pt</xsl:attribute>
                </xsl:when>
                <xsl:when test="$is-first">
                  <xsl:attribute name="fox:border-before-end-radius">0</xsl:attribute>
                  <xsl:attribute name="fox:border-after-end-radius">0</xsl:attribute>
                  <xsl:attribute name="margin-left">0pt</xsl:attribute>
                  <xsl:attribute name="margin-right">-1pt</xsl:attribute>
                </xsl:when>
                <xsl:when test="$is-last">
                  <xsl:attribute name="fox:border-before-start-radius">0</xsl:attribute>
                  <xsl:attribute name="fox:border-after-start-radius">0</xsl:attribute>
                  <xsl:attribute name="margin-left">-1pt</xsl:attribute>
                  <xsl:attribute name="margin-right">0pt</xsl:attribute>
                </xsl:when>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>

        <!-- Content handling - ensure we only process the intended text -->
        <fo:inline>
          <xsl:if test="normalize-space() != '' and not(contains(@outputclass, 'btn-floating'))">
            <xsl:attribute name="baseline-shift">0.5pt</xsl:attribute>
          </xsl:if>
          <xsl:choose>
            <!-- If button has explicit child text or formatting elements, use those -->
            <xsl:when test="node()[not(self::processing-instruction('ditaot'))]">
              <xsl:apply-templates select="node()" mode="bootstrap-label"/>
            </xsl:when>
            <!-- Fallback: retrieve target title only (cleanly) -->
            <xsl:when test="@href">
               <xsl:variable name="dest" select="opentopic-func:getDestinationId(@href)"/>
               <xsl:variable name="target" select="key('key_anchor', $dest, $root)[1]"/>
               <xsl:choose>
                  <xsl:when test="$target/*[contains(@class, ' topic/title ')]">
                     <xsl:apply-templates select="$target/*[contains(@class, ' topic/title ')]" mode="insert-text"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="@href"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
          </xsl:choose>
        </fo:inline>
      </xsl:element>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$has-destination">
        <fo:basic-link xsl:use-attribute-sets="xref">
          <!-- Link Destination -->
          <xsl:choose>
            <xsl:when test="$is-external">
              <xsl:attribute name="external-destination">url('<xsl:value-of select="@href"/>')</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="internal-destination" select="$internal-dest-id"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:sequence select="$button-content"/>
        </fo:basic-link>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$button-content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' topic/xref ') and (@theme or exists(tokenize(@outputclass, ' ')[starts-with(., 'link-') or . = 'link-underline']))]"
    priority="10"
  >
    <xsl:variable name="theme">
      <xsl:choose>
        <xsl:when test="@theme">
          <xsl:value-of select="if (contains(@theme, '-')) then substring-before(@theme, '-') else @theme"/>
        </xsl:when>
        <xsl:when test="exists(tokenize(@outputclass, ' ')[starts-with(., 'link-') and not(. = 'link-underline')])">
           <xsl:value-of
            select="substring-after(tokenize(@outputclass, ' ')[starts-with(., 'link-') and not(. = 'link-underline')][1], 'link-')"
          />
        </xsl:when>
        <xsl:otherwise>primary</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="color">
       <xsl:variable name="explicitVar" select="concat('bootstrap-', $theme)"/>
       <xsl:choose>
          <xsl:when test="$bootstrap-settings/entry[@name = $explicitVar]">
             <xsl:value-of select="$bootstrap-settings/entry[@name = $explicitVar]"/>
          </xsl:when>
          <xsl:otherwise/>
       </xsl:choose>
    </xsl:variable>

    <xsl:variable
      name="is-external"
      select="boolean(@href) and ((@scope = 'external') or not(empty(@format) or @format = 'dita'))"
    />
    <xsl:variable
      name="internal-dest-id"
      select="if (@href and not($is-external)) then opentopic-func:getDestinationId(@href) else ''"
    />
    <xsl:variable name="has-destination" select="$is-external or ($internal-dest-id != '')"/>

    <xsl:element name="{if ($has-destination) then 'fo:basic-link' else 'fo:inline'}" use-attribute-sets="xref">
      <xsl:call-template name="commonattributes"/>
      <xsl:if test="$color != ''">
         <xsl:attribute name="color"><xsl:value-of select="$color"/></xsl:attribute>
      </xsl:if>

      <xsl:if test="tokenize(@outputclass, ' ') = 'link-underline'">
         <xsl:attribute name="text-decoration">underline</xsl:attribute>
      </xsl:if>

      <xsl:if test="$has-destination">
        <xsl:choose>
          <xsl:when test="$is-external">
            <xsl:attribute name="external-destination">url('<xsl:value-of select="@href"/>')</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="internal-destination" select="$internal-dest-id"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>

      <xsl:choose>
        <!-- If link has explicit child text or icons, use those, but suppress metadata -->
        <xsl:when test="node()[not(self::processing-instruction('ditaot'))]">
          <xsl:apply-templates mode="bootstrap-label"/>
        </xsl:when>
        <!-- Fallback: retrieve target title only (cleanly) -->
        <xsl:otherwise>
          <xsl:apply-templates select="." mode="insert-text"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
