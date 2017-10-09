<?xml version="1.0" encoding="utf-8"?>

<!--
This is an XSL stylesheet which converts mscript XML files into XSLT.
Use the XSLT command to perform the conversion.

Ned Gulley and Matthew Simoneau, September 2003
Copyright 1984-2013 The MathWorks, Inc.

Modified to provide github-markdown by Aslak Grinsted

-->

<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:escape="http://www.mathworks.com/namespace/latex/escape"
  xmlns:mwsh="http://www.mathworks.com/namespace/mcode/v1/syntaxhighlight.dtd">
  <xsl:output method="text" indent="no"/>

<xsl:template match="mscript">

    <!-- Determine if the there should be an introduction section. -->
    <xsl:variable name="hasIntro" select="count(cell[@style = 'overview'])"/>
    <xsl:if test = "$hasIntro">
<xsl:apply-templates select="cell[1]/steptitle"/>
=======================================

<xsl:apply-templates select="cell[1]/text"/>
</xsl:if>

    <xsl:variable name="body-cells" select="cell[not(@style = 'overview')]"/>

    <!-- Include contents if there are titles for any subsections.
    <xsl:if test="count(cell/steptitle[not(@style = 'document')])">
      <xsl:call-template name="contents">
        <xsl:with-param name="body-cells" select="$body-cells"/>
      </xsl:call-template>
    </xsl:if> -->

    <!-- Loop over each cell -->
    <xsl:for-each select="$body-cells">
        <!-- Title of cell -->
        <xsl:if test="steptitle">
          <xsl:variable name="headinglevel">
            <xsl:choose>
<xsl:when test="steptitle[@style = 'document']">
==========================================================

</xsl:when>
<xsl:otherwise>
----------------------------------------------------------

</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

<xsl:text>

</xsl:text>
<xsl:apply-templates select="steptitle"/>
<xsl:value-of select="$headinglevel"/>

</xsl:if>

<!-- Contents of each cell -->
<xsl:apply-templates select="text"/>
<xsl:apply-templates select="mcode"/>
<xsl:apply-templates select="mcodeoutput"/>
<xsl:apply-templates select="img"/>

</xsl:for-each>


<xsl:if test="copyright">

*<xsl:apply-templates select="copyright"/>*

</xsl:if>



</xsl:template>



<xsl:template name="contents">
  <xsl:param name="body-cells"/>
Contents
-------------------------<xsl:for-each select="$body-cells"><xsl:if test="./steptitle">
<xsl:apply-templates select="steptitle">

</xsl:apply-templates>
</xsl:if>
</xsl:for-each>

</xsl:template>




<!-- HTML Tags in text sections -->
<xsl:template match="p"><xsl:apply-templates/><xsl:text>

</xsl:text>
</xsl:template>

<xsl:template match="ul">

<xsl:apply-templates/>

</xsl:template>
<xsl:template match="ol">

<xsl:apply-templates/>

</xsl:template>
<xsl:template match="li">   + <xsl:apply-templates/><xsl:text>
</xsl:text></xsl:template>

<xsl:template match="pre">
  <xsl:choose>
    <xsl:when test="@class='error'">
```<xsl:value-of select="."/>```
    </xsl:when>
    <xsl:otherwise>
```matlab
<xsl:value-of select="."/>
```
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<xsl:template match="b">**<xsl:apply-templates/>**</xsl:template>
<xsl:template match="tt">`<xsl:apply-templates/>`</xsl:template>
<xsl:template match="i">*<xsl:apply-templates/>*</xsl:template>
<xsl:template match="a"><xsl:value-of select="."/></xsl:template>

<xsl:template match="text()">
  <!-- Escape special characters in text -->
  <xsl:call-template name="replace">
    <xsl:with-param name="string" select="."/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="equation">
<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="latex">
    <xsl:value-of select="@text" disable-output-escaping="yes"/>
</xsl:template>
<xsl:template match="html"/>


<!-- Code input and output -->

<xsl:template match="mcode">```matlab
<xsl:value-of select="."/>
```
</xsl:template>


<xsl:template match="mcodeoutput">
  <xsl:choose>
    <xsl:when test="substring(.,0,8)='&lt;latex&gt;'">
      <xsl:value-of select="substring(.,8,string-length(.)-16)" disable-output-escaping="yes"/>
    </xsl:when>
    <xsl:otherwise>
```
<xsl:value-of select="."/>
```
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Figure and model snapshots -->

<xsl:template match="img">
![IMAGE](<xsl:value-of select="@src"/>)
</xsl:template>

<!-- Colors for syntax-highlighted input code -->

<xsl:template match="mwsh:code">```matlab<xsl:apply-templates/>```
</xsl:template>
<xsl:template match="mwsh:keywords">
  <span class="keyword"><xsl:value-of select="."/></span>
</xsl:template>
<xsl:template match="mwsh:strings">
  <span class="string"><xsl:value-of select="."/></span>
</xsl:template>
<xsl:template match="mwsh:comments">
  <span class="comment"><xsl:value-of select="."/></span>
</xsl:template>
<xsl:template match="mwsh:unterminated_strings">
  <span class="untermstring"><xsl:value-of select="."/></span>
</xsl:template>
<xsl:template match="mwsh:system_commands">
  <span class="syscmd"><xsl:value-of select="."/></span>
</xsl:template>


<!-- Used to escape special characters in the LaTeX output. -->

<escape:replacements>
  <!-- special TeX characters -->
  <replace><from>*</from><to>\*</to></replace>
  <replace><from>#</from><to>\%</to></replace>
  <replace><from>/</from><to>\#</to></replace>
  <replace><from>&lt;</from><to>\&lt;</to></replace>
  <replace><from>&gt;</from><to>\&gt;</to></replace>
  <replace><from>[</from><to>\[</to></replace>
  <replace><from>]</from><to>\]</to></replace>
</escape:replacements>

<xsl:variable name="replacements" select="document('')/xsl:stylesheet/escape:replacements/replace"/>

<xsl:template name="replace">
  <xsl:param name="string"/>
  <xsl:param name="next" select="1"/>

  <xsl:variable name="count" select="count($replacements)"/>
  <xsl:variable name="first" select="$replacements[$next]"/>
  <xsl:choose>
    <xsl:when test="$next > $count">
      <xsl:value-of select="$string"/>
    </xsl:when>
    <xsl:when test="contains($string, $first/from)">
      <xsl:call-template name="replace">
        <xsl:with-param name="string"
                        select="substring-before($string, $first/from)"/>
        <xsl:with-param name="next" select="$next+1" />
      </xsl:call-template>
      <xsl:copy-of select="$first/to" />
      <xsl:call-template name="replace">
        <xsl:with-param name="string"
                        select="substring-after($string, $first/from)"/>
        <xsl:with-param name="next" select="$next"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="replace">
        <xsl:with-param name="string" select="$string"/>
        <xsl:with-param name="next" select="$next+1"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
