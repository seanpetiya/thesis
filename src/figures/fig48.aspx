<%@ Page Language="C#" %>
<!DOCTYPE html>
<!--
    NAME         : Figure 48. Dynamic content rendered in HTML/RDFa (p. 119)
    DATE CREATED : 11/29/14
    AUTHOR       : Sean Petiya
    URL          : http://petiya.com/thesis
-->
<html>
    <head>
        <title>Figure 48</title>
    </head>
    <body>
        <div vocab="http://comicmeta.org/cbo/">
            <div typeof="Comic">
                <div property="series" typeof="Series" resource='#012345678'>
                    <h1 property="seriesTitle">Amazing Spider-Man (<span property="seriesYear">1963</span>)</h1>
                </div>
            </div>
        </div>
    </body>
</html>