<?xml version="1.0" encoding="UTF-8"?>
<!--
	This file is part of the DITA Bootstrap PDF plug-in for DITA Open Toolkit.
	See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  version="2.0"
>

  <!-- Matches list-group specialized elements or ul with list-group outputclass -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/list-group ') or (tokenize(@outputclass, ' ') = 'list-group' and contains(@class, ' topic/ul '))]"
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

      <fo:table table-layout="fixed" width="100%" border-collapse="collapse">
         <!-- Default border if not 'flush' -->
         <xsl:choose>
            <xsl:when test="@flush = 'yes' or tokenize(@outputclass, ' ') = 'list-group-flush'">
               <!-- No border on flush -->
            </xsl:when>
            <xsl:otherwise>
               <xsl:attribute name="border">
                 <xsl:value-of select="concat($bootstrap-border-width, ' solid ', $bootstrap-border-color)"/>
               </xsl:attribute>
            </xsl:otherwise>
         </xsl:choose>
         
         <fo:table-column column-width="proportional-column-width(1)"/>
         <fo:table-body>
           <xsl:apply-templates select="*[contains(@class, ' topic/li ')]"/>
         </fo:table-body>
      </fo:table>
    </fo:block>
  </xsl:template>

  <!-- Matches list items within a list-group -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/list-group ') or (tokenize(@outputclass, ' ') = 'list-group' and contains(@class, ' topic/ul '))]/*[contains(@class, ' topic/li ')]"
    priority="5"
  >
    <fo:table-row>
      <xsl:variable name="theme">
        <xsl:call-template name="get-theme-color">
          <xsl:with-param name="node" select=".."/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable
        name="itemTheme"
        select="(tokenize(@outputclass, ' ')[starts-with(., 'list-group-item-') or starts-with(., 'theme-')])[1]"
      />
      
      <!-- Apply text color from parent @theme if present -->
      <xsl:if test="$theme">
         <xsl:call-template name="processBootstrapAttrSetReflection">
            <xsl:with-param name="attrSet" select="concat('__color__', $theme)"/>
         </xsl:call-template>
      </xsl:if>
      
      <fo:table-cell>
        <xsl:attribute name="border-bottom">
          <xsl:value-of select="concat($bootstrap-border-width, ' solid ', $bootstrap-border-color)"/>
        </xsl:attribute>
        <!-- Apply text color from item specific class if present -->
        <xsl:if test="exists($itemTheme)">
             <xsl:variable
            name="colorName"
            select="if (starts-with($itemTheme, 'theme-')) then substring-after($itemTheme, 'theme-') else substring-after($itemTheme, 'list-group-item-')"
          />
             <xsl:if test="$colorName != '' and $colorName != 'action'">
                 <xsl:call-template name="processBootstrapAttrSetReflection">
                    <xsl:with-param name="attrSet" select="concat('__color__', $colorName)"/>
                 </xsl:call-template>
             </xsl:if>
        </xsl:if>

        <xsl:attribute name="padding">
            <xsl:choose>
               <xsl:when test="../@compact = 'yes'">4pt 15pt</xsl:when>
               <xsl:otherwise>8pt 15pt</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <!-- Remove bottom border for the last item if it's not flush (since the table bottom border exists) -->
        <xsl:if
          test="position() = last() and not(../@flush = 'yes' or tokenize(../@outputclass, ' ') = 'list-group-flush')"
        >
            <xsl:attribute name="border-bottom">none</xsl:attribute>
        </xsl:if>
        
        <xsl:call-template name="processBootstrapDirection"/>
        <fo:block>
           <xsl:call-template name="processBootstrapDirection"/>
           <xsl:apply-templates/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>

</xsl:stylesheet>
