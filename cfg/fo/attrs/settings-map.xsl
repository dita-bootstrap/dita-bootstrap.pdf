<?xml version="1.0" encoding="UTF-8"?>
<!--
	This file is part of the DITA-OT Bootstrap Print Plug-in project.
	See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

  <!-- Bootstrap Settings Map for Reflection -->
  <xsl:variable name="bootstrap-settings">
    <entry name="bootstrap-primary"><xsl:value-of select="$bootstrap-primary"/></entry>
    <entry name="bootstrap-secondary"><xsl:value-of select="$bootstrap-secondary"/></entry>
    <entry name="bootstrap-success"><xsl:value-of select="$bootstrap-success"/></entry>
    <entry name="bootstrap-danger"><xsl:value-of select="$bootstrap-danger"/></entry>
    <entry name="bootstrap-warning"><xsl:value-of select="$bootstrap-warning"/></entry>
    <entry name="bootstrap-info"><xsl:value-of select="$bootstrap-info"/></entry>
    <entry name="bootstrap-accent"><xsl:value-of select="$bootstrap-accent"/></entry>
    <entry name="bootstrap-inverse"><xsl:value-of select="$bootstrap-inverse"/></entry>
    <entry name="bootstrap-link"><xsl:value-of select="$bootstrap-link"/></entry>

    <entry name="bootstrap-primary-subtle"><xsl:value-of select="$bootstrap-primary-subtle"/></entry>
    <entry name="bootstrap-primary-subtle-text"><xsl:value-of select="$bootstrap-primary-subtle-text"/></entry>
    <entry name="bootstrap-secondary-subtle"><xsl:value-of select="$bootstrap-secondary-subtle"/></entry>
    <entry name="bootstrap-secondary-subtle-text"><xsl:value-of select="$bootstrap-secondary-subtle-text"/></entry>
    <entry name="bootstrap-success-subtle"><xsl:value-of select="$bootstrap-success-subtle"/></entry>
    <entry name="bootstrap-success-subtle-text"><xsl:value-of select="$bootstrap-success-subtle-text"/></entry>
    <entry name="bootstrap-danger-subtle"><xsl:value-of select="$bootstrap-danger-subtle"/></entry>
    <entry name="bootstrap-danger-subtle-text"><xsl:value-of select="$bootstrap-danger-subtle-text"/></entry>
    <entry name="bootstrap-warning-subtle"><xsl:value-of select="$bootstrap-warning-subtle"/></entry>
    <entry name="bootstrap-warning-subtle-text"><xsl:value-of select="$bootstrap-warning-subtle-text"/></entry>
    <entry name="bootstrap-info-subtle"><xsl:value-of select="$bootstrap-info-subtle"/></entry>
    <entry name="bootstrap-info-subtle-text"><xsl:value-of select="$bootstrap-info-subtle-text"/></entry>
    <entry name="bootstrap-accent-subtle"><xsl:value-of select="$bootstrap-accent-subtle"/></entry>
    <entry name="bootstrap-accent-subtle-text"><xsl:value-of select="$bootstrap-accent-subtle-text"/></entry>
    <entry name="bootstrap-inverse-subtle"><xsl:value-of select="$bootstrap-inverse-subtle"/></entry>
    <entry name="bootstrap-inverse-subtle-text"><xsl:value-of select="$bootstrap-inverse-subtle-text"/></entry>

    <!-- Component-specific: Tables -->
    <entry name="bootstrap-table-primary-bg"><xsl:value-of select="$bootstrap-table-primary-bg"/></entry>
    <entry name="bootstrap-table-primary-color"><xsl:value-of select="$bootstrap-table-primary-color"/></entry>
    <entry name="bootstrap-table-secondary-bg"><xsl:value-of select="$bootstrap-table-secondary-bg"/></entry>
    <entry name="bootstrap-table-secondary-color"><xsl:value-of select="$bootstrap-table-secondary-color"/></entry>
    <entry name="bootstrap-table-success-bg"><xsl:value-of select="$bootstrap-table-success-bg"/></entry>
    <entry name="bootstrap-table-success-color"><xsl:value-of select="$bootstrap-table-success-color"/></entry>
    <entry name="bootstrap-table-info-bg"><xsl:value-of select="$bootstrap-table-info-bg"/></entry>
    <entry name="bootstrap-table-info-color"><xsl:value-of select="$bootstrap-table-info-color"/></entry>
    <entry name="bootstrap-table-warning-bg"><xsl:value-of select="$bootstrap-table-warning-bg"/></entry>
    <entry name="bootstrap-table-warning-color"><xsl:value-of select="$bootstrap-table-warning-color"/></entry>
    <entry name="bootstrap-table-danger-bg"><xsl:value-of select="$bootstrap-table-danger-bg"/></entry>
    <entry name="bootstrap-table-danger-color"><xsl:value-of select="$bootstrap-table-danger-color"/></entry>
    <entry name="bootstrap-table-accent-bg"><xsl:value-of select="$bootstrap-table-accent-bg"/></entry>
    <entry name="bootstrap-table-accent-color"><xsl:value-of select="$bootstrap-table-accent-color"/></entry>
    <entry name="bootstrap-table-inverse-bg"><xsl:value-of select="$bootstrap-table-inverse-bg"/></entry>
    <entry name="bootstrap-table-inverse-color"><xsl:value-of select="$bootstrap-table-inverse-color"/></entry>

    <!-- Component-specific: Buttons -->
    <entry name="bootstrap-btn-primary-bg"><xsl:value-of select="$bootstrap-btn-primary-bg"/></entry>
    <entry name="bootstrap-btn-primary-color"><xsl:value-of select="$bootstrap-btn-primary-color"/></entry>
    <entry name="bootstrap-btn-secondary-bg"><xsl:value-of select="$bootstrap-btn-secondary-bg"/></entry>
    <entry name="bootstrap-btn-secondary-color"><xsl:value-of select="$bootstrap-btn-secondary-color"/></entry>
    <entry name="bootstrap-btn-success-bg"><xsl:value-of select="$bootstrap-btn-success-bg"/></entry>
    <entry name="bootstrap-btn-success-color"><xsl:value-of select="$bootstrap-btn-success-color"/></entry>
    <entry name="bootstrap-btn-info-bg"><xsl:value-of select="$bootstrap-btn-info-bg"/></entry>
    <entry name="bootstrap-btn-info-color"><xsl:value-of select="$bootstrap-btn-info-color"/></entry>
    <entry name="bootstrap-btn-warning-bg"><xsl:value-of select="$bootstrap-btn-warning-bg"/></entry>
    <entry name="bootstrap-btn-warning-color"><xsl:value-of select="$bootstrap-btn-warning-color"/></entry>
    <entry name="bootstrap-btn-danger-bg"><xsl:value-of select="$bootstrap-btn-danger-bg"/></entry>
    <entry name="bootstrap-btn-danger-color"><xsl:value-of select="$bootstrap-btn-danger-color"/></entry>
    <entry name="bootstrap-btn-accent-bg"><xsl:value-of select="$bootstrap-btn-accent-bg"/></entry>
    <entry name="bootstrap-btn-accent-color"><xsl:value-of select="$bootstrap-btn-accent-color"/></entry>
    <entry name="bootstrap-btn-inverse-bg"><xsl:value-of select="$bootstrap-btn-inverse-bg"/></entry>
    <entry name="bootstrap-btn-inverse-color"><xsl:value-of select="$bootstrap-btn-inverse-color"/></entry>

    <!-- Component-specific: Badges -->
    <entry name="bootstrap-badge-primary-bg"><xsl:value-of select="$bootstrap-badge-primary-bg"/></entry>
    <entry name="bootstrap-badge-primary-color"><xsl:value-of select="$bootstrap-badge-primary-color"/></entry>
    <entry name="bootstrap-badge-secondary-bg"><xsl:value-of select="$bootstrap-badge-secondary-bg"/></entry>
    <entry name="bootstrap-badge-secondary-color"><xsl:value-of select="$bootstrap-badge-secondary-color"/></entry>
    <entry name="bootstrap-badge-success-bg"><xsl:value-of select="$bootstrap-badge-success-bg"/></entry>
    <entry name="bootstrap-badge-success-color"><xsl:value-of select="$bootstrap-badge-success-color"/></entry>
    <entry name="bootstrap-badge-info-bg"><xsl:value-of select="$bootstrap-badge-info-bg"/></entry>
    <entry name="bootstrap-badge-info-color"><xsl:value-of select="$bootstrap-badge-info-color"/></entry>
    <entry name="bootstrap-badge-warning-bg"><xsl:value-of select="$bootstrap-badge-warning-bg"/></entry>
    <entry name="bootstrap-badge-warning-color"><xsl:value-of select="$bootstrap-badge-warning-color"/></entry>
    <entry name="bootstrap-badge-danger-bg"><xsl:value-of select="$bootstrap-badge-danger-bg"/></entry>
    <entry name="bootstrap-badge-danger-color"><xsl:value-of select="$bootstrap-badge-danger-color"/></entry>
    <entry name="bootstrap-badge-accent-bg"><xsl:value-of select="$bootstrap-badge-accent-bg"/></entry>
    <entry name="bootstrap-badge-accent-color"><xsl:value-of select="$bootstrap-badge-accent-color"/></entry>
    <entry name="bootstrap-badge-inverse-bg"><xsl:value-of select="$bootstrap-badge-inverse-bg"/></entry>
    <entry name="bootstrap-badge-inverse-color"><xsl:value-of select="$bootstrap-badge-inverse-color"/></entry>

    <entry name="bootstrap-spacing-0"><xsl:value-of select="$bootstrap-spacing-0"/></entry>
    <entry name="bootstrap-spacing-1"><xsl:value-of select="$bootstrap-spacing-1"/></entry>
    <entry name="bootstrap-spacing-2"><xsl:value-of select="$bootstrap-spacing-2"/></entry>
    <entry name="bootstrap-spacing-3"><xsl:value-of select="$bootstrap-spacing-3"/></entry>
    <entry name="bootstrap-spacing-4"><xsl:value-of select="$bootstrap-spacing-4"/></entry>
    <entry name="bootstrap-spacing-5"><xsl:value-of select="$bootstrap-spacing-5"/></entry>

    <entry name="bootstrap-border-color"><xsl:value-of select="$bootstrap-border-color"/></entry>
    <entry name="bootstrap-border-width"><xsl:value-of select="$bootstrap-border-width"/></entry>

    <entry name="bootstrap-rounded"><xsl:value-of select="$bootstrap-rounded"/></entry>
    <entry name="bootstrap-rounded-0"><xsl:value-of select="$bootstrap-rounded-0"/></entry>
    <entry name="bootstrap-rounded-1"><xsl:value-of select="$bootstrap-rounded-1"/></entry>
    <entry name="bootstrap-rounded-2"><xsl:value-of select="$bootstrap-rounded-2"/></entry>
    <entry name="bootstrap-rounded-3"><xsl:value-of select="$bootstrap-rounded-3"/></entry>
    <entry name="bootstrap-rounded-4"><xsl:value-of select="$bootstrap-rounded-4"/></entry>
    <entry name="bootstrap-rounded-5"><xsl:value-of select="$bootstrap-rounded-5"/></entry>
    <entry name="bootstrap-rounded-circle"><xsl:value-of select="$bootstrap-rounded-circle"/></entry>
    <entry name="bootstrap-rounded-pill"><xsl:value-of select="$bootstrap-rounded-pill"/></entry>

    <entry name="bootstrap-h1-font-size"><xsl:value-of select="$bootstrap-h1-font-size"/></entry>
    <entry name="bootstrap-h1-margin-top"><xsl:value-of select="$bootstrap-h1-margin-top"/></entry>
    <entry name="bootstrap-h1-margin-bottom"><xsl:value-of select="$bootstrap-h1-margin-bottom"/></entry>
    <entry name="bootstrap-h2-font-size"><xsl:value-of select="$bootstrap-h2-font-size"/></entry>
    <entry name="bootstrap-h2-margin-top"><xsl:value-of select="$bootstrap-h2-margin-top"/></entry>
    <entry name="bootstrap-h2-margin-bottom"><xsl:value-of select="$bootstrap-h2-margin-bottom"/></entry>
    <entry name="bootstrap-h3-font-size"><xsl:value-of select="$bootstrap-h3-font-size"/></entry>
    <entry name="bootstrap-h3-margin-top"><xsl:value-of select="$bootstrap-h3-margin-top"/></entry>
    <entry name="bootstrap-h3-margin-bottom"><xsl:value-of select="$bootstrap-h3-margin-bottom"/></entry>
    <entry name="bootstrap-h4-font-size"><xsl:value-of select="$bootstrap-h4-font-size"/></entry>
    <entry name="bootstrap-h4-margin-top"><xsl:value-of select="$bootstrap-h4-margin-top"/></entry>
    <entry name="bootstrap-h4-margin-bottom"><xsl:value-of select="$bootstrap-h4-margin-bottom"/></entry>
    <entry name="bootstrap-h5-font-size"><xsl:value-of select="$bootstrap-h5-font-size"/></entry>
    <entry name="bootstrap-h5-margin-top"><xsl:value-of select="$bootstrap-h5-margin-top"/></entry>
    <entry name="bootstrap-h5-margin-bottom"><xsl:value-of select="$bootstrap-h5-margin-bottom"/></entry>
    <entry name="bootstrap-h6-font-size"><xsl:value-of select="$bootstrap-h6-font-size"/></entry>
    <entry name="bootstrap-h6-margin-top"><xsl:value-of select="$bootstrap-h6-margin-top"/></entry>
    <entry name="bootstrap-h6-margin-bottom"><xsl:value-of select="$bootstrap-h6-margin-bottom"/></entry>

    <entry name="bootstrap-fs-xs"><xsl:value-of select="$bootstrap-fs-xs"/></entry>
    <entry name="bootstrap-fs-sm"><xsl:value-of select="$bootstrap-fs-sm"/></entry>
    <entry name="bootstrap-fs-base"><xsl:value-of select="$bootstrap-fs-base"/></entry>
    <entry name="bootstrap-fs-md"><xsl:value-of select="$bootstrap-fs-md"/></entry>
    <entry name="bootstrap-fs-lg"><xsl:value-of select="$bootstrap-fs-lg"/></entry>
    <entry name="bootstrap-fs-xl"><xsl:value-of select="$bootstrap-fs-xl"/></entry>
    <entry name="bootstrap-fs-2xl"><xsl:value-of select="$bootstrap-fs-2xl"/></entry>
    <entry name="bootstrap-fs-3xl"><xsl:value-of select="$bootstrap-fs-3xl"/></entry>
    <entry name="bootstrap-fs-4xl"><xsl:value-of select="$bootstrap-fs-4xl"/></entry>
    <entry name="bootstrap-fs-5xl"><xsl:value-of select="$bootstrap-fs-5xl"/></entry>
    <entry name="bootstrap-fs-6xl"><xsl:value-of select="$bootstrap-fs-6xl"/></entry>

    <entry name="bootstrap-table-striped-color"><xsl:value-of select="$bootstrap-table-striped-color"/></entry>
    <entry name="bootstrap-lead-font-size"><xsl:value-of select="$bootstrap-lead-font-size"/></entry>
    <entry name="bootstrap-lead-font-weight"><xsl:value-of select="$bootstrap-lead-font-weight"/></entry>
    
    <!-- PrismJS Decorator -->
    <entry name="prismjs.text.color"><xsl:value-of select="$prismjs.text.color"/></entry>
    <entry name="prismjs.background.color"><xsl:value-of select="$prismjs.background.color"/></entry>
    <entry name="prismjs.border.width"><xsl:value-of select="$prismjs.border.width"/></entry>
  </xsl:variable>

</xsl:stylesheet>
