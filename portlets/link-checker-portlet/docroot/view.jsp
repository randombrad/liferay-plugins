<%
/**
 * Copyright (c) 2000-2012 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
%>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>

<%@ page import="com.liferay.taglib.aui.PanelTag" %>
<%@ page import="com.liferay.portal.theme.ThemeDisplay" %>
<%@ page import="com.liferay.taglib.aui.FieldWrapperTag" %>

<%@ page import="com.liferay.portlet.journal.model.JournalArticle" %>
<%@ page import="com.liferay.portlet.journal.service.JournalArticleLocalServiceUtil" %>
<%@ page import="com.liferay.portlet.journalcontent.util.JournalContentUtil" %>
<%@ page import="java.io.StringReader" %>
<%@ page import="java.io.Reader" %>
<%@ page import="java.lang.Character" %>
<%@ page import="java.lang.String" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>

<%@ page import="com.liferay.util.HTMLParser" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>

<portlet:defineObjects />
<liferay-theme:defineObjects />

<%
	long customScopeId = themeDisplay.getScopeGroupId();
	List<JournalArticle> journalArticleList = JournalArticleLocalServiceUtil.getArticles(customScopeId);
	String langageId = themeDisplay.getLanguageId();
%>


<%
	if (journalArticleList.size() == 0) {
%>
		<p>This site has no web content to check</p>
<%
	} else {
	
		for (JournalArticle journalArticle : journalArticleList) {
	%>
		<%
			if (JournalArticleLocalServiceUtil.isLatestVersion(journalArticle.getGroupId(), journalArticle.getArticleId(), journalArticle.getVersion())){
		%>

			<div class="webContent-<%=journalArticle.getArticleId()%>">

				<%
					String webContent = JournalContentUtil.getContent(customScopeId, journalArticle.getArticleId(), null, null, langageId, themeDisplay);
					Reader currentContent = new StringReader(webContent);

					HTMLParser parser = new HTMLParser(currentContent);
					List<String> webContentLinks = parser.getLinks();
					List<String> webContentImages = parser.getImages();
					int ignoredCount = 0;
					List<String> badList=new ArrayList<String>();
				%>

				<ul>
					<%
						for (String webContentLink : webContentLinks) {
							char firstChar = webContentLink.charAt(0);
							char secondChar = webContentLink.charAt(1);
					%>

						<li><%=webContentLink%></li>

						<%
							if (firstChar == '#'){
								ignoredCount = ignoredCount + 1;
						%>

						<%
							}else{
						%>
							<%
								if (secondChar == '/'){
									webContentLink = webContentLink.replace("//", "http://");
							%>

							<%
								}
							%>
							<%
								URL url = new URL(webContentLink);
								HttpURLConnection http = (HttpURLConnection)url.openConnection();
								int statusCode = http.getResponseCode();
							%>

							<%=webContentLink%>-<%=statusCode%>

							<%
								if (statusCode == 404){
							%>
								<li>
									<%
										badList.add(webContentLink);
									%>
								</li>
							<%
								}
							%>
							<table border="5px">
								<tr>
								    <th>Links Found</th>
								    <th>Links Ignored</th>
									<th>Broken Links</th>
								  </tr>
								<tr>
									<td><%=webContentLinks.size()%></td>
									<td><%=ignoredCount%></td>
									<td><%=badList.size()%></td>
								</tr>
							</table>
							</li>
						<%
							}
						%>
						<hr/>
					</div>
					<%
					}
					%>
				</ul>
			<hr/>
			<hr/>

				<h1><%= webContentImages.size() %> Images found</h1>

				<ul>
					<%
						for (String webContentImage : webContentImages) {
					%>

						<li><%=themeDisplay.getPortalURL()%><%=webContentImage %></li>

					<%
						}
					%>
				</ul>
			</li>
		<%
			}
		}
	}
		%>
	
