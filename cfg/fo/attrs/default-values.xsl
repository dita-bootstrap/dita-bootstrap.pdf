<?xml version="1.0" encoding="UTF-8"?>
<!--
	This file is part of the DITA-OT Bootstrap Print Plug-in project.
	See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

  <!-- Core Theme Colors -->
  <xsl:variable name="bootstrap-primary">#0087fe</xsl:variable>
  <xsl:variable name="bootstrap-secondary">#636c74</xsl:variable>
  <xsl:variable name="bootstrap-success">#00b15a</xsl:variable>
  <xsl:variable name="bootstrap-danger">#e62845</xsl:variable>
  <xsl:variable name="bootstrap-warning">#ffc900</xsl:variable>
  <xsl:variable name="bootstrap-info">#00b4f8</xsl:variable>
  <xsl:variable name="bootstrap-accent">#7740ff</xsl:variable>
  <xsl:variable name="bootstrap-inverse">#2c2f32</xsl:variable>
  <xsl:variable name="bootstrap-link">#0d6efd</xsl:variable>

  <!-- Subtle Colors -->
  <xsl:variable name="bootstrap-primary-subtle">#dfe5ff</xsl:variable>
  <xsl:variable name="bootstrap-primary-subtle-text">#21457c</xsl:variable>
  <xsl:variable name="bootstrap-secondary-subtle">#f1f2f3</xsl:variable>
  <xsl:variable name="bootstrap-secondary-subtle-text">#3e4347</xsl:variable>
  <xsl:variable name="bootstrap-success-subtle">#d8f0dd</xsl:variable>
  <xsl:variable name="bootstrap-success-subtle-text">#1a5931</xsl:variable>
  <xsl:variable name="bootstrap-danger-subtle">#ffd9d7</xsl:variable>
  <xsl:variable name="bootstrap-danger-subtle-text">#732026</xsl:variable>
  <xsl:variable name="bootstrap-warning-subtle">#fff4d5</xsl:variable>
  <xsl:variable name="bootstrap-warning-subtle-text">#7e6317</xsl:variable>
  <xsl:variable name="bootstrap-info-subtle">#def0fe</xsl:variable>
  <xsl:variable name="bootstrap-info-subtle-text">#215a79</xsl:variable>
  <xsl:variable name="bootstrap-accent-subtle">#ead9ff</xsl:variable>
  <xsl:variable name="bootstrap-accent-subtle-text">#41267c</xsl:variable>
  <xsl:variable name="bootstrap-inverse-subtle">#e3e5e7</xsl:variable>
  <xsl:variable name="bootstrap-inverse-subtle-text">#131415</xsl:variable>

  <!-- Component-specific: Tables -->
  <xsl:variable name="bootstrap-table-primary-bg">#dfe5ff</xsl:variable>
  <xsl:variable name="bootstrap-table-primary-color">#21457c</xsl:variable>
  <xsl:variable name="bootstrap-table-secondary-bg">#f1f2f3</xsl:variable>
  <xsl:variable name="bootstrap-table-secondary-color">#3e4347</xsl:variable>
  <xsl:variable name="bootstrap-table-success-bg">#d8f0dd</xsl:variable>
  <xsl:variable name="bootstrap-table-success-color">#1a5931</xsl:variable>
  <xsl:variable name="bootstrap-table-info-bg">#def0fe</xsl:variable>
  <xsl:variable name="bootstrap-table-info-color">#215a79</xsl:variable>
  <xsl:variable name="bootstrap-table-warning-bg">#fff4d5</xsl:variable>
  <xsl:variable name="bootstrap-table-warning-color">#7e6317</xsl:variable>
  <xsl:variable name="bootstrap-table-danger-bg">#ffd9d7</xsl:variable>
  <xsl:variable name="bootstrap-table-danger-color">#732026</xsl:variable>
  <xsl:variable name="bootstrap-table-accent-bg">#ead9ff</xsl:variable>
  <xsl:variable name="bootstrap-table-accent-color">#41267c</xsl:variable>
  <xsl:variable name="bootstrap-table-inverse-bg">#2c2f32</xsl:variable>
  <xsl:variable name="bootstrap-table-inverse-color">#ffffff</xsl:variable>

  <!-- Component-specific: Buttons -->
  <xsl:variable name="bootstrap-btn-primary-bg">#0087fe</xsl:variable>
  <xsl:variable name="bootstrap-btn-primary-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-btn-secondary-bg">#636c74</xsl:variable>
  <xsl:variable name="bootstrap-btn-secondary-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-btn-success-bg">#00b15a</xsl:variable>
  <xsl:variable name="bootstrap-btn-success-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-btn-info-bg">#00b4f8</xsl:variable>
  <xsl:variable name="bootstrap-btn-info-color">#2c2f32</xsl:variable>
  <xsl:variable name="bootstrap-btn-warning-bg">#ffc900</xsl:variable>
  <xsl:variable name="bootstrap-btn-warning-color">#2c2f32</xsl:variable>
  <xsl:variable name="bootstrap-btn-danger-bg">#e62845</xsl:variable>
  <xsl:variable name="bootstrap-btn-danger-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-btn-accent-bg">#7740ff</xsl:variable>
  <xsl:variable name="bootstrap-btn-accent-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-btn-inverse-bg">#2c2f32</xsl:variable>
  <xsl:variable name="bootstrap-btn-inverse-color">#ffffff</xsl:variable>

  <!-- Component-specific: Badges -->
  <xsl:variable name="bootstrap-badge-primary-bg">#0087fe</xsl:variable>
  <xsl:variable name="bootstrap-badge-primary-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-badge-secondary-bg">#636c74</xsl:variable>
  <xsl:variable name="bootstrap-badge-secondary-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-badge-success-bg">#00b15a</xsl:variable>
  <xsl:variable name="bootstrap-badge-success-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-badge-info-bg">#00b4f8</xsl:variable>
  <xsl:variable name="bootstrap-badge-info-color">#2c2f32</xsl:variable>
  <xsl:variable name="bootstrap-badge-warning-bg">#ffc900</xsl:variable>
  <xsl:variable name="bootstrap-badge-warning-color">#2c2f32</xsl:variable>
  <xsl:variable name="bootstrap-badge-danger-bg">#e62845</xsl:variable>
  <xsl:variable name="bootstrap-badge-danger-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-badge-accent-bg">#7740ff</xsl:variable>
  <xsl:variable name="bootstrap-badge-accent-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-badge-inverse-bg">#2c2f32</xsl:variable>
  <xsl:variable name="bootstrap-badge-inverse-color">#ffffff</xsl:variable>

  <!-- Component-specific: Notes -->
  <xsl:variable name="bootstrap-note-border-width">6pt</xsl:variable>
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

  <xsl:variable name="bootstrap-border-color">#dee2e6</xsl:variable>
  <xsl:variable name="bootstrap-card-border-color" select="$bootstrap-border-color"/>
  <xsl:variable name="bootstrap-border-width">1pt</xsl:variable>
  <xsl:variable name="bootstrap-blockquote-border-width">3pt</xsl:variable>

  <xsl:variable name="bootstrap-rounded">6pt</xsl:variable>
  <xsl:variable name="bootstrap-rounded-0">0</xsl:variable>
  <xsl:variable name="bootstrap-rounded-1">3pt</xsl:variable>
  <xsl:variable name="bootstrap-rounded-2">4pt</xsl:variable>
  <xsl:variable name="bootstrap-rounded-3">5pt</xsl:variable>
  <xsl:variable name="bootstrap-rounded-4">8pt</xsl:variable>
  <xsl:variable name="bootstrap-rounded-5">16pt</xsl:variable>
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

  <xsl:variable name="bootstrap-body-color">#212529</xsl:variable>
  <xsl:variable name="bootstrap-body-bg">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-table-striped-color">#f2f2f2</xsl:variable>
  <xsl:variable name="bootstrap-lead-font-size">1.25em</xsl:variable>
  <xsl:variable name="bootstrap-lead-font-weight">300</xsl:variable>

  <!-- PrismJS Decorator defaults -->
  <xsl:variable name="prismjs.text.color" select="$bootstrap-body-color"/>
  <xsl:variable name="prismjs.background.color" select="$bootstrap-secondary-subtle"/>
  <xsl:variable name="prismjs.border.color" select="$bootstrap-card-border-color"/>
  <xsl:variable name="prismjs.border.width" select="$bootstrap-border-width"/>

</xsl:stylesheet>
