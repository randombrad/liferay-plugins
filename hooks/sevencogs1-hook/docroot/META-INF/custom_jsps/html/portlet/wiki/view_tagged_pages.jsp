<%--
/**
 * Copyright (c) 2000-2011 Liferay, Inc. All rights reserved.
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
--%>

<%@ include file="/html/portlet/wiki/init.jsp" %>

<liferay-util:buffer var="html">
	<liferay-util:include page="/html/portlet/wiki/view_tagged_pages.portal.jsp" />
</liferay-util:buffer>

<%
int x = html.indexOf("<p class=\"tag-description\"");

if (x != -1) {
	int y = html.indexOf("</p>", x);

	html = html.substring(0, x) + html.substring(y + 4);
}

html = html.replace("<h1", "<h3");
html = html.replace("</h1>", "</h3>");
%>

<%= html %>