<?xml version="1.0" encoding="UTF-8"?>
<!--
	This file is part of the DITA Bootstrap PDF plug-in for DITA Open Toolkit.
	See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  exclude-result-prefixes="xs dita-ot"
  version="2.0"
>

  <!-- 
    Table Support for Bootstrap Print
    
    Theming Hierarchy: Entry > Row > thead > Table

    When <table theme="primary"> is set:
    - thead row takes primary color (like badge)
    - tbody rows take primary-subtle color (like alert)
    - borders (if present) also take primary color
    
    When <thead theme="xxx"> is set:
    - thead row takes the specified color, overriding table color.
    
    When <table striped="yes"> is set:
    - Only even rows in the body take the background color.
    
    When <table striped-columns="yes"> is set:
    - Only even columns in the body take the background color.
    
    When <table divider="yes"> is set:
    - A thicker border (2pt) is applied between table groups (thead, tbody, tfoot).
  -->
  
  <xsl:template match="*[contains(@class, ' topic/table ')]" priority="5">
    <xsl:variable
      name="hasDecoration"
      select="@theme or @padding or @width or @margin or @shadow or
                                               exists(tokenize(@outputclass, ' ')[starts-with(., 'theme-') or starts-with(., 'table-') or starts-with(., 'w-') or starts-with(., 'p-') or starts-with(., 'm-') or . = 'shadow-sm' or . = 'shadow' or . = 'shadow-lg' or . = 'shadow-none'])"
    />
    <xsl:choose>
      <xsl:when test="$hasDecoration">
        <fo:block xsl:use-attribute-sets="table__container">
          <xsl:call-template name="commonattributes"/>
          <xsl:call-template name="bootstrap.decoration"/>
          <xsl:apply-templates
            select="*[not(contains(@class, ' topic/tgroup ')) and not(contains(@class, ' topic/title '))]"
          />
          <xsl:apply-templates select="*[contains(@class, ' topic/tgroup ')]"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates
          select="*[not(contains(@class, ' topic/tgroup ')) and not(contains(@class, ' topic/title '))]"
        />
        <xsl:apply-templates select="*[contains(@class, ' topic/tgroup ')]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/tgroup ')]" priority="5">
    <fo:table xsl:use-attribute-sets="table">
      <xsl:call-template name="commonattributes"/>
      <xsl:attribute name="start-indent">inherited-property-value(start-indent)</xsl:attribute>
      <xsl:call-template name="bootstrap.decoration">
           <xsl:with-param name="node" select="parent::*"/>
      </xsl:call-template>
      <xsl:apply-templates/>
    </fo:table>
  </xsl:template>

  <!-- 1. Table Header Row Styling -->
  <xsl:template match="*[contains(@class, ' topic/thead ')]/*[contains(@class, ' topic/row ')]" priority="5">
    <fo:table-row xsl:use-attribute-sets="thead.row">
      <xsl:call-template name="commonattributes"/>
      
      <!-- Inherit theme from thead if not set on row -->
      <xsl:variable name="thead" select="parent::*"/>
      <xsl:variable
        name="theme"
        select="(@theme, $thead/@theme,
                 substring-after(tokenize($thead/@outputclass, ' ')[starts-with(., 'theme-')][1], 'theme-'),
                 substring-after(tokenize($thead/@outputclass, ' ')[starts-with(., 'table-')][1], 'table-'))[1]"
      />
      
      <xsl:call-template name="bootstrap.decoration">
          <xsl:with-param name="theme" select="$theme"/>
      </xsl:call-template>
      
      <xsl:apply-templates/>
    </fo:table-row>
  </xsl:template>

  <!-- 2. Table Body Row Styling -->
  <xsl:template match="*[contains(@class, ' topic/tbody ')]/*[contains(@class, ' topic/row ')]" priority="5">
    <fo:table-row xsl:use-attribute-sets="tbody.row">
      <xsl:call-template name="commonattributes"/>

      <xsl:variable name="tbody" select="parent::*"/>
      <xsl:variable name="table" select="ancestor::*[contains(@class, ' topic/table ')][1]"/>
      
      <xsl:variable name="tableTheme" select="$table/@theme"/>
      <xsl:variable
        name="striped"
        select="$table/@striped = 'yes' or tokenize($table/@outputclass, ' ') = 'table-striped'"
      />

      <!-- Inherit theme from tbody if not set on row -->
      <xsl:variable
        name="rowTheme"
        select="(@theme,
                 substring-after(tokenize($tbody/@outputclass, ' ')[starts-with(., 'theme-')][1], 'theme-'),
                 substring-after(tokenize($tbody/@outputclass, ' ')[starts-with(., 'table-')][1], 'table-'))[1]"
      />
      
      <xsl:variable name="rowIndex" select="count(preceding-sibling::*[contains(@class, ' topic/row ')]) + 1"/>
      
      <xsl:call-template name="bootstrap.decoration">
          <xsl:with-param name="theme" select="$rowTheme"/>
      </xsl:call-template>

      <!-- Row Striping Logic -->
      <xsl:if test="$striped and ($rowIndex mod 2 = 0)">
        <xsl:choose>
            <xsl:when test="$tableTheme">
              <xsl:call-template name="processBootstrapAttrSetReflection">
                <xsl:with-param name="attrSet" select="concat('__bg__', $tableTheme, '-subtle')"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="processBootstrapAttrSetReflection">
                <xsl:with-param name="attrSet" select="'table-striped'"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
      </xsl:if>

      <xsl:apply-templates/>
    </fo:table-row>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/tfoot ')]/*[contains(@class, ' topic/row ')]" priority="5">
    <fo:table-row xsl:use-attribute-sets="tfoot.row">
      <xsl:call-template name="commonattributes"/>

      <!-- Inherit theme from tfoot if not set on row -->
      <xsl:variable name="tfoot" select="parent::*"/>
      <xsl:variable
        name="theme"
        select="(@theme, $tfoot/@theme,
                 substring-after(tokenize($tfoot/@outputclass, ' ')[starts-with(., 'theme-')][1], 'theme-'),
                 substring-after(tokenize($tfoot/@outputclass, ' ')[starts-with(., 'table-')][1], 'table-'))[1]"
      />

      <xsl:call-template name="bootstrap.decoration">
          <xsl:with-param name="theme" select="$theme"/>
      </xsl:call-template>

      <xsl:apply-templates/>
    </fo:table-row>
  </xsl:template>
  
  <!-- 3. Entry styling to handle border colors, cell backgrounds, striping and dividends -->
  <xsl:template match="*[contains(@class, ' topic/entry ')]" priority="5">
    <xsl:variable
      name="isHeader"
      select="parent::*[contains(@class, ' topic/row ')]/parent::*[contains(@class, ' topic/thead ')]"
    />
    <xsl:variable
      name="isFooter"
      select="parent::*[contains(@class, ' topic/row ')]/parent::*[contains(@class, ' topic/tfoot ')]"
    />
    <xsl:variable name="table" select="ancestor::*[contains(@class, ' topic/table ')][1]"/>
    <xsl:variable name="tableTheme" select="$table/@theme"/>
    <xsl:variable
      name="stripedCols"
      select="$table/@striped-columns = 'yes' or tokenize($table/@outputclass, ' ') = 'table-striped-columns'"
    />
    
    <xsl:variable name="colIndex" select="if (@dita-ot:x) then xs:integer(@dita-ot:x) else 0"/>
    <xsl:variable
      name="isColoredCol"
      select="$stripedCols and ($colIndex mod 2 = 0) and not($isHeader) and not($isFooter)"
    />
    
    <xsl:variable
      name="isGroupDivider"
      select="$table/@divider = 'yes' and not(parent::*/preceding-sibling::*[contains(@class, ' topic/row ')]) and (parent::*/parent::*[contains(@class, ' topic/tbody ')] or parent::*/parent::*[contains(@class, ' topic/tfoot ')])"
    />

    <fo:table-cell>
      <xsl:call-template name="commonattributes"/>
      
      <!-- Apply Standard PDF2 Attribute Sets -->
      <xsl:choose>
        <xsl:when test="$isHeader">
          <xsl:call-template name="get-attributes">
            <xsl:with-param name="element" as="element()">
              <placeholder xsl:use-attribute-sets="thead.row.entry"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$table/@rowheader = 'firstcol' and @dita-ot:x = '1'">
              <xsl:call-template name="get-attributes">
                <xsl:with-param name="element" as="element()">
                  <placeholder xsl:use-attribute-sets="tbody.row.entry__firstcol"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="get-attributes">
                <xsl:with-param name="element" as="element()">
                  <placeholder xsl:use-attribute-sets="tbody.row.entry"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
      
      <xsl:call-template name="applySpansAttrs"/>
      <xsl:call-template name="applyAlignAttrs"/>
      <xsl:call-template name="generateTableEntryBorder"/>
      
      <xsl:call-template name="bootstrap.decoration"/>
      
      <!-- 5. Group Divider (Thicker border between table groups) -->
      <xsl:if test="$isGroupDivider">
        <xsl:attribute name="border-top-width">2pt</xsl:attribute>
      </xsl:if>
      
      <!-- Entry-specific background overrides -->
      <xsl:choose>
        <!-- Column Striping (applied if cell has no theme color) -->
        <xsl:when test="$isColoredCol and not(@theme)">
           <xsl:choose>
            <xsl:when test="$tableTheme">
              <xsl:call-template name="processBootstrapAttrSetReflection">
                <xsl:with-param name="attrSet" select="concat('__bg__', $tableTheme, '-subtle')"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="processBootstrapAttrSetReflection">
                <xsl:with-param name="attrSet" select="'table-striped'"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
      
      <!-- 6. Content -->
      <xsl:choose>
        <xsl:when test="@rotate eq '1'">
          <fo:block-container reference-orientation="90">
            <fo:block>
              <xsl:call-template name="get-attributes">
                <xsl:with-param name="element" as="element()">
                  <xsl:choose>
                    <xsl:when test="$isHeader"><placeholder
                        xsl:use-attribute-sets="thead.row.entry__content"
                      /></xsl:when>
                    <xsl:otherwise><placeholder xsl:use-attribute-sets="tbody.row.entry__content"/></xsl:otherwise>
                  </xsl:choose>
                </xsl:with-param>
              </xsl:call-template>
              <xsl:call-template name="processEntryContent"/>
            </fo:block>
          </fo:block-container>
        </xsl:when>
        <xsl:otherwise>
          <fo:block>
            <xsl:call-template name="get-attributes">
              <xsl:with-param name="element" as="element()">
                <xsl:choose>
                  <xsl:when test="$isHeader"><placeholder xsl:use-attribute-sets="thead.row.entry__content"/></xsl:when>
                  <xsl:otherwise><placeholder xsl:use-attribute-sets="tbody.row.entry__content"/></xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="processEntryContent"/>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </fo:table-cell>
  </xsl:template>

</xsl:stylesheet>
