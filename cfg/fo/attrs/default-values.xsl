<?xml version="1.0" encoding="UTF-8"?>
<!--
	This file is part of the DITA-OT Bootstrap Print Plug-in project.
	See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

  <!-- Core Theme Colors -->
  <xsl:variable name="bootstrap-primary">#0d6efd</xsl:variable>
  <xsl:variable name="bootstrap-secondary">#6c757d</xsl:variable>
  <xsl:variable name="bootstrap-success">#198754</xsl:variable>
  <xsl:variable name="bootstrap-danger">#dc3545</xsl:variable>
  <xsl:variable name="bootstrap-warning">#ffc107</xsl:variable>
  <xsl:variable name="bootstrap-info">#0dcaf0</xsl:variable>
  <xsl:variable name="bootstrap-light">#f8f9fa</xsl:variable>
  <xsl:variable name="bootstrap-dark">#212529</xsl:variable>
  <xsl:variable name="bootstrap-link">#0d6efd</xsl:variable>

  <!-- Subtle Colors -->
  <xsl:variable name="bootstrap-primary-subtle">#e0f2ff</xsl:variable>
  <xsl:variable name="bootstrap-primary-subtle-text">#084298</xsl:variable>
  <xsl:variable name="bootstrap-secondary-subtle">#e2e3e5</xsl:variable>
  <xsl:variable name="bootstrap-secondary-subtle-text">#41464b</xsl:variable>
  <xsl:variable name="bootstrap-success-subtle">#d1e7dd</xsl:variable>
  <xsl:variable name="bootstrap-success-subtle-text">#0f5132</xsl:variable>
  <xsl:variable name="bootstrap-danger-subtle">#f8d7da</xsl:variable>
  <xsl:variable name="bootstrap-danger-subtle-text">#842029</xsl:variable>
  <xsl:variable name="bootstrap-warning-subtle">#fff3cd</xsl:variable>
  <xsl:variable name="bootstrap-warning-subtle-text">#332701</xsl:variable>
  <xsl:variable name="bootstrap-info-subtle">#cff4fc</xsl:variable>
  <xsl:variable name="bootstrap-info-subtle-text">#032830</xsl:variable>
  <xsl:variable name="bootstrap-light-subtle">#fefefe</xsl:variable>
  <xsl:variable name="bootstrap-light-subtle-text">#141619</xsl:variable>
  <xsl:variable name="bootstrap-dark-subtle">#ced4da</xsl:variable>
  <xsl:variable name="bootstrap-dark-subtle-text">#141619</xsl:variable>

  <!-- Component-specific: Tables -->
  <xsl:variable name="bootstrap-table-primary-bg">#cfe2ff</xsl:variable>
  <xsl:variable name="bootstrap-table-primary-color">#052c65</xsl:variable>
  <xsl:variable name="bootstrap-table-secondary-bg">#e2e3e5</xsl:variable>
  <xsl:variable name="bootstrap-table-secondary-color">#41464b</xsl:variable>
  <xsl:variable name="bootstrap-table-success-bg">#d1e7dd</xsl:variable>
  <xsl:variable name="bootstrap-table-success-color">#0f5132</xsl:variable>
  <xsl:variable name="bootstrap-table-info-bg">#cff4fc</xsl:variable>
  <xsl:variable name="bootstrap-table-info-color">#032830</xsl:variable>
  <xsl:variable name="bootstrap-table-warning-bg">#fff3cd</xsl:variable>
  <xsl:variable name="bootstrap-table-warning-color">#332701</xsl:variable>
  <xsl:variable name="bootstrap-table-danger-bg">#f8d7da</xsl:variable>
  <xsl:variable name="bootstrap-table-danger-color">#842029</xsl:variable>
  <xsl:variable name="bootstrap-table-light-bg">#f8f9fa</xsl:variable>
  <xsl:variable name="bootstrap-table-light-color">#212529</xsl:variable>
  <xsl:variable name="bootstrap-table-dark-bg">#212529</xsl:variable>
  <xsl:variable name="bootstrap-table-dark-color">#ffffff</xsl:variable>

  <!-- Component-specific: Buttons -->
  <xsl:variable name="bootstrap-btn-primary-bg">#0d6efd</xsl:variable>
  <xsl:variable name="bootstrap-btn-primary-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-btn-secondary-bg">#6c757d</xsl:variable>
  <xsl:variable name="bootstrap-btn-secondary-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-btn-success-bg">#198754</xsl:variable>
  <xsl:variable name="bootstrap-btn-success-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-btn-info-bg">#0dcaf0</xsl:variable>
  <xsl:variable name="bootstrap-btn-info-color">#000000</xsl:variable>
  <xsl:variable name="bootstrap-btn-warning-bg">#ffc107</xsl:variable>
  <xsl:variable name="bootstrap-btn-warning-color">#000000</xsl:variable>
  <xsl:variable name="bootstrap-btn-danger-bg">#dc3545</xsl:variable>
  <xsl:variable name="bootstrap-btn-danger-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-btn-light-bg">#f8f9fa</xsl:variable>
  <xsl:variable name="bootstrap-btn-light-color">#000000</xsl:variable>
  <xsl:variable name="bootstrap-btn-dark-bg">#212529</xsl:variable>
  <xsl:variable name="bootstrap-btn-dark-color">#ffffff</xsl:variable>

  <!-- Component-specific: Badges -->
  <xsl:variable name="bootstrap-badge-primary-bg">#0d6efd</xsl:variable>
  <xsl:variable name="bootstrap-badge-primary-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-badge-secondary-bg">#6c757d</xsl:variable>
  <xsl:variable name="bootstrap-badge-secondary-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-badge-success-bg">#198754</xsl:variable>
  <xsl:variable name="bootstrap-badge-success-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-badge-info-bg">#0dcaf0</xsl:variable>
  <xsl:variable name="bootstrap-badge-info-color">#000000</xsl:variable>
  <xsl:variable name="bootstrap-badge-warning-bg">#ffc107</xsl:variable>
  <xsl:variable name="bootstrap-badge-warning-color">#000000</xsl:variable>
  <xsl:variable name="bootstrap-badge-danger-bg">#dc3545</xsl:variable>
  <xsl:variable name="bootstrap-badge-danger-color">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-badge-light-bg">#f8f9fa</xsl:variable>
  <xsl:variable name="bootstrap-badge-light-color">#000000</xsl:variable>
  <xsl:variable name="bootstrap-badge-dark-bg">#212529</xsl:variable>
  <xsl:variable name="bootstrap-badge-dark-color">#ffffff</xsl:variable>

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
  <xsl:variable name="bootstrap-border-width">1pt</xsl:variable>

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
  <xsl:variable name="bootstrap-primary-border" select="$bootstrap-primary"/>
  <xsl:variable name="bootstrap-secondary-border" select="$bootstrap-secondary"/>
  <xsl:variable name="bootstrap-success-border" select="$bootstrap-success"/>
  <xsl:variable name="bootstrap-danger-border" select="$bootstrap-danger"/>
  <xsl:variable name="bootstrap-warning-border" select="$bootstrap-warning"/>
  <xsl:variable name="bootstrap-info-border" select="$bootstrap-info"/>
  <xsl:variable name="bootstrap-btn-rounded" select="$bootstrap-rounded"/>
  <xsl:variable
    name="bootstrap-btn-rounded-lg"
    select="if (matches($bootstrap-btn-rounded, '^[0-9.]+pt$')) then concat(number(substring-before($bootstrap-btn-rounded, 'pt')) * 1.5, 'pt') else $bootstrap-btn-rounded"
  />
  <xsl:variable name="bootstrap-card-fill"/>
  <xsl:variable name="bootstrap-surface-image"/>
  <xsl:variable name="bootstrap-surface-image-color"/>
  <xsl:variable name="bootstrap-surface-image-border"/>
  <xsl:variable name="bootstrap-surface-image-text"/>
  <xsl:variable name="bootstrap-accordion-active-bg" select="$bootstrap-primary-subtle"/>
  <xsl:variable name="bootstrap-accordion-active-color" select="$bootstrap-primary-subtle-text"/>
  <xsl:variable name="bootstrap-heading-color" select="$bootstrap-body-color"/>
  <xsl:variable name="bootstrap-heading-font-weight">bold</xsl:variable>
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

  <xsl:variable name="bootstrap-display-1-font-size">60pt</xsl:variable>
  <xsl:variable name="bootstrap-display-2-font-size">52pt</xsl:variable>
  <xsl:variable name="bootstrap-display-3-font-size">44pt</xsl:variable>
  <xsl:variable name="bootstrap-display-4-font-size">36pt</xsl:variable>
  <xsl:variable name="bootstrap-display-5-font-size">28pt</xsl:variable>
  <xsl:variable name="bootstrap-display-6-font-size">24pt</xsl:variable>
  <xsl:variable name="bootstrap-display-font-weight">300</xsl:variable>
  <xsl:variable name="bootstrap-display-line-height">1.2</xsl:variable>

  <xsl:variable name="bootstrap-body-color">#212529</xsl:variable>
  <xsl:variable name="bootstrap-body-bg">#ffffff</xsl:variable>
  <xsl:variable name="bootstrap-table-striped-color">#f2f2f2</xsl:variable>
  <xsl:variable name="bootstrap-lead-font-size">1.25em</xsl:variable>
  <xsl:variable name="bootstrap-lead-font-weight">300</xsl:variable>

  <!-- PrismJS Decorator defaults -->
  <xsl:variable name="prismjs.text.color" select="$bootstrap-body-color"/>
  <xsl:variable name="prismjs.background.color" select="$bootstrap-secondary-subtle"/>
  <xsl:variable name="prismjs.border.width" select="$bootstrap-border-width"/>

</xsl:stylesheet>
