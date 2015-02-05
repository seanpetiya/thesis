<%@ Page Language="C#" %>
<!DOCTYPE html>
<!--
    NAME         :  Figure 47. Dynamic content template example in ASP.NET (p. 119)
    DATE CREATED :  11/29/14
    AUTHOR       :  Sean Petiya
    URL          :  http://petiya.com/thesis
-->
<html>
    <head>
        <title>Figure 47</title>
    </head>
    <body>
        <asp:ListView ID="ComicBook" runat="server">
            <LayoutTemplate>
                <div vocab="http://comicmeta.org/cbo/">
                    <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                </div>
            </LayoutTemplate>
            <ItemTemplate>
                <div typeof="Comic">
                    <div property="series" typeof="Series" resource='<%# string.Format("#{0}", Eval("SeriesId")) %>'>
                        <h1 property="seriesTitle"><%# Eval("SeriesTitle") %> (<span property="seriesYear"><%# Eval("SeriesYear") %></span>)</h1>
                    </div>
                </div>
            </ItemTemplate>
        </asp:ListView>
    </body>
</html>