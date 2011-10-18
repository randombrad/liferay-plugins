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

<%@ include file="/html/portlet/message_boards/init.jsp" %>

<liferay-util:buffer var="html">
	<liferay-util:include page="/html/portlet/message_boards/view.portal.jsp" />
</liferay-util:buffer>

<%
String topLink = ParamUtil.getString(request, "topLink", "message-boards-home");

if (topLink.equals("recent-posts")) {
	int x = html.lastIndexOf("<table");
	int y = html.indexOf("</table>", x);

	html = html.substring(0, x) + html.substring(y + 8);
}

int categoryButtonsX = html.indexOf("<div class=\"category-buttons\"");
int categoryButtonsY = html.indexOf("</div>", categoryButtonsX);

if ((categoryButtonsX != -1) && (categoryButtonsY != -1)) {
	html = html.substring(0, categoryButtonsX) + html.substring(categoryButtonsY + 6);
}

int categorySubscriptionsIndex = html.indexOf("class=\"category-subscriptions\"");

if (categorySubscriptionsIndex != -1) {
	html = html.substring(0, categorySubscriptionsIndex + 30) + " style=\"display: none;\" " + html.substring(categorySubscriptionsIndex + 30);
}

int taglibHeaderX = html.indexOf("<div class=\"taglib-header");
int taglibHeaderY = html.indexOf("</div>", taglibHeaderX);

if ((taglibHeaderX != -1) && (taglibHeaderY != -1)) {
	html = html.substring(0, taglibHeaderX) + html.substring(taglibHeaderY + 6);
}

MBCategory category = (MBCategory)request.getAttribute(WebKeys.MESSAGE_BOARDS_CATEGORY);

long categoryId = MBUtil.getCategoryId(request, category);

int threadsCount = MBThreadServiceUtil.getThreadsCount(scopeGroupId, categoryId, WorkflowConstants.STATUS_APPROVED);

if (threadsCount == 0) {
	int taglibHeaderIndex = html.indexOf("id=\"messageBoardsThreadsPanel\"");

	if (taglibHeaderIndex != -1) {
		html = html.substring(0, taglibHeaderIndex + 30) + " style=\"display: none;\" " + html.substring(taglibHeaderIndex + 30);
	}
}
%>

<%= html %>