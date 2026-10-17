<?xml version="1.0" encoding="UTF-8"?>
<!--
	This file is part of the DITA Bootstrap PDF plug-in for DITA Open Toolkit.
	See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  xmlns:grid="urn:dita-bootstrap:pdf:grid"
  exclude-result-prefixes="grid"
  version="2.0"
>

  <xsl:function name="grid:gutter" as="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:param name="row" as="element()?"/>
    <xsl:sequence select="if ($row/@gap) then concat(xs:integer($row/@gap) * 3, 'pt') else '12pt'"/>
  </xsl:function>

  <xsl:function name="grid:span" as="xs:integer" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:param name="cell" as="node()"/>
    <xsl:variable name="row" select="$cell/parent::*"/>
    <xsl:variable
      name="parsed-span"
      select="(for $t in tokenize($cell/@outputclass, '\s+') return if (matches($t, '^(.*:)?col(-[a-z]+)?-[0-9]+$')) then replace($t, '^.*col(?:-[a-z]+)?-([0-9]+)$', '$1') else ())[1]"
    />
    <xsl:variable
      name="row-cols"
      select="(for $t in tokenize($row/@outputclass, '\s+') return if (matches($t, '^row-cols-[0-9]+$')) then replace($t, '^row-cols-', '') else ())[1]"
    />
    <xsl:variable
      name="col-count"
      select="count($row/*[contains(@class, ' bootstrap-d/grid-col ') or exists(tokenize(@outputclass, ' ')[starts-with(., 'col') or contains(., ':col')])])"
    />
    <xsl:sequence
      select="
      if (not($cell/self::*[contains(@class, ' bootstrap-d/grid-col ') or exists(tokenize(@outputclass, ' ')[starts-with(., 'col') or contains(., ':col')])])) then 12
      else if ($cell/@colspan castable as xs:integer) then xs:integer($cell/@colspan)
      else if (normalize-space($parsed-span)) then xs:integer($parsed-span)
      else if (normalize-space($row-cols)) then max((1, 12 idiv xs:integer($row-cols)))
      else max((1, 12 idiv $col-count))"
    />
  </xsl:function>

  <!-- Number of leading cells that fit in one 12-column row (at least 1) -->
  <xsl:function name="grid:row-length" as="xs:integer" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:param name="spans" as="xs:integer*"/>
    <xsl:param name="used" as="xs:integer"/>
    <xsl:sequence
      select="
      if (empty($spans) or ($used gt 0 and $used + $spans[1] gt 12)) then 0
      else 1 + grid:row-length(subsequence($spans, 2), $used + $spans[1])"
    />
  </xsl:function>

  <xsl:template name="grid-rows">
    <xsl:param name="cells" as="node()*"/>
    <xsl:if test="exists($cells)">
      <xsl:variable name="n" select="grid:row-length(for $c in $cells return grid:span($c), 0)"/>
      <fo:table-row>
        <xsl:call-template name="processBootstrapDirection"/>
        <xsl:apply-templates select="subsequence($cells, 1, $n)" mode="grid-row-children"/>
      </fo:table-row>
      <xsl:call-template name="grid-rows">
        <xsl:with-param name="cells" select="subsequence($cells, $n + 1)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Grid Row Handling -->
  <!-- A grid-row is a table of one row with 12 columns. -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/grid-row ') or (tokenize(@outputclass, ' ') = 'row' and (contains(@class, ' topic/div ') or contains(@class, ' topic/bodydiv ')))]"
    priority="5"
  >
    <fo:block>
      <xsl:call-template name="processBootstrapSpacing">
        <xsl:with-param name="attrValue" select="@margin"/>
        <xsl:with-param name="prefix" select="'m'"/>
      </xsl:call-template>
      <xsl:call-template name="processBootstrapSpacing">
        <xsl:with-param name="attrValue" select="@padding"/>
        <xsl:with-param name="prefix" select="'p'"/>
      </xsl:call-template>
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
          <xsl:call-template name="grid-rows">
            <xsl:with-param name="cells" select="node()[self::* or (self::text() and normalize-space())]"/>
          </xsl:call-template>
        </fo:table-body>
      </fo:table>
    </fo:block>
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
      
      <xsl:attribute name="number-columns-spanned" select="grid:span(.)"/>

      <!-- Standard Bootstrap-like gutter padding -->
      <xsl:attribute name="padding-left" select="grid:gutter(parent::*)"/>
      <xsl:attribute name="padding-right" select="grid:gutter(parent::*)"/>
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
     <fo:table-cell
      number-columns-spanned="12"
      padding-left="{grid:gutter(parent::*)}"
      padding-right="{grid:gutter(parent::*)}"
    >
        <fo:block start-indent="0pt">
           <xsl:apply-templates select="."/>
        </fo:block>
     </fo:table-cell>
  </xsl:template>

  <!-- Ignore whitespace between columns to avoid overflow cells -->
  <xsl:template match="text()[not(normalize-space())]" mode="grid-row-children"/>

  <!-- Wrap non-empty text in a cell if it appears directly in a row -->
  <xsl:template match="text()[normalize-space()]" mode="grid-row-children" priority="1">
     <fo:table-cell
      number-columns-spanned="12"
      padding-left="{grid:gutter(parent::*)}"
      padding-right="{grid:gutter(parent::*)}"
    >
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
