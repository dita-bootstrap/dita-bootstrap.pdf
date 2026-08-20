<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
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

</xsl:stylesheet>
