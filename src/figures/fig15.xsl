<!--
    NAME         :  Figure 15. An XSLT code snippet (p. 63)
    DATE CREATED :  11/29/2014
    AUTHOR       :  Sean Petiya
    URL          :  http://petiya.com/thesis
-->  

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
