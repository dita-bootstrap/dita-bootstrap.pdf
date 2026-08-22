<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
  exclude-result-prefixes="xs opentopic-func"
  version="2.0"
>

  <!-- Template to customize section titles using Bootstrap heading sizes -->
  <xsl:template match="*[contains(@class, ' topic/section ')]/*[contains(@class, ' topic/title ')]">
    <xsl:choose>
      <!-- Tabbed dialog sections and navigation panes where titles act as labels -->
      <xsl:when
        test="ancestor::*[contains(@class, ' bootstrap-d/tabbed-dialog ')] or
                      ancestor::*[tokenize(@outputclass, ' ') = ('nav-tabs', 'nav-pills', 'nav-pills-vertical')]"
      >
        <fo:block xsl:use-attribute-sets="section.title">
          <xsl:attribute name="color">
            <xsl:choose>
              <xsl:when test="@theme">
                <xsl:variable
                  name="themeColor"
                  select="if (contains(@theme, '-')) then substring-before(@theme, '-') else @theme"
                />
                <xsl:value-of select="$bootstrap-settings/entry[@name = concat('bootstrap-', $themeColor)]"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$bootstrap-body-color"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:call-template name="commonattributes"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>

      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="section.title">
          <xsl:attribute name="font-size"><xsl:value-of select="$bootstrap-h6-font-size"/></xsl:attribute>
          <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
          <xsl:call-template name="commonattributes"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>

  <!-- Titles within colored components (note/alert) -->
  <xsl:template
    match="*[contains(@class, ' topic/title ')][ancestor::*[contains(@class, ' topic/note ')] or ancestor::*[contains(@class, ' bootstrap-d/alert ')]]"
    priority="6"
  >
      <xsl:variable name="theme">
        <xsl:choose>
          <xsl:when test="ancestor::*[contains(@class, ' topic/note ')]/@theme">
            <xsl:variable name="noteTheme" select="ancestor::*[contains(@class, ' topic/note ')]/@theme"/>
            <xsl:value-of
            select="if (contains($noteTheme, '-')) then substring-before($noteTheme, '-') else $noteTheme"
          />
          </xsl:when>
          <xsl:when test="ancestor::*[contains(@class, ' topic/note ')]">
            <xsl:call-template name="getNoteTheme">
               <xsl:with-param name="type" select="(ancestor::*[contains(@class, ' topic/note ')]/@type, 'note')[1]"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="ancestor::*[contains(@class, ' bootstrap-d/alert ')]">
            <xsl:variable
            name="alertTheme"
            select="(ancestor::*[contains(@class, ' bootstrap-d/alert ')]/@theme, 'secondary')[1]"
          />
            <xsl:value-of
            select="if (contains($alertTheme, '-')) then substring-before($alertTheme, '-') else $alertTheme"
          />
          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="subtleColor">
         <xsl:if test="$theme != ''">
            <xsl:call-template name="getBootstrapAttrValue">
               <xsl:with-param name="attrSet" select="concat('__bg__', $theme, '-subtle')"/>
            </xsl:call-template>
         </xsl:if>
      </xsl:variable>

      <xsl:choose>
         <xsl:when test="parent::*[contains(@class, ' topic/example ')]">
            <fo:block xsl:use-attribute-sets="example.title">
               <xsl:if test="$subtleColor != ''"><xsl:attribute name="color"><xsl:value-of
                select="$subtleColor"
              /></xsl:attribute></xsl:if>
               <xsl:call-template name="commonattributes"/>
               <xsl:apply-templates/>
            </fo:block>
         </xsl:when>
         <xsl:otherwise>
            <fo:block xsl:use-attribute-sets="section.title">
               <xsl:if test="$subtleColor != ''"><xsl:attribute name="color"><xsl:value-of
                select="$subtleColor"
              /></xsl:attribute></xsl:if>
               <xsl:call-template name="commonattributes"/>
               <xsl:apply-templates/>
            </fo:block>
         </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/shortdesc ')]">
    <fo:block xsl:use-attribute-sets="topic__shortdesc">
      <xsl:if test="parent::*[contains(@class,' topic/abstract ')]">
          <xsl:attribute name="start-indent">from-parent(start-indent)</xsl:attribute>
      </xsl:if>
      <xsl:call-template name="processBootstrapAttrSetReflection">
          <xsl:with-param name="attrSet" select="'lead'"/>
      </xsl:call-template>
      <xsl:call-template name="commonattributes"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- Baseline Section and Div Support -->
  <xsl:template
    match="*[contains(@class, ' topic/section ') or
                         contains(@class, ' topic/div ') or
                         contains(@class, ' topic/bodydiv ')]"
    priority="-1"
  >
    <fo:block>
      <xsl:if test="contains(@class, ' topic/section ')">
         <xsl:call-template name="get-attributes">
            <xsl:with-param name="element" as="element()">
               <placeholder xsl:use-attribute-sets="section"/>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="bootstrap.decoration"/>

      <xsl:variable name="ancestorStartPad">
        <xsl:call-template name="get-ancestor-padding-indent">
          <xsl:with-param name="side" select="'start'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="ancestorEndPad">
        <xsl:call-template name="get-ancestor-padding-indent">
          <xsl:with-param name="side" select="'end'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="number($ancestorStartPad) > 0">
        <xsl:attribute name="start-indent" select="concat($ancestorStartPad, 'pt + from-parent(start-indent)')"/>
      </xsl:if>
      <xsl:if test="number($ancestorEndPad) > 0">
        <xsl:attribute name="end-indent" select="concat($ancestorEndPad, 'pt + from-parent(end-indent)')"/>
      </xsl:if>

      <xsl:variable name="widthVal">
        <xsl:choose>
          <xsl:when test="@width != ''"><xsl:value-of select="@width"/></xsl:when>
          <xsl:when test="exists(tokenize(@outputclass, ' ')[starts-with(., 'w-')])">
            <xsl:value-of select="substring-after(tokenize(@outputclass, ' ')[starts-with(., 'w-')][1], 'w-')"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="totalPad" select="number($ancestorStartPad) + number($ancestorEndPad)"/>
      <xsl:if test="$widthVal = ('25', '50', '75', '100') and $totalPad > 0">
        <xsl:attribute name="width" select="concat($widthVal, '% - ', $totalPad, 'pt')"/>
        <xsl:attribute name="inline-progression-dimension" select="concat($widthVal, '% - ', $totalPad, 'pt')"/>
      </xsl:if>

      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- Inline Ph Support (Explicitly excludes syntax tokens to allow PrismJS overrides).  -->
  <xsl:template
    match="*[contains(@class, ' topic/ph ')
             and not(contains(@outputclass, 'token'))
             and not(contains(@class, ' pr-d/codeph '))
             and not(contains(@class, ' hi-d/'))]"
  >
    <fo:inline>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="bootstrap.decoration"/>
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>

  <!-- Paragraph Support (Low priority to allow specialized overrides) -->
  <xsl:template match="*[contains(@class, ' topic/p ')]" priority="-1">
    <fo:block xsl:use-attribute-sets="p">
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="bootstrap.decoration"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- Blockquote (lq) Support. -->
  <xsl:template match="*[contains(@class, ' topic/lq ')]">
    <fo:block margin-bottom="{$bootstrap-spacing-3}">
      <xsl:call-template name="get-attributes">
        <xsl:with-param name="element" as="element()">
           <placeholder xsl:use-attribute-sets="lq_simple"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="bootstrap.decoration"/>

      <xsl:variable name="themeColor">
        <xsl:call-template name="get-theme-color"/>
      </xsl:variable>

      <xsl:if test="$themeColor = '' and not(parent::*[contains(@class, ' topic/fig ')])">
        <xsl:call-template name="apply-default-blockquote-border"/>
      </xsl:if>

      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- Text/Paragraphs within Blockquote (lq) -->
  <xsl:template match="*[contains(@class, ' topic/lq ')]/*[contains(@class, ' topic/p ')]" priority="5">
    <fo:block xsl:use-attribute-sets="p" line-height="1.5">
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="processBootstrapDirection"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- Pre Support -->
  <xsl:template
    match="*[contains(@class, ' topic/pre ') and not(contains(@outputclass, 'language-') or contains(@class, ' pr-d/codeblock '))]"
  >
    <fo:block xsl:use-attribute-sets="pre">
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="bootstrap.decoration"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- Note Support (Styled as Bootstrap Alerts) -->
  <xsl:template match="*[contains(@class, ' topic/note ')]" priority="5">
    <fo:block xsl:use-attribute-sets="section">
      <xsl:call-template name="commonattributes"/>
      <xsl:variable name="explicitThemeColor">
        <xsl:call-template name="get-theme-color"/>
      </xsl:variable>
      <xsl:variable name="themeSuffix">
        <xsl:if test="$explicitThemeColor != ''">
          <xsl:call-template name="get-theme-suffix"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="theme">
        <xsl:choose>
          <xsl:when test="$explicitThemeColor != ''"><xsl:value-of select="$explicitThemeColor"/></xsl:when>
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
      <xsl:variable name="suffixTokens" select="if ($themeSuffix != '') then tokenize($themeSuffix, '-') else ()"/>
      <xsl:variable name="isMuted" select="$suffixTokens = 'muted'"/>
      <xsl:variable name="isSubtle" select="$themeSuffix = '' or $suffixTokens = 'subtle'"/>
      <xsl:variable name="isBorderOnly" select="$themeSuffix = 'border'"/>
      <xsl:variable
        name="attrSetName"
        select="
        if ($isMuted) then concat('__muted__', $theme)
        else if ($isBorderOnly) then concat('border-', $theme)
        else if ($isSubtle) then concat('__bg__', $theme, '-subtle')
        else concat('__bg__', $theme)"
      />
      <xsl:variable name="icon-color-raw">
        <xsl:call-template name="getBootstrapAttrValue">
          <xsl:with-param name="attrSet" select="$attrSetName"/>
          <xsl:with-param name="attrName" select="if ($isBorderOnly) then 'border-color' else 'color'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable
        name="icon-color-is-white"
        select="normalize-space(lower-case($icon-color-raw)) = ('#fff', '#ffffff', 'white')"
      />
      <xsl:variable name="icon-color">
        <xsl:choose>
          <xsl:when test="$icon-color-is-white">
            <xsl:call-template name="getBootstrapAttrValue">
              <xsl:with-param name="attrSet" select="concat('__bg__', $theme, '-subtle')"/>
              <xsl:with-param name="attrName" select="'background-color'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$icon-color-raw"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- 1. Unified Decoration -->
      <xsl:choose>
        <xsl:when test="$isMuted">
          <xsl:call-template name="bootstrap.decoration">
              <xsl:with-param name="theme" select="$theme"/>
              <xsl:with-param name="prefix" select="'__muted__'"/>
              <xsl:with-param name="defaultRounded" select="true()"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$isBorderOnly">
          <xsl:call-template name="bootstrap.decoration">
              <xsl:with-param name="theme" select="$theme"/>
              <xsl:with-param name="skipBackground" select="true()"/>
              <xsl:with-param name="defaultRounded" select="true()"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="bootstrap.decoration">
              <xsl:with-param name="variant" select="if ($isSubtle) then 'subtle' else ''"/>
              <xsl:with-param name="theme" select="$theme"/>
              <xsl:with-param name="defaultRounded" select="true()"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

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

      <!-- 4. Ancestor Indent Compensation -->
      <xsl:variable name="ancestorStartPad">
        <xsl:call-template name="get-ancestor-padding-indent">
          <xsl:with-param name="side" select="'start'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="ancestorEndPad">
        <xsl:call-template name="get-ancestor-padding-indent">
          <xsl:with-param name="side" select="'end'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="number($ancestorStartPad) > 0">
        <xsl:attribute name="start-indent" select="concat($ancestorStartPad, 'pt + from-parent(start-indent)')"/>
      </xsl:if>
      <xsl:if test="number($ancestorEndPad) > 0">
        <xsl:attribute name="end-indent" select="concat($ancestorEndPad, 'pt + from-parent(end-indent)')"/>
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

  <!-- Override to prevent duplicate ID generation on inline elements in dt/pt -->
  <xsl:template match="@id" priority="2">
    <xsl:param name="bootstrap-suppress-id" select="false()" tunnel="yes" as="xs:boolean"/>
    <xsl:if test="not($bootstrap-suppress-id)">
      <xsl:attribute name="id" select="."/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/dt ')]" mode="inlineTextOptionalKeyref" priority="2">
    <xsl:next-match>
      <xsl:with-param name="bootstrap-suppress-id" select="true()" tunnel="yes"/>
    </xsl:next-match>
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' topic/xref ')][@href][not(@scope = 'external')][empty(@format) or @format = 'dita'][opentopic-func:getDestinationId(@href) = ''][not(contains(@class, ' bootstrap-d/button ') or exists(tokenize(@outputclass, ' ')[starts-with(., 'btn')]) or @theme or exists(tokenize(@outputclass, ' ')[starts-with(., 'link-') or . = 'link-underline']))]"
    priority="25"
  >
    <fo:inline>
      <xsl:call-template name="commonattributes"/>
      <xsl:apply-templates select="*[not(contains(@class, ' topic/desc '))] | text()"/>
    </fo:inline>
  </xsl:template>

</xsl:stylesheet>
