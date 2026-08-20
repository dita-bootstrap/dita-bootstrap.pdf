<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  version="2.0"
>

  <!-- Matches accordion specialized elements or bodydiv with accordion outputclass -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/accordion ') or (contains(@class, ' topic/bodydiv ') and (tokenize(@outputclass, ' ') = ('accordion', 'accordion-flush') or contains(@outputclass, 'accordion')))]"
    priority="5"
  >
    <fo:block>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="processBootstrapDirection"/>
      <xsl:call-template name="processBootstrapSpacing">
        <xsl:with-param name="attrValue" select="@margin"/>
        <xsl:with-param name="prefix" select="'m'"/>
      </xsl:call-template>
      <xsl:call-template name="processBootstrapWidth">
        <xsl:with-param name="attrValue" select="@width"/>
      </xsl:call-template>

      <!-- Border and rounding for the accordion container if not flushed -->
      <xsl:variable name="is-flush" select="@flush = 'yes' or tokenize(@outputclass, ' ') = 'accordion-flush'"/>
      
      <fo:block>
         <xsl:if test="not($is-flush)">
            <xsl:attribute name="border">
              <xsl:value-of select="concat($bootstrap-border-width, ' solid ', $bootstrap-border-color)"/>
            </xsl:attribute>
            <xsl:if test="@rounded">
               <xsl:call-template name="processBootstrapRounded">
                  <xsl:with-param name="attrValue" select="@rounded"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:if>
         
         <xsl:apply-templates select="*[contains(@class, ' topic/section ')]" mode="accordion"/>
      </fo:block>
    </fo:block>
  </xsl:template>

  <!-- Matches accordion items -->
  <xsl:template match="*[contains(@class, ' topic/section ')]" mode="accordion">
    <xsl:variable name="parent-color">
      <xsl:call-template name="get-theme-color">
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
    </xsl:variable>
    
    <fo:table table-layout="fixed" width="100%">
      <xsl:attribute name="border-bottom">
        <xsl:value-of select="concat($bootstrap-border-width, ' solid ', $bootstrap-border-color)"/>
      </xsl:attribute>
      <xsl:if test="position() = last()">
         <xsl:attribute name="border-bottom">none</xsl:attribute>
      </xsl:if>
      
      <!-- Ensure the entire accordion item stays on one page -->
      <xsl:attribute name="keep-together.within-page">always</xsl:attribute>

      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-body>
        <!-- Accordion Header -->
        <fo:table-row>
          <fo:table-cell padding="10pt 15pt">
            <xsl:call-template name="processBootstrapDirection"/>
            <xsl:choose>
               <xsl:when test="$parent-color">
                  <xsl:call-template name="processBootstrapAttrSetReflection">
                     <xsl:with-param name="attrSet" select="concat('__bg__', $parent-color, '-subtle')"/>
                  </xsl:call-template>
               </xsl:when>
                <xsl:otherwise>
                  <!-- Default background is grey (secondary-subtle) -->
                  <xsl:call-template name="processBootstrapAttrSetReflection">
                    <xsl:with-param name="attrSet" select="'__bg__secondary-subtle'"/>
                  </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
            <fo:block font-weight="bold">
               <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="accordion-header"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>

        <!-- Accordion Body -->
        <fo:table-row>
          <fo:table-cell padding="10pt 15pt">
            <xsl:call-template name="processBootstrapDirection"/>
            <fo:block>
               <xsl:apply-templates select="node() except *[contains(@class, ' topic/title ')]"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>

  <!-- Title in accordion header -->
  <xsl:template match="*[contains(@class, ' topic/title ')]" mode="accordion-header">
     <fo:block>
        <xsl:apply-templates/>
     </fo:block>
  </xsl:template>

</xsl:stylesheet>
