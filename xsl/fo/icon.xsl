<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  version="2.0"
>

  <!-- Icon Support (Bootstrap Icons via SVG) -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/icon ') or (contains(@class,' topic/ph ') and exists(tokenize(@outputclass, ' ')[starts-with(., 'bi-')]))]"
    priority="10"
  >
    <xsl:param name="color"/>
    <xsl:if test="@outputclass">
      <xsl:variable name="icon-src">
        <xsl:variable
          name="raw-icon"
          select="(tokenize(@outputclass, ' ')[starts-with(., 'bi-')], tokenize(@outputclass, ' ')[not(. = ('bi', 'icon')) and not(contains(., '('))])[1]"
        />
        <xsl:variable
          name="clean-icon"
          select="if (starts-with($raw-icon, 'bi-')) then substring-after($raw-icon, 'bi-') else $raw-icon"
        />
        <xsl:value-of select="concat('https://icons.getbootstrap.com/assets/icons/', $clean-icon, '.svg')"/>
      </xsl:variable>

      <!-- Determine color from ancestors (e.g. if in a primary button, the icon should be white) -->
      <xsl:variable
        name="theme-container"
        select="ancestor-or-self::*[
          contains(@class, ' bootstrap-d/button ') or 
          contains(@class, ' bootstrap-d/badge ') or 
          contains(@class, ' bootstrap-d/alert ') or 
          contains(@class, ' topic/note ') or 
          contains(@class, ' topic/xref ') or
          @color or
          exists(tokenize(@outputclass, ' ')[starts-with(., 'btn') or starts-with(., 'alert') or starts-with(., 'badge') or starts-with(., 'link-') or starts-with(., 'theme-')])
        ][1]"
      />
      
      <xsl:variable name="theme">
        <xsl:choose>
          <xsl:when test="$theme-container/@color"><xsl:value-of select="$theme-container/@color"/></xsl:when>
          <xsl:when test="exists(tokenize($theme-container/@outputclass, ' ')[starts-with(., 'theme-')])">
             <xsl:value-of
              select="substring-after(tokenize($theme-container/@outputclass, ' ')[starts-with(., 'theme-')][1], 'theme-')"
            />
          </xsl:when>
          <xsl:when
            test="exists(tokenize($theme-container/@outputclass, ' ')[starts-with(., 'btn-') and not(. = ('btn-lg', 'btn-sm', 'btn-toolbar', 'btn-group'))])"
          >
             <xsl:variable
              name="token"
              select="tokenize($theme-container/@outputclass, ' ')[starts-with(., 'btn-') and not(. = ('btn-lg', 'btn-sm', 'btn-toolbar', 'btn-group'))][1]"
            />
             <xsl:value-of
              select="substring-after($token, if (contains($token, 'outline-')) then 'btn-outline-' else 'btn-')"
            />
          </xsl:when>
          <xsl:when test="exists(tokenize($theme-container/@outputclass, ' ')[starts-with(., 'alert-')])">
             <xsl:value-of
              select="substring-after(tokenize($theme-container/@outputclass, ' ')[starts-with(., 'alert-')][1], 'alert-')"
            />
          </xsl:when>
          <xsl:when test="exists(tokenize($theme-container/@outputclass, ' ')[starts-with(., 'badge-')])">
             <xsl:value-of
              select="substring-after(tokenize($theme-container/@outputclass, ' ')[starts-with(., 'badge-')][1], 'badge-')"
            />
          </xsl:when>
          <xsl:when test="exists(tokenize($theme-container/@outputclass, ' ')[starts-with(., 'link-')])">
             <xsl:value-of
              select="substring-after(tokenize($theme-container/@outputclass, ' ')[starts-with(., 'link-')][1], 'link-')"
            />
          </xsl:when>
          <xsl:when test="$theme-container">primary</xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="icon-color">
        <xsl:choose>
          <!-- 1. Explicit Color Parameter -->
          <xsl:when test="$color != ''">
            <xsl:value-of select="$color"/>
          </xsl:when>

          <!-- 2. Context-Aware Lookups -->
          <xsl:when test="$theme-container">
            <xsl:variable
              name="is-button"
              select="contains($theme-container/@class, ' bootstrap-d/button ') or exists(tokenize($theme-container/@outputclass, ' ')[starts-with(., 'btn')])"
            />
            <xsl:variable
              name="is-badge"
              select="contains($theme-container/@class, ' bootstrap-d/badge ') or exists(tokenize($theme-container/@outputclass, ' ')[starts-with(., 'badge')])"
            />
            <xsl:variable
              name="is-alert"
              select="contains($theme-container/@class, ' bootstrap-d/alert ') or contains($theme-container/@class, ' topic/note ') or exists(tokenize($theme-container/@outputclass, ' ')[starts-with(., 'alert')])"
            />
            <xsl:variable
              name="is-xref"
              select="contains($theme-container/@class, ' topic/xref ') and not($is-button)"
            />

            <xsl:choose>
                <xsl:when test="$is-xref">
                   <xsl:variable name="explicitVar" select="concat('bootstrap-', ($theme, 'primary')[1])"/>
                   <xsl:choose>
                      <xsl:when test="$bootstrap-settings/entry[@name = $explicitVar]">
                         <xsl:value-of select="$bootstrap-settings/entry[@name = $explicitVar]"/>
                      </xsl:when>
                      <xsl:otherwise><xsl:value-of select="($theme, 'currentColor')[1]"/></xsl:otherwise>
                   </xsl:choose>
                </xsl:when>
                <xsl:when test="$is-button">
                   <xsl:call-template name="getBootstrapAttrValue">
                      <xsl:with-param name="attrSet" select="concat('__btn__', ($theme, 'primary')[1])"/>
                   </xsl:call-template>
                </xsl:when>
                <xsl:when test="$is-badge">
                   <xsl:call-template name="getBootstrapAttrValue">
                      <xsl:with-param name="attrSet" select="concat('__badge__', ($theme, 'primary')[1])"/>
                   </xsl:call-template>
                </xsl:when>
                <xsl:when test="$is-alert">
                   <xsl:variable name="note-theme">
                      <xsl:choose>
                         <xsl:when test="$theme != ''"><xsl:value-of select="$theme"/></xsl:when>
                         <xsl:otherwise>
                            <xsl:call-template name="getNoteTheme">
                               <xsl:with-param name="type" select="$theme-container/@type"/>
                            </xsl:call-template>
                         </xsl:otherwise>
                      </xsl:choose>
                   </xsl:variable>
                   <xsl:call-template name="getBootstrapAttrValue">
                      <xsl:with-param name="attrSet" select="concat('__bg__', $note-theme, '-subtle')"/>
                   </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>currentColor</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <!-- 3. Fallback -->
          <xsl:otherwise>currentColor</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <!-- Use instream-foreign-object and forcefully inject the target color into the SVG -->
      <fo:instream-foreign-object content-height="1.1em" content-width="auto" text-decoration="no-underline">
        <xsl:attribute name="baseline-shift">
           <xsl:choose>
              <!-- If icon is solo in a button/badge, don't shift (to keep it centered) -->
              <xsl:when
              test="ancestor::*[contains(@class, ' bootstrap-d/button ') or contains(@class, ' bootstrap-d/badge ')][not(normalize-space() != '')]"
            >0</xsl:when>
              <xsl:otherwise>-10%</xsl:otherwise>
           </xsl:choose>
        </xsl:attribute>
        <xsl:call-template name="processBootstrapSpacing">
          <xsl:with-param name="attrValue" select="@margin"/>
          <xsl:with-param name="prefix" select="'m'"/>
        </xsl:call-template>
        <xsl:call-template name="processBootstrapSpacing">
          <xsl:with-param name="attrValue">
             <xsl:variable name="has-preceding" select="preceding-sibling::node()[normalize-space() != '']"/>
             <xsl:variable name="has-following" select="following-sibling::node()[normalize-space() != '']"/>
             <xsl:choose>
                <xsl:when test="@padding"><xsl:value-of select="@padding"/></xsl:when>
                <xsl:when test="$has-preceding and $has-following">x2</xsl:when>
                <xsl:when test="$has-following">e2</xsl:when>
                <xsl:when test="$has-preceding">s2</xsl:when>
                <xsl:otherwise><!-- Solo icon: No padding --></xsl:otherwise>
             </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="prefix" select="'p'"/>
        </xsl:call-template>
        <xsl:if test="doc-available($icon-src)">
          <xsl:apply-templates select="document($icon-src)/*" mode="color-icon">
             <xsl:with-param name="color" select="$icon-color"/>
          </xsl:apply-templates>
        </xsl:if>
      </fo:instream-foreign-object>
    </xsl:if>
  </xsl:template>

  <!-- Dedicated mode for injecting target color into the SVG XML -->
  <xsl:template match="node() | @*" mode="color-icon">
    <xsl:param name="color"/>
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" mode="color-icon">
        <xsl:with-param name="color" select="$color"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <!-- Special handling for fill and color attributes to forcefully inject theme color -->
  <xsl:template match="@fill | @color" mode="color-icon">
    <xsl:param name="color"/>
    <xsl:attribute name="{name()}" select="$color"/>
  </xsl:template>

  <!-- Ensure SVG elements that depend on inheritance pick up the color explicitly -->
  <xsl:template
    match="*[local-name()='svg' or local-name()='path' or local-name()='circle' or local-name()='rect'][not(@fill)]"
    mode="color-icon"
  >
    <xsl:param name="color"/>
    <xsl:copy>
      <xsl:attribute name="fill" select="$color"/>
      <xsl:apply-templates select="node() | @*" mode="color-icon">
        <xsl:with-param name="color" select="$color"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
