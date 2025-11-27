<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:cei="http://www.monasterium.net/NS/cei"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xpath-default-namespace="urn:isbn:1-931666-22-9"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!--<xsl:template match="*|@*">
        <xsl:message>WARNING: Unprocessed node: <xsl:value-of select="name()"/></xsl:message>
    </xsl:template>-->
    
    <xsl:template match="ead">
        <cei:cei>
            <cei:teiHeader>
                <cei:fileDesc>
                    <cei:titleStmt>
                        <xsl:apply-templates select='eadheader/filedesc/titlestmt/titleproper'/>
                        <cei:author/>
                    </cei:titleStmt>
                    <cei:publicationStmt>
                        <cei:p/>
                    </cei:publicationStmt>
                    <cei:sourceDesc>
                        <cei:p/>
                    </cei:sourceDesc>
                </cei:fileDesc>
            </cei:teiHeader>
            <xsl:apply-templates select="archdesc/dsc"/>
            <!--calls c[did/unittitle/text() = 'Urkunden']-->
        </cei:cei>
    </xsl:template>
    
    <xsl:template match="titleproper">
        <cei:title>
            <xsl:apply-templates/>
        </cei:title>
    </xsl:template>
    
    <xsl:template match="profiledesc"/>
    
    <xsl:template match="dsc">
        <cei:text>
            <cei:group>
                <xsl:apply-templates select="//c[@level='file']"/>
            </cei:group>
        </cei:text>
    </xsl:template>
    
    <!--individual charter-->
    <xsl:template match="c[@level='file']">
        <cei:text type='charter'>
            <cei:front/>
            <cei:body>
                <cei:idno id="{substring-after(odd[head/text()= 'Signatur']/p, 'BayHStA, ')}">
                    <xsl:apply-templates select="substring-after(odd[head/text()= 'Signatur']/p, 'BayHStA, ')"/>
                </cei:idno>
                <cei:chDesc>
                    <cei:abstract>
                        <xsl:value-of select="did/unittitle"/>
                    </cei:abstract>
                    <cei:issued>
                        <xsl:call-template name="date"/>
                        <cei:placeName>
                            <xsl:value-of select="odd[head/text()='Ausstellungsort']/p/normalize-space()"/>
                        </cei:placeName>
                    </cei:issued>
                    <cei:witnessOrig>
                        <cei:traditioForm>
                            <xsl:value-of select="odd[head/text()='Überlieferung']/p"/>
                        </cei:traditioForm>
                        <cei:archIdentifier>
                            <cei:settlement>München</cei:settlement>
                            <cei:region>Bayern</cei:region>
                            <cei:country>Deutschland</cei:country>
                            <cei:arch>Bayerisches Hauptstaatsarchiv</cei:arch>
                            <cei:archFond>
                                <xsl:value-of select="did/origination[@label='Provenienz'][1]/name"/>
                            </cei:archFond>
                            <!--<xsl:apply-templates select="odd[head/text()='Identifier Archivtektonik']/p"/>-->
                            <xsl:apply-templates select="odd[head/text()='Bestellnummer']/p"/>
                            <xsl:apply-templates select="daogrp"/>
                        </cei:archIdentifier>
                        <cei:physicalDesc>
                            <!--<xsl:apply-templates select="odd[head/text()='Medium']/p"/>-->
                            <xsl:apply-templates select="odd[head/text()='Äußere Beschreibung']/p"/>
                            <xsl:apply-templates select="odd[head/text()='Gesamtbewertung des Schadens']/p"/>
                            <xsl:apply-templates select="odd[head/text()='Erläuterung des Schadens']/p"/>
                            <xsl:apply-templates select="odd[head/text()='Schadenskataster']/p"/>
                            <xsl:apply-templates select="did/materialspec"/>
                        </cei:physicalDesc>
                        <cei:auth>
                            <cei:sealDesc>
                                <xsl:value-of select="odd[head/text()='Besiegelung/Beglaubigung']/p"/>
                                <xsl:apply-templates select="odd[head/text()='Siegler']/p"/>
                            </cei:sealDesc>
                        </cei:auth>
                        <xsl:apply-templates select="odd[head/text()='Vermerke']/p"/>
                    </cei:witnessOrig>
                    <cei:diplomaticAnalysis>
                        <!--[1] weil es oft doppelt vorkommt-->
                        <xsl:apply-templates select="odd[head/text()='Originaldatierung'][1]/p"/>
                        <xsl:apply-templates select="odd[head/text()='Interne Bemerkungen']/p"/>
                        <xsl:apply-templates select="odd[head/text()='Literatur']/p"/>
                        <xsl:apply-templates select="odd[head/text()='Objektbeschreibung']/p"/>
                    </cei:diplomaticAnalysis>
                    <cei:lang_MOM>
                        <xsl:apply-templates select="odd[head/text()= 'Sprache'][1]/p"/>
                    </cei:lang_MOM>
                </cei:chDesc>
            </cei:body>
            <cei:back>
            <xsl:apply-templates select="index"/>
            </cei:back>
        </cei:text>
    </xsl:template>
    
    <xsl:template match="odd[head/text()='Äußere Beschreibung']/p">
        <xsl:choose>
            <xsl:when test="contains(., 'H:')">
                <cei:dimensions>
                    <xsl:apply-templates/>
                </cei:dimensions>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="odd[head/text()='Interne Bemerkungen']/p">
        <cei:p>
            <xsl:apply-templates/>
        </cei:p>
    </xsl:template>
    
    <xsl:template match="odd[head/text()='Siegler']/p">
        <cei:seal>
            <cei:sigillant>
                <xsl:apply-templates/>
            </cei:sigillant>
        </cei:seal>
    </xsl:template>
    
    <xsl:template match="odd[head/text()='Objektbeschreibung']/p">
        <cei:p>
            <xsl:apply-templates/>
        </cei:p>
    </xsl:template>
    
    <xsl:template match="odd[head/text()='Literatur']/p">
        <xsl:choose>
            <xsl:when test="contains(., 'Edition:')">
                <cei:listBiblEdition>
                    <cei:bibl>
                        <xsl:apply-templates/>
                    </cei:bibl>
                </cei:listBiblEdition>
            </xsl:when>
            <xsl:otherwise>
                <cei:listBibl>
                    <cei:bibl>
                        <xsl:apply-templates/>
                    </cei:bibl>
                </cei:listBibl>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="odd[head/text()='Vermerke']/p">
        <xsl:choose>
            <xsl:when test="contains(., 'RV:')">
                <cei:nota>
                    <xsl:apply-templates/>
                </cei:nota>
            </xsl:when>
            <xsl:otherwise>
                <cei:rubrum>
                    <xsl:apply-templates/>
                </cei:rubrum>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="odd[head/text()='Gesamtbewertung des Schadens']/p">
        <cei:condition n='Gesamtbewertung'>
            <xsl:apply-templates/>
        </cei:condition>
    </xsl:template>
    
    <xsl:template match="odd[head/text()='Erläuterung des Schadens']/p">
        <cei:condition n='Erläuterung'>
            <xsl:apply-templates/>
        </cei:condition>
    </xsl:template>
    
    <xsl:template match="odd[head/text()='Schadenskataster']/p">
        <cei:condition n='Schadenskataster'>
            <xsl:apply-templates/>
        </cei:condition>
    </xsl:template>
    
    <!--<xsl:template match="odd[head/text()='Medium']/p">
        <cei:material>
            <xsl:apply-templates/>
        </cei:material>
    </xsl:template>-->
    
    <xsl:template match="odd[head/text()='Identifier Archivtektonik']/p">
        <cei:archFond>
            <xsl:apply-templates/>
        </cei:archFond>
    </xsl:template>
    
    <xsl:template match="odd[head/text()='Bestellnummer']/p">
        <xsl:variable name="unternummer" select="./ancestor::c/odd[head/text()='Unternummer']/p/text()"/>
        <xsl:variable name="registratursignatur" select="./ancestor::c/did/unitid[@type='Registratursignatur/AZ']/text()"/>
        <cei:idno n='{../head/text()}'>
            <xsl:value-of select="string-join((., $unternummer, $registratursignatur), ', ')"/>
        </cei:idno>
    </xsl:template>
    
    <xsl:template match="odd[head/text()='Originaldatierung']/p">
        <cei:quoteOriginaldatierung>
            <xsl:apply-templates/>
        </cei:quoteOriginaldatierung>
    </xsl:template>
    
    <xsl:template match="unittitle[parent::did/parent::c[@level='class']]"/>
    
    <xsl:template match="index">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="indexentry">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="geogname">
        <cei:geogName>
            <xsl:apply-templates/>
        </cei:geogName>
    </xsl:template>
    
    <xsl:template match="persname">
        <cei:persName>
            <xsl:apply-templates/>
        </cei:persName>
    </xsl:template>
    
    <xsl:template match="subject">
        <cei:index>
            <xsl:apply-templates/>
        </cei:index>
    </xsl:template>
    
    <xsl:template match="materialspec">
        <cei:material>
            <xsl:apply-templates/>
        </cei:material>
    </xsl:template>
    
    <xsl:template match="daogrp">
        <xsl:apply-templates select="daoloc[@xlink:role/data() = 'externer_viewer']"/>
    </xsl:template>
    
    <xsl:template match="daoloc">
        <cei:ref target='{@xlink:href/data()}'/>
    </xsl:template>
    
    <xsl:template match="did/unitid[@type='Registratursignatur/AZ']">
        <cei:idno>
            <xsl:apply-templates/>
        </cei:idno>
    </xsl:template>
    
    <xsl:template name="date">
        <xsl:choose>
            <xsl:when test="odd/head/text()='Tag' or odd/head/text()='Monat' or odd/head/text()='Jahr'">
                <cei:date>
                    <xsl:variable name="month">
                        <xsl:variable name="zero_month">
                            <xsl:choose>
                                <xsl:when test="not(odd/head/text()='Monat')">
                                    <xsl:text>99</xsl:text>
                                </xsl:when>
                                <xsl:when test="odd[head/text()='Monat']/p = 'Januar'">
                                    <xsl:text>01</xsl:text>
                                </xsl:when>
                                <xsl:when test="odd[head/text()='Monat']/p = 'Februar'">
                                    <xsl:text>02</xsl:text>
                                </xsl:when>
                                <xsl:when test="odd[head/text()='Monat']/p = 'September'">
                                    <xsl:text>09</xsl:text>
                                </xsl:when>
                                <xsl:when test="odd[head/text()='Monat']/p = 'November'">
                                    <xsl:text>11</xsl:text>
                                </xsl:when>
                                <xsl:when test="odd[head/text()='Monat']/p = 'August'">
                                    <xsl:text>08</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('0', odd[head/text()='Monat']/p)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:value-of select="substring($zero_month, string-length($zero_month) - 1, 2)"/>
                    </xsl:variable>
                    <xsl:variable name="day">
                        <xsl:variable name="zero_day">
                            <xsl:choose>
                                <xsl:when test="not(odd/head/text()='Tag')">
                                    <xsl:text>99</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('0', odd[head/text()='Tag']/p)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:value-of select="substring($zero_day, string-length($zero_day) - 1, 2)"/>
                    </xsl:variable>
                    <xsl:variable name="year">
                        <xsl:choose>
                            <xsl:when test="not(odd/head/text()='Jahr')">
                                <xsl:text>9999</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="odd[head/text()='Jahr']/p"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="value" select="concat($year, $month, $day)"/>
                    <!--<xsl:text> (</xsl:text>-->
                    <xsl:value-of select="normalize-space(odd[head/text()='Laufzeit']/p)"/>
                    <!--<xsl:text>)</xsl:text>-->
                </cei:date>
            </xsl:when>
            <xsl:when test="matches(odd[head/text()='Laufzeit']/p, '(\d{4}).+(\d{4})')">
                <cei:dateRange>
                    <xsl:analyze-string select="odd[head/text()='Laufzeit']/p" regex="(\d{{4}}).+(\d{{4}})">
                        <xsl:matching-substring>
                            <xsl:attribute name="from">
                                <xsl:value-of select="regex-group(1)"/>
                                <xsl:text>9999</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="to">
                                <xsl:value-of select="regex-group(2)"/>
                                <xsl:text>9999</xsl:text>
                            </xsl:attribute>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                    <xsl:value-of select="normalize-space(odd[head/text()='Laufzeit']/p)"/>
                </cei:dateRange>
            </xsl:when>
            <xsl:when test="matches(odd[head/text()='Laufzeit']/p, '(\d{4})')">
                <cei:date>
                    <xsl:analyze-string select="odd[head/text()='Laufzeit']/p" regex="(\d{{4}})">
                        <xsl:matching-substring>
                            <xsl:attribute name="value">
                                <xsl:value-of select="regex-group(1)"/>
                                <xsl:text>9999</xsl:text>
                            </xsl:attribute>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                    <xsl:value-of select="normalize-space(odd[head/text()='Laufzeit']/p)"/>
                </cei:date>
            </xsl:when>
            <xsl:otherwise>
                <cei:date value='99999999'>
                    <xsl:value-of select="normalize-space(odd[head/text()='Laufzeit']/p)"/>
                </cei:date>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>