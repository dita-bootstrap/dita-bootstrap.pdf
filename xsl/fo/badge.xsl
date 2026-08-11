<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  version="2.0"
>

  <!-- Badge Support -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/badge ') or (contains(@class,' topic/ph ') and contains(@outputclass, 'badge'))]"
    priority="100"
  >
    <fo:inline>
      <xsl:call-template name="commonattributes"/>

      <!-- Style variant: none | solid (default) | outline | subtle -->
      <xsl:variable
        name="style"
        select="(@style,
          if (exists(tokenize(@outputclass, ' ')[. = 'badge-outline'])) then 'outline'
          else if (exists(tokenize(@outputclass, ' ')[. = 'badge-subtle'])) then 'subtle'
          else (),
          'solid')[1]"
      />

      <!-- Specialized Bootstrap Styling -->
      <xsl:variable
        name="theme"
        select="if ($style = 'none') then '' else (@color,
          substring-after(tokenize(@outputclass, ' ')[starts-with(., 'theme-')][1], 'theme-'),
          substring-after(tokenize(@outputclass, ' ')[starts-with(., 'bg-')][1], 'bg-'),
          substring-after(tokenize(@outputclass, ' ')[starts-with(., 'text-bg-')][1], 'text-bg-'),
          'primary')[1]"
      />

      <!-- 1. Background, border & Spacing via Unified Hub -->
      <xsl:choose>
        <xsl:when test="$theme = ''"/>
        <xsl:when test="$style = 'outline'">
          <xsl:call-template name="processBootstrapAttrSetReflection">
            <xsl:with-param name="attrSet" select="concat('__color__', $theme)"/>
          </xsl:call-template>
          <xsl:call-template name="processBootstrapBorderColor">
            <xsl:with-param name="attrValue" select="$theme"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$style = 'subtle'">
          <xsl:call-template name="bootstrap.decoration">
              <xsl:with-param name="theme" select="concat($theme, '-subtle')"/>
              <xsl:with-param name="prefix" select="'__bg__'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="bootstrap.decoration">
              <xsl:with-param name="theme" select="$theme"/>
              <xsl:with-param name="prefix" select="'__badge__'"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

      <!-- 2. Set tighter default padding (1pt 3pt) if not overridden -->
      <xsl:if test="not(@padding or exists(tokenize(@outputclass, ' ')[starts-with(., 'p-')]))">
        <xsl:attribute name="padding">1pt 3pt</xsl:attribute>
      </xsl:if>

      <!-- 3. Badge-specific defaults (weights and alignment) -->
      <xsl:attribute name="font-weight">bold</xsl:attribute>
      <xsl:attribute name="vertical-align">baseline</xsl:attribute>

      <!-- 4. Default Rounding (tighter badge look) if not overridden -->
      <xsl:if test="not(@rounded or exists(tokenize(@outputclass, ' ')[starts-with(., 'rounded-')]))">
        <xsl:call-template name="processBootstrapRounded">
            <xsl:with-param name="attrValue" select="'1'"/>
        </xsl:call-template>
      </xsl:if>

      <!-- 5. Content -->
      <xsl:apply-templates/>

    </fo:inline>
  </xsl:template>

</xsl:stylesheet>
