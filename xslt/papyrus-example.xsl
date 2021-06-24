<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:t="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="t"
  version="3.0">
  <xsl:output method="html" html-version="5"/>
  
  <!-- Run this on the CPR.26.36.xml file in the xml folder.
    
       Match the root of the document, write the "shell" of the
       HTML output. -->
  <xsl:template match="/">
    <html>
      <head>
        <meta charset="utf-8"/>
        <title><xsl:value-of select="t:TEI/t:teiHeader/t:fileDesc/t:titleStmt/t:title"/></title>
        <style>
          *[lang=ar] {
            direction: rtl;
            text-align: right;
          }
          div.body {
            width: 100%;
          }
          div.edition {
            font-family: "Antinoou", "IFAO-Grec Unicode", "Gentium Plus", "Gentium", "New Athena Unicode", "Times New Roman";
            font-size: 1.5em;
            margin-left: auto;
            margin-right: auto;
            width: 45%;
          }
          h1 {
            margin-left: auto;
            margin-right: auto;
            width: 45%;
          }
          span.margin-num {
            position: absolute;
            right: 25vw;
          }
        </style>
      </head>
      <body>
        <xsl:apply-templates select="t:TEI/t:text/t:body"/> <!-- Go find the TEI body tag and start work from there -->
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="t:body">
    <div class="body">
      <xsl:apply-templates/> <!-- Plain apply-templates (without a select) means just find the next node and process it. -->
    </div>                   <!-- If there is a matching template for that node, it will be used. -->
  </xsl:template>
  
  <xsl:template match="t:head">
    <h1><xsl:apply-templates/></h1>
  </xsl:template>
  
  <xsl:template match="t:div[@type='edition']">
    <div class="edition">
      <!-- Turn the xml:lang attribute into a plain lang -->
      <xsl:attribute name="lang"><xsl:value-of select="@xml:lang"/></xsl:attribute>
      <xsl:apply-templates/>
    </div>    
  </xsl:template>
  
  <!-- Turn TEI lb tags into br -->
  <xsl:template match="t:lb">
    <!-- If the n attribute's value is divisible by 5, print the number in the margin -->
    <br/><xsl:if test="@n mod 5 = 0"><span class="margin-num"><xsl:value-of select="@n"/></span></xsl:if>
  </xsl:template>
  
  <!-- Wrap the content of supplied tags in square brackets -->
  <xsl:template match="t:supplied[@reason='lost']">[<xsl:apply-templates/>]</xsl:template>
  
  <!-- Print a combining dot below after each letter in an unclear tag -->
  <xsl:template match="t:unclear">
    <xsl:variable name="current" select="."/>
    <xsl:for-each select="1 to string-length(.)"><xsl:value-of select="substring($current,.,1)"/>&#x0323;</xsl:for-each>
  </xsl:template>
  
  
</xsl:stylesheet>