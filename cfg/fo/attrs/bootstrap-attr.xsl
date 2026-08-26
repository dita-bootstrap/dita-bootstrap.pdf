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

  <xsl:import href="default-values.xsl"/>
  <xsl:import href="settings-map.xsl"/>

  <xsl:template name="get-context-theme-color">
    <xsl:variable name="rawTheme">
      <xsl:choose>
        <xsl:when test="ancestor::*[contains(@class, ' topic/note ')]/@theme">
          <xsl:value-of select="ancestor::*[contains(@class, ' topic/note ')][1]/@theme"/>
        </xsl:when>
        <xsl:when test="ancestor::*[contains(@class, ' topic/note ')]">
          <xsl:variable name="type" select="(ancestor::*[contains(@class, ' topic/note ')][1]/@type, 'note')[1]"/>
          <xsl:choose>
            <xsl:when test="$type = 'note' or $type = 'notice' or $type = 'remember'">info</xsl:when>
            <xsl:when test="$type = 'tip' or $type = 'fastpath'">success</xsl:when>
            <xsl:when test="$type = 'important'">primary</xsl:when>
            <xsl:when
              test="$type = 'warning' or $type = 'caution' or $type = 'restriction' or $type = 'trouble'"
            >warning</xsl:when>
            <xsl:when test="$type = 'danger'">danger</xsl:when>
            <xsl:otherwise>secondary</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="ancestor::*[contains(@class, ' bootstrap-d/alert ') or tokenize(@outputclass, ' ') = 'alert']">
          <xsl:variable
            name="node"
            select="ancestor::*[contains(@class, ' bootstrap-d/alert ') or tokenize(@outputclass, ' ') = 'alert'][1]"
          />
          <xsl:value-of
            select="($node/@theme, substring-after(tokenize($node/@outputclass, ' ')[starts-with(., 'alert-')][1], 'alert-'), 'secondary')[1]"
          />
        </xsl:when>
        <xsl:when
          test="ancestor::*[contains(@class, ' bootstrap-d/card ') or tokenize(@outputclass, ' ') = 'card']"
        ><xsl:value-of
            select="ancestor::*[contains(@class, ' bootstrap-d/card ') or tokenize(@outputclass, ' ') = 'card'][1]/@theme"
          /></xsl:when>
        <xsl:when
          test="ancestor::*[contains(@class, ' topic/section ') or contains(@class, ' topic/div ') or contains(@class, ' topic/bodydiv ')]"
        ><xsl:value-of
            select="ancestor::*[contains(@class, ' topic/section ') or contains(@class, ' topic/div ') or contains(@class, ' topic/bodydiv ')][1]/@theme"
          /></xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="if (contains($rawTheme, '-')) then substring-before($rawTheme, '-') else $rawTheme"/>
  </xsl:template>

  <!-- Standard Bootstrap Text Colors -->
  <xsl:attribute-set name="__color__primary">
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-primary"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__color__secondary">
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-secondary"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__color__success">
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-success"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__color__danger">
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-danger"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__color__warning">
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-warning"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__color__info">
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-info"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__color__accent">
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-accent"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__color__inverse">
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-inverse"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="common.link">
    <xsl:attribute name="color">
      <xsl:choose>
        <xsl:when test="@theme and local-name() = 'xref'">
          <xsl:variable
            name="baseColor"
            select="if (contains(@theme, '-')) then substring-before(@theme, '-') else @theme"
          />
          <xsl:variable name="explicitVar" select="concat('bootstrap-', $baseColor)"/>
          <xsl:choose>
            <xsl:when test="$bootstrap-settings/entry[@name = $explicitVar]">
              <xsl:value-of select="$bootstrap-settings/entry[@name = $explicitVar]"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$baseColor"/></xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="theme"><xsl:call-template name="get-context-theme-color"/></xsl:variable>
          <xsl:choose>
            <xsl:when test="$theme != ''">
              <xsl:variable name="subtleVar" select="concat('bootstrap-', $theme, '-subtle-text')"/>
              <xsl:value-of select="$bootstrap-settings/entry[@name = $subtleVar]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$bootstrap-link"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="text-decoration">
      <xsl:choose>
        <xsl:when test="@theme and local-name() = 'xref'"><xsl:value-of
            select="$bootstrap-alert-link-text-decoration"
          /></xsl:when>
        <xsl:otherwise>
          <xsl:variable name="theme"><xsl:call-template name="get-context-theme-color"/></xsl:variable>
          <xsl:choose>
            <xsl:when test="$theme != ''"><xsl:value-of select="$bootstrap-alert-link-text-decoration"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="$bootstrap-link-text-decoration"/></xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="font-weight">
      <xsl:choose>
        <xsl:when
          test="ancestor::*[contains(@class, ' topic/note ')] or ancestor::*[contains(@class, ' bootstrap-d/alert ') or tokenize(@outputclass, ' ') = 'alert']"
        ><xsl:value-of select="$bootstrap-alert-link-font-weight"/></xsl:when>
        <xsl:otherwise>inherit</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>

  <!-- Standard Bootstrap Background Colors -->
  <xsl:attribute-set name="__bg__primary">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-primary"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-btn-primary-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__bg__secondary">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-secondary"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-btn-secondary-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__bg__success">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-success"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-btn-success-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__bg__danger">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-danger"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-btn-danger-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__bg__warning">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-warning"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-btn-warning-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__bg__info">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-info"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-btn-info-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__bg__accent">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-accent"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-btn-accent-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__bg__inverse">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-inverse"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-btn-inverse-color"/></xsl:attribute>
  </xsl:attribute-set>
  <!-- Subtle Background Colors (for Alerts, Callouts, etc.) -->
  <xsl:attribute-set name="__bg__primary-subtle">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-primary-subtle"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-primary-subtle-text"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__bg__secondary-subtle">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-secondary-subtle"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-secondary-subtle-text"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__bg__success-subtle">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-success-subtle"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-success-subtle-text"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__bg__danger-subtle">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-danger-subtle"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-danger-subtle-text"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__bg__warning-subtle">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-warning-subtle"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-warning-subtle-text"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__bg__info-subtle">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-info-subtle"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-info-subtle-text"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__bg__accent-subtle">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-accent-subtle"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-accent-subtle-text"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__bg__inverse-subtle">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-inverse-subtle"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-inverse-subtle-text"/></xsl:attribute>
  </xsl:attribute-set>

  <!-- Muted: subtle background paired with the plain theme color, since PDF has no muted tokens of its own -->
  <xsl:attribute-set name="__muted__primary">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-primary-subtle"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-primary"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__muted__secondary">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-secondary-subtle"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-secondary"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__muted__success">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-success-subtle"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-success"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__muted__danger">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-danger-subtle"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-danger"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__muted__warning">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-warning-subtle"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-warning"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__muted__info">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-info-subtle"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-info"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__muted__accent">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-accent-subtle"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-accent"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__muted__inverse">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-inverse-subtle"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-inverse"/></xsl:attribute>
  </xsl:attribute-set>

  <!-- Component-Specific Backgrounds: Tables -->
  <xsl:attribute-set name="__table__primary">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-table-primary-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-table-primary-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__table__secondary">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-table-secondary-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-table-secondary-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__table__success">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-table-success-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-table-success-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__table__info">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-table-info-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-table-info-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__table__warning">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-table-warning-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-table-warning-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__table__danger">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-table-danger-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-table-danger-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__table__accent">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-table-accent-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-table-accent-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__table__inverse">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-table-inverse-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-table-inverse-color"/></xsl:attribute>
  </xsl:attribute-set>

  <!-- Component-Specific Backgrounds: Buttons -->
  <xsl:attribute-set name="__btn__primary">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-btn-primary-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-btn-primary-color"/></xsl:attribute>
    <xsl:attribute name="border-color"><xsl:value-of select="$bootstrap-btn-primary-bg"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__btn__secondary">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-btn-secondary-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-btn-secondary-color"/></xsl:attribute>
    <xsl:attribute name="border-color"><xsl:value-of select="$bootstrap-btn-secondary-bg"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__btn__success">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-btn-success-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-btn-success-color"/></xsl:attribute>
    <xsl:attribute name="border-color"><xsl:value-of select="$bootstrap-btn-success-bg"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__btn__info">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-btn-info-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-btn-info-color"/></xsl:attribute>
    <xsl:attribute name="border-color"><xsl:value-of select="$bootstrap-btn-info-bg"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__btn__warning">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-btn-warning-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-btn-warning-color"/></xsl:attribute>
    <xsl:attribute name="border-color"><xsl:value-of select="$bootstrap-btn-warning-bg"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__btn__danger">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-btn-danger-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-btn-danger-color"/></xsl:attribute>
    <xsl:attribute name="border-color"><xsl:value-of select="$bootstrap-btn-danger-bg"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__btn__accent">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-btn-accent-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-btn-accent-color"/></xsl:attribute>
    <xsl:attribute name="border-color"><xsl:value-of select="$bootstrap-btn-accent-bg"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__btn__inverse">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-btn-inverse-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-btn-inverse-color"/></xsl:attribute>
    <xsl:attribute name="border-color"><xsl:value-of select="$bootstrap-btn-inverse-bg"/></xsl:attribute>
  </xsl:attribute-set>

  <!-- Component-Specific Backgrounds: Badges -->
  <xsl:attribute-set name="__badge__primary">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-badge-primary-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-badge-primary-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__badge__secondary">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-badge-secondary-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-badge-secondary-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__badge__success">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-badge-success-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-badge-success-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__badge__info">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-badge-info-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-badge-info-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__badge__warning">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-badge-warning-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-badge-warning-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__badge__danger">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-badge-danger-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-badge-danger-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__badge__accent">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-badge-accent-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-badge-accent-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__badge__inverse">
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-badge-inverse-bg"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-badge-inverse-color"/></xsl:attribute>
  </xsl:attribute-set>

  <!-- Standard Bootstrap Spacing (Padding) -->
  <xsl:attribute-set name="p-0"><xsl:attribute name="padding"><xsl:value-of
        select="$bootstrap-spacing-0"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="p-1"><xsl:attribute name="padding"><xsl:value-of
        select="$bootstrap-spacing-1"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="p-2"><xsl:attribute name="padding"><xsl:value-of
        select="$bootstrap-spacing-2"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="p-3"><xsl:attribute name="padding"><xsl:value-of
        select="$bootstrap-spacing-3"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="p-4"><xsl:attribute name="padding"><xsl:value-of
        select="$bootstrap-spacing-4"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="p-5"><xsl:attribute name="padding"><xsl:value-of
        select="$bootstrap-spacing-5"
      /></xsl:attribute></xsl:attribute-set>

  <xsl:attribute-set name="pt-0"><xsl:attribute name="padding-top"><xsl:value-of
        select="$bootstrap-spacing-0"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="pt-1"><xsl:attribute name="padding-top"><xsl:value-of
        select="$bootstrap-spacing-1"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="pt-2"><xsl:attribute name="padding-top"><xsl:value-of
        select="$bootstrap-spacing-2"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="pt-3"><xsl:attribute name="padding-top"><xsl:value-of
        select="$bootstrap-spacing-3"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="pt-4"><xsl:attribute name="padding-top"><xsl:value-of
        select="$bootstrap-spacing-4"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="pt-5"><xsl:attribute name="padding-top"><xsl:value-of
        select="$bootstrap-spacing-5"
      /></xsl:attribute></xsl:attribute-set>

  <xsl:attribute-set name="pb-0"><xsl:attribute name="padding-bottom"><xsl:value-of
        select="$bootstrap-spacing-0"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="pb-1"><xsl:attribute name="padding-bottom"><xsl:value-of
        select="$bootstrap-spacing-1"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="pb-2"><xsl:attribute name="padding-bottom"><xsl:value-of
        select="$bootstrap-spacing-2"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="pb-3"><xsl:attribute name="padding-bottom"><xsl:value-of
        select="$bootstrap-spacing-3"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="pb-4"><xsl:attribute name="padding-bottom"><xsl:value-of
        select="$bootstrap-spacing-4"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="pb-5"><xsl:attribute name="padding-bottom"><xsl:value-of
        select="$bootstrap-spacing-5"
      /></xsl:attribute></xsl:attribute-set>

  <xsl:attribute-set name="ps-0"><xsl:attribute name="padding-left"><xsl:value-of
        select="$bootstrap-spacing-0"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="ps-1"><xsl:attribute name="padding-left"><xsl:value-of
        select="$bootstrap-spacing-1"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="ps-2"><xsl:attribute name="padding-left"><xsl:value-of
        select="$bootstrap-spacing-2"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="ps-3"><xsl:attribute name="padding-left"><xsl:value-of
        select="$bootstrap-spacing-3"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="ps-4"><xsl:attribute name="padding-left"><xsl:value-of
        select="$bootstrap-spacing-4"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="ps-5"><xsl:attribute name="padding-left"><xsl:value-of
        select="$bootstrap-spacing-5"
      /></xsl:attribute></xsl:attribute-set>

  <xsl:attribute-set name="pe-0"><xsl:attribute name="padding-right"><xsl:value-of
        select="$bootstrap-spacing-0"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="pe-1"><xsl:attribute name="padding-right"><xsl:value-of
        select="$bootstrap-spacing-1"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="pe-2"><xsl:attribute name="padding-right"><xsl:value-of
        select="$bootstrap-spacing-2"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="pe-3"><xsl:attribute name="padding-right"><xsl:value-of
        select="$bootstrap-spacing-3"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="pe-4"><xsl:attribute name="padding-right"><xsl:value-of
        select="$bootstrap-spacing-4"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="pe-5"><xsl:attribute name="padding-right"><xsl:value-of
        select="$bootstrap-spacing-5"
      /></xsl:attribute></xsl:attribute-set>

  <xsl:attribute-set name="px-0"><xsl:attribute name="padding-left"><xsl:value-of
        select="$bootstrap-spacing-0"
      /></xsl:attribute><xsl:attribute name="padding-right"><xsl:value-of
        select="$bootstrap-spacing-0"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="px-1"><xsl:attribute name="padding-left"><xsl:value-of
        select="$bootstrap-spacing-1"
      /></xsl:attribute><xsl:attribute name="padding-right"><xsl:value-of
        select="$bootstrap-spacing-1"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="px-2"><xsl:attribute name="padding-left"><xsl:value-of
        select="$bootstrap-spacing-2"
      /></xsl:attribute><xsl:attribute name="padding-right"><xsl:value-of
        select="$bootstrap-spacing-2"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="px-3"><xsl:attribute name="padding-left"><xsl:value-of
        select="$bootstrap-spacing-3"
      /></xsl:attribute><xsl:attribute name="padding-right"><xsl:value-of
        select="$bootstrap-spacing-3"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="px-4"><xsl:attribute name="padding-left"><xsl:value-of
        select="$bootstrap-spacing-4"
      /></xsl:attribute><xsl:attribute name="padding-right"><xsl:value-of
        select="$bootstrap-spacing-4"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="px-5"><xsl:attribute name="padding-left"><xsl:value-of
        select="$bootstrap-spacing-5"
      /></xsl:attribute><xsl:attribute name="padding-right"><xsl:value-of
        select="$bootstrap-spacing-5"
      /></xsl:attribute></xsl:attribute-set>

  <xsl:attribute-set name="py-0"><xsl:attribute name="padding-top"><xsl:value-of
        select="$bootstrap-spacing-0"
      /></xsl:attribute><xsl:attribute name="padding-bottom"><xsl:value-of
        select="$bootstrap-spacing-0"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="py-1"><xsl:attribute name="padding-top"><xsl:value-of
        select="$bootstrap-spacing-1"
      /></xsl:attribute><xsl:attribute name="padding-bottom"><xsl:value-of
        select="$bootstrap-spacing-1"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="py-2"><xsl:attribute name="padding-top"><xsl:value-of
        select="$bootstrap-spacing-2"
      /></xsl:attribute><xsl:attribute name="padding-bottom"><xsl:value-of
        select="$bootstrap-spacing-2"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="py-3"><xsl:attribute name="padding-top"><xsl:value-of
        select="$bootstrap-spacing-3"
      /></xsl:attribute><xsl:attribute name="padding-bottom"><xsl:value-of
        select="$bootstrap-spacing-3"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="py-4"><xsl:attribute name="padding-top"><xsl:value-of
        select="$bootstrap-spacing-4"
      /></xsl:attribute><xsl:attribute name="padding-bottom"><xsl:value-of
        select="$bootstrap-spacing-4"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="py-5"><xsl:attribute name="padding-top"><xsl:value-of
        select="$bootstrap-spacing-5"
      /></xsl:attribute><xsl:attribute name="padding-bottom"><xsl:value-of
        select="$bootstrap-spacing-5"
      /></xsl:attribute></xsl:attribute-set>

  <!-- Standard Bootstrap Spacing (Margin) -->
  <xsl:attribute-set name="m-0"><xsl:attribute name="margin"><xsl:value-of
        select="$bootstrap-spacing-0"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="m-1"><xsl:attribute name="margin"><xsl:value-of
        select="$bootstrap-spacing-1"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="m-2"><xsl:attribute name="margin"><xsl:value-of
        select="$bootstrap-spacing-2"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="m-3"><xsl:attribute name="margin"><xsl:value-of
        select="$bootstrap-spacing-3"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="m-4"><xsl:attribute name="margin"><xsl:value-of
        select="$bootstrap-spacing-4"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="m-5"><xsl:attribute name="margin"><xsl:value-of
        select="$bootstrap-spacing-5"
      /></xsl:attribute></xsl:attribute-set>

  <xsl:attribute-set name="mt-0"><xsl:attribute name="margin-top"><xsl:value-of
        select="$bootstrap-spacing-0"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="mt-1"><xsl:attribute name="margin-top"><xsl:value-of
        select="$bootstrap-spacing-1"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="mt-2"><xsl:attribute name="margin-top"><xsl:value-of
        select="$bootstrap-spacing-2"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="mt-3"><xsl:attribute name="margin-top"><xsl:value-of
        select="$bootstrap-spacing-3"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="mt-4"><xsl:attribute name="margin-top"><xsl:value-of
        select="$bootstrap-spacing-4"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="mt-5"><xsl:attribute name="margin-top"><xsl:value-of
        select="$bootstrap-spacing-5"
      /></xsl:attribute></xsl:attribute-set>

  <xsl:attribute-set name="mb-0"><xsl:attribute name="margin-bottom"><xsl:value-of
        select="$bootstrap-spacing-0"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="mb-1"><xsl:attribute name="margin-bottom"><xsl:value-of
        select="$bootstrap-spacing-1"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="mb-2"><xsl:attribute name="margin-bottom"><xsl:value-of
        select="$bootstrap-spacing-2"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="mb-3"><xsl:attribute name="margin-bottom"><xsl:value-of
        select="$bootstrap-spacing-3"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="mb-4"><xsl:attribute name="margin-bottom"><xsl:value-of
        select="$bootstrap-spacing-4"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="mb-5"><xsl:attribute name="margin-bottom"><xsl:value-of
        select="$bootstrap-spacing-5"
      /></xsl:attribute></xsl:attribute-set>

  <xsl:attribute-set name="ms-0"><xsl:attribute name="margin-left"><xsl:value-of
        select="$bootstrap-spacing-0"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="ms-1"><xsl:attribute name="margin-left"><xsl:value-of
        select="$bootstrap-spacing-1"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="ms-2"><xsl:attribute name="margin-left"><xsl:value-of
        select="$bootstrap-spacing-2"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="ms-3"><xsl:attribute name="margin-left"><xsl:value-of
        select="$bootstrap-spacing-3"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="ms-4"><xsl:attribute name="margin-left"><xsl:value-of
        select="$bootstrap-spacing-4"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="ms-5"><xsl:attribute name="margin-left"><xsl:value-of
        select="$bootstrap-spacing-5"
      /></xsl:attribute></xsl:attribute-set>

  <xsl:attribute-set name="me-0"><xsl:attribute name="margin-right"><xsl:value-of
        select="$bootstrap-spacing-0"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="me-1"><xsl:attribute name="margin-right"><xsl:value-of
        select="$bootstrap-spacing-1"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="me-2"><xsl:attribute name="margin-right"><xsl:value-of
        select="$bootstrap-spacing-2"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="me-3"><xsl:attribute name="margin-right"><xsl:value-of
        select="$bootstrap-spacing-3"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="me-4"><xsl:attribute name="margin-right"><xsl:value-of
        select="$bootstrap-spacing-4"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="me-5"><xsl:attribute name="margin-right"><xsl:value-of
        select="$bootstrap-spacing-5"
      /></xsl:attribute></xsl:attribute-set>

  <xsl:attribute-set name="mx-0"><xsl:attribute name="margin-left"><xsl:value-of
        select="$bootstrap-spacing-0"
      /></xsl:attribute><xsl:attribute name="margin-right"><xsl:value-of
        select="$bootstrap-spacing-0"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="mx-1"><xsl:attribute name="margin-left"><xsl:value-of
        select="$bootstrap-spacing-1"
      /></xsl:attribute><xsl:attribute name="margin-right"><xsl:value-of
        select="$bootstrap-spacing-1"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="mx-2"><xsl:attribute name="margin-left"><xsl:value-of
        select="$bootstrap-spacing-2"
      /></xsl:attribute><xsl:attribute name="margin-right"><xsl:value-of
        select="$bootstrap-spacing-2"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="mx-3"><xsl:attribute name="margin-left"><xsl:value-of
        select="$bootstrap-spacing-3"
      /></xsl:attribute><xsl:attribute name="margin-right"><xsl:value-of
        select="$bootstrap-spacing-3"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="mx-4"><xsl:attribute name="margin-left"><xsl:value-of
        select="$bootstrap-spacing-4"
      /></xsl:attribute><xsl:attribute name="margin-right"><xsl:value-of
        select="$bootstrap-spacing-4"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="mx-5"><xsl:attribute name="margin-left"><xsl:value-of
        select="$bootstrap-spacing-5"
      /></xsl:attribute><xsl:attribute name="margin-right"><xsl:value-of
        select="$bootstrap-spacing-5"
      /></xsl:attribute></xsl:attribute-set>

  <xsl:attribute-set name="my-0"><xsl:attribute name="margin-top"><xsl:value-of
        select="$bootstrap-spacing-0"
      /></xsl:attribute><xsl:attribute name="margin-bottom"><xsl:value-of
        select="$bootstrap-spacing-0"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="my-1"><xsl:attribute name="margin-top"><xsl:value-of
        select="$bootstrap-spacing-1"
      /></xsl:attribute><xsl:attribute name="margin-bottom"><xsl:value-of
        select="$bootstrap-spacing-1"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="my-2"><xsl:attribute name="margin-top"><xsl:value-of
        select="$bootstrap-spacing-2"
      /></xsl:attribute><xsl:attribute name="margin-bottom"><xsl:value-of
        select="$bootstrap-spacing-2"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="my-3"><xsl:attribute name="margin-top"><xsl:value-of
        select="$bootstrap-spacing-3"
      /></xsl:attribute><xsl:attribute name="margin-bottom"><xsl:value-of
        select="$bootstrap-spacing-3"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="my-4"><xsl:attribute name="margin-top"><xsl:value-of
        select="$bootstrap-spacing-4"
      /></xsl:attribute><xsl:attribute name="margin-bottom"><xsl:value-of
        select="$bootstrap-spacing-4"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="my-5"><xsl:attribute name="margin-top"><xsl:value-of
        select="$bootstrap-spacing-5"
      /></xsl:attribute><xsl:attribute name="margin-bottom"><xsl:value-of
        select="$bootstrap-spacing-5"
      /></xsl:attribute></xsl:attribute-set>

  <xsl:attribute-set name="m-auto"><xsl:attribute name="margin">auto</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="mx-auto"><xsl:attribute name="margin-left">auto</xsl:attribute><xsl:attribute
      name="margin-right"
    >auto</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="my-auto"><xsl:attribute name="margin-top">auto</xsl:attribute><xsl:attribute
      name="margin-bottom"
    >auto</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="mt-auto"><xsl:attribute name="margin-top">auto</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="mb-auto"><xsl:attribute name="margin-bottom">auto</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="ms-auto"><xsl:attribute name="margin-left">auto</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="me-auto"><xsl:attribute name="margin-right">auto</xsl:attribute></xsl:attribute-set>

  <!-- Standard Bootstrap Widths -->
  <xsl:attribute-set name="w-25"><xsl:attribute name="inline-progression-dimension">25%</xsl:attribute><xsl:attribute
      name="width"
    >25%</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="w-50"><xsl:attribute name="inline-progression-dimension">50%</xsl:attribute><xsl:attribute
      name="width"
    >50%</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="w-75"><xsl:attribute name="inline-progression-dimension">75%</xsl:attribute><xsl:attribute
      name="width"
    >75%</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="w-100"><xsl:attribute name="inline-progression-dimension">100%</xsl:attribute><xsl:attribute
      name="width"
    >100%</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="w-auto"><xsl:attribute name="inline-progression-dimension">auto</xsl:attribute><xsl:attribute
      name="width"
    >auto</xsl:attribute></xsl:attribute-set>

  <!-- Standard Bootstrap Borders -->
  <xsl:attribute-set name="border">
    <xsl:attribute name="border">
      <xsl:value-of select="$bootstrap-border-width"/> solid <xsl:value-of select="$bootstrap-border-color"/>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="border-top">
    <xsl:attribute name="border-top">
      <xsl:value-of select="$bootstrap-border-width"/> solid <xsl:value-of select="$bootstrap-border-color"/>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="border-bottom">
    <xsl:attribute name="border-bottom">
      <xsl:value-of select="$bootstrap-border-width"/> solid <xsl:value-of select="$bootstrap-border-color"/>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="border-start">
    <xsl:attribute name="border-left">
      <xsl:value-of select="$bootstrap-border-width"/> solid <xsl:value-of select="$bootstrap-border-color"/>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="border-end">
    <xsl:attribute name="border-right">
      <xsl:value-of select="$bootstrap-border-width"/> solid <xsl:value-of select="$bootstrap-border-color"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <!-- Border Colors -->
  <xsl:attribute-set name="border-primary"><xsl:attribute name="border-color"><xsl:value-of
        select="$bootstrap-primary"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="border-secondary"><xsl:attribute name="border-color"><xsl:value-of
        select="$bootstrap-secondary"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="border-success"><xsl:attribute name="border-color"><xsl:value-of
        select="$bootstrap-success"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="border-danger"><xsl:attribute name="border-color"><xsl:value-of
        select="$bootstrap-danger"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="border-warning"><xsl:attribute name="border-color"><xsl:value-of
        select="$bootstrap-warning"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="border-info"><xsl:attribute name="border-color"><xsl:value-of
        select="$bootstrap-info"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="border-accent"><xsl:attribute name="border-color"><xsl:value-of
        select="$bootstrap-accent"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="border-inverse"><xsl:attribute name="border-color"><xsl:value-of
        select="$bootstrap-inverse"
      /></xsl:attribute></xsl:attribute-set>
  <!-- Border Thickness -->
  <xsl:attribute-set name="border-1"><xsl:attribute name="border-width">1pt</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="border-2"><xsl:attribute name="border-width">2pt</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="border-3"><xsl:attribute name="border-width">3pt</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="border-4"><xsl:attribute name="border-width">4pt</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="border-5"><xsl:attribute name="border-width">5pt</xsl:attribute></xsl:attribute-set>

  <xsl:attribute-set name="border-primary-subtle"><xsl:attribute name="border-color"><xsl:value-of
        select="$bootstrap-primary-subtle-text"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="border-secondary-subtle"><xsl:attribute name="border-color"><xsl:value-of
        select="$bootstrap-secondary-subtle-text"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="border-success-subtle"><xsl:attribute name="border-color"><xsl:value-of
        select="$bootstrap-success-subtle-text"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="border-danger-subtle"><xsl:attribute name="border-color"><xsl:value-of
        select="$bootstrap-danger-subtle-text"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="border-warning-subtle"><xsl:attribute name="border-color"><xsl:value-of
        select="$bootstrap-warning-subtle-text"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="border-info-subtle"><xsl:attribute name="border-color"><xsl:value-of
        select="$bootstrap-info-subtle-text"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="border-accent-subtle"><xsl:attribute name="border-color"><xsl:value-of
        select="$bootstrap-accent-subtle-text"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="border-inverse-subtle"><xsl:attribute name="border-color"><xsl:value-of
        select="$bootstrap-inverse-subtle-text"
      /></xsl:attribute></xsl:attribute-set>

  <!-- Rounded Corners (Approximate Bootstrap values) -->
  <!-- Rounded Corners (Apache FOP extensions) -->
  <xsl:attribute-set name="rounded">
    <xsl:attribute name="fox:border-radius">
      <xsl:value-of select="$bootstrap-rounded"/>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="rounded-0"><xsl:attribute name="fox:border-radius"><xsl:value-of
        select="$bootstrap-rounded-0"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="rounded-1"><xsl:attribute name="fox:border-radius"><xsl:value-of
        select="$bootstrap-rounded-1"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="rounded-2"><xsl:attribute name="fox:border-radius"><xsl:value-of
        select="$bootstrap-rounded-2"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="rounded-3"><xsl:attribute name="fox:border-radius"><xsl:value-of
        select="$bootstrap-rounded-3"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="rounded-4"><xsl:attribute name="fox:border-radius"><xsl:value-of
        select="$bootstrap-rounded-4"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="rounded-5"><xsl:attribute name="fox:border-radius"><xsl:value-of
        select="$bootstrap-rounded-5"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="rounded-circle"><xsl:attribute name="fox:border-radius"><xsl:value-of
        select="$bootstrap-rounded-circle"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="rounded-pill"><xsl:attribute name="fox:border-radius"><xsl:value-of
        select="$bootstrap-rounded-pill"
      /></xsl:attribute></xsl:attribute-set>

  <xsl:attribute-set name="section.title">
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-heading-color"/></xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="example.title">
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-heading-color"/></xsl:attribute>
  </xsl:attribute-set>

  <!-- Heading utilities (h1-h6 aliases) -->
  <xsl:attribute-set name="h1"><xsl:attribute name="font-size"><xsl:value-of
        select="$bootstrap-h1-font-size"
      /></xsl:attribute><xsl:attribute name="font-weight"><xsl:value-of
        select="$bootstrap-heading-font-weight"
      /></xsl:attribute><xsl:attribute name="color"><xsl:value-of
        select="$bootstrap-heading-color"
      /></xsl:attribute><xsl:attribute name="margin-top"><xsl:value-of
        select="$bootstrap-h1-margin-top"
      /></xsl:attribute><xsl:attribute name="margin-bottom"><xsl:value-of
        select="$bootstrap-h1-margin-bottom"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="h2"><xsl:attribute name="font-size"><xsl:value-of
        select="$bootstrap-h2-font-size"
      /></xsl:attribute><xsl:attribute name="font-weight"><xsl:value-of
        select="$bootstrap-heading-font-weight"
      /></xsl:attribute><xsl:attribute name="color"><xsl:value-of
        select="$bootstrap-heading-color"
      /></xsl:attribute><xsl:attribute name="margin-top"><xsl:value-of
        select="$bootstrap-h2-margin-top"
      /></xsl:attribute><xsl:attribute name="margin-bottom"><xsl:value-of
        select="$bootstrap-h2-margin-bottom"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="h3"><xsl:attribute name="font-size"><xsl:value-of
        select="$bootstrap-h3-font-size"
      /></xsl:attribute><xsl:attribute name="font-weight"><xsl:value-of
        select="$bootstrap-heading-font-weight"
      /></xsl:attribute><xsl:attribute name="color"><xsl:value-of
        select="$bootstrap-heading-color"
      /></xsl:attribute><xsl:attribute name="margin-top"><xsl:value-of
        select="$bootstrap-h3-margin-top"
      /></xsl:attribute><xsl:attribute name="margin-bottom"><xsl:value-of
        select="$bootstrap-h3-margin-bottom"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="h4"><xsl:attribute name="font-size"><xsl:value-of
        select="$bootstrap-h4-font-size"
      /></xsl:attribute><xsl:attribute name="font-weight"><xsl:value-of
        select="$bootstrap-heading-font-weight"
      /></xsl:attribute><xsl:attribute name="color"><xsl:value-of
        select="$bootstrap-heading-color"
      /></xsl:attribute><xsl:attribute name="margin-top"><xsl:value-of
        select="$bootstrap-h4-margin-top"
      /></xsl:attribute><xsl:attribute name="margin-bottom"><xsl:value-of
        select="$bootstrap-h4-margin-bottom"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="h5"><xsl:attribute name="font-size"><xsl:value-of
        select="$bootstrap-h5-font-size"
      /></xsl:attribute><xsl:attribute name="font-weight"><xsl:value-of
        select="$bootstrap-heading-font-weight"
      /></xsl:attribute><xsl:attribute name="color"><xsl:value-of
        select="$bootstrap-heading-color"
      /></xsl:attribute><xsl:attribute name="margin-top"><xsl:value-of
        select="$bootstrap-h5-margin-top"
      /></xsl:attribute><xsl:attribute name="margin-bottom"><xsl:value-of
        select="$bootstrap-h5-margin-bottom"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="h6"><xsl:attribute name="font-size"><xsl:value-of
        select="$bootstrap-h6-font-size"
      /></xsl:attribute><xsl:attribute name="font-weight"><xsl:value-of
        select="$bootstrap-heading-font-weight"
      /></xsl:attribute><xsl:attribute name="color"><xsl:value-of
        select="$bootstrap-heading-color"
      /></xsl:attribute><xsl:attribute name="margin-top"><xsl:value-of
        select="$bootstrap-h6-margin-top"
      /></xsl:attribute><xsl:attribute name="margin-bottom"><xsl:value-of
        select="$bootstrap-h6-margin-bottom"
      /></xsl:attribute></xsl:attribute-set>

  <!-- Topic Headings Overrides -->
  <xsl:attribute-set name="topic.title" use-attribute-sets="h1">
    <xsl:attribute name="border-after-width">1pt</xsl:attribute>
    <xsl:attribute name="border-after-style">solid</xsl:attribute>
    <xsl:attribute name="border-after-color"><xsl:value-of select="$bootstrap-border-color"/></xsl:attribute>
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="topic.topic.title" use-attribute-sets="h2">
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="topic.topic.topic.title" use-attribute-sets="h3">
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="topic.topic.topic.topic.title" use-attribute-sets="h4">
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="topic.topic.topic.topic.topic.title" use-attribute-sets="h5">
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="topic.topic.topic.topic.topic.topic.title" use-attribute-sets="h6">
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  </xsl:attribute-set>


  <!-- Font-size utilities (fs-*), combined with fw-* for weight, e.g. outputclass="fw-light fs-6xl" -->
  <xsl:attribute-set name="fs-xs"><xsl:attribute name="font-size"><xsl:value-of
        select="$bootstrap-fs-xs"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="fs-sm"><xsl:attribute name="font-size"><xsl:value-of
        select="$bootstrap-fs-sm"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="fs-base"><xsl:attribute name="font-size"><xsl:value-of
        select="$bootstrap-fs-base"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="fs-md"><xsl:attribute name="font-size"><xsl:value-of
        select="$bootstrap-fs-md"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="fs-lg"><xsl:attribute name="font-size"><xsl:value-of
        select="$bootstrap-fs-lg"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="fs-xl"><xsl:attribute name="font-size"><xsl:value-of
        select="$bootstrap-fs-xl"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="fs-2xl"><xsl:attribute name="font-size"><xsl:value-of
        select="$bootstrap-fs-2xl"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="fs-3xl"><xsl:attribute name="font-size"><xsl:value-of
        select="$bootstrap-fs-3xl"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="fs-4xl"><xsl:attribute name="font-size"><xsl:value-of
        select="$bootstrap-fs-4xl"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="fs-5xl"><xsl:attribute name="font-size"><xsl:value-of
        select="$bootstrap-fs-5xl"
      /></xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="fs-6xl"><xsl:attribute name="font-size"><xsl:value-of
        select="$bootstrap-fs-6xl"
      /></xsl:attribute></xsl:attribute-set>

  <!-- Font-weight utilities (fw-*); lighter/bolder are relative XSL-FO keywords, matching CSS -->
  <xsl:attribute-set name="fw-lighter"><xsl:attribute name="font-weight">lighter</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="fw-light"><xsl:attribute name="font-weight">300</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="fw-normal"><xsl:attribute name="font-weight">400</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="fw-medium"><xsl:attribute name="font-weight">500</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="fw-semibold"><xsl:attribute name="font-weight">600</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="fw-bold"><xsl:attribute name="font-weight">700</xsl:attribute></xsl:attribute-set>
  <xsl:attribute-set name="fw-bolder"><xsl:attribute name="font-weight">bolder</xsl:attribute></xsl:attribute-set>

  <!-- Table Striping -->
  <xsl:attribute-set name="table-striped">
      <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-table-striped-color"/></xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="lead">
      <xsl:attribute name="font-size"><xsl:value-of select="$bootstrap-lead-font-size"/></xsl:attribute>
      <xsl:attribute name="font-weight"><xsl:value-of select="$bootstrap-lead-font-weight"/></xsl:attribute>
  </xsl:attribute-set>

  <!-- Monospace and Code Elements -->
  <xsl:attribute-set name="codeph" use-attribute-sets="base-font">
    <xsl:attribute name="font-family">monospace</xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-code-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="filepath" use-attribute-sets="base-font">
    <xsl:attribute name="font-family">monospace</xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-code-color"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="option">
    <xsl:attribute name="font-family">monospace</xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-code-color"/></xsl:attribute>
  </xsl:attribute-set>

  <!-- Commands & Parameters -->
  <xsl:attribute-set name="cmdname">
    <xsl:attribute name="font-family">monospace</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-dita-prussian-blue"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="parmname">
    <xsl:attribute name="font-family">monospace</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-dita-prussian-blue"/></xsl:attribute>
  </xsl:attribute-set>

  <!-- XML Entities -->
  <xsl:attribute-set name="numcharref">
    <xsl:attribute name="font-family">monospace</xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-dita-violet"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="parameterentity">
    <xsl:attribute name="font-family">monospace</xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-dita-violet"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="textentity">
    <xsl:attribute name="font-family">monospace</xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-dita-violet"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="xmlatt">
    <xsl:attribute name="font-family">monospace</xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-dita-violet"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="xmlelement">
    <xsl:attribute name="font-family">monospace</xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-dita-violet"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="xmlnsname">
    <xsl:attribute name="font-family">monospace</xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-dita-violet"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="xmlpi">
    <xsl:attribute name="font-family">monospace</xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-dita-violet"/></xsl:attribute>
  </xsl:attribute-set>

  <!-- Syntax -->
  <xsl:attribute-set name="syntaxdiagram">
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-dita-maroon"/></xsl:attribute>
  </xsl:attribute-set>

  <!-- States -->
  <xsl:attribute-set name="boolean">
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-success"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="state">
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-danger"/></xsl:attribute>
  </xsl:attribute-set>

  <!-- Keyboard and Keyword style reversal (light text on dark background) -->
  <xsl:attribute-set name="kwd">
    <xsl:attribute name="font-family">monospace</xsl:attribute>
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-body-color"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-body-bg"/></xsl:attribute>
    <xsl:attribute name="padding-left">3pt</xsl:attribute>
    <xsl:attribute name="padding-right">3pt</xsl:attribute>
    <xsl:attribute name="padding-top">3pt</xsl:attribute>
    <xsl:attribute name="padding-bottom">1pt</xsl:attribute>
    <xsl:attribute name="margin-bottom">3pt</xsl:attribute>
    <xsl:attribute name="fox:border-radius"><xsl:value-of select="$bootstrap-rounded-1"/></xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="userinput">
    <xsl:attribute name="font-family">monospace</xsl:attribute>
    <xsl:attribute name="background-color"><xsl:value-of select="$bootstrap-body-color"/></xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$bootstrap-body-bg"/></xsl:attribute>
    <xsl:attribute name="padding-left">3pt</xsl:attribute>
    <xsl:attribute name="padding-right">3pt</xsl:attribute>
    <xsl:attribute name="padding-top">3pt</xsl:attribute>
    <xsl:attribute name="padding-bottom">1pt</xsl:attribute>
    <xsl:attribute name="margin-bottom">3pt</xsl:attribute>
    <xsl:attribute name="fox:border-radius"><xsl:value-of select="$bootstrap-rounded-1"/></xsl:attribute>
  </xsl:attribute-set>

</xsl:stylesheet>
