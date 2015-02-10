<?xml version="1.0" encoding="UTF-8"?>

<!--
        NAME         : cboCore2Rdf
        DATE CREATED : 09/27/14
        AUTHOR       : Sean Petiya
        URL          : http://comicmeta.org/tools/core-convert/
        DESCRIPTION  : This XSL stylesheet converts qualified XML records to RDF/XML using elements from
                       the Comic Book Schema (Core) metadata application profile. Common values are replaced with
                       a selected list of Linked Data URIs.
-->

<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:cbo="http://comicmeta.org/cbo/"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:msxml="urn:schemas-microsoft-com:xslt">

    <xsl:variable name="cbv" select="'http://comicmeta.org/vocab/'"></xsl:variable>
  
    <xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

    <xsl:template match="/">
        <rdf:RDF>
            <xsl:apply-templates></xsl:apply-templates>
        </rdf:RDF>
    </xsl:template>

    <xsl:template match="//cbo:Comic">
        <rdf:Description>
            <rdf:type rdf:resource="http://comicmeta.org/cbo/Comic"/>
     
            <xsl:call-template name="Series"></xsl:call-template>
      
        </rdf:Description>
    </xsl:template>
  
    <!-- // CLASSES -->
  
    <!-- Publisher -->
    
    <xsl:template name="Publisher" match="cbo:Comic">
        <xsl:variable name="id">
            <xsl:call-template name="getPublisherId">
                <xsl:with-param name="input" select="cbo:publisherName"></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not($id = '')">
                <cbo:publisher>
                    <rdf:Description rdf:about="{$id}">
                        <xsl:apply-templates select="cbo:publisherName"></xsl:apply-templates>
                        <xsl:apply-templates select="cbo:imprintName"></xsl:apply-templates>
                    </rdf:Description>
                </cbo:publisher>
            </xsl:when>
            <xsl:otherwise>
                <cbo:publisher>
                    <rdf:Description>
                        <xsl:apply-templates select="cbo:publisherName"></xsl:apply-templates>
                        <xsl:apply-templates select="cbo:imprintName"></xsl:apply-templates>
                    </rdf:Description>
                </cbo:publisher>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- Series -->
    
    <xsl:template name="Series" match="cbo:Comic">
        <cbo:series>
            <rdf:Description>
                <xsl:call-template name="Publisher"></xsl:call-template>
                <xsl:apply-templates select="cbo:country"></xsl:apply-templates>
                <xsl:apply-templates select="cbo:seriesTitle"></xsl:apply-templates>
                <xsl:apply-templates select="cbo:seriesYear"></xsl:apply-templates>
                <xsl:call-template name="Volume"></xsl:call-template>
            </rdf:Description>
        </cbo:series>
    </xsl:template>
  
    <!-- Volume -->
    
    <xsl:template name="Volume" match="cbo:Comic">
        <cbo:volume>
            <rdf:Description>
                <xsl:apply-templates select="cbo:volumeNumber"></xsl:apply-templates>
          
                <xsl:call-template name="Issue"></xsl:call-template>
            </rdf:Description>
        </cbo:volume>
    </xsl:template>

    <!-- Issue -->
    
    <xsl:template name="Issue" match="cbo:Comic">
        <xsl:variable name="data" select="cbo:issueNumber|cbo:language|cbo:format|cbo:edition|cbo:printing|variance"></xsl:variable>
        <cbo:issue>
            <rdf:Description>
                <xsl:apply-templates select="cbo:issueNumber"></xsl:apply-templates>
                <xsl:apply-templates select="cbo:format"></xsl:apply-templates>
                <xsl:apply-templates select="cbo:edition"></xsl:apply-templates>
                <xsl:apply-templates select="cbo:printing"></xsl:apply-templates>
                <xsl:apply-templates select="cbo:variance"></xsl:apply-templates>
                <xsl:call-template name="Copy"></xsl:call-template>
            </rdf:Description>
        </cbo:issue>
    </xsl:template>
  
    <!-- Copy -->
    
    <xsl:template name="Copy" match="cbo:Comic">
        <xsl:variable name="data" select="cbo:condition|cbo:grade|cbo:certNumber"></xsl:variable>
        <xsl:if test="$data">
            <cbo:copy>
                <rdf:Description>
                    <xsl:apply-templates select="cbo:condition"></xsl:apply-templates>
                    <xsl:apply-templates select="cbo:grade"></xsl:apply-templates>
                    <xsl:apply-templates select="cbo:certNumber"></xsl:apply-templates>
                </rdf:Description>
            </cbo:copy>
        </xsl:if>
    </xsl:template>
   
    <!-- // PROPERTIES -->
  
    <!-- publisherName -->
    
    <xsl:template match="cbo:publisherName">
        <xsl:if test=".">
            <cbo:publisherName>
                <xsl:value-of select="."/>
            </cbo:publisherName>
        </xsl:if>
    </xsl:template>

    <!-- imprintName -->
    
    <xsl:template match="cbo:imprintName">
        <xsl:if test=".">
            <cbo:imprint>
                <rdf:Description>
                    <cbo:imprintName>
                        <xsl:value-of select="."/>
                    </cbo:imprintName>
                </rdf:Description>
            </cbo:imprint>
        </xsl:if>
    </xsl:template>

    <!-- country -->
  
    <xsl:template match="cbo:country">
        <xsl:variable name="id">
            <xsl:call-template name="getCountryId">
                <xsl:with-param name="input" select="."></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not($id = '')">
                <cbo:country rdf:resource="{$id}" />
            </xsl:when>
            <xsl:otherwise>
                <cbo:country>
                    <xsl:value-of select="."/>
                </cbo:country>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- language -->

    <xsl:template match="cbo:language">
        <xsl:variable name="id">
            <xsl:call-template name="getLanguageId">
                <xsl:with-param name="input" select="."></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not($id = '')">
                <cbo:language rdf:resource="{$id}" />
            </xsl:when>
            <xsl:otherwise>
                <cbo:language>
                    <xsl:value-of select="."/>
                </cbo:language>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- seriesTitle -->
  
    <xsl:template match="cbo:seriesTitle">
        <cbo:seriesTitle>
            <xsl:value-of select="."/>
        </cbo:seriesTitle>
    </xsl:template>

    <!-- seriesYear -->
  
    <xsl:template match="cbo:seriesYear">
        <cbo:seriesYear>
            <xsl:value-of select="."/>
        </cbo:seriesYear>
    </xsl:template>
  
    <!-- volumeNumber -->
  
    <xsl:template match="cbo:volumeNumber">
        <cbo:volumeNumber>
            <xsl:value-of select="."/>
        </cbo:volumeNumber>
    </xsl:template>

    <!-- issueNumber -->

    <xsl:template match="cbo:issueNumber">
        <cbo:issueNumber>
            <xsl:value-of select="."/>
        </cbo:issueNumber>
    </xsl:template>

    <!-- format -->

    <xsl:template match="cbo:format">
        <xsl:variable name="id">
            <xsl:call-template name="getFormatId">
                <xsl:with-param name="input" select="."></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not($id = '')">
                <cbo:format rdf:resource="{$id}" />
            </xsl:when>
            <xsl:otherwise>
                <cbo:format>
                    <xsl:value-of select="."/>
                </cbo:format>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- edition -->

    <xsl:template match="cbo:edition">
        <xsl:variable name="id">
            <xsl:call-template name="getEditionId">
                <xsl:with-param name="input" select="."></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not($id = '')">
                <cbo:edition rdf:resource="{$id}" />
            </xsl:when>
            <xsl:otherwise>
                <cbo:edition>
                    <xsl:value-of select="."/>
                </cbo:edition>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- printing -->

    <xsl:template match="cbo:printing">
        <cbo:printing>
            <xsl:value-of select="."/>
        </cbo:printing>
    </xsl:template>

    <!-- variance -->

    <xsl:template match="cbo:variance">
        <cbo:variance>
            <xsl:value-of select="."/>
        </cbo:variance>
    </xsl:template>

    <!-- condition -->

    <xsl:template match="cbo:condition">
        <xsl:variable name="id">
            <xsl:call-template name="getConditionId">
                <xsl:with-param name="input" select="."></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not($id = '')">
                <cbo:condition rdf:resource="{$id}" />
            </xsl:when>
            <xsl:otherwise>
                <cbo:condition>
                    <xsl:value-of select="."/>
                </cbo:condition>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- grade -->

    <xsl:template match="cbo:grade">
        <xsl:variable name="id">
            <xsl:call-template name="getGradeId">
                <xsl:with-param name="input" select="."></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not($id = '')">
                <cbo:grade rdf:resource="{$id}" />
            </xsl:when>
            <xsl:otherwise>
                <cbo:grade>
                    <xsl:value-of select="."/>
                </cbo:grade>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- certNumber -->

    <xsl:template match="cbo:certNumber">
        <cbo:certNumber>
            <xsl:value-of select="."/>
        </cbo:certNumber>
    </xsl:template>

    <!-- // FUNCTIONS -->

    <!-- getPublisherId -->

    <xsl:template name="getPublisherId">
        <xsl:param name="input"></xsl:param>
        <xsl:variable name="viaf" select="'http://viaf.org/viaf/'"/>
        <xsl:variable name="data">
            <xsl:call-template name="strLower">
                <xsl:with-param name="input" select="$input"></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="publisher">
            <xsl:value-of select="translate($data, 'comics comic group publisher entertainment', '')"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains('marvel', $publisher)">
                <xsl:value-of select="concat($viaf, '152451185')"/>
            </xsl:when>
            <xsl:when test="contains('dc', $publisher)">
                <xsl:value-of select="concat($viaf, '133815881')"/>
            </xsl:when>
            <xsl:when test="contains('darkhorse dh dhc', $publisher)">
                <xsl:value-of select="concat($viaf, '124653077')"/>
            </xsl:when>
            <xsl:when test="contains('archie', $publisher)">
                <xsl:value-of select="concat($viaf, '125846736')"/>
            </xsl:when>
            <xsl:when test="contains('image', $publisher)">
                <xsl:value-of select="concat($viaf, '152802199')"/>
            </xsl:when>
            <xsl:when test="contains('dynamite', $publisher)">
                <xsl:value-of select="concat($viaf, '254610986')"/>
            </xsl:when>
            <xsl:when test="contains('idw', $publisher)">
                <xsl:value-of select="concat($viaf, '263138289')"/>
            </xsl:when>
            <xsl:when test="contains('harvey', $publisher)">
                <xsl:value-of select="concat($viaf, '151539692')"/>
            </xsl:when>
            <xsl:when test="contains('panini', $publisher)">
                <xsl:value-of select="concat($viaf, '142190500')"/>
            </xsl:when>
            <xsl:when test="contains('tokyopop', $publisher)">
                <xsl:value-of select="concat($viaf, '153968998')"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- getCountryId -->
    
    <xsl:template name="getCountryId">
        <xsl:param name="input"></xsl:param>
        <xsl:variable name="lcGa" select="'http://id.loc.gov/vocabulary/geographicAreas/'"/>
        <xsl:variable name="data">
            <xsl:call-template name="strLower">
                <xsl:with-param name="input" select="$input"></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains('us usa', $data)">
                <xsl:value-of select="concat($lcGa, 'n-us')"/>
            </xsl:when>
            <xsl:when test="contains('no norway', $data)">
                <xsl:value-of select="concat($lcGa, 'e-no')"/>
            </xsl:when>
            <xsl:when test="contains('it italy', $data)">
                <xsl:value-of select="concat($lcGa, 'e-it')"/>
            </xsl:when>
            <xsl:when test="contains('uk united kingdom britain', $data)">
                <xsl:value-of select="concat($lcGa, 'e-uk')"/>
            </xsl:when>
            <xsl:when test="contains('ge gx germany', $data)">
                <xsl:value-of select="concat($lcGa, 'e-gx')"/>
            </xsl:when>
            <xsl:when test="contains('ne netherlands', $data)">
                <xsl:value-of select="concat($lcGa, 'e-ne')"/>
            </xsl:when>
            <xsl:when test="contains('sw sweden', $data)">
                <xsl:value-of select="concat($lcGa, 'e-sw')"/>
            </xsl:when>
            <xsl:when test="contains('be belgium', $data)">
                <xsl:value-of select="concat($lcGa, 'e-be')"/>
            </xsl:when>
            <xsl:when test="contains('be belgium', $data)">
                <xsl:value-of select="concat($lcGa, 'e-be')"/>
            </xsl:when>
            <xsl:when test="contains('ca canada', $data)">
                <xsl:value-of select="concat($lcGa, 'n-cn')"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- getLanguageId -->
    
    <xsl:template name="getLanguageId">
        <xsl:param name="input"></xsl:param>
        <xsl:variable name="lcIso639" select="'http://id.loc.gov/vocabulary/iso639-2/'"/>
        <xsl:variable name="data">
            <xsl:call-template name="strLower">
                <xsl:with-param name="input" select="$input"></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains('en eng english', $data)">
                <xsl:value-of select="concat($lcIso639, 'eng')"/>
            </xsl:when>
            <xsl:when test="contains('nor norwegian', $data)">
                <xsl:value-of select="concat($lcIso639, 'nor')"/>
            </xsl:when>
            <xsl:when test="contains('ita italian', $data)">
                <xsl:value-of select="concat($lcIso639, 'ita')"/>
            </xsl:when>
            <xsl:when test="contains('ger german', $data)">
                <xsl:value-of select="concat($lcIso639, 'ger')"/>
            </xsl:when>
            <xsl:when test="contains('dut dutch', $data)">
                <xsl:value-of select="concat($lcIso639, 'dut')"/>
            </xsl:when>
            <xsl:when test="contains('fr fra french', $data)">
                <xsl:value-of select="concat($lcIso639, 'fra')"/>
            </xsl:when>
            <xsl:when test="contains('swe swedish', $data)">
                <xsl:value-of select="concat($lcIso639, 'swe')"/>
            </xsl:when>
            <xsl:when test="contains('spa spanish', $data)">
                <xsl:value-of select="concat($lcIso639, 'spa')"/>
            </xsl:when>
            <xsl:when test="contains('por portugese', $data)">
                <xsl:value-of select="concat($lcIso639, 'por')"/>
            </xsl:when>
            <xsl:when test="contains('pol polish', $data)">
                <xsl:value-of select="concat($lcIso639, 'pol')"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- getFormatId -->
    
    <xsl:template name="getFormatId">
        <xsl:param name="input"></xsl:param>
        <xsl:variable name="data">
            <xsl:call-template name="strLower">
                <xsl:with-param name="input" select="$input"></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="contains('bw b&amp;w blackandwhite', $data)">
                <xsl:value-of select="concat($cbv, 'DigitalComic')"/>
            </xsl:when>
            <xsl:when test="contains('digital digitalcomic', $data)">
                <xsl:value-of select="concat($cbv, 'DigitalComic')"/>
            </xsl:when>
            <xsl:when test="contains('gn graphicnovel', $data)">
                <xsl:value-of select="concat($cbv, 'GraphicNovel')"/>
            </xsl:when>
            <xsl:when test="contains('mm mmpb massmarket massmarketpaperback', $data)">
                <xsl:value-of select="concat($cbv, 'MassMarketPaperback')"/>
            </xsl:when>
            <xsl:when test="contains('print comic comicbook', $data)">
                <xsl:value-of select="concat($cbv, 'ComicBook')"/>
            </xsl:when>
            <xsl:when test="contains('tradepaperback trade tpb tp', $data)">
                <xsl:value-of select="concat($cbv, 'TradePaperback')"/>
            </xsl:when>
            <xsl:when test="contains('web webcomic', $data)">
                <xsl:value-of select="concat($cbv, 'WebComic')"/>
            </xsl:when>
            <xsl:when test="contains('ashcan', $data)">
                <xsl:value-of select="concat($cbv, 'AshCan')"/>
            </xsl:when>
            <xsl:when test="contains('color', $data)">
                <xsl:value-of select="concat($cbv, 'Color')"/>
            </xsl:when>
            <xsl:when test="contains('fanzine', $data)">
                <xsl:value-of select="concat($cbv, 'Fanzine')"/>
            </xsl:when>
            <xsl:when test="contains('fumetti', $data)">
                <xsl:value-of select="concat($cbv, 'Fumetti')"/>
            </xsl:when>
            <xsl:when test="contains('manga', $data)">
                <xsl:value-of select="concat($cbv, 'Manga')"/>
            </xsl:when>
            <xsl:when test="contains('omnibus', $data)">
                <xsl:value-of select="concat($cbv, 'Omnibus')"/>
            </xsl:when>
            <xsl:when test="contains('preview sample', $data)">
                <xsl:value-of select="concat($cbv, 'Preview')"/>
            </xsl:when>
            <xsl:when test="contains('promotional', $data)">
                <xsl:value-of select="concat($cbv, 'Promotional')"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- getEditionId -->

    <xsl:template name="getEditionId">
        <xsl:param name="input"></xsl:param>
        <xsl:variable name="data">
            <xsl:call-template name="strLower">
                <xsl:with-param name="input" select="$input"></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="editions" select="'direct limited newsstand subscription'"></xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($editions, $data)">
                <xsl:variable name="id">
                    <xsl:call-template name="strSentenceCase">
                        <xsl:with-param name="input" select="$data"></xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($cbv, $id)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- getConditionId -->
  
    <xsl:template name="getConditionId">
        <xsl:param name="input"></xsl:param>
        <xsl:variable name="data">
            <xsl:call-template name="strLower">
                <xsl:with-param name="input" select="$input"></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="conditions" select="'fn fn+ fn- fn/vf fn_vf fr fr/gd fr_gd gd gd+ gd- gd/vg gd_vg gm mt nm nm+ nm- nm/mt nm_mt vf vf+ vf- vf/nm vf_nm vg vg+ vg- vg/fn vg_fn'"></xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($conditions, $data)">
                <xsl:variable name="condition">
                    <xsl:call-template name="strUpper">
                        <xsl:with-param name="input" select="$data"></xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($cbv, translate($condition, '/', '_'))"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- getGradeId -->
  
    <xsl:template name="getGradeId">
        <xsl:param name="input"></xsl:param>
        <xsl:variable name="data">
            <xsl:call-template name="strLower">
                <xsl:with-param name="input" select="$input"></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="grades" select="'10.0 9.9 9.8 9.6 9.4 9.2 9.0 8.5 8.0 7.5 7.0 6.5 6.0 5.5 5.0 4.5 4.0 3.5 3.0 2.5 2.0 1.8 1.5 1.0 0.5'"></xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($grades, $data)">
                <xsl:value-of select="concat($cbv, $data)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- // UTILITY -->
  
    <xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

    <!-- strLower -->

    <xsl:template name="strLower">
        <xsl:param name="input"></xsl:param>
        <xsl:value-of select="translate($input, $upper, $lower)"/>
    </xsl:template>

    <!-- strUpper -->
    <xsl:template name="strUpper">
        <xsl:param name="input"></xsl:param>
        <xsl:value-of select="translate($input, $lower, $upper)"/>
    </xsl:template>
  
    <!-- strSentenceCase-->
    <xsl:template name="strSentenceCase">
        <xsl:param name="input"></xsl:param>
        <xsl:value-of select="translate(substring($input,1,1),$lower,$upper)"></xsl:value-of>
        <xsl:value-of select="substring($input,2)"/>
    </xsl:template>
  
</xsl:stylesheet>