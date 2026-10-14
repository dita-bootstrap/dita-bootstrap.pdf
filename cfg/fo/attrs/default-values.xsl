<?xml version="1.0" encoding="UTF-8"?>
<!--
	This file is part of the DITA Bootstrap PDF plug-in for DITA Open Toolkit.
	See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

  <!-- Core Theme Colors -->
  <xsl:variable name="bootstrap-primary">#0087fe</xsl:variable>
  <xsl:variable name="bootstrap-secondary">#5d666e</xsl:variable>
  <xsl:variable name="bootstrap-success">#00b15a</xsl:variable>
  <xsl:variable name="bootstrap-danger">#e62845</xsl:variable>
  <xsl:variable name="bootstrap-warning">#ffc900</xsl:variable>
  <xsl:variable name="bootstrap-info">#00b4f8</xsl:variable>
  <xsl:variable name="bootstrap-accent">#7740ff</xsl:variable>
  <xsl:variable name="bootstrap-inverse">#171a1d</xsl:variable>
  <xsl:variable name="bootstrap-link">#0087fe</xsl:variable>
  <xsl:variable name="bootstrap-heading-color" select="$bootstrap-body-color"/>
  <xsl:variable name="bootstrap-heading-font-weight">bold</xsl:variable>

  <!-- Theme foreground (text/outline) and border shades -->
  <xsl:variable name="bootstrap-primary-fg">#006ac9</xsl:variable>
  <xsl:variable name="bootstrap-primary-border">#49bcff</xsl:variable>
  <xsl:variable name="bootstrap-secondary-fg">#5d666e</xsl:variable>
  <xsl:variable name="bootstrap-secondary-border">#abb2b8</xsl:variable>
  <xsl:variable name="bootstrap-success-fg">#008c45</xsl:variable>
  <xsl:variable name="bootstrap-success-border">#60d29b</xsl:variable>
  <xsl:variable name="bootstrap-danger-fg">#b61e35</xsl:variable>
  <xsl:variable name="bootstrap-danger-border">#fa8d8e</xsl:variable>
  <xsl:variable name="bootstrap-warning-fg">#df9f00</xsl:variable>
  <xsl:variable name="bootstrap-warning-border">#ffe16b</xsl:variable>
  <xsl:variable name="bootstrap-info-fg">#008ec4</xsl:variable>
  <xsl:variable name="bootstrap-info-border">#42d5fd</xsl:variable>
  <xsl:variable name="bootstrap-accent-fg">#5d31cb</xsl:variable>
  <xsl:variable name="bootstrap-accent-border">#a697ff</xsl:variable>
  <xsl:variable name="bootstrap-inverse-fg">#171a1d</xsl:variable>
  <xsl:variable name="bootstrap-inverse-border">#909aa2</xsl:variable>

  <!-- Subtle Colors -->
  <xsl:variable name="bootstrap-primary-subtle">#c9eaff</xsl:variable>
  <xsl:variable name="bootstrap-primary-subtle-text">#003468</xsl:variable>
  <xsl:variable name="bootstrap-accordion-active-bg" select="$bootstrap-primary-subtle"/>
  <xsl:variable name="bootstrap-accordion-active-color" select="$bootstrap-primary-subtle-text"/>
  <xsl:variable name="bootstrap-secondary-subtle">#f1f2f3</xsl:variable>
  <xsl:variable name="bootstrap-secondary-subtle-text">#2d3136</xsl:variable>
  <xsl:variable name="bootstrap-success-subtle">#cff1dd</xsl:variable>
  <xsl:variable name="bootstrap-success-subtle-text">#004620</xsl:variable>
  <xsl:variable name="bootstrap-danger-subtle">#ffdad8</xsl:variable>
  <xsl:variable name="bootstrap-danger-subtle-text">#5e0a17</xsl:variable>
  <xsl:variable name="bootstrap-warning-subtle">#fff6d3</xsl:variable>
  <xsl:variable name="bootstrap-warning-subtle-text">#745100</xsl:variable>
  <xsl:variable name="bootstrap-info-subtle">#cbf2ff</xsl:variable>
  <xsl:variable name="bootstrap-info-subtle-text">#004865</xsl:variable>
  <xsl:variable name="bootstrap-accent-subtle">#dfddff</xsl:variable>
  <xsl:variable name="bootstrap-accent-subtle-text">#2d1569</xsl:variable>
  <xsl:variable name="bootstrap-inverse-subtle">#e2e5e7</xsl:variable>
  <xsl:variable name="bootstrap-inverse-subtle-text">#080a0c</xsl:variable>

  <!-- Component-specific: Tables -->
  <xsl:variable name="bootstrap-table-primary-bg">#c9eaff</xsl:variable>
  <xsl:variable name="bootstrap-table-primary-color">#003468</xsl:variable>
  <xsl:variable name="bootstrap-table-secondary-bg">#f1f2f3</xsl:variable>
  <xsl:variable name="bootstrap-table-secondary-color">#2d3136</xsl:variable>
  <xsl:variable name="bootstrap-table-success-bg">#cff1dd</xsl:variable>
  <xsl:variable name="bootstrap-table-success-color">#004620</xsl:variable>
  <xsl:variable name="bootstrap-table-info-bg">#cbf2ff</xsl:variable>
  <xsl:variable name="bootstrap-table-info-color">#004865</xsl:variable>
  <xsl:variable name="bootstrap-table-warning-bg">#fff6d3</xsl:variable>
  <xsl:variable name="bootstrap-table-warning-color">#745100</xsl:variable>
  <xsl:variable name="bootstrap-table-danger-bg">#ffdad8</xsl:variable>
  <xsl:variable name="bootstrap-table-danger-color">#5e0a17</xsl:variable>
  <xsl:variable name="bootstrap-table-accent-bg">#dfddff</xsl:variable>
  <xsl:variable name="bootstrap-table-accent-color">#2d1569</xsl:variable>
  <xsl:variable name="bootstrap-table-inverse-bg">#171a1d</xsl:variable>
  <xsl:variable name="bootstrap-table-inverse-color">#ffffff</xsl:variable>

  <!-- Component-specific: Buttons -->
  <xsl:variable name="bootstrap-btn-primary-bg">#0087fe</xsl:variable>
  <xsl:variable name="bootstrap-btn-primary-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-btn-secondary-bg">#e2e5e7</xsl:variable>
  <xsl:variable name="bootstrap-btn-secondary-color">#171a1d</xsl:variable>
  <xsl:variable name="bootstrap-btn-success-bg">#00b15a</xsl:variable>
  <xsl:variable name="bootstrap-btn-success-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-btn-info-bg">#00b4f8</xsl:variable>
  <xsl:variable name="bootstrap-btn-info-color">#171a1d</xsl:variable>
  <xsl:variable name="bootstrap-btn-warning-bg">#ffc900</xsl:variable>
  <xsl:variable name="bootstrap-btn-warning-color">#171a1d</xsl:variable>
  <xsl:variable name="bootstrap-btn-danger-bg">#e62845</xsl:variable>
  <xsl:variable name="bootstrap-btn-danger-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-btn-accent-bg">#7740ff</xsl:variable>
  <xsl:variable name="bootstrap-btn-accent-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-btn-inverse-bg">#171a1d</xsl:variable>
  <xsl:variable name="bootstrap-btn-inverse-color">#ffffff</xsl:variable>

  <!-- Component-specific: Badges -->
  <xsl:variable name="bootstrap-badge-default-bg">#f1f2f3</xsl:variable>
  <xsl:variable name="bootstrap-badge-primary-bg">#0087fe</xsl:variable>
  <xsl:variable name="bootstrap-badge-primary-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-badge-secondary-bg">#e2e5e7</xsl:variable>
  <xsl:variable name="bootstrap-badge-secondary-color">#171a1d</xsl:variable>
  <xsl:variable name="bootstrap-badge-success-bg">#00b15a</xsl:variable>
  <xsl:variable name="bootstrap-badge-success-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-badge-info-bg">#00b4f8</xsl:variable>
  <xsl:variable name="bootstrap-badge-info-color">#171a1d</xsl:variable>
  <xsl:variable name="bootstrap-badge-warning-bg">#ffc900</xsl:variable>
  <xsl:variable name="bootstrap-badge-warning-color">#171a1d</xsl:variable>
  <xsl:variable name="bootstrap-badge-danger-bg">#e62845</xsl:variable>
  <xsl:variable name="bootstrap-badge-danger-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-badge-accent-bg">#7740ff</xsl:variable>
  <xsl:variable name="bootstrap-badge-accent-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-badge-inverse-bg">#171a1d</xsl:variable>
  <xsl:variable name="bootstrap-badge-inverse-color">#ffffff</xsl:variable>

  <!-- Component-specific: Notes -->
  <xsl:variable name="bootstrap-note-border-width">6pt</xsl:variable>
  <xsl:variable name="bootstrap-alert-solid" select="false()"/>
  <xsl:variable name="bootstrap-surface-image"/>
  <xsl:variable name="bootstrap-surface-image-color"/>
  <xsl:variable name="bootstrap-surface-image-border"/>
  <xsl:variable name="bootstrap-surface-image-text"/>
  <xsl:variable name="bootstrap-surface-image-bar-factor" select="1"/>
  <xsl:variable name="bootstrap-surface-bg"/>
  <xsl:variable name="bootstrap-surface-header-bg"/>
  <xsl:variable name="bootstrap-surface-text"/>
  <xsl:variable name="bootstrap-surface-heading-color"/>
  <xsl:variable name="bootstrap-glow-color"/>
  <xsl:variable name="bootstrap-glow-scope">all</xsl:variable>
  <xsl:variable name="bootstrap-surface-code-color"/>
  <xsl:variable name="bootstrap-surface-xml-color"/>
  <xsl:variable name="bootstrap-surface-cmd-color"/>
  <xsl:variable name="bootstrap-surface-border"/>
  <xsl:variable name="bootstrap-surface-primary-bg"/>
  <xsl:variable name="bootstrap-surface-primary-color"/>
  <xsl:variable name="bootstrap-surface-secondary-bg"/>
  <xsl:variable name="bootstrap-surface-secondary-color"/>
  <xsl:variable name="bootstrap-surface-success-bg"/>
  <xsl:variable name="bootstrap-surface-success-color"/>
  <xsl:variable name="bootstrap-surface-info-bg"/>
  <xsl:variable name="bootstrap-surface-info-color"/>
  <xsl:variable name="bootstrap-surface-warning-bg"/>
  <xsl:variable name="bootstrap-surface-warning-color"/>
  <xsl:variable name="bootstrap-surface-danger-bg"/>
  <xsl:variable name="bootstrap-surface-danger-color"/>
  <xsl:variable name="bootstrap-surface-accent-bg"/>
  <xsl:variable name="bootstrap-surface-accent-color"/>
  <xsl:variable name="bootstrap-surface-inverse-bg"/>
  <xsl:variable name="bootstrap-surface-inverse-color"/>

  <xsl:variable name="bootstrap-alert-link-font-weight">bold</xsl:variable>
  <xsl:variable name="bootstrap-link-text-decoration">none</xsl:variable>
  <xsl:variable name="bootstrap-alert-link-text-decoration">underline</xsl:variable>

  <!-- Utilities -->
  <xsl:variable name="bootstrap-spacing-0">0</xsl:variable>
  <xsl:variable name="bootstrap-spacing-1">3pt</xsl:variable>
  <xsl:variable name="bootstrap-spacing-2">6pt</xsl:variable>
  <xsl:variable name="bootstrap-spacing-3">12pt</xsl:variable>
  <xsl:variable name="bootstrap-spacing-4">18pt</xsl:variable>
  <xsl:variable name="bootstrap-spacing-5">36pt</xsl:variable>
  <xsl:variable name="bootstrap-spacing-6">15pt</xsl:variable>
  <xsl:variable name="bootstrap-spacing-7">18pt</xsl:variable>
  <xsl:variable name="bootstrap-spacing-8">21pt</xsl:variable>
  <xsl:variable name="bootstrap-spacing-9">24pt</xsl:variable>
  <xsl:variable name="bootstrap-spacing-10">27pt</xsl:variable>
  <xsl:variable name="bootstrap-spacing-11">30pt</xsl:variable>
  <xsl:variable name="bootstrap-spacing-12">36pt</xsl:variable>

  <xsl:variable name="bootstrap-border-color">#c6cbcf</xsl:variable>
  <xsl:variable name="bootstrap-card-border-color" select="$bootstrap-border-color"/>
  <xsl:variable name="bootstrap-card-background-color" select="$bootstrap-secondary-subtle"/>
  <xsl:variable name="bootstrap-card-fill"/>
  <xsl:variable name="bootstrap-border-width">1pt</xsl:variable>
  <xsl:variable name="bootstrap-blockquote-border-width">3pt</xsl:variable>

  <xsl:variable name="bootstrap-rounded">6pt</xsl:variable>
  <xsl:variable name="bootstrap-btn-rounded" select="$bootstrap-rounded"/>
  <xsl:variable
    name="bootstrap-btn-rounded-lg"
    select="if (matches($bootstrap-btn-rounded, '^[0-9.]+pt$')) then concat(number(substring-before($bootstrap-btn-rounded, 'pt')) * 1.5, 'pt') else $bootstrap-btn-rounded"
  />
  <xsl:variable name="bootstrap-rounded-0">0</xsl:variable>
  <xsl:variable name="bootstrap-rounded-1">1.5pt</xsl:variable>
  <xsl:variable name="bootstrap-rounded-2">2.25pt</xsl:variable>
  <xsl:variable name="bootstrap-rounded-3">3pt</xsl:variable>
  <xsl:variable name="bootstrap-rounded-4">4.5pt</xsl:variable>
  <xsl:variable name="bootstrap-rounded-5">6pt</xsl:variable>
  <xsl:variable name="bootstrap-rounded-6">7.5pt</xsl:variable>
  <xsl:variable name="bootstrap-rounded-7">9pt</xsl:variable>
  <xsl:variable name="bootstrap-rounded-8">10.5pt</xsl:variable>
  <xsl:variable name="bootstrap-rounded-9">12pt</xsl:variable>
  <xsl:variable name="bootstrap-rounded-circle">50%</xsl:variable>
  <xsl:variable name="bootstrap-rounded-pill">100pt</xsl:variable>

  <!-- Typography -->
  <xsl:variable name="bootstrap-code-color">#d63384</xsl:variable>
  <xsl:variable name="bootstrap-dita-prussian-blue" select="$bootstrap-primary-subtle-text"/>
  <xsl:variable name="bootstrap-dita-maroon">#800000</xsl:variable>
  <xsl:variable name="bootstrap-dita-violet">#6f42c1</xsl:variable>
  <xsl:variable name="bootstrap-h1-font-size">28pt</xsl:variable>
  <xsl:variable name="bootstrap-h1-margin-top">12pt</xsl:variable>
  <xsl:variable name="bootstrap-h1-margin-bottom">6pt</xsl:variable>
  <xsl:variable name="bootstrap-h2-font-size">24pt</xsl:variable>
  <xsl:variable name="bootstrap-h2-margin-top">10pt</xsl:variable>
  <xsl:variable name="bootstrap-h2-margin-bottom">5pt</xsl:variable>
  <xsl:variable name="bootstrap-h3-font-size">18pt</xsl:variable>
  <xsl:variable name="bootstrap-h3-margin-top">10pt</xsl:variable>
  <xsl:variable name="bootstrap-h3-margin-bottom">5pt</xsl:variable>
  <xsl:variable name="bootstrap-h4-font-size">14pt</xsl:variable>
  <xsl:variable name="bootstrap-h4-margin-top">8pt</xsl:variable>
  <xsl:variable name="bootstrap-h4-margin-bottom">4pt</xsl:variable>
  <xsl:variable name="bootstrap-h5-font-size">12pt</xsl:variable>
  <xsl:variable name="bootstrap-h5-margin-top">8pt</xsl:variable>
  <xsl:variable name="bootstrap-h5-margin-bottom">4pt</xsl:variable>
  <xsl:variable name="bootstrap-h6-font-size">10pt</xsl:variable>
  <xsl:variable name="bootstrap-h6-margin-top">6pt</xsl:variable>
  <xsl:variable name="bootstrap-h6-margin-bottom">3pt</xsl:variable>

  <xsl:variable name="bootstrap-fs-xs">9pt</xsl:variable>
  <xsl:variable name="bootstrap-fs-sm">10.5pt</xsl:variable>
  <xsl:variable name="bootstrap-fs-base">12pt</xsl:variable>
  <xsl:variable name="bootstrap-fs-md" select="$bootstrap-fs-base"/>
  <xsl:variable name="bootstrap-fs-lg">15pt</xsl:variable>
  <xsl:variable name="bootstrap-fs-xl">20.4pt</xsl:variable>
  <xsl:variable name="bootstrap-fs-2xl">24pt</xsl:variable>
  <xsl:variable name="bootstrap-fs-3xl">30pt</xsl:variable>
  <xsl:variable name="bootstrap-fs-4xl">36pt</xsl:variable>
  <xsl:variable name="bootstrap-fs-5xl">48pt</xsl:variable>
  <xsl:variable name="bootstrap-fs-6xl">60pt</xsl:variable>

  <xsl:variable name="bootstrap-body-color">#171a1d</xsl:variable>
  <xsl:variable name="bootstrap-body-bg">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-table-striped-color">#f2f2f2</xsl:variable>
  <xsl:variable name="bootstrap-lead-font-size">1.25em</xsl:variable>
  <xsl:variable name="bootstrap-lead-font-weight">300</xsl:variable>

  <!-- PrismJS Decorator defaults -->
  <xsl:variable name="prismjs.text.color" select="$bootstrap-body-color"/>
  <xsl:variable name="prismjs.background.color" select="$bootstrap-card-background-color"/>
  <xsl:variable name="prismjs.border.color" select="$bootstrap-card-border-color"/>
  <xsl:variable name="prismjs.border.width" select="$bootstrap-border-width"/>
  <xsl:variable name="prismjs.card.background.color" select="$bootstrap-card-background-color"/>

</xsl:stylesheet>
