<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:cei="http://www.monasterium.net/NS/cei"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xpath-default-namespace="urn:isbn:1-931666-22-9"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
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
            <xsl:apply-templates select="archdesc/dsc/c/c"/>
            <!--calls c[did/unittitle/text() = 'Urkunden']-->
        </cei:cei>
    </xsl:template>
    
    <xsl:template match="titleproper">
        <cei:title>
            <xsl:apply-templates/>
        </cei:title>
    </xsl:template>
    
    <xsl:template match="profiledesc"/>
    
    <xsl:template match="c[did/unittitle/text() = 'Urkunden']">
        <cei:text>
            <cei:group>
                <xsl:apply-templates select="c[@level='file']"/>
            </cei:group>
        </cei:text>
    </xsl:template>
    
    <xsl:template match="c[@level='file']">
        <cei:text type='charter'>
            <cei:front>
                <cei:sourceDesc>
                    <cei:sourceDescVolltext>
                        <cei:bibl/>
                    </cei:sourceDescVolltext>
                    <cei:sourceDescRegest>
                        <cei:bibl/>
                    </cei:sourceDescRegest>
                </cei:sourceDesc>
            </cei:front>
            <cei:body>
                <cei:idno>
                    <xsl:apply-templates select="odd[head/text()= 'Signatur']/p"/>
                </cei:idno>
                <cei:chDesc>
                    <cei:abstract>
                        <xsl:value-of select="did/unittitle[@type = 'Kopfregest']"/>
                    </cei:abstract>
                    <cei:issued>
                        <cei:date>
                            <xsl:variable name="month">
                                <xsl:variable name="zero_month" select="concat('0', odd[head/text()='Monat']/p)"/>
                                <xsl:value-of select="substring($zero_month, string-length($zero_month) - 1, 2)"/>
                            </xsl:variable>
                            <xsl:attribute name="value" select="concat(odd[head/text()='Tag']/p, $month, odd[head/text()='Jahr']/p)"/>
                            <xsl:value-of select="odd[head/text()='Originaldatierung'][1]/p"/>
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="normalize-space(odd[head/text()='Laufzeit']/p)"/>
                            <xsl:text>)</xsl:text>
                        </cei:date>
                        <cei:placeName>
                            <xsl:value-of select="odd[head/text()='Ausstellungsort']/p"/>
                        </cei:placeName>
                    </cei:issued>
                    <cei:witnessOrig>
                        <cei:traditioForm>
                            <xsl:value-of select="odd[head/text()='Überlieferung']/p"/>
                        </cei:traditioForm>
                        <cei:archIdentifier>
                            
                        </cei:archIdentifier>
                        <cei:physicalDesc>
                            <xsl:apply-templates select="odd[head/text()='Äußere Beschreibung']/p"/>
                            <xsl:apply-templates select="odd[head/text()='Objektbeschreibung']/p"/>
                            <xsl:apply-templates select="odd[head/text()='Gesamtbewertung des Schadens']/p"/>
                            <xsl:apply-templates select="odd[head/text()='Erläuterung des Schadens']/p"/>
                            <xsl:apply-templates select="odd[head/text()='Schadenskataster']/p"/>
                        </cei:physicalDesc>
                        <cei:auth>
                            <cei:sealDesc>
                                <xsl:value-of select="odd[head/text()='Besiegelung']/p"/>
                                <xsl:value-of select="odd[head/text()='Beglaubigung']/p"/>
                                <xsl:apply-templates select="odd[head/text()='Siegler']/p"/>
                            </cei:sealDesc>
                        </cei:auth>
                        <xsl:apply-templates select="odd[head/text()='Vermerke']/p"/>
                    </cei:witnessOrig>
                    <cei:diplomaticAnalysis>
                        <xsl:apply-templates select="odd[head/text()='Interne Bemerkungen']/p"/>
                        <xsl:apply-templates select="odd[head/text()='Literatur']/p"/>
                    </cei:diplomaticAnalysis>
                    <cei:lang_MOM>
                        <xsl:apply-templates select="odd[head/text()= 'Sprache'][1]/p"/>
                    </cei:lang_MOM>
                </cei:chDesc>
            </cei:body>
        </cei:text>
    </xsl:template>
    
    <!--<xsl:variable name="date">
        <cei:date>
            <xsl:attribute name="value">
                <xsl:value-of select="concat(odd[head/text()= 'Jahr']/p, odd[head/text()= 'Monat']/p, odd[head/text()= 'Tag']/p)"/>
            </xsl:attribute>
            <xsl:value-of select="odd[head/text()= 'Laufzeit']/p"/>
        </cei:date>
    </xsl:variable>-->
    
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
        <cei:decoDesc>
            <cei:p>
                <xsl:apply-templates/>
            </cei:p>
        </cei:decoDesc>
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
    
</xsl:stylesheet>