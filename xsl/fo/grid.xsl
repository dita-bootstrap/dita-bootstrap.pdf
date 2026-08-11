<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  version="2.0"
>

  <!-- Grid Row Handling -->
  <!-- A grid-row is a table of one row with 12 columns. -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/grid-row ') or (tokenize(@outputclass, ' ') = 'row' and (contains(@class, ' topic/div ') or contains(@class, ' topic/bodydiv ')))]"
    priority="5"
  >
    <fo:table table-layout="fixed" width="100%" space-before="10pt" space-after="10pt">
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="processBootstrapDirection"/>
      
      <!-- Table Stacking Trick: Inherit indentation from parent -->
      <xsl:attribute name="start-indent">inherited-property-value(start-indent)</xsl:attribute>
      
      <!-- Define exactly 12 columns as per Bootstrap grid system -->
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column column-width="proportional-column-width(1)"/>
      
      <fo:table-body>
        <fo:table-row>
          <xsl:call-template name="processBootstrapDirection"/>
          <xsl:apply-templates mode="grid-row-children"/>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>

  <!-- Grid Column Handling -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/grid-col ') or 
           (exists(tokenize(@outputclass, ' ')[starts-with(., 'col') or contains(., ':col')]) and (contains(@class, ' topic/div ') or contains(@class, ' topic/bodydiv ')))]"
    priority="5"
    mode="grid-row-children"
  >
    <fo:table-cell>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="processBootstrapDirection"/>
      
      <!-- Spanning logic: Use @colspan if defined, else parse from outputclass, else assign equally among siblings -->
      <xsl:variable
        name="col-count"
        select="count(../*[contains(@class, ' bootstrap-d/grid-col ') or exists(tokenize(@outputclass, ' ')[starts-with(., 'col') or contains(., ':col')])])"
      />
      <xsl:variable
        name="parsed-span"
        select="(for $t in tokenize(@outputclass, '\s+') return if (matches($t, '^(.*:)?col(-[a-z]+)?-[0-9]+$')) then replace($t, '^.*col(?:-[a-z]+)?-([0-9]+)$', '$1') else ())[1]"
      />
      <xsl:attribute name="number-columns-spanned">
        <xsl:choose>
          <xsl:when test="@colspan">
            <xsl:value-of select="@colspan"/>
          </xsl:when>
          <xsl:when test="normalize-space($parsed-span)">
            <xsl:value-of select="$parsed-span"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="12 idiv $col-count"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <!-- Standard Bootstrap-like gutter padding -->
      <xsl:attribute name="padding-left">12pt</xsl:attribute>
      <xsl:attribute name="padding-right">12pt</xsl:attribute>
      <fo:block start-indent="0pt">
        <xsl:call-template name="processBootstrapDirection"/>
        <!-- @padding/@margin (e.g. p-3, mb-2) stack on top of the structural column gutter above -->
        <xsl:call-template name="processBootstrapSpacing">
          <xsl:with-param name="attrValue" select="@padding"/>
          <xsl:with-param name="prefix" select="'p'"/>
        </xsl:call-template>
        <xsl:call-template name="processBootstrapSpacing">
          <xsl:with-param name="attrValue" select="@margin"/>
          <xsl:with-param name="prefix" select="'m'"/>
        </xsl:call-template>
        <xsl:apply-templates/>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <!-- Fallback: Wrap any other ELEMENTS of a row in a full-width cell -->
  <xsl:template match="*" mode="grid-row-children" priority="1">
     <fo:table-cell number-columns-spanned="12" padding-left="12pt" padding-right="12pt">
        <fo:block start-indent="0pt">
           <xsl:apply-templates select="."/>
        </fo:block>
     </fo:table-cell>
  </xsl:template>

  <!-- Ignore whitespace between columns to avoid overflow cells -->
  <xsl:template match="text()[not(normalize-space())]" mode="grid-row-children"/>

  <!-- Wrap non-empty text in a cell if it appears directly in a row -->
  <xsl:template match="text()[normalize-space()]" mode="grid-row-children" priority="1">
     <fo:table-cell number-columns-spanned="12" padding-left="12pt" padding-right="12pt">
        <fo:block start-indent="0pt">
           <xsl:value-of select="."/>
        </fo:block>
     </fo:table-cell>
  </xsl:template>

  <!-- Special case for specialized grid-col if encountered in default mode -->
  <xsl:template match="*[contains(@class, ' bootstrap-d/grid-col ')]" priority="5">
      <fo:table table-layout="fixed" width="100%">
          <fo:table-body>
              <fo:table-row>
                  <xsl:apply-templates select="." mode="grid-row-children"/>
              </fo:table-row>
          </fo:table-body>
      </fo:table>
  </xsl:template>

</xsl:stylesheet>
