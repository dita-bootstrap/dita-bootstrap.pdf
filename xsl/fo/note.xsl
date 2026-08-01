<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  version="2.0"
>

  <!-- Note Support (Styled as Bootstrap Alerts) -->
  <xsl:template match="*[contains(@class, ' topic/note ')]" priority="5">
    <fo:block xsl:use-attribute-sets="section">
      <xsl:call-template name="commonattributes"/>
      
      <!-- Map DITA Note Type or @color to Bootstrap Theme -->
      <xsl:variable name="theme">
        <xsl:choose>
          <xsl:when test="@color"><xsl:value-of select="@color"/></xsl:when>
          <xsl:when test="exists(tokenize(@outputclass, ' ')[starts-with(., 'theme-')])">
            <xsl:value-of select="substring-after(tokenize(@outputclass, ' ')[starts-with(., 'theme-')][1], 'theme-')"/>
          </xsl:when>
          <xsl:when test="exists(tokenize(@outputclass, ' ')[starts-with(., 'alert-')])">
            <xsl:value-of select="substring-after(tokenize(@outputclass, ' ')[starts-with(., 'alert-')][1], 'alert-')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="getNoteTheme">
              <xsl:with-param name="type" select="(@type, 'note')[1]"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <!-- Determine text color for the icon and border from the theme-subtle attribute set -->
      <xsl:variable name="icon-color">
        <xsl:call-template name="getBootstrapAttrValue">
          <xsl:with-param name="attrSet" select="concat('__bg__', $theme, '-subtle')"/>
        </xsl:call-template>
      </xsl:variable>

      <!-- 1. Unified Decoration (subtle variant) -->
      <xsl:call-template name="bootstrap.decoration">
          <xsl:with-param name="variant" select="'subtle'"/>
          <xsl:with-param name="theme" select="$theme"/>
          <xsl:with-param name="defaultRounded" select="true()"/>
      </xsl:call-template>

      <xsl:variable name="direction">
        <xsl:choose>
            <xsl:when test="@dir"><xsl:value-of select="@dir"/></xsl:when>
            <xsl:when test="ancestor::*[@dir]"><xsl:value-of select="ancestor::*[@dir][1]/@dir"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="$writing-mode"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$direction = 'rtl' or $direction = 'rl'">
          <xsl:attribute name="border-right-width"><xsl:value-of select="$bootstrap-note-border-width"/></xsl:attribute>
          <xsl:attribute name="border-right-style">solid</xsl:attribute>
          <xsl:attribute name="border-right-color"><xsl:value-of select="$icon-color"/></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="border-left-width"><xsl:value-of select="$bootstrap-note-border-width"/></xsl:attribute>
          <xsl:attribute name="border-left-style">solid</xsl:attribute>
          <xsl:attribute name="border-left-color"><xsl:value-of select="$icon-color"/></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <!-- 3. Spacing Defaults (if not overridden by attributes) -->
      <xsl:if test="not(@padding or exists(tokenize(@outputclass, ' ')[starts-with(., 'p-')]))">
        <xsl:attribute name="padding">12pt</xsl:attribute>
      </xsl:if>
      <xsl:if test="not(@margin or exists(tokenize(@outputclass, ' ')[starts-with(., 'm-')]))">
        <xsl:attribute name="margin-top">10pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">10pt</xsl:attribute>
      </xsl:if>
      
      <!-- Ensure the note stays on one page -->
      <xsl:attribute name="keep-together.within-page">always</xsl:attribute>

      <!-- Note Title / Icon Prefix -->
      <fo:inline font-weight="bold" color="{$icon-color}">
        <xsl:variable name="type" select="(@type, 'note')[1]"/>
        <xsl:variable
          name="explicit-icon"
          select="(@icon, substring-before(substring-after(@otherprops, 'icon('), ')'))[1]"
        />

        <xsl:if
          test="$BOOTSTRAP_ICONS_INCLUDE = 'yes' and ($explicit-icon != '' or ($type != 'othertype' and $type != 'other'))"
        >
          <xsl:variable name="icon-name">
            <xsl:choose>
              <xsl:when test="$explicit-icon != ''">
                <xsl:variable
                  name="raw"
                  select="(tokenize($explicit-icon, ' ')[starts-with(., 'bi-')], tokenize($explicit-icon, ' ')[not(. = ('bi', 'icon')) and not(contains(., '('))])[1]"
                />
                <xsl:value-of select="if (starts-with($raw, 'bi-')) then $raw else concat('bi-', $raw)"/>
              </xsl:when>
              <xsl:when test="$type = 'tip'">bi-lightbulb</xsl:when>
              <xsl:when test="$type = 'fastpath'">bi-shield-check</xsl:when>
              <xsl:when test="$type = 'remember'">bi-clipboard-check</xsl:when>
              <xsl:when test="$type = 'restriction'">bi-slash-circle</xsl:when>
              <xsl:when test="$type = 'important'">bi-exclamation-circle-fill</xsl:when>
              <xsl:when test="$type = 'attention'">bi-exclamation-triangle</xsl:when>
              <xsl:when test="$type = 'caution'">bi-exclamation-triangle</xsl:when>
              <xsl:when test="$type = 'warning'">bi-exclamation-triangle</xsl:when>
              <xsl:when test="$type = 'trouble'">bi-exclamation-triangle</xsl:when>
              <xsl:when test="$type = 'danger'">bi-exclamation-triangle</xsl:when>
              <xsl:when test="$type = 'notice'">bi-info-circle-fill</xsl:when>
              <xsl:when test="$type = 'note'">bi-pencil</xsl:when>
              <xsl:otherwise>bi-info-circle</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          
          <xsl:variable name="temp-icon">
            <icon class="+ topic/ph bootstrap-d/icon " outputclass="{$icon-name}" padding="e2"/>
          </xsl:variable>
          <xsl:apply-templates select="$temp-icon/*">
             <xsl:with-param name="color" select="$icon-color"/>
          </xsl:apply-templates>
        </xsl:if>
        
        <xsl:variable name="type" select="(@type, 'note')[1]"/>
        <xsl:variable name="label">
           <xsl:choose>
              <xsl:when test="($type = 'other' or $type = 'othertype') and @othertype">
                 <xsl:value-of select="@othertype"/>
              </xsl:when>
              <xsl:otherwise>
                 <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="concat(upper-case(substring($type, 1, 1)), substring($type, 2))"/>
                 </xsl:call-template>
              </xsl:otherwise>
           </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$label"/>
        <xsl:call-template name="getVariable">
           <xsl:with-param name="id" select="'ColonSymbol'"/>
        </xsl:call-template>
      </fo:inline>
      <xsl:text>&#160;</xsl:text>

      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

</xsl:stylesheet>
