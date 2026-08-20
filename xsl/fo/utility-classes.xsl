<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0"
>

  <xsl:param name="BOOTSTRAP_ICONS_INCLUDE" select="'yes'"/>

  <!-- Helper Template to retrieve settings from the $bootstrap-settings map with a fallback -->
  <xsl:template name="getBootstrapSetting">
    <xsl:param name="name"/>
    <xsl:param name="default"/>
    <xsl:variable name="val" select="$bootstrap-settings/entry[@name = $name]"/>
    <xsl:choose>
      <xsl:when test="$val != ''"><xsl:value-of select="$val"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$default"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Map DITA Note Type to Bootstrap Theme -->
  <xsl:template name="getNoteTheme">
    <xsl:param name="type" select="'note'"/>
    <xsl:choose>
      <xsl:when test="$type = 'note' or $type = 'notice' or $type = 'remember'">info</xsl:when>
      <xsl:when test="$type = 'tip' or $type = 'fastpath'">success</xsl:when>
      <xsl:when test="$type = 'important'">primary</xsl:when>
      <xsl:when
        test="$type = 'warning' or $type = 'caution' or $type = 'restriction' or $type = 'trouble'"
      >warning</xsl:when>
      <xsl:when test="$type = 'danger'">danger</xsl:when>
      <xsl:otherwise>secondary</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- The 8 Bootstrap theme color names (bootstrap-color-values in the shared DTD). -->
  <xsl:variable
    name="bootstrap-theme-color-names"
    select="('primary', 'secondary', 'success', 'danger', 'warning', 'info', 'accent', 'inverse')"
    as="xs:string*"
  />

  <xsl:template name="get-outputclass-theme-color">
    <xsl:param name="outputclass" select="''"/>
    <xsl:variable
      name="match"
      select="
        (for $t in tokenize($outputclass, ' ')[starts-with(., 'theme-')]
         return substring-after($t, 'theme-'))[. = $bootstrap-theme-color-names][1]"
    />
    <xsl:value-of select="$match"/>
  </xsl:template>

  <xsl:template name="get-outputclass-theme-suffix">
    <xsl:param name="outputclass" select="''"/>
    <xsl:variable
      name="modifiers"
      select="
        (for $t in tokenize($outputclass, ' ')[starts-with(., 'theme-')]
         return substring-after($t, 'theme-'))[. = ('contrast', 'subtle', 'muted', 'border')]"
    />
    <xsl:value-of
      select="
        if (exists($modifiers[. = 'subtle']) and exists($modifiers[. = 'border'])) then 'subtle-border'
        else if (exists($modifiers[. = 'subtle'])) then 'subtle'
        else if (exists($modifiers[. = 'border'])) then 'border'
        else if (exists($modifiers[. = 'muted'])) then 'muted'
        else if (exists($modifiers[. = 'contrast'])) then 'contrast'
        else ''"
    />
  </xsl:template>

  <xsl:template name="get-theme-color">
    <xsl:param name="node" select="."/>
    <xsl:choose>
      <xsl:when test="$node/@theme">
        <xsl:value-of
          select="if (contains($node/@theme, '-')) then substring-before($node/@theme, '-') else $node/@theme"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="get-outputclass-theme-color">
          <xsl:with-param name="outputclass" select="$node/@outputclass"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="get-theme-suffix">
    <xsl:param name="node" select="."/>
    <xsl:choose>
      <xsl:when test="$node/@theme">
        <xsl:value-of select="if (contains($node/@theme, '-')) then substring-after($node/@theme, '-') else ''"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="get-outputclass-theme-suffix">
          <xsl:with-param name="outputclass" select="$node/@outputclass"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="apply-default-blockquote-border">
    <xsl:param name="node" select="."/>
    <xsl:variable name="direction">
      <xsl:choose>
        <xsl:when test="$node/@dir"><xsl:value-of select="$node/@dir"/></xsl:when>
        <xsl:when test="$node/ancestor::*[@dir]"><xsl:value-of select="$node/ancestor::*[@dir][1]/@dir"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$writing-mode"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable
      name="skipPadding"
      select="$node/@padding or exists(tokenize($node/@outputclass, ' ')[starts-with(., 'p-')])"
    />
    <xsl:choose>
      <xsl:when test="$direction = 'rtl' or $direction = 'rl'">
        <xsl:attribute name="border-right-width"><xsl:value-of
            select="$bootstrap-blockquote-border-width"
          /></xsl:attribute>
        <xsl:attribute name="border-right-style">solid</xsl:attribute>
        <xsl:attribute name="border-right-color"><xsl:value-of select="$bootstrap-border-color"/></xsl:attribute>
        <xsl:if test="not($skipPadding)">
          <xsl:attribute name="padding-right"><xsl:value-of select="$bootstrap-spacing-3"/></xsl:attribute>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="border-left-width"><xsl:value-of
            select="$bootstrap-blockquote-border-width"
          /></xsl:attribute>
        <xsl:attribute name="border-left-style">solid</xsl:attribute>
        <xsl:attribute name="border-left-color"><xsl:value-of select="$bootstrap-border-color"/></xsl:attribute>
        <xsl:if test="not($skipPadding)">
          <xsl:attribute name="padding-left"><xsl:value-of select="$bootstrap-spacing-3"/></xsl:attribute>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Retrieve the computed value of a specific attribute from an attribute-set -->
  <xsl:template name="getBootstrapAttrValue">
    <xsl:param name="attrSet"/>
    <xsl:param name="attrName" select="'color'"/>
    <xsl:param name="path" select="'../../cfg/fo/attrs/bootstrap-attr.xsl'"/>
    <xsl:variable
      name="custom-attr"
      select="if (doc-available('cfg:fo/attrs/custom.xsl')) then document('cfg:fo/attrs/custom.xsl')//xsl:attribute-set[@name = $attrSet]/xsl:attribute[@name = $attrName] else ()"
    />
    <xsl:variable
      name="theme-attr"
      select="if (not($custom-attr) and doc-available('cfg:fo/attrs/dita-ot.xsl')) then document('cfg:fo/attrs/dita-ot.xsl')//xsl:attribute-set[@name = $attrSet]/xsl:attribute[@name = $attrName] else ()"
    />
    <xsl:variable
      name="attr"
      select="($custom-attr, $theme-attr, document($path)//xsl:attribute-set[@name = $attrSet]/xsl:attribute[@name = $attrName])[1]"
    />
    <xsl:choose>
      <xsl:when test="$attr/xsl:value-of">
        <xsl:variable name="select" select="$attr/xsl:value-of/@select"/>
        <xsl:variable
          name="varName"
          select="if (starts-with($select, '$')) then substring-after($select, '$') else $select"
        />
        <xsl:value-of select="$bootstrap-settings/entry[@name = $varName]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$attr"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Reflection Template for Bootstrap Attribute Sets -->
  <xsl:template name="processBootstrapAttrSetReflection">
    <xsl:param name="attrSet"/>
    <xsl:param name="path" select="'../../cfg/fo/attrs/bootstrap-attr.xsl'"/>

    <xsl:variable
      name="custom-attrs"
      select="if (doc-available('cfg:fo/attrs/custom.xsl')) then document('cfg:fo/attrs/custom.xsl')//xsl:attribute-set[@name = $attrSet]/xsl:attribute else ()"
    />
    <xsl:variable
      name="theme-attrs"
      select="if (not($custom-attrs) and doc-available('cfg:fo/attrs/dita-ot.xsl')) then document('cfg:fo/attrs/dita-ot.xsl')//xsl:attribute-set[@name = $attrSet]/xsl:attribute else ()"
    />
    <xsl:variable
      name="attrs"
      select="(document($path)//xsl:attribute-set[@name = $attrSet]/xsl:attribute, $theme-attrs, $custom-attrs)"
    />

    <xsl:for-each select="$attrs">
      <xsl:attribute name="{@name}">
        <xsl:for-each select="node()">
          <xsl:choose>
            <xsl:when test="self::xsl:value-of">
              <xsl:variable name="select" select="@select"/>
              <xsl:variable
                name="varName"
                select="if (starts-with($select, '$')) then substring-after($select, '$') else $select"
              />
              <xsl:value-of select="$bootstrap-settings/entry[@name = $varName]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="."/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:attribute>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="processBootstrapWidth">
    <xsl:param name="node" select="."/>
    <xsl:param name="attrValue" select="$node/@width"/>
    <xsl:param name="outputclass" select="$node/@outputclass"/>
    
    <xsl:variable name="val">
        <xsl:choose>
            <xsl:when test="$attrValue != ''"><xsl:value-of select="$attrValue"/></xsl:when>
            <xsl:when test="exists(tokenize($outputclass, ' ')[starts-with(., 'w-')])">
                <xsl:value-of select="substring-after(tokenize($outputclass, ' ')[starts-with(., 'w-')][1], 'w-')"/>
            </xsl:when>
        </xsl:choose>
    </xsl:variable>

    <xsl:if test="$val != ''">
        <xsl:choose>
            <xsl:when test="$val = ('25', '50', '75', '100', 'auto')">
                <xsl:call-template name="processBootstrapAttrSetReflection">
                    <xsl:with-param name="attrSet" select="concat('w-', $val)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="width">
                    <xsl:value-of
              select="if (contains($val, '%') or contains($val, 'in') or contains($val, 'pt') or contains($val, 'px') or contains($val, 'mm') or contains($val, 'cm')) then $val else concat($val, '%')"
            />
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- Process @border attribute -->
  <xsl:template name="processBootstrapBorder">
    <xsl:param name="attrValue"/>
    <xsl:if test="$attrValue">
      <xsl:for-each select="tokenize(normalize-space($attrValue), ' ')">
        <xsl:variable name="token" select="."/>

        <!-- Apply base border style for numeric thickness outside the variable to avoid Saxon error -->
        <xsl:if test="string(number($token)) != 'NaN'">
          <xsl:call-template name="processBootstrapAttrSetReflection">
            <xsl:with-param name="attrSet" select="'border'"/>
          </xsl:call-template>
        </xsl:if>

        <xsl:variable name="attrSetName">
          <xsl:choose>
            <xsl:when test="$token = 'yes' or $token = 'true' or $token = 'border'">border</xsl:when>
            <xsl:when test="starts-with($token, 'border-')">
              <xsl:value-of select="$token"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('border-', $token)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:call-template name="processBootstrapAttrSetReflection">
          <xsl:with-param name="attrSet">
            <xsl:choose>
                <xsl:when test="$writing-mode = 'rl'">
                    <xsl:choose>
                        <xsl:when test="starts-with($attrSetName, 'ps-')"><xsl:value-of
                      select="concat('pe-', substring-after($attrSetName, '-'))"
                    /></xsl:when>
                        <xsl:when test="starts-with($attrSetName, 'pe-')"><xsl:value-of
                      select="concat('ps-', substring-after($attrSetName, '-'))"
                    /></xsl:when>
                        <xsl:when test="starts-with($attrSetName, 'ms-')"><xsl:value-of
                      select="concat('me-', substring-after($attrSetName, '-'))"
                    /></xsl:when>
                        <xsl:when test="starts-with($attrSetName, 'me-')"><xsl:value-of
                      select="concat('ms-', substring-after($attrSetName, '-'))"
                    /></xsl:when>
                        <xsl:otherwise><xsl:value-of select="$attrSetName"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="$attrSetName"/></xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <!-- Process @frame attribute for Figures -->
  <xsl:template name="processBootstrapFrame">
    <xsl:param name="attrValue"/>
    <xsl:if test="$attrValue">
      <xsl:variable name="processedValue">
        <xsl:choose>
          <xsl:when test="$attrValue = 'all'">border</xsl:when>
          <xsl:when test="$attrValue = 'sides'">start end</xsl:when>
          <xsl:when test="$attrValue = 'top'">top</xsl:when>
          <xsl:when test="$attrValue = 'bottom'">bottom</xsl:when>
          <xsl:when test="$attrValue = 'topbot'">top bottom</xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="normalize-space($processedValue) != ''">
        <xsl:call-template name="processBootstrapBorder">
          <xsl:with-param name="attrValue" select="$processedValue"/>
        </xsl:call-template>
        <!-- Effectively an additional padded border - using p-3 / 12pt -->
        <xsl:attribute name="padding"><xsl:value-of select="$bootstrap-spacing-3"/></xsl:attribute>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- Apply a border color from an explicit color name (e.g. a '-border' @theme suffix) -->
  <xsl:template name="processBootstrapBorderColor">
    <xsl:param name="attrValue"/>
    <xsl:param name="theme" select="''"/>
    
    <xsl:variable name="resolvedTheme" select="if ($theme != '') then $theme else $attrValue"/>
    
    <xsl:if test="$resolvedTheme != ''">
      <xsl:variable
        name="isZeroWidth"
        select="normalize-space($bootstrap-border-width) = ('0', '0pt', '0px', '0in', '0mm', '0cm', '0.0pt', '0.0px')"
      />
      <xsl:if test="not($isZeroWidth)">
        <xsl:attribute name="border-style">solid</xsl:attribute>
        <xsl:attribute name="border-width"><xsl:value-of select="$bootstrap-border-width"/></xsl:attribute>
      </xsl:if>
      <xsl:call-template name="processBootstrapAttrSetReflection">
        <xsl:with-param name="attrSet" select="concat('border-', $resolvedTheme)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


  <!-- Process @dir attribute for RTL/LTR direction -->
  <xsl:template name="processBootstrapDirection">
    <xsl:variable name="direction">
        <xsl:choose>
            <xsl:when test="@dir"><xsl:value-of select="@dir"/></xsl:when>
            <!-- ↓ Ensure code is rendered LTR in RTL documents ↓ -->
            <xsl:when
          test="$writing-mode = 'rl' and (contains(@class,' pr-d/') or contains(@class,' sw-d/') or contains(@class,' xml-d/'))"
        >ltr</xsl:when>
            <xsl:when test="ancestor::*[@dir]"><xsl:value-of select="ancestor::*[@dir][1]/@dir"/></xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$direction = 'rtl'">
        <xsl:attribute name="writing-mode">rl-tb</xsl:attribute>
        <xsl:attribute name="direction">rtl</xsl:attribute>
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="text-align-last">right</xsl:attribute>
      </xsl:when>
      <xsl:when test="$direction = 'ltr'">
        <xsl:attribute name="writing-mode">lr-tb</xsl:attribute>
        <xsl:attribute name="direction">ltr</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

   <xsl:template name="processBootstrapRounded">
    <xsl:param name="node" select="."/>
    <xsl:param name="attrValue" select="$node/@rounded"/>
    <xsl:param name="outputclass" select="$node/@outputclass"/>
    <xsl:param name="isDefault" select="false()"/>

    <xsl:variable name="val">
        <xsl:choose>
            <xsl:when test="$attrValue != ''"><xsl:value-of select="$attrValue"/></xsl:when>
            <xsl:when test="exists(tokenize($outputclass, ' ')[starts-with(., 'rounded-')])">
                <xsl:value-of
            select="substring-after(tokenize($outputclass, ' ')[starts-with(., 'rounded-')][1], 'rounded-')"
          />
            </xsl:when>
            <xsl:when test="tokenize($outputclass, ' ') = 'rounded'">yes</xsl:when>
            <xsl:when test="$isDefault">yes</xsl:when>
        </xsl:choose>
    </xsl:variable>

    <xsl:if test="$val != ''">
      <xsl:variable name="level" select="if ($val = ('yes', 'true')) then '' else concat('-', $val)"/>
      <xsl:variable name="varName" select="concat('bootstrap-rounded', $level)"/>
      <xsl:variable name="radius">
        <xsl:call-template name="getBootstrapSetting">
          <xsl:with-param name="name" select="$varName"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:if test="not(normalize-space($radius) = ('0', '0pt', '0px', '0in', '0mm', '0cm', '0.0pt', '0.0px'))">
        <xsl:variable
          name="attrSetName"
          select="if ($val = ('yes', 'true')) then 'rounded' else concat('rounded-', $val)"
        />
        <xsl:call-template name="processBootstrapAttrSetReflection">
          <xsl:with-param name="attrSet">
            <xsl:choose>
                <xsl:when test="$writing-mode = 'rl'">
                    <xsl:choose>
                        <xsl:when test="starts-with($attrSetName, 'ps-')"><xsl:value-of
                      select="concat('pe-', substring-after($attrSetName, '-'))"
                    /></xsl:when>
                        <xsl:when test="starts-with($attrSetName, 'pe-')"><xsl:value-of
                      select="concat('ps-', substring-after($attrSetName, '-'))"
                    /></xsl:when>
                        <xsl:when test="starts-with($attrSetName, 'ms-')"><xsl:value-of
                      select="concat('me-', substring-after($attrSetName, '-'))"
                    /></xsl:when>
                        <xsl:when test="starts-with($attrSetName, 'me-')"><xsl:value-of
                      select="concat('ms-', substring-after($attrSetName, '-'))"
                    /></xsl:when>
                        <xsl:otherwise><xsl:value-of select="$attrSetName"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="$attrSetName"/></xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="processBootstrapBackground">
    <xsl:param name="node" select="."/>
    <xsl:param name="outputclass" select="$node/@outputclass"/>
    <xsl:param name="variant" select="''"/> <!-- e.g. 'subtle' -->
    <xsl:param name="theme" select="''"/>
    <xsl:param name="prefix" select="''"/> <!-- e.g. '__badge__' -->
    <xsl:param
      name="isTableContext"
      select="contains($node/@class, ' topic/table ') or contains($node/@class, ' topic/row ') or contains($node/@class, ' topic/entry ')"
    />

    <xsl:variable name="resolvedTheme">
        <xsl:choose>
            <xsl:when test="$theme != ''"><xsl:value-of select="$theme"/></xsl:when>
            <xsl:when test="exists(tokenize($outputclass, ' ')[starts-with(., 'text-bg-')])">
                <xsl:value-of
            select="substring-after(tokenize($outputclass, ' ')[starts-with(., 'text-bg-')][1], 'text-bg-')"
          />
            </xsl:when>
            <xsl:when test="exists(tokenize($outputclass, ' ')[starts-with(., 'bg-')])">
                <xsl:value-of select="substring-after(tokenize($outputclass, ' ')[starts-with(., 'bg-')][1], 'bg-')"/>
            </xsl:when>
            <xsl:when test="exists(tokenize($outputclass, ' ')[starts-with(., 'table-')])">
                <xsl:value-of
            select="substring-after(tokenize($outputclass, ' ')[starts-with(., 'table-')][1], 'table-')"
          />
            </xsl:when>
        </xsl:choose>
    </xsl:variable>

    <xsl:if test="$resolvedTheme != ''">
        <xsl:variable name="attrSet">
            <xsl:choose>
                <xsl:when test="$isTableContext">
                    <xsl:value-of select="concat('__table__', $resolvedTheme)"/>
                </xsl:when>
                <xsl:when test="$prefix != ''">
                    <xsl:value-of select="concat($prefix, $resolvedTheme)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
              select="concat('__bg__', $resolvedTheme, if ($variant != '') then concat('-', $variant) else '')"
            />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="processBootstrapAttrSetReflection">
            <xsl:with-param name="attrSet" select="$attrSet"/>
        </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Process @margin and @padding attributes -->
  <xsl:template name="processBootstrapSpacing">
    <xsl:param name="prefix"/> <!-- 'p' or 'm' -->
    <xsl:param name="node" select="."/>
    <xsl:param name="attrValue" select="if ($prefix = 'p') then $node/@padding else $node/@margin"/>
    <xsl:param name="outputclass" select="$node/@outputclass"/>
    
    <!-- 1. Process explicit attribute -->
    <xsl:if test="$attrValue">
      <xsl:for-each select="tokenize(normalize-space($attrValue), ' ')">
        <xsl:variable name="token" select="."/>
        <xsl:variable name="attrSetName">
          <xsl:choose>
            <xsl:when test="$token = 'auto'">
              <xsl:value-of select="concat($prefix, '-auto')"/>
            </xsl:when>
            <xsl:when test="string-length($token) = 1">
              <xsl:value-of select="concat($prefix, '-', $token)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($prefix, substring($token, 1, 1), '-', substring($token, 2))"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="processBootstrapAttrSetReflection">
          <xsl:with-param name="attrSet">
            <xsl:choose>
                <xsl:when test="$writing-mode = 'rl'">
                    <xsl:choose>
                        <xsl:when test="starts-with($attrSetName, 'ps-')"><xsl:value-of
                      select="concat('pe-', substring-after($attrSetName, '-'))"
                    /></xsl:when>
                        <xsl:when test="starts-with($attrSetName, 'pe-')"><xsl:value-of
                      select="concat('ps-', substring-after($attrSetName, '-'))"
                    /></xsl:when>
                        <xsl:when test="starts-with($attrSetName, 'ms-')"><xsl:value-of
                      select="concat('me-', substring-after($attrSetName, '-'))"
                    /></xsl:when>
                        <xsl:when test="starts-with($attrSetName, 'me-')"><xsl:value-of
                      select="concat('ms-', substring-after($attrSetName, '-'))"
                    /></xsl:when>
                        <xsl:otherwise><xsl:value-of select="$attrSetName"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="$attrSetName"/></xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>

    <!-- 2. Process outputclass tokens -->
    <xsl:if test="$outputclass">
      <xsl:for-each select="tokenize(normalize-space($outputclass), ' ')">
        <xsl:variable name="token" select="."/>
        <xsl:if test="starts-with($token, $prefix) and contains($token, '-')">
           <xsl:call-template name="processBootstrapAttrSetReflection">
             <xsl:with-param name="attrSet">
                <xsl:choose>
                    <xsl:when test="$writing-mode = 'rl'">
                        <xsl:choose>
                            <xsl:when test="starts-with($token, 'ps-')"><xsl:value-of
                        select="concat('pe-', substring-after($token, '-'))"
                      /></xsl:when>
                            <xsl:when test="starts-with($token, 'pe-')"><xsl:value-of
                        select="concat('ps-', substring-after($token, '-'))"
                      /></xsl:when>
                            <xsl:when test="starts-with($token, 'ms-')"><xsl:value-of
                        select="concat('me-', substring-after($token, '-'))"
                      /></xsl:when>
                            <xsl:when test="starts-with($token, 'me-')"><xsl:value-of
                        select="concat('ms-', substring-after($token, '-'))"
                      /></xsl:when>
                            <xsl:otherwise><xsl:value-of select="$token"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of select="$token"/></xsl:otherwise>
                </xsl:choose>
             </xsl:with-param>
           </xsl:call-template>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <!-- Resolve the padding a single container applies to its own content -->
  <xsl:template name="get-container-side-padding">
    <xsl:param name="node"/>
    <xsl:param name="side" select="'start'"/>
    <xsl:variable name="attrName" select="if ($side = 'start') then 'padding-left' else 'padding-right'"/>
    <xsl:variable name="rtf">
      <tmp>
        <xsl:call-template name="processBootstrapSpacing">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="prefix" select="'p'"/>
        </xsl:call-template>
        <xsl:if
          test="$side = 'start'
                and contains($node/@class, ' topic/lq ')
                and not($node/@padding)
                and not(exists(tokenize($node/@outputclass, ' ')[starts-with(., 'p-')]))"
        >
          <xsl:attribute name="{$attrName}"><xsl:value-of select="$bootstrap-spacing-3"/></xsl:attribute>
        </xsl:if>
      </tmp>
    </xsl:variable>
    <xsl:variable name="resolved" select="($rtf/tmp/@*[local-name() = $attrName], $rtf/tmp/@padding)[1]"/>
    <xsl:value-of select="if ($resolved) then $resolved else '0'"/>
  </xsl:template>

  <!-- Sum the padding contributed by every ancestor of $node on the given side
       ('start' or 'end'). Works around a FOP layout bug: a block that has its own
       border + background + padding (e.g. <note>, via bootstrap.decoration) does
       not inherit an ancestor's *padding*-based inset when FOP paints that block's
       border/background box - only the FO start-indent/end-indent properties are
       correctly propagated. Bootstrap grid columns are excluded because they are
       rendered as fo:table-cell, whose width FOP already constrains natively. -->
  <xsl:template name="get-ancestor-padding-indent">
    <xsl:param name="node" select="."/>
    <xsl:param name="side" select="'start'"/>
    <xsl:variable
      name="containers"
      select="
        $node/ancestor::*[
          (@padding or
           exists(tokenize(@outputclass, ' ')[starts-with(., 'p-') or starts-with(., 'ps-') or starts-with(., 'pe-') or starts-with(., 'px-')]) or
           contains(@class, ' topic/lq '))
          and not(contains(@class, ' bootstrap-d/grid-col '))
          and not(exists(tokenize(@outputclass, ' ')[starts-with(., 'col') or contains(., ':col')]))
        ]"
    />
    <xsl:variable name="values" as="xs:double*">
      <xsl:for-each select="$containers">
        <xsl:variable name="raw">
          <xsl:call-template name="get-container-side-padding">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="side" select="$side"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="num" select="number(replace(normalize-space($raw), '[^0-9.\-].*$', ''))"/>
        <xsl:sequence select="if ($num != $num) then 0 else $num"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="format-number(sum(($values, 0)), '0.######')"/>
  </xsl:template>

  <!-- Process @outputclass attribute for Bootstrap classes -->
  <xsl:template name="processBootstrapOutputClass">
    <xsl:param name="attrValue"/>
    <xsl:if test="$attrValue">
      <xsl:variable name="tokens" select="tokenize(normalize-space($attrValue), ' ')"/>
      
      <!-- Pass 1: Background and other utilities -->
      <xsl:for-each select="$tokens">
        <xsl:variable name="token" select="."/>
        <xsl:choose>
          <xsl:when test="starts-with($token, 'bg-')">
            <xsl:call-template name="processBootstrapAttrSetReflection">
              <xsl:with-param name="attrSet" select="concat('__bg__', substring-after($token, 'bg-'))"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="starts-with($token, 'text-bg-')">
            <xsl:call-template name="processBootstrapAttrSetReflection">
              <xsl:with-param name="attrSet" select="concat('__bg__', substring-after($token, 'text-bg-'))"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when
            test="$token = 'border' or $token = 'border-top' or $token = 'border-bottom' or $token = 'border-start' or $token = 'border-end' or 
                        starts-with($token, 'border-') or starts-with($token, 'rounded-') or $token = 'rounded' or
                        starts-with($token, 'w-') or starts-with($token, 'p-') or starts-with($token, 'm-') or
                        starts-with($token, 'px-') or starts-with($token, 'py-') or starts-with($token, 'pt-') or starts-with($token, 'pb-') or starts-with($token, 'ps-') or starts-with($token, 'pe-') or
                        starts-with($token, 'mx-') or starts-with($token, 'my-') or starts-with($token, 'mt-') or starts-with($token, 'mb-') or starts-with($token, 'ms-') or starts-with($token, 'me-') or
                        $token = 'h1' or $token = 'h2' or $token = 'h3' or $token = 'h4' or $token = 'h5' or $token = 'h6' or
                        $token = 'lead' or
                        starts-with($token, 'fw-') or starts-with($token, 'fs-')"
          >
            <xsl:call-template name="processBootstrapAttrSetReflection">
              <xsl:with-param name="attrSet">
                <xsl:choose>
                    <xsl:when test="$writing-mode = 'rl'">
                        <xsl:choose>
                            <xsl:when test="starts-with($token, 'ps-')"><xsl:value-of
                          select="concat('pe-', substring-after($token, '-'))"
                        /></xsl:when>
                            <xsl:when test="starts-with($token, 'pe-')"><xsl:value-of
                          select="concat('ps-', substring-after($token, '-'))"
                        /></xsl:when>
                            <xsl:when test="starts-with($token, 'ms-')"><xsl:value-of
                          select="concat('me-', substring-after($token, '-'))"
                        /></xsl:when>
                            <xsl:when test="starts-with($token, 'me-')"><xsl:value-of
                          select="concat('ms-', substring-after($token, '-'))"
                        /></xsl:when>
                            <xsl:otherwise><xsl:value-of select="$token"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of select="$token"/></xsl:otherwise>
                </xsl:choose>
             </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <!-- Text Align utilities (New) -->
          <xsl:when test="$token = 'text-start'"><xsl:attribute name="text-align">left</xsl:attribute></xsl:when>
          <xsl:when test="$token = 'text-center'"><xsl:attribute name="text-align">center</xsl:attribute></xsl:when>
          <xsl:when test="$token = 'text-end'"><xsl:attribute name="text-align">right</xsl:attribute></xsl:when>
        </xsl:choose>
      </xsl:for-each>

      <!-- Pass 2: Text color -->
      <xsl:for-each select="$tokens">
        <xsl:variable name="token" select="."/>
        <xsl:if
          test="starts-with($token, 'text-') and not($token = 'text-start' or $token = 'text-center' or $token = 'text-end')"
        >
          <xsl:call-template name="processBootstrapAttrSetReflection">
            <xsl:with-param name="attrSet" select="concat('__color__', substring-after($token, 'text-'))"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <!-- Suppress any elements used for dark/light mode switching in print -->
  <xsl:template
    match="*[tokenize(normalize-space(@outputclass), ' ') = 'd-light' or tokenize(normalize-space(@outputclass), ' ') = 'd-dark']"
    priority="10"
  />

  <xsl:template match="*" mode="prismDecoration">
      <xsl:call-template name="processBootstrapAttrSetReflection">
          <xsl:with-param name="attrSet" select="'__bg__secondary-subtle'"/>
      </xsl:call-template>
      <xsl:call-template name="processBootstrapBorderColor">
          <xsl:with-param name="attrValue" select="'secondary'"/>
      </xsl:call-template>
      <!-- Overrides from settings-map if present -->
      <xsl:variable name="textColor">
          <xsl:call-template name="getBootstrapSetting">
              <xsl:with-param name="name" select="'prismjs.text.color'"/>
          </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="bgColor">
          <xsl:call-template name="getBootstrapSetting">
              <xsl:with-param name="name" select="'prismjs.background.color'"/>
          </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="borderWidth">
          <xsl:call-template name="getBootstrapSetting">
              <xsl:with-param name="name" select="'prismjs.border.width'"/>
          </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$textColor != ''"><xsl:attribute name="color" select="$textColor"/></xsl:if>
      <xsl:if test="$bgColor != ''"><xsl:attribute name="background-color" select="$bgColor"/></xsl:if>
      <xsl:if test="$borderWidth != ''">
          <xsl:attribute name="border-width" select="$borderWidth"/>
          <xsl:if test="normalize-space($borderWidth) != ('0', '0pt', '0px', '0in', '0mm', '0cm', '0.0pt', '0.0px')">
              <xsl:attribute name="border-style">solid</xsl:attribute>
          </xsl:if>
      </xsl:if>
      <!-- Use global variables for consistent theme scaling and rounding awareness -->
      <xsl:call-template name="processBootstrapRounded">
        <xsl:with-param name="attrValue" select="(@rounded, 'yes')[1]"/>
      </xsl:call-template>
      <xsl:attribute name="padding"><xsl:value-of select="$bootstrap-spacing-1"/></xsl:attribute>
      <xsl:call-template name="bootstrap.decoration"/>
  </xsl:template>
  
  <xsl:template name="bootstrap.decoration">
      <xsl:param name="node" select="."/>
      <xsl:param name="variant" select="''"/>
      <xsl:param name="theme" select="''"/>
      <xsl:param name="prefix" select="''"/>
      <xsl:param name="defaultRounded" select="false()"/>
      <!-- Set when a caller resolved a '-border'-only theme (border color, no background) -->
      <xsl:param name="skipBackground" select="false()"/>
      <xsl:apply-templates select="$node" mode="bootstrapDecoration">
          <xsl:with-param name="variant" select="$variant"/>
          <xsl:with-param name="theme" select="$theme"/>
          <xsl:with-param name="prefix" select="$prefix"/>
          <xsl:with-param name="defaultRounded" select="$defaultRounded"/>
          <xsl:with-param name="skipBackground" select="$skipBackground"/>
      </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="*" mode="bootstrapDecoration">
      <xsl:param name="variant" select="''"/>
      <xsl:param name="theme" select="''"/>
      <xsl:param name="prefix" select="''"/>
      <xsl:param name="defaultRounded" select="false()"/>
      <xsl:param name="skipBackground" select="false()"/>

      <xsl:variable
      name="isTableContext"
      select="contains(@class, ' topic/table ') or contains(@class, ' topic/row ') or contains(@class, ' topic/entry ')"
    />
      <xsl:variable name="ownColor">
        <xsl:if test="$theme = ''">
          <xsl:call-template name="get-theme-color"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="ownSuffixParts">
        <xsl:if test="$theme = '' and $ownColor != ''">
          <xsl:call-template name="get-theme-suffix"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable
      name="ownSuffixTokens"
      select="if ($ownSuffixParts != '') then tokenize($ownSuffixParts, '-') else ()"
    />
      <xsl:variable name="ownIsMuted" select="$ownSuffixTokens = 'muted'"/>
      <xsl:variable name="ownIsSubtle" select="$ownSuffixTokens = 'subtle'"/>
      <xsl:variable name="ownIsBorder" select="$ownSuffixTokens = 'border'"/>
      <xsl:variable name="ownIsBare" select="$ownColor != '' and $ownSuffixParts = '' and not($isTableContext)"/>

      <xsl:variable name="ownIsBorderOnly" select="$ownSuffixParts = 'border'"/>

      <xsl:if test="not($skipBackground)">
        <xsl:choose>
          <xsl:when test="$theme = '' and $ownIsMuted and $ownColor != ''">
            <xsl:call-template name="processBootstrapAttrSetReflection">
              <xsl:with-param name="attrSet" select="concat('__muted__', $ownColor)"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$theme = '' and ($ownIsBare or $ownIsBorderOnly)"/>
          <xsl:otherwise>
            <xsl:call-template name="processBootstrapBackground">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param
              name="variant"
              select="if ($theme != '') then $variant else (if ($ownIsSubtle) then 'subtle' else '')"
            />
                <xsl:with-param name="theme" select="if ($theme != '') then $theme else $ownColor"/>
                <xsl:with-param name="prefix" select="$prefix"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>

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
      <xsl:variable
      name="hasExplicitBorder"
      select="@border or $ownIsBorder or exists(tokenize(@outputclass, ' ')[starts-with(., 'border-')])"
    />

      <xsl:if test="not($isTableContext) or $hasExplicitBorder">
        <xsl:call-template name="processBootstrapBorderColor">
            <xsl:with-param
          name="attrValue"
          select="if ($theme = '' and $ownIsBorder and $ownColor != '') then (if ($ownIsSubtle) then concat($ownColor, '-subtle') else $ownColor) else ()"
        />
            <xsl:with-param name="theme" select="$theme"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:call-template name="processBootstrapRounded">
          <xsl:with-param name="node" select="."/>
          <xsl:with-param name="isDefault" select="$defaultRounded"/>
      </xsl:call-template>
      <xsl:call-template name="processBootstrapOutputClass">
          <xsl:with-param name="attrValue" select="@outputclass"/>
      </xsl:call-template>
      <xsl:call-template name="processBootstrapDirection"/>
  </xsl:template>

  <!-- Remove borders -->
  <xsl:template name="bootstrapBorderless">
    <xsl:if
      test="not(@style = 'outline' or @border or @bordercolor or contains(@outputclass, 'border') or contains(@class, ' bootstrap-d/card '))"
    >
      <xsl:attribute name="border-width">0pt</xsl:attribute>
      <xsl:attribute name="border-style">none</xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- Global Shadow Wrapper for shadow styling -->
  <xsl:template
    match="*[@shadow][not(@shadow = 'none') and not(@shadow = 'no')][not(contains(@class, ' bootstrap-d/card ') or tokenize(@outputclass, ' ') = 'card')]"
    priority="10"
  >
    <xsl:variable name="inner">
      <xsl:next-match/>
    </xsl:variable>

    <xsl:call-template name="apply-shadow-wrapper">
      <xsl:with-param name="inner" select="$inner"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="apply-shadow-wrapper">
    <xsl:param name="inner"/>
    <xsl:param name="shadow-val" select="@shadow"/>
    <xsl:param name="margin-val" select="@margin"/>
    <!-- reset-indent: set to true() only when called from inside a table-cell context (e.g. cards)
         to anchor the wrapper at x=0 and prevent inherited body start-indent from causing a shift. -->
    <xsl:param name="reset-indent" select="false()"/>

    <xsl:choose>
      <xsl:when test="$inner/*[1][self::fo:inline or self::fo:basic-link]">
        <!-- Do not wrap inline elements in block-level shadow wrappers -->
        <xsl:copy-of select="$inner"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="shadow-offset">
          <xsl:choose>
            <xsl:when test="$shadow-val = 'sm'">3pt</xsl:when>
            <xsl:when test="$shadow-val = 'lg'">12pt</xsl:when>
            <xsl:when test="$shadow-val = 'md' or $shadow-val = 'yes'">6pt</xsl:when>
            <xsl:otherwise>6pt</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- Bottom offset is half of right offset for a natural drop-shadow angle -->
        <xsl:variable name="shadow-offset-bottom">
          <xsl:choose>
            <xsl:when test="$shadow-val = 'sm'">1.5pt</xsl:when>
            <xsl:when test="$shadow-val = 'lg'">6pt</xsl:when>
            <xsl:otherwise>3pt</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="inner-border-radius" select="$inner/*[1]/@fox:border-radius"/>

        <fo:block>
          <xsl:if test="$reset-indent">
            <xsl:attribute name="start-indent">0pt</xsl:attribute>
            <xsl:attribute name="end-indent">0pt</xsl:attribute>
          </xsl:if>
          <xsl:if test="$inner/*[1]/@width">
            <xsl:attribute name="width"><xsl:value-of select="$inner/*[1]/@width"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="$inner/*[1]/@inline-progression-dimension">
            <xsl:attribute name="inline-progression-dimension"><xsl:value-of
                select="$inner/*[1]/@inline-progression-dimension"
              /></xsl:attribute>
          </xsl:if>
          
          <xsl:call-template name="processBootstrapSpacing">
            <xsl:with-param name="attrValue" select="$margin-val"/>
            <xsl:with-param name="prefix" select="'m'"/>
          </xsl:call-template>

          <fo:block margin-right="-{$shadow-offset}" margin-bottom="-{$shadow-offset-bottom}">
            <!-- Diffuse Shadow: layered nested blocks -->
            <xsl:choose>

              <!-- sm: 2 diffuse layers -->
              <xsl:when test="$shadow-val = 'sm'">
                <fo:block background-color="#eeeeee" padding-bottom="1.5pt" padding-right="3pt">
                  <xsl:if test="$inner-border-radius"><xsl:attribute name="fox:border-radius"><xsl:value-of
                        select="$inner-border-radius"
                      /></xsl:attribute></xsl:if>
                  <fo:block background-color="#d4d4d4" padding-bottom="0.5pt" padding-right="1pt">
                    <xsl:if test="$inner-border-radius"><xsl:attribute name="fox:border-radius"><xsl:value-of
                          select="$inner-border-radius"
                        /></xsl:attribute></xsl:if>
                    <xsl:apply-templates select="$inner/node()" mode="strip-margin"/>
                  </fo:block>
                </fo:block>
              </xsl:when>

              <!-- lg: 8 diffuse layers (12pt right / 6pt bottom) -->
              <xsl:when test="$shadow-val = 'lg'">
                <fo:block background-color="#f6f6f6" padding-bottom="6pt" padding-right="12pt">
                  <xsl:if test="$inner-border-radius"><xsl:attribute name="fox:border-radius"><xsl:value-of
                        select="$inner-border-radius"
                      /></xsl:attribute></xsl:if>
                  <fo:block background-color="#f2f2f2" padding-bottom="5pt" padding-right="10pt">
                    <xsl:if test="$inner-border-radius"><xsl:attribute name="fox:border-radius"><xsl:value-of
                          select="$inner-border-radius"
                        /></xsl:attribute></xsl:if>
                    <fo:block background-color="#eeeeee" padding-bottom="4pt" padding-right="8pt">
                      <xsl:if test="$inner-border-radius"><xsl:attribute name="fox:border-radius"><xsl:value-of
                            select="$inner-border-radius"
                          /></xsl:attribute></xsl:if>
                      <fo:block background-color="#e8e8e8" padding-bottom="3pt" padding-right="6pt">
                        <xsl:if test="$inner-border-radius"><xsl:attribute name="fox:border-radius"><xsl:value-of
                              select="$inner-border-radius"
                            /></xsl:attribute></xsl:if>
                        <fo:block background-color="#e0e0e0" padding-bottom="2pt" padding-right="4pt">
                          <xsl:if test="$inner-border-radius"><xsl:attribute name="fox:border-radius"><xsl:value-of
                                select="$inner-border-radius"
                              /></xsl:attribute></xsl:if>
                          <fo:block background-color="#dcdcdc" padding-bottom="1.5pt" padding-right="3pt">
                            <xsl:if test="$inner-border-radius"><xsl:attribute name="fox:border-radius"><xsl:value-of
                                  select="$inner-border-radius"
                                /></xsl:attribute></xsl:if>
                            <fo:block background-color="#d8d8d8" padding-bottom="1pt" padding-right="2pt">
                              <xsl:if test="$inner-border-radius"><xsl:attribute name="fox:border-radius"><xsl:value-of
                                    select="$inner-border-radius"
                                  /></xsl:attribute></xsl:if>
                              <fo:block background-color="#d4d4d4" padding-bottom="0.5pt" padding-right="1pt">
                                <xsl:if test="$inner-border-radius"><xsl:attribute
                                    name="fox:border-radius"
                                  ><xsl:value-of select="$inner-border-radius"/></xsl:attribute></xsl:if>
                                <xsl:apply-templates select="$inner/node()" mode="strip-margin"/>
                              </fo:block>
                            </fo:block>
                          </fo:block>
                        </fo:block>
                      </fo:block>
                    </fo:block>
                  </fo:block>
                </fo:block>
              </xsl:when>

              <!-- md / yes / default: 6 diffuse layers (6pt right / 3pt bottom, 1pt right steps) -->
              <xsl:otherwise>
                <fo:block background-color="#f4f4f4" padding-bottom="3pt" padding-right="6pt">
                  <xsl:if test="$inner-border-radius"><xsl:attribute name="fox:border-radius"><xsl:value-of
                        select="$inner-border-radius"
                      /></xsl:attribute></xsl:if>
                  <fo:block background-color="#eeeeee" padding-bottom="2.5pt" padding-right="5pt">
                    <xsl:if test="$inner-border-radius"><xsl:attribute name="fox:border-radius"><xsl:value-of
                          select="$inner-border-radius"
                        /></xsl:attribute></xsl:if>
                    <fo:block background-color="#e8e8e8" padding-bottom="2pt" padding-right="4pt">
                      <xsl:if test="$inner-border-radius"><xsl:attribute name="fox:border-radius"><xsl:value-of
                            select="$inner-border-radius"
                          /></xsl:attribute></xsl:if>
                      <fo:block background-color="#e0e0e0" padding-bottom="1.5pt" padding-right="3pt">
                        <xsl:if test="$inner-border-radius"><xsl:attribute name="fox:border-radius"><xsl:value-of
                              select="$inner-border-radius"
                            /></xsl:attribute></xsl:if>
                        <fo:block background-color="#d8d8d8" padding-bottom="1pt" padding-right="2pt">
                          <xsl:if test="$inner-border-radius"><xsl:attribute name="fox:border-radius"><xsl:value-of
                                select="$inner-border-radius"
                              /></xsl:attribute></xsl:if>
                          <fo:block background-color="#d4d4d4" padding-bottom="0.5pt" padding-right="1pt">
                            <xsl:if test="$inner-border-radius"><xsl:attribute name="fox:border-radius"><xsl:value-of
                                  select="$inner-border-radius"
                                /></xsl:attribute></xsl:if>
                            <xsl:apply-templates select="$inner/node()" mode="strip-margin"/>
                          </fo:block>
                        </fo:block>
                      </fo:block>
                    </fo:block>
                  </fo:block>
                </fo:block>
              </xsl:otherwise>

            </xsl:choose>
          </fo:block>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- Identity transform to strip margins from the inner shadow block -->
  <xsl:template match="node() | @*" mode="strip-margin">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" mode="strip-margin"/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove margin and explicit widths from the root fo:block of the processed inner tree -->
  <!-- For nested elements (non-root), all attributes pass through unchanged -->
  <xsl:template
    match="fo:block/@margin | fo:block/@margin-top | fo:block/@margin-bottom | fo:block/@margin-left | fo:block/@margin-right | fo:block/@width | fo:block/@inline-progression-dimension"
    mode="strip-margin"
  >
    <xsl:if test="count(../ancestor::*) &gt; 1">
      <xsl:copy/>
    </xsl:if>
  </xsl:template>

  <!-- For fo:table: only strip margin/space attrs at root level, keep width -->
  <xsl:template
    match="fo:table/@margin | fo:table/@margin-top | fo:table/@margin-bottom | fo:table/@margin-left | fo:table/@margin-right | fo:table/@space-before | fo:table/@space-after"
    mode="strip-margin"
  >
    <xsl:if test="count(../ancestor::*) &gt; 1">
      <xsl:copy/>
    </xsl:if>
  </xsl:template>

  <!-- Remove margin from root - for fo:block strip width too (outer block controls size) -->
  <xsl:template match="fo:block[count(ancestor::*) = 0]" mode="strip-margin" priority="6">
    <xsl:copy>
      <xsl:if test="not(@background-color)">
        <xsl:attribute name="background-color">#ffffff</xsl:attribute>
      </xsl:if>
      <xsl:attribute name="margin">0pt</xsl:attribute>
      <xsl:apply-templates select="node() | @*" mode="strip-margin"/>
    </xsl:copy>
  </xsl:template>

  <!-- For fo:table at root: only zero out margin/space; preserve width and border intact -->
  <xsl:template match="fo:table[count(ancestor::*) = 0]" mode="strip-margin" priority="6">
    <xsl:copy>
      <xsl:attribute name="margin">0pt</xsl:attribute>
      <xsl:attribute name="space-before">0pt</xsl:attribute>
      <xsl:attribute name="space-after">0pt</xsl:attribute>
      <xsl:apply-templates select="node() | @*" mode="strip-margin"/>
    </xsl:copy>
  </xsl:template>


  <!-- Dedicated mode for bootstrap labels to ensure no metadata leak -->
  <xsl:template match="node() | @*" mode="bootstrap-label">
    <xsl:apply-templates select="."/>
  </xsl:template>

  <!-- Suppress metadata elements in Bootstrap labels (buttons, links, badges) -->
  <xsl:template
    match="*[contains(@class, ' topic/desc ') or contains(@class, ' topic/shortdesc ')]"
    mode="bootstrap-label"
    priority="10"
  />

  <!-- Intercept block-level code elements to force a new LTR reference area for FOP -->
  <xsl:template match="*[contains(@class, ' pr-d/codeblock ')]" priority="1000">
    <xsl:choose>
      <xsl:when test="$writing-mode = 'rl' and not(@dir)">
        <fo:block-container writing-mode="lr-tb">
          <!-- Force indent to 0 on the container so we don't double-inherit the RTL right-indent -->
          <xsl:attribute name="start-indent">0pt</xsl:attribute>
          <xsl:attribute name="end-indent">0pt</xsl:attribute>
          <xsl:next-match/>
        </fo:block-container>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Override commonattributes to ensure codeblocks, codeph, and PrismJS tokens are rendered LTR in RTL documents -->
  <xsl:template
    match="*[contains(@class, ' pr-d/') or contains(@class, ' sw-d/') or contains(@class, ' xml-d/') or (contains(@class,' topic/ph ') and contains(@outputclass, 'token'))]"
    mode="commonattributes"
  >
    <xsl:next-match/>
    <xsl:if test="$writing-mode = 'rl' and not(@dir)">
      <xsl:attribute name="writing-mode">lr-tb</xsl:attribute>
      <xsl:attribute name="direction">ltr</xsl:attribute>
      <xsl:attribute name="unicode-bidi">bidi-override</xsl:attribute>
      <xsl:attribute name="xml:lang">en</xsl:attribute>
      <xsl:attribute name="text-align">left</xsl:attribute>
      <xsl:attribute name="text-align-last">left</xsl:attribute>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
