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

<%
String redirect = ParamUtil.getString(request, "redirect");

long breadcrumbsCategoryId = ParamUtil.getLong(request, "breadcrumbsCategoryId");
long breadcrumbsMessageId = ParamUtil.getLong(request, "breadcrumbsMessageId");

long searchCategoryId = ParamUtil.getLong(request, "searchCategoryId");

long[] categoryIdsArray = null;

List categoryIds = new ArrayList();

categoryIds.add(new Long(searchCategoryId));

MBCategoryServiceUtil.getSubcategoryIds(categoryIds, scopeGroupId, searchCategoryId);

categoryIdsArray = StringUtil.split(StringUtil.merge(categoryIds), 0L);

long threadId = ParamUtil.getLong(request, "threadId");
String keywords = ParamUtil.getString(request, "keywords");
%>

<liferay-util:include page="/html/portlet/message_boards/top_links.jsp" />

<%
PortletURL portletURL = renderResponse.createRenderURL();

portletURL.setParameter("struts_action", "/message_boards/search");
portletURL.setParameter("redirect", redirect);
portletURL.setParameter("breadcrumbsCategoryId", String.valueOf(breadcrumbsCategoryId));
portletURL.setParameter("breadcrumbsMessageId", String.valueOf(breadcrumbsMessageId));
portletURL.setParameter("searchCategoryId", String.valueOf(searchCategoryId));
portletURL.setParameter("threadId", String.valueOf(threadId));
portletURL.setParameter("keywords", keywords);

List<String> headerNames = new ArrayList<String>();

headerNames.add("message");
headerNames.add("category");
headerNames.add("thread-posts");
headerNames.add("thread-views");

SearchContainer searchContainer = new SearchContainer(renderRequest, null, null, SearchContainer.DEFAULT_CUR_PARAM, SearchContainer.DEFAULT_DELTA, portletURL, headerNames, LanguageUtil.format(pageContext, "no-messages-were-found-that-matched-the-keywords-x", "<strong>" + HtmlUtil.escape(keywords) + "</strong>"));

try {
	Indexer indexer = IndexerRegistryUtil.getIndexer(MBMessage.class);

	SearchContext searchContext = SearchContextFactory.getInstance(request);

	searchContext.setAttribute("paginationType", "more");
	searchContext.setCategoryIds(categoryIdsArray);
	searchContext.setEnd(searchContainer.getEnd());
	searchContext.setKeywords(keywords);
	searchContext.setStart(searchContainer.getStart());

	Hits results = indexer.search(searchContext);

	int total = results.getLength();

	searchContainer.setTotal(total);

	List resultRows = searchContainer.getResultRows();

	for (int i = 0; i < results.getDocs().length; i++) {
		Document doc = results.doc(i);

		ResultRow row = new ResultRow(doc, i, i);

		// Thread and message

		long curThreadId = GetterUtil.getLong(doc.get("threadId"));
		long messageId = GetterUtil.getLong(doc.get(Field.ENTRY_CLASS_PK));

		MBThread thread = null;

		try {
			thread = MBThreadLocalServiceUtil.getThread(curThreadId);
		}
		catch (Exception e) {
			if (_log.isWarnEnabled()) {
				_log.warn("Message boards search index is stale and contains thread " + curThreadId);
			}

			continue;
		}

		MBMessage message = null;

		try {
			message = MBMessageLocalServiceUtil.getMessage(messageId);
		}
		catch (Exception e) {
			if (_log.isWarnEnabled()) {
				_log.warn("Message boards search index is stale and contains message " + messageId);
			}

			continue;
		}

		PortletURL rowURL = renderResponse.createRenderURL();

		rowURL.setParameter("struts_action", "/message_boards/view_message");
		rowURL.setParameter("redirect", currentURL);
		rowURL.setParameter("messageId", String.valueOf(messageId));

		row.addText(HtmlUtil.escape(message.getSubject()), rowURL);

		// Category

		long categoryId = GetterUtil.getLong(doc.get("categoryId"));

		MBCategory category = null;

		try {
			category = MBCategoryLocalServiceUtil.getCategory(categoryId);
		}
		catch (Exception e) {
			if (_log.isWarnEnabled()) {
				_log.warn("Message boards search index is stale and contains category " + categoryId);
			}

			continue;
		}

		PortletURL categoryUrl = renderResponse.createRenderURL();

		categoryUrl.setParameter("struts_action", "/message_boards/view");
		categoryUrl.setParameter("redirect", currentURL);
		categoryUrl.setParameter("mbCategoryId", String.valueOf(categoryId));

		row.addText(HtmlUtil.escape(category.getName()), categoryUrl);

		row.addText(String.valueOf(thread.getMessageCount()), rowURL);
		row.addText(String.valueOf(thread.getViewCount()), rowURL);

		// Add result row

		resultRows.add(row);
	}
%>

	<liferay-ui:search-iterator searchContainer="<%= searchContainer %>" type="more" />

<%
}
catch (Exception e) {
	_log.error(e.getMessage());
}
%>

<%!
private static Log _log = LogFactoryUtil.getLog("portal-web.docroot.html.portlet.message_boards.search_jsp");
%>