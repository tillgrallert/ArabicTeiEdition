<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0" 
    xmlns:eg="http://www.tei-c.org/ns/Examples"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:exsl="http://exslt.org/common"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    extension-element-prefixes="exsl msxsl"
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:html="http://www.w3.org/1999/xhtml" 
    exclude-result-prefixes="xsl tei xd eg fn #default">
    
    <!-- import teibp.xsl, which allows templates, 
         variables, and parameters from teibp.xsl 
         to be overridden here. -->
    <xsl:import href="teibp.xsl"/>
    
    <!-- provide information based on the sourceDesc -->
    <!--    <xsl:template match="tei:sourceDesc">
        <div class="cSource">
            <xsl:apply-templates select="descendant::tei:biblStruct"/>
        </div>
    </xsl:template>-->
    <xsl:template match="child::tei:biblStruct[child::tei:monogr/child::tei:title[@level = 'j']]">
        <div class="cSource">
            <xsl:for-each
                select="child::tei:monogr/child::tei:title[@level = 'j'][not(@type = 'sub')]">
                <xsl:apply-templates select="."/>
            </xsl:for-each>
        </div>
    </xsl:template>
    <xsl:template match="tei:monogr/child::tei:title[@level = 'j'][not(@type = 'sub')]">
        <xsl:variable name="vLang" select="@xml:lang"/>
        <div>
            <xsl:call-template name="templHtmlAttrLang">
                <xsl:with-param name="pInput" select="."/>
            </xsl:call-template>
            <title>
                <xsl:value-of select="."/>
            </title>
            <xsl:for-each
                select="parent::tei:monogr/child::tei:title[@level = 'j'][@type = 'sub'][@xml:lang = $vLang]">
                <xsl:text>: </xsl:text>
                <span class="cSubTitle">
                    <xsl:value-of select="."/>
                </span>
            </xsl:for-each>
            <!-- volume and issue information -->
            <span class="cBiblScope">
                <xsl:apply-templates select="parent::tei:monogr/child::tei:biblScope[@unit='volume'][@xml:lang=$vLang]"/>
            </span>
            <!-- editors -->
            <xsl:if test="parent::tei:monogr/child::tei:editor[@xml:lang = $vLang]">
                <span class="cAuthors">
                    <xsl:text>, </xsl:text>
                    <xsl:if test="$vLang='en'">
                        <xsl:text>edited by </xsl:text>
                    </xsl:if>
                    <xsl:if test="$vLang='ar-Latn-x-ijmes'">
                        <xsl:text>edited by </xsl:text>
                    </xsl:if>
                    <xsl:for-each select="parent::tei:monogr/child::tei:editor[@xml:lang = $vLang]">
                        <xsl:apply-templates select="node()"/>
                        <xsl:if test="not(position() = last())">, </xsl:if>
                    </xsl:for-each>
                </span>
            </xsl:if>
            <!-- publiser and place of publication -->
            <span class="cImprint">
                <xsl:text>, </xsl:text>
                <xsl:apply-templates
                    select="parent::tei:monogr/child::tei:imprint/child::tei:pubPlace[@xml:lang = $vLang]"/>
                <xsl:text>, </xsl:text>
                <xsl:apply-templates
                    select="parent::tei:monogr/child::tei:imprint/child::tei:publisher[@xml:lang = $vLang]"
                />
                <xsl:text>, </xsl:text>
                <xsl:apply-templates
                    select="parent::tei:monogr/child::tei:imprint/child::tei:date[@xml:lang = $vLang]"
                />
            </span>
        </div>
    </xsl:template>
    
</xsl:stylesheet>