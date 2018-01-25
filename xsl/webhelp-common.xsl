<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:d="http://docbook.org/ns/docbook"
xmlns:exsl="http://exslt.org/common"
        xmlns:ng="http://docbook.org/docbook-ng"
        xmlns:db="http://docbook.org/ns/docbook"
        version="1.0" xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="exsl ng db d">

    <!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part customization layer on top of the XSL DocBook
     Stylesheet distribution that generates webhelp output.

     ******************************************************************** -->

    <xsl:param name="chunker.output.method">
        <xsl:choose>
            <xsl:when test="contains(system-property('xsl:vendor'), 'SAXON 6')">saxon:xhtml</xsl:when>
            <xsl:otherwise>html</xsl:otherwise>
        </xsl:choose>
    </xsl:param>

    <xsl:param name="doc.title">
      <xsl:call-template name="get.doc.title"/>
    </xsl:param>

    <!-- Set some reasonable defaults for webhelp output -->
    <xsl:param name="webhelp.common.dir">common/</xsl:param>
    <xsl:param name="chunker.output.indent">yes</xsl:param>
    <xsl:param name="navig.showtitles">1</xsl:param>
    <xsl:param name="manifest.in.base.dir" select="0"/>
    <xsl:param name="base.dir" select="concat($webhelp.base.dir,'/')"/>
    <xsl:param name="suppress.navigation">0</xsl:param>
    <!-- Generate the end-of-the-book index -->
    <xsl:param name="generate.index" select="0"/>
    <xsl:param name="inherit.keywords" select="'1'"/>
    <xsl:param name="para.propagates.style" select="1"/>
    <xsl:param name="phrase.propagates.style" select="1"/>
    <xsl:param name="chunk.first.sections" select="1"/>
    <xsl:param name="chunk.section.depth" select="1"/>
    <xsl:param name="use.id.as.filename" select="1"/>
    <xsl:param name="branding">not set</xsl:param>
    <xsl:param name="brandname">Rudder</xsl:param>

    <xsl:param name="section.autolabel" select="0"/>
    <xsl:param name="chapter.autolabel" select="0"/>
    <xsl:param name="appendix.autolabel" select="0"/>
    <xsl:param name="qandadiv.autolabel" select="0"/>
    <xsl:param name="reference.autolabel" select="0"/>
    <xsl:param name="part.autolabel" select="0"/>
    <xsl:param name="section.label.includes.component.label" select="1"/>

    <xsl:param name="generate.section.toc.level" select="1"/>
    <xsl:param name="component.label.includes.part.label" select="1"/>
    <xsl:param name="suppress.footer.navigation">0</xsl:param>
    <xsl:param name="callout.graphics.path"><xsl:value-of select="$webhelp.common.dir"/>images/callouts/</xsl:param>
    <xsl:param name="callouts.extension">1</xsl:param>
    <xsl:param name="admon.graphics.path"><xsl:value-of select="$webhelp.common.dir"/>images/admon-icons/</xsl:param>
    <xsl:param name="admon.graphics" select="1"/>
    <!--xsl:param name="generate.toc">book toc</xsl:param-->
    <xsl:param name="webhelp.include.search.tab" select="0"/>

<xsl:param name="generate.toc">
appendix  toc,title
article/appendix  nop
article   toc,title
chapter   toc,title
part      toc,title
preface   toc,title
qandadiv  toc
qandaset  toc
reference toc,title
sect1     toc
sect2     toc
sect3     toc
sect4     toc
sect5     toc
section   toc,title
set       toc,title
</xsl:param>

    <!-- Localizations of webhelp specific words. Your contributions for other languages are appreciated.
	Currently, only around 10 translations needed. -->
    <!-- Moved to files under 'gentext/locale/', search for WebHelp -->
    <xsl:template match="processing-instruction('asciidoc-hr')">
      <hr/>
    </xsl:template>
    <xsl:template name="user.head.title">
      <xsl:param name="node" select="."/>
      <xsl:param name="title">
	<xsl:apply-templates select="$node" mode="object.title.markup.textonly"/>
      </xsl:param>
      <xsl:param name="document-title">
	<xsl:apply-templates select="/*" mode="object.title.markup.textonly"/>
      </xsl:param>

      <title>
	        <xsl:copy-of select="$title"/><xsl:if test="parent::*"> - <xsl:copy-of select="$document-title"/></xsl:if>
       </title>

    </xsl:template>

  <xsl:template name="system.head.content">
  <xsl:param name="node" select="."/>
<xsl:text>
</xsl:text>
       <!--
The meta tag tells the IE rendering engine that it should use the latest, or edge, version of the IE rendering environment;It prevents IE from entring compatibility mode.
 -->
       <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <xsl:text>
</xsl:text>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <xsl:text>
</xsl:text>
    </xsl:template>

    <!-- HTML <head> section customizations -->
    <xsl:template name="user.head.content">
        <xsl:param name="title">
                <xsl:apply-templates select="." mode="object.title.markup.textonly"/>
        </xsl:param>
         <meta name="Section-title" content="{$title}"/>

        <!--  <xsl:message>
            webhelp.tree.cookie.id = <xsl:value-of select="$webhelp.tree.cookie.id"/> +++ <xsl:value-of select="count(//node())"/>
            $webhelp.indexer.language = <xsl:value-of select="$webhelp.indexer.language"/> +++ <xsl:value-of select="count(//node())"/>
        </xsl:message>-->
        <script type="text/javascript">
            //The id for tree cookie
            var treeCookieId = "<xsl:value-of select="$webhelp.tree.cookie.id"/>";
            var language = "<xsl:value-of select="$webhelp.indexer.language"/>";
            var w = new Object();
            //Localization
            txt_filesfound = '<xsl:call-template name="gentext.template">
                <xsl:with-param name="name" select="'txt_filesfound'"/>
		<xsl:with-param name="context" select="'webhelp'"/>
                </xsl:call-template>';
            txt_enter_at_least_1_char = "<xsl:call-template name="gentext.template">
                <xsl:with-param name="name" select="'txt_enter_at_least_1_char'"/>
		<xsl:with-param name="context" select="'webhelp'"/>
                </xsl:call-template>";
            txt_browser_not_supported = "<xsl:call-template name="gentext.template">
                <xsl:with-param name="name" select="'txt_browser_not_supported'"/>
		<xsl:with-param name="context" select="'webhelp'"/>
                </xsl:call-template>";
            txt_please_wait = "<xsl:call-template name="gentext.template">
                <xsl:with-param name="name" select="'txt_please_wait'"/>
		<xsl:with-param name="context" select="'webhelp'"/>
                </xsl:call-template>";
            txt_results_for = "<xsl:call-template name="gentext.template">
                <xsl:with-param name="name" select="'txt_results_for'"/>
		<xsl:with-param name="context" select="'webhelp'"/>
                </xsl:call-template>";
        </script>

<!-- kasunbg: Order is important between the in-html-file css and the linked css files. Some css declarations in jquery-ui-1.8.2.custom.css are over-ridden.
     If that's a concern, just remove the additional css contents inside these default jquery css files. I thought of keeping them intact for easier maintenance! -->
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon"/>
        <link rel="stylesheet" type="text/css" href="common/css/positioning.css"/>
        <link rel="stylesheet" type="text/css" href="common/jquery/theme-redmond/jquery-ui-1.8.2.custom.css"/>
        <link rel="stylesheet" type="text/css" href="common/jquery/treeview/jquery.treeview.css"/>
        <link rel="stylesheet" type="text/css" href="common/LatoLatin/latolatinfonts.css"/>

        <style type="text/css">

#noscript{
    font-weight:bold;
	background-color: #55AA55;
    font-weight: bold;
    height: 25spx;
    z-index: 3000;
	top:0px;
	width:100%;
	position: relative;
	border-bottom: solid 5px black;
	text-align:center;
	color: white;
}

input {
    margin-bottom: 5px;
    margin-top: 2px;
}
.folder {
    display: block;
    height: 22px;
    padding-left: 20px;
    background: transparent url(<xsl:value-of select="$webhelp.common.dir"/>jquery/treeview/images/folder.gif) 0 0px no-repeat;
}
span.contentsTab {
    padding-left: 20px;
    background: url(<xsl:value-of select="$webhelp.common.dir"/>images/toc-icon.png) no-repeat 0 center;
}
span.searchTab {
    padding-left: 20px;
    background: url(<xsl:value-of select="$webhelp.common.dir"/>images/search-icon.png) no-repeat 0 center;
}

/* Overide jquery treeview's defaults for ul. */
.treeview ul {
    background-color: transparent;
    margin-top: 4px;
}
#webhelp-currentid {
    background-color: #FFCA8E !important;
}
.treeview .hover { color: black; }
.filetree li span a { text-decoration: none; font-size: 13px; color: black; }
.filetree li span a:hover { color: #EE7F00; }

/* Override jquery-ui's default css customizations. These are supposed to take precedence over those.*/
.ui-widget-content {
    border: 0px;
    background: none;
    color: none;
}
.ui-widget-header {
    color: #e9e8e9;
    border-left: 1px solid #e5e5e5;
    border-right: 1px solid #e5e5e5;
    border-bottom: 1px solid #bbc4c5;
    border-top: 4px solid #e5e5e5;
    border: medium none;
    background: #F4F4F4; /* old browsers */
    background: -moz-linear-gradient(top, #F4F4F4 0%, #E6E4E5 100%); /* firefox */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#F4F4F4), color-stop(100%,#E6E4E5)); /* webkit */
    font-weight: none;
}
.ui-widget-header a { color: none; }
.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default {
border: none; background: none; font-weight: none; color: none; }
.ui-state-default a, .ui-state-default a:link, .ui-state-default a:visited { color: black; text-decoration: none; }
.ui-state-hover, .ui-widget-content .ui-state-hover, .ui-widget-header .ui-state-hover, .ui-state-focus, .ui-widget-content .ui-state-focus, .ui-widget-header .ui-state-focus { border: none; background: none; font-weight: none; color: none; }

.ui-state-active, .ui-widget-content .ui-state-active, .ui-widget-header .ui-state-active { border: none; background: none; font-weight: none; color: none; }
.ui-state-active a, .ui-state-active a:link, .ui-state-active a:visited {
    color: black; text-decoration: none;
    background: #C6C6C6;
    -webkit-border-radius:15px; -moz-border-radius:10px;
    border: 1px solid #f1f1f1;
}
.ui-corner-all { border-radius: 0 0 0 0; }

.ui-tabs { padding: .2em;}
.ui-tabs .ui-tabs-nav li { top: 0px; margin: -2px 0 1px; text-transform: uppercase; font-size: 10.5px;}
.ui-tabs .ui-tabs-nav li a { padding: .25em 2em .25em 1em; margin: .5em; text-shadow: 0 1px 0 rgba(255,255,255,.5); }
       /**
	 *	Basic Layout Theme
	 *
	 *	This theme uses the default layout class-names for all classes
	 *	Add any 'custom class-names', from options: paneClass, resizerClass, togglerClass
	 */

	.ui-layout-pane { /* all 'panes' */
		background: #fafafa;
		padding: 05x;
		overflow: auto;
	}

	.ui-layout-resizer { /* all 'resizer-bars' */
		background: #DDD;
                top:100px
	}

	.ui-layout-toggler { /* all 'toggler-buttons' */
		background: #AAA;
	}

       </style>
        <xsl:comment><xsl:text>[if IE]>
	&lt;link rel="stylesheet" type="text/css" href="../common/css/ie.css"/>
	&lt;![endif]</xsl:text></xsl:comment>

	<!--
	     browserDetect is an Oxygen addition to warn the user if they're using chrome from the file system.
	     This breaks the Oxygen search highlighting.
	-->
	<script type="text/javascript" src="{$webhelp.common.dir}browserDetect.js">
            <xsl:comment> </xsl:comment>
	</script>
        <script type="text/javascript" src="{$webhelp.common.dir}jquery/jquery-1.7.2.min.js">
            <xsl:comment> </xsl:comment>
        </script>
        <script type="text/javascript" src="{$webhelp.common.dir}jquery/jquery.ui.all.js">
            <xsl:comment> </xsl:comment>
        </script>
        <script type="text/javascript" src="{$webhelp.common.dir}jquery/jquery.cookie.js">
            <xsl:comment> </xsl:comment>
        </script>
        <script type="text/javascript" src="{$webhelp.common.dir}jquery/treeview/jquery.treeview.min.js">
            <xsl:comment> </xsl:comment>
        </script>
         <script type="text/javascript" src="{$webhelp.common.dir}jquery/layout/jquery.layout.js">
            <xsl:comment> </xsl:comment>
        </script>
        <xsl:if test="$webhelp.include.search.tab != '0'">
            <!--Scripts/css stylesheets for Search-->
            <!-- TODO: Why THREE files? There's absolutely no need for having separate files.
		These should have been identified at the optimization phase! -->
            <script type="text/javascript" src="search/l10n.js">
	    <xsl:comment/>
	  </script>
      <script type="text/javascript" src="search/htmlFileInfoList.js">
	      <xsl:comment> </xsl:comment>
	  </script>
	  <script type="text/javascript" src="search/nwSearchFnt.js">
	      <xsl:comment> </xsl:comment>
	  </script>

	  <!--
	     NOTE: Stemmer javascript files should be in format <language>_stemmer.js.
	     For example, for English(en), source should be: "search/stemmers/en_stemmer.js"
	     For country codes, see: http://www.uspto.gov/patft/help/helpctry.htm
	  -->
	  <!--<xsl:message><xsl:value-of select="concat('search/stemmers/',$webhelp.indexer.language,'_stemmer.js')"/></xsl:message>-->
	  <script type="text/javascript" src="{concat('search/stemmers/',$webhelp.indexer.language,'_stemmer.js')}">
	      <xsl:comment>//make this scalable to other languages as well.</xsl:comment>
	  </script>

	  <!--Index Files:
	      Index is broken in to three equal sized(number of index items) files. This is to help parallel downloading
	      of files to make it faster.
		TODO: Generate webhelp index for largest docbook document that can be find, and analyze the file sizes.
		IF the file size is still around ~50KB for a given file, we should consider merging these files together. again.
	  -->
	  <script type="text/javascript" src="search/index-1.js">
	      <xsl:comment> </xsl:comment>
	  </script>
	  <script type="text/javascript" src="search/index-2.js">
	      <xsl:comment> </xsl:comment>
	  </script>
	  <script type="text/javascript" src="search/index-3.js">
	      <xsl:comment> </xsl:comment>
	  </script>
	  <!--End of index files -->
	</xsl:if>
	<xsl:call-template name="user.webhelp.head.content"/>
    </xsl:template>

    <!-- This is for the USERS. Users who want to customize webhelp may over-ride this template to add content to <head>. -->
    <xsl:template name="user.webhelp.head.content"/>

    <xsl:template name="user.header.navigation">
        <xsl:param name="prev"/>
        <xsl:param name="next"/>
        <xsl:param name="nav.context"/>
        <xsl:call-template name="webhelpheader">
            <xsl:with-param name="prev" select="$prev"/>
            <xsl:with-param name="next" select="$next"/>
            <xsl:with-param name="nav.context" select="$nav.context"/>
        </xsl:call-template>
        <!--xsl:call-template name="webhelptoc"/-->

        <!--testing toc in the content page>
        <xsl:call-template name="webhelptoctoc"/>
        <xsl:if test="$webhelp.include.search.tab != '0'">
            <xsl:call-template name="search"/>
        </xsl:if-->
    </xsl:template>

    <xsl:template name="user.header.content">
        <xsl:comment> <!-- KEEP this code. --> </xsl:comment>
    </xsl:template>

    <xsl:template name="user.footer.navigation">
    	<xsl:call-template name="webhelptoc">
		  <xsl:with-param name="currentid" select="generate-id(.)"/>
	     </xsl:call-template>
    </xsl:template>

  <xsl:template match="/">
	<xsl:message>language: <xsl:value-of select="$webhelp.indexer.language"/> </xsl:message>
	<!-- * Get a title for current doc so that we let the user -->
	<!-- * know what document we are processing at this point. -->
	<xsl:choose>

	  <!-- include extra test for Xalan quirk -->
	  <xsl:when test="namespace-uri(*[1]) != 'http://docbook.org/ns/docbook'">
 <xsl:call-template name="log.message">
 <xsl:with-param name="level">Note</xsl:with-param>
 <xsl:with-param name="source"><xsl:call-template name="get.doc.title"/></xsl:with-param>
 <xsl:with-param name="context-desc">
 <xsl:text>namesp. add</xsl:text>
 </xsl:with-param>
 <xsl:with-param name="message">
 <xsl:text>added namespace before processing</xsl:text>
 </xsl:with-param>
 </xsl:call-template>
 <xsl:variable name="addns">
    <xsl:apply-templates mode="addNS"/>
  </xsl:variable>
  <xsl:apply-templates select="exsl:node-set($addns)"/>
</xsl:when>
	  <!-- Can't process unless namespace removed -->
	  <xsl:when test="namespace-uri(*[1]) != 'http://docbook.org/ns/docbook'">
 <xsl:call-template name="log.message">
 <xsl:with-param name="level">Note</xsl:with-param>
 <xsl:with-param name="source"><xsl:call-template name="get.doc.title"/></xsl:with-param>
 <xsl:with-param name="context-desc">
 <xsl:text>namesp. add</xsl:text>
 </xsl:with-param>
 <xsl:with-param name="message">
 <xsl:text>added namespace before processing</xsl:text>
 </xsl:with-param>
 </xsl:call-template>
 <xsl:variable name="addns">
    <xsl:apply-templates mode="addNS"/>
  </xsl:variable>
  <xsl:apply-templates select="exsl:node-set($addns)"/>
</xsl:when>
	  <xsl:otherwise>
		<xsl:choose>
		  <xsl:when test="$rootid != ''">
			<xsl:choose>
			  <xsl:when test="count(key('id',$rootid)) = 0">
				<xsl:message terminate="yes">
				  <xsl:text>ID '</xsl:text>
				  <xsl:value-of select="$rootid"/>
				  <xsl:text>' not found in document.</xsl:text>
				</xsl:message>
			  </xsl:when>
			  <xsl:otherwise>
				<xsl:if test="$collect.xref.targets = 'yes' or                             $collect.xref.targets = 'only'">
				  <xsl:apply-templates select="key('id', $rootid)" mode="collect.targets"/>
				</xsl:if>
				<xsl:if test="$collect.xref.targets != 'only'">
				  <xsl:apply-templates select="key('id',$rootid)" mode="process.root"/>
				  <xsl:if test="$tex.math.in.alt != ''">
					<xsl:apply-templates select="key('id',$rootid)" mode="collect.tex.math"/>
                                  </xsl:if>
				</xsl:if>
			  </xsl:otherwise>
			</xsl:choose>
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:if test="$collect.xref.targets = 'yes' or                         $collect.xref.targets = 'only'">
			  <xsl:apply-templates select="/" mode="collect.targets"/>
			</xsl:if>
			<xsl:if test="$collect.xref.targets != 'only'">
			  <xsl:apply-templates select="/" mode="process.root"/>
			  <xsl:if test="$tex.math.in.alt != ''">
              <xsl:apply-templates select="/" mode="collect.tex.math"/>
            </xsl:if>
          </xsl:if>
		  </xsl:otherwise>
		</xsl:choose>
	  </xsl:otherwise>
	</xsl:choose>


	<xsl:call-template name="l10n.js"/>
    </xsl:template>


    <!-- The WebHelp output structure. similar to main() method.
	basic format:
	<html>
		<head> calls-appropriate-template </head>
		<body>
   		       some-generic-content
		       <div id="content">
		       		All your docbook document content goes here
				....
		       </div>
		       some-other-generic-content-at-footer
		</body>
	</html>
    -->
    <xsl:template name="chunk-element-content">
        <xsl:param name="prev"/>
        <xsl:param name="next"/>
        <xsl:param name="nav.context"/>
        <xsl:param name="content">
            <xsl:apply-imports/>
        </xsl:param>

        <xsl:call-template name="user.preroot"/>

        <html>
            <xsl:call-template name="html.head">
                <xsl:with-param name="prev" select="$prev"/>
                <xsl:with-param name="next" select="$next"/>
            </xsl:call-template>

            <body>
                <noscript>
                    <div id="noscript">

                        <xsl:call-template name="gentext.template">
                            <xsl:with-param name="name" select="'txt_browser_not_supported'"/>
                            <xsl:with-param name="context" select="'webhelp'"/>
                        </xsl:call-template>

                    </div>
                </noscript>

                <xsl:call-template name="body.attributes"/>

                <xsl:call-template name="user.header.navigation">
                    <xsl:with-param name="prev" select="$prev"/>
                    <xsl:with-param name="next" select="$next"/>
                    <xsl:with-param name="nav.context" select="$nav.context"/>
                </xsl:call-template>

                <div id="content">

                    <xsl:call-template name="user.header.content"/>

                    <xsl:copy-of select="$content"/>

                    <xsl:call-template name="user.footer.content"/>

					<!-- Redundant since the upper navigation bar always visible -->
                    <xsl:call-template name="footer.navigation">
                        <xsl:with-param name="prev" select="$prev"/>
                        <xsl:with-param name="next" select="$next"/>
                        <xsl:with-param name="nav.context" select="$nav.context"/>
                    </xsl:call-template>

		    <xsl:call-template name="user.webhelp.content.footer"/>
                </div>

                <xsl:call-template name="user.footer.navigation"/>
                <xsl:choose><xsl:when test="$webhelp.include.search.tab = '0'">
                  <script type="text/javascript" src="https://cdn.jsdelivr.net/docsearch.js/1/docsearch.min.js"></script> 
                  <script type="text/javascript"> docsearch({
                    apiKey: '339fdb9d06e694d14046ad9a5cd4fbb3',
                    indexName: 'rudder_project',
                    inputSelector: '#searchfield',
                    algoliaOptions: {
                      'hitsPerPage': 5,
                      'facetFilters': '(tags:v4.3)'
                    }
                  }); 
                  </script>
                </xsl:when></xsl:choose>
            </body>
        </html>
        <xsl:value-of select="$chunk.append"/>
    </xsl:template>

    <!-- This is for the USERS. Users who want to customize webhelp may over-ride this template to add content to the footer of the content DIV.
  	 i.e. within <div id="content"> ... </div> -->
    <xsl:template name="user.webhelp.content.footer"/>

    <!-- The Header with the company logo -->
    <xsl:template name="webhelpheader">
        <xsl:param name="prev"/>
        <xsl:param name="next"/>
        <xsl:param name="nav.context"/>

        <xsl:variable name="home" select="/*[1]"/>
        <xsl:variable name="up" select="parent::*"/>

        <div id="header">
  	    <xsl:call-template name="webhelpheader.logo"/>
            <!-- Display the page title and the main heading(parent) of it-->
            <h1>
              <span class="bigtitle"><xsl:apply-templates select="/*[1]" mode="title.markup"/></span>
	      <span>
                <xsl:choose>
                    <xsl:when
			test="count($up) &gt; 0 and generate-id($up) != generate-id($home)">
		      <xsl:apply-templates select="$up" mode="object.title.markup"/>
		    </xsl:when>
		    <xsl:when test="not(generate-id(.) = generate-id(/*))">
		      <xsl:apply-templates select="." mode="object.title.markup"/>
		    </xsl:when>
                    <xsl:otherwise>&#160;</xsl:otherwise>
                </xsl:choose></span>
	    </h1>

      <xsl:call-template name="otherlinks"/>
    <xsl:choose><xsl:when test="$webhelp.include.search.tab = '0'">
        <xsl:call-template name="searchbox"/>
      </xsl:when></xsl:choose>
            <!-- Prev and Next links generation-->
            <div id="navheader">
	      <xsl:call-template name="user.webhelp.navheader.content"/>
                <xsl:comment>
                    <!-- KEEP this code. In case of neither prev nor next links are available, this will help to
                        keep the integrity of the DOM tree-->
                </xsl:comment>
                <!--xsl:with-param name="prev" select="$prev"/>
                <xsl:with-param name="next" select="$next"/>
                <xsl:with-param name="nav.context" select="$nav.context"/-->
                <table class="navLinks">
                    <tr>
                        <td>
                            <a id="showHideButton" href="#" onclick="myLayout.toggle('west')"
                                class="pointLeft" tabindex="5" title="Hide TOC tree">Sidebar
                            </a>
                        </td>
                        <xsl:if test="count($prev) &gt; 0
                            or (count($up) &gt; 0
                            and generate-id($up) != generate-id($home)
                            and $navig.showtitles != 0)
                            or count($next) &gt; 0">
                            <td>
                                <xsl:if test="count($prev)>0">
                                    <a accesskey="p" class="navLinkPrevious" tabindex="5">
                                        <xsl:attribute name="href">
                                            <xsl:call-template name="href.target">
                                                <xsl:with-param name="object" select="$prev"/>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                        <xsl:call-template name="navig.content">
                                            <xsl:with-param name="direction" select="'prev'"/>
                                        </xsl:call-template>
                                    </a>
                                </xsl:if>

                                <!-- "Up" link-->
                                <xsl:choose>
                                    <xsl:when test="count($up)&gt;0
                                              and generate-id($up) != generate-id($home)">
                                        |
                                        <a accesskey="u" class="navLinkUp" tabindex="5">
                                            <xsl:attribute name="href">
                                                <xsl:call-template name="href.target">
                                                    <xsl:with-param name="object" select="$up"/>
                                                </xsl:call-template>
                                            </xsl:attribute>
                                            <xsl:call-template name="navig.content">
                                                <xsl:with-param name="direction" select="'up'"/>
                                            </xsl:call-template>
                                        </a>
                                    </xsl:when>
                                    <xsl:otherwise>&#160;</xsl:otherwise>
                                </xsl:choose>

                                <xsl:if test="count($next)>0">
                                    |
                                    <a accesskey="n" class="navLinkNext" tabindex="5">
                                        <xsl:attribute name="href">
                                            <xsl:call-template name="href.target">
                                                <xsl:with-param name="object" select="$next"/>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                        <xsl:call-template name="navig.content">
                                            <xsl:with-param name="direction" select="'next'"/>
                                        </xsl:call-template>
                                    </a>
                                </xsl:if>
                            </td>
                        </xsl:if>
                    </tr>
                </table>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="webhelpheader.logo">
	<a href="index.html">
	<img style='margin-right: 2px; height: 70px; padding-right: 25px;' align="right"
	    src='{$webhelp.common.dir}images/logo_Rudder.svg' alt="{$brandname} Documentation"/>
	</a>
    </xsl:template>
    
    <xsl:template name="searchbox">
    <div id="searchbox">
    <span class="algolia-autocomplete">
        <input type="text" size="35" id="searchfield" name="search" placeholder="Search the docs..." />
    </span>
    </div>
    </xsl:template>

    <xsl:template name="user.webhelp.navheader.content"/>

    <xsl:template name="webhelptoc">
        <xsl:param name="currentid"/>
        <xsl:choose>
            <xsl:when test="$rootid != ''">
                <xsl:variable name="title">
                    <xsl:if test="$webhelp.autolabel=1">
                        <xsl:variable name="label.markup">
                            <xsl:apply-templates select="key('id',$rootid)" mode="label.markup"/>
                        </xsl:variable>
                        <xsl:if test="normalize-space($label.markup)">
                            <xsl:value-of select="concat($label.markup,$autotoc.label.separator)"/>
                        </xsl:if>
                    </xsl:if>
                    <xsl:apply-templates select="key('id',$rootid)" mode="titleabbrev.markup"/>
                </xsl:variable>
                <xsl:variable name="href">
                    <xsl:choose>
                        <xsl:when test="$manifest.in.base.dir != 0">
                            <xsl:call-template name="href.target">
                                <xsl:with-param name="object" select="key('id',$rootid)"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="href.target.with.base.dir">
                                <xsl:with-param name="object" select="key('id',$rootid)"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
            </xsl:when>

            <xsl:otherwise>
                <xsl:variable name="title">
                    <xsl:if test="$webhelp.autolabel=1">
                        <xsl:variable name="label.markup">
                            <xsl:apply-templates select="/*" mode="label.markup"/>
                        </xsl:variable>
                        <xsl:if test="normalize-space($label.markup)">
                            <xsl:value-of select="concat($label.markup,$autotoc.label.separator)"/>
                        </xsl:if>
                    </xsl:if>
                    <xsl:apply-templates select="/*" mode="titleabbrev.markup"/>
                </xsl:variable>
                <xsl:variable name="href">
                    <xsl:choose>
                        <xsl:when test="$manifest.in.base.dir != 0">
                            <xsl:call-template name="href.target">
                                <xsl:with-param name="object" select="/"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="href.target.with.base.dir">
                                <xsl:with-param name="object" select="/"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
              
                <div id="sidebar"> <!--#sidebar id is used for showing and hiding the side bar -->
                    <div id="leftnavigation" style="padding-top:3px;">
                        <div id="tabs">
                            <ul>
                              <xsl:choose><xsl:when test="$webhelp.include.search.tab != '0'">
                                <li>
                                    <a href="#treeDiv" style="outline:0;" tabindex="1">
                                        <span class="contentsTab">
                                            <xsl:call-template name="gentext.template">
                                                <xsl:with-param name="name" select="'TableofContents'"/>
						<xsl:with-param name="context" select="'webhelp'"/>
                                            </xsl:call-template>
                                        </span>
                                    </a>
                                </li>
                                <xsl:if test="$webhelp.include.search.tab != '0'">
                                    <li>
                                        <a href="#searchDiv" style="outline:0;" tabindex="1" onclick="doSearch()">
                                            <span class="searchTab">
                                                <xsl:call-template name="gentext.template">
                                                    <xsl:with-param name="name" select="'Search'"/>
						    <xsl:with-param name="context" select="'webhelp'"/>
                                                </xsl:call-template>
                                            </span>
                                        </a>
                                    </li>
                                </xsl:if>
				<xsl:call-template name="user.webhelp.tabs.title"/>
                              </xsl:when></xsl:choose>
                            </ul>
                            <div id="treeDiv">
                                <img src="{$webhelp.common.dir}images/loading.gif" alt="loading table of contents..."
                                     id="tocLoading" style="display:block;"/>
                                <div id="ulTreeDiv" style="display:none">
                                    <ul id="tree" class="filetree">
                                        <xsl:apply-templates select="/*/*" mode="webhelptoc">
                                            <xsl:with-param name="currentid" select="$currentid"/>
                                        </xsl:apply-templates>
                                    </ul>
                                </div>

                            </div>
                            <xsl:if test="$webhelp.include.search.tab != '0'">
                                <div id="searchDiv">
                                    <div id="search">
                                        <form onsubmit="Verifie(searchForm);return false"
                                            name="searchForm" class="searchForm">
                                            <div>

<!--                                                    <xsl:call-template name="gentext.template">
                                                        <xsl:with-param name="name" select="'Search'"/>
							<xsl:with-param name="context" select="'webhelp'"/>
                                                    </xsl:call-template>-->


                                                    <input id="textToSearch" name="textToSearch" type="search" placeholder="Search"
                                                           class="searchText" tabindex="1"/>
                                                    <xsl:text disable-output-escaping="yes"> <![CDATA[&nbsp;]]> </xsl:text>
                                                    <input onclick="Verifie(searchForm)" type="button"
                                                           class="searchButton"
                                                           value="Go" id="doSearch" tabindex="1"/>

                                            </div>
                                        </form>
                                    </div>
                                    <div id="searchResults">
                                           <center> </center>
                                    </div>
                                    <p class="searchHighlight"><a href="#" onclick="toggleHighlight()">Search Highlighter (On/Off)</a></p>
                                </div>
                            </xsl:if>
			    <xsl:call-template name="user.webhelp.tabs.content"/>
                        </div>
                    </div>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Hooks for adding customs tabs -->
    <xsl:template name="user.webhelp.tabs.title"/>
    <xsl:template name="user.webhelp.tabs.content"/>

    <!-- Generates the webhelp table-of-contents (TOC). -->
    <xsl:template
            match="d:book|d:part|d:reference|d:preface|d:chapter|d:bibliography|d:appendix|d:article|d:topic|d:glossary|d:section|d:simplesect|d:sect1|d:sect2|d:sect3|d:sect4|d:sect5|d:refentry|d:colophon|d:bibliodiv|d:index|d:setindex"
            mode="webhelptoc">
        <xsl:param name="currentid"/>
        <xsl:variable name="title">
            <xsl:if test="$webhelp.autolabel=1">
                <xsl:variable name="label.markup">
                    <xsl:apply-templates select="." mode="label.markup"/>
                </xsl:variable>
                <xsl:if test="normalize-space($label.markup)">
                    <xsl:value-of select="concat($label.markup,$autotoc.label.separator)"/>
                </xsl:if>
            </xsl:if>
            <xsl:apply-templates select="." mode="titleabbrev.markup"/>
        </xsl:variable>

        <xsl:variable name="href">
            <xsl:choose>
                <xsl:when test="$manifest.in.base.dir != 0">
                    <xsl:call-template name="href.target"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="href.target.with.base.dir"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="id" select="generate-id(.)"/>

        <xsl:if test="not(self::d:index) or (self::d:index and not($generate.index = 0))">
            <!--li style="white-space: pre; line-height: 0em;"-->
            <li>
                <xsl:if test="$id = $currentid">
                    <xsl:attribute name="id">webhelp-currentid</xsl:attribute>
                </xsl:if>
                <span class="file">
                    <a href="{substring-after($href, $base.dir)}"  tabindex="1">
                        <xsl:value-of select="$title"/>
                    </a>
                </span>
                <xsl:if test="d:part|d:reference|d:preface|d:chapter|d:bibliography|d:appendix|d:article|d:topic|d:glossary|d:section|d:simplesect|d:sect1|d:sect2|d:sect3|d:sect4|d:sect5|d:refentry|d:colophon|d:bibliodiv">
                    <ul>
                        <xsl:apply-templates
                                select="d:part|d:reference|d:preface|d:chapter|d:bibliography|d:appendix|d:article|d:topic|d:glossary|d:section|d:simplesect|d:sect1|d:sect2|d:sect3|d:sect4|d:sect5|d:refentry|d:colophon|d:bibliodiv"
                                mode="webhelptoc">
                            <xsl:with-param name="currentid" select="$currentid"/>
                        </xsl:apply-templates>
                    </ul>
                </xsl:if>
            </li>
        </xsl:if>
    </xsl:template>

    <xsl:template match="text()" mode="webhelptoc"/>

    <xsl:template name="user.footer.content">
        <script type="text/javascript" src="{$webhelp.common.dir}main.js">
            <xsl:comment> </xsl:comment>
        </script>
        <script type="text/javascript" src="{$webhelp.common.dir}splitterInit.js">
            <xsl:comment> </xsl:comment>
        </script>
    </xsl:template>

    <xsl:template name="l10n.js">
        <xsl:call-template name="write.chunk">
            <xsl:with-param name="filename">
             <xsl:value-of select="concat($base.dir,'search/l10n.js')"/>
            </xsl:with-param>
            <xsl:with-param name="method" select="'text'"/>
            <xsl:with-param name="encoding" select="'utf-8'"/>
            <xsl:with-param name="indent" select="'no'"/>
            <xsl:with-param name="content">
             //Resource strings for localization
             var localeresource = new Object;
             localeresource["search_no_results"]="<xsl:call-template name="gentext.template">
                <xsl:with-param name="name" select="'Your_search_returned_no_results'"/>
               <xsl:with-param name="context" select="'webhelp'"/>
                </xsl:call-template>";
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:include href="links.xsl"/>

</xsl:stylesheet>
