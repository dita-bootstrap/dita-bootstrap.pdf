<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  exclude-result-prefixes="xs fox"
  version="2.0"
>

  <!-- Core Attribute Sets and Utility Functions -->
  <xsl:import href="../cfg/fo/attrs/bootstrap-attr.xsl"/>
  
  <!-- Shared Utilities (Refactored logic) -->
  <xsl:include href="fo/utility-classes.xsl"/>

  <!-- Component Specific Modules -->
  <xsl:include href="fo/accordion.xsl"/>
  <xsl:include href="fo/alert.xsl"/>
  <xsl:include href="fo/button.xsl"/>
  <xsl:include href="fo/badge.xsl"/>
  <xsl:include href="fo/card.xsl"/>
  <xsl:include href="fo/carousel.xsl"/>
  <xsl:include href="fo/figure.xsl"/>
  <xsl:include href="fo/grid.xsl"/>
  <xsl:include href="fo/icon.xsl"/>
  <xsl:include href="fo/list-group.xsl"/>
  <xsl:include href="fo/pagination.xsl"/>
  <xsl:include href="fo/note.xsl"/>
  <xsl:include href="fo/tables.xsl"/>
  <xsl:include href="fo/topic.xsl"/>

</xsl:stylesheet>
