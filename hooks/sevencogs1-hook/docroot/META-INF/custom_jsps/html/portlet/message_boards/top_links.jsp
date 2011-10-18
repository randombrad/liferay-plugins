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
String topLink = ParamUtil.getString(request, "topLink", "message-boards-home");

MBCategory category = (MBCategory)request.getAttribute(WebKeys.MESSAGE_BOARDS_CATEGORY);

MBMessageDisplay messageDisplay = (MBMessageDisplay)request.getAttribute(WebKeys.MESSAGE_BOARDS_MESSAGE);

long categoryId = MBUtil.getCategoryId(request, category);

long searchCategoryId = ParamUtil.getLong(request, "searchCategoryId", categoryId);

String strutsAction = ParamUtil.getString(request, "struts_action");

String keywords = ParamUtil.getString(request, "keywords");

PortletURL portletURL = renderResponse.createRenderURL();

portletURL.setParameter("struts_action", "/message_boards/view");
portletURL.setParameter("topLink", "message-boards-home");

PortalUtil.addPortletBreadcrumbEntry(request, LanguageUtil.get(pageContext, "home"), portletURL.toString());

if (messageDisplay != null) {
	category = messageDisplay.getCategory();

	MBUtil.addPortletBreadcrumbEntries(category, request, renderResponse);
}
else if (category != null) {
	MBUtil.addPortletBreadcrumbEntries(category, request, renderResponse);
}
else if (strutsAction.equals("/message_boards/search")) {
	long breadcrumbsCategoryId = ParamUtil.getLong(request, "breadcrumbsCategoryId");

	if (breadcrumbsCategoryId > 0) {
		MBUtil.addPortletBreadcrumbEntries(breadcrumbsCategoryId, request, renderResponse);
	}

	PortalUtil.addPortletBreadcrumbEntry(request, LanguageUtil.get(pageContext, "search") + ": " + keywords, currentURL);
}
else if (!topLink.equals("message-boards-home") && (topLink.equals("my-posts") || topLink.equals("my-subscriptions") || topLink.equals("recent-posts") || topLink.equals("statistics") || topLink.equals("banned-users"))) {
	portletURL.setParameter("topLink", topLink);

	PortalUtil.addPortletBreadcrumbEntry(request, LanguageUtil.get(pageContext, TextFormatter.format(topLink, TextFormatter.O)), portletURL.toString());
}
%>

<div class="page-heading">
	<c:if test="<%= showSearch %>">
		<liferay-portlet:renderURL varImpl="searchURL">
			<portlet:param name="struts_action" value="/message_boards/search" />
		</liferay-portlet:renderURL>

		<aui:form action="<%= searchURL %>" method="get" name="searchFm">
			<liferay-portlet:renderURLParams varImpl="searchURL" />
			<aui:input name="redirect" type="hidden" value="<%= currentURL %>" />
			<aui:input name="breadcrumbsCategoryId" type="hidden" value="<%= searchCategoryId %>" />
			<aui:input name="searchCategoryId" type="hidden" value="<%= searchCategoryId %>" />

			<div class="fr">
				<div class="tab-content">
					<div class="field-inline">
						<div class="field-content">
							<div class="tab-unit f">
								<label class="field-label" for="<portlet:namespace />keywords1">Search</label>
							</div>

							<div class="tab-unit l">
								<input class="aui-field-input aui-field-input-text" type="text" title="<liferay-ui:message key="search-messages" />" name="<portlet:namespace />keywords" id="<portlet:namespace />keywords1" value="<%= HtmlUtil.escape(keywords) %>" />
							</div>
						</div>
					</div>
				</div>
			</div>
		</aui:form>
	</c:if>

	<h1>
		<liferay-ui:message key="forums" />
	</h1>

	<h2>
		<liferay-ui:breadcrumb displayStyle="<%= 3 %>" portletURL="<%= portletURL %>" />
	</h2>
</div>

<div class="mb-commands nav-x">
	<ul>
		<c:if test="<%= themeDisplay.isSignedIn() %>">

			<%
			portletURL.setParameter("topLink", "my-posts");
			%>

			<li>
				<a href="<%= portletURL.toString() %>" class="btn"><liferay-ui:message key="my-posts" /></a>
			</li>

			<%
			portletURL.setParameter("topLink", "my-subscriptions");
			%>

			<li>
				<a href="<%= portletURL.toString() %>" class="btn"><liferay-ui:message key="my-subscriptions" /></a>
			</li>
		</c:if>

		<%
		portletURL.setParameter("topLink", "recent-posts");
		%>

		<li>
			<a href="<%= portletURL.toString() %>" class="btn"><liferay-ui:message key="recent-posts" /></a>
		</li>

		<%
		portletURL.setParameter("topLink", "statistics");
		%>

		<li>
			<a href="<%= portletURL.toString() %>" class="btn"><liferay-ui:message key="statistics" /></a>
		</li>

		<c:if test="<%= MBPermission.contains(permissionChecker, scopeGroupId, ActionKeys.BAN_USER) %>">

			<%
			portletURL.setParameter("topLink", "banned-users");
			%>

			<li>
				<a href="<%= portletURL.toString() %>" class="btn"><liferay-ui:message key="banned-users" /></a>
			</li>
		</c:if>

		<c:if test="<%= (category != null) && MBCategoryPermission.contains(permissionChecker, scopeGroupId, category.getCategoryId(), ActionKeys.ADD_MESSAGE) %>">
			<li>
				<portlet:renderURL var="editMessageURL">
					<portlet:param name="struts_action" value="/message_boards/edit_message" />
					<portlet:param name="redirect" value="<%= currentURL %>" />
					<portlet:param name="mbCategoryId" value="<%= String.valueOf(category.getCategoryId()) %>" />
				</portlet:renderURL>

				<a href="<%= editMessageURL %>" class="btn"><liferay-ui:message key="post-new-thread" /></a>
			</li>
		</c:if>
	</ul>

	<c:if test='<%= (topLink.equals("message-boards-home") && ((category != null) || (messageDisplay != null))) || topLink.equals("recent-posts") %>'>
		<div class="subscription">

			<%
			String rssURL = themeDisplay.getPortalURL() + themeDisplay.getPathMain() + "/message_boards/rss?p_l_id=" + plid;

			if (topLink.equals("recent-posts")) {
				long groupThreadsUserId = ParamUtil.getLong(request, "groupThreadsUserId");

				rssURL += "&groupId=" + scopeGroupId;

				if (groupThreadsUserId > 0) {
					rssURL += "&userId=" + groupThreadsUserId;
				}

				rssURL += rssURLParams;
			}
			else if (messageDisplay != null) {
				MBMessage message = messageDisplay.getMessage();

				rssURL += "&threadId=" + message.getThreadId() + rssURLParams;
			}
			else if (category != null) {
				rssURL += "&mbCategoryId=" + category.getCategoryId() + rssURLParams;
			}
			%>

			<liferay-ui:icon
				image="rss"
				label="<%= true %>"
				method="get"
				target="_blank"
				url="<%= rssURL %>"
			/>

			<%
			boolean showSubscribeButton = false;
			boolean isSubscribed = false;
			String subscribeStrutsActionValue = StringPool.BLANK;
			String subscribeParamName = StringPool.BLANK;
			String subscribeParamValue = StringPool.BLANK;

			if (messageDisplay != null) {
				MBMessage message = messageDisplay.getMessage();
				MBThread thread = messageDisplay.getThread();

				showSubscribeButton = MBMessagePermission.contains(permissionChecker, message, ActionKeys.SUBSCRIBE);

				if (showSubscribeButton) {
					isSubscribed = SubscriptionLocalServiceUtil.isSubscribed(themeDisplay.getCompanyId(), user.getUserId(), MBThread.class.getName(), message.getThreadId());
					subscribeStrutsActionValue = "/message_boards/edit_message";
					subscribeParamName = "messageId";
					subscribeParamValue = String.valueOf(message.getMessageId());
				}
			}
			else if (category != null) {
				showSubscribeButton = MBCategoryPermission.contains(permissionChecker, category, ActionKeys.SUBSCRIBE);

				if (showSubscribeButton) {
					isSubscribed = SubscriptionLocalServiceUtil.isSubscribed(themeDisplay.getCompanyId(), user.getUserId(), MBCategory.class.getName(), category.getCategoryId());
					subscribeStrutsActionValue = "/message_boards/edit_category";
					subscribeParamName = "mbCategoryId";
					subscribeParamValue = String.valueOf(category.getCategoryId());
				}
			}
			%>

			<c:if test="<%= showSubscribeButton %>">
				<c:choose>
					<c:when test="<%= isSubscribed %>">
						<portlet:actionURL var="unsubscribeURL">
							<portlet:param name="struts_action" value="<%= subscribeStrutsActionValue %>" />
							<portlet:param name="<%= Constants.CMD %>" value="<%= Constants.UNSUBSCRIBE %>" />
							<portlet:param name="redirect" value="<%= currentURL %>" />
							<portlet:param name="<%= subscribeParamName %>" value="<%= subscribeParamValue %>" />
						</portlet:actionURL>

						<liferay-ui:icon
							image="unsubscribe"
							label="<%= true %>"
							url="<%= unsubscribeURL %>"
						/>
					</c:when>
					<c:otherwise>
						<portlet:actionURL var="subscribeURL">
							<portlet:param name="struts_action" value="<%= subscribeStrutsActionValue %>" />
							<portlet:param name="<%= Constants.CMD %>" value="<%= Constants.SUBSCRIBE %>" />
							<portlet:param name="redirect" value="<%= currentURL %>" />
							<portlet:param name="<%= subscribeParamName %>" value="<%= subscribeParamValue %>" />
						</portlet:actionURL>

						<liferay-ui:icon
							image="subscribe"
							label="<%= true %>"
							url="<%= subscribeURL %>"
						/>
					</c:otherwise>
				</c:choose>
			</c:if>
		</div>
	</c:if>
</div>

<c:if test='<%= topLink.equals("message-boards-home") %>'>
	<p>
		<c:choose>
			<c:when test="<%= messageDisplay != null %>">

				<%
				MBMessage message = messageDisplay.getMessage();
				MBThread thread = messageDisplay.getThread();
				%>

				<c:if test="<%= MBCategoryPermission.contains(permissionChecker, scopeGroupId, (category != null) ? category.getCategoryId() : MBCategoryConstants.DEFAULT_PARENT_CATEGORY_ID, ActionKeys.LOCK_THREAD) %>">
					<c:choose>
						<c:when test="<%= thread.isLocked() %>">
							<portlet:actionURL var="unlockThreadURL">
								<portlet:param name="struts_action" value="/message_boards/edit_message" />
								<portlet:param name="<%= Constants.CMD %>" value="<%= Constants.UNLOCK %>" />
								<portlet:param name="redirect" value="<%= currentURL %>" />
								<portlet:param name="threadId" value="<%= String.valueOf(message.getThreadId()) %>" />
							</portlet:actionURL>

							<input type="button" onClick="submitForm(document.hrefFm, '<%= unlockThreadURL %>'); return false;" value="<liferay-ui:message key="unlock" />" />
						</c:when>
						<c:otherwise>
							<portlet:actionURL var="lockThreadURL">
								<portlet:param name="struts_action" value="/message_boards/edit_message" />
								<portlet:param name="<%= Constants.CMD %>" value="<%= Constants.LOCK %>" />
								<portlet:param name="redirect" value="<%= currentURL %>" />
								<portlet:param name="threadId" value="<%= String.valueOf(message.getThreadId()) %>" />
							</portlet:actionURL>

							<input type="button" onClick="submitForm(document.hrefFm, '<%= lockThreadURL %>'); return false;" value="<liferay-ui:message key="lock-thread" />" />
						</c:otherwise>
					</c:choose>
				</c:if>

				<c:if test="<%= MBCategoryPermission.contains(permissionChecker, scopeGroupId, (category != null) ? category.getCategoryId() : MBCategoryConstants.DEFAULT_PARENT_CATEGORY_ID, ActionKeys.MOVE_THREAD) %>">
					<portlet:renderURL var="editThreadURL">
						<portlet:param name="struts_action" value="/message_boards/move_thread" />
						<portlet:param name="redirect" value="<%= currentURL %>" />
						<portlet:param name="mbCategoryId" value="<%= (category != null) ? String.valueOf(category.getCategoryId()) : String.valueOf(MBCategoryConstants.DEFAULT_PARENT_CATEGORY_ID) %>" />
						<portlet:param name="threadId" value="<%= String.valueOf(message.getThreadId()) %>" />
					</portlet:renderURL>

					<input type="button" onClick="location.href = '<%= editThreadURL %>';" value="<liferay-ui:message key="move-thread" />" />
				</c:if>
			</c:when>
			<c:otherwise>

				<%
				boolean showPermissionsButton = false;

				String modelResource = "com.liferay.portlet.messageboards";
				String modelResourceDescription = themeDisplay.getScopeGroupName();
				String resourcePrimKey = String.valueOf(scopeGroupId);

				if (category != null) {
					showPermissionsButton = MBCategoryPermission.contains(permissionChecker, category, ActionKeys.PERMISSIONS);

					modelResource = MBCategory.class.getName();
					modelResourceDescription = category.getName();
					resourcePrimKey = String.valueOf(category.getCategoryId());
				}
				else {
					showPermissionsButton = MBPermission.contains(permissionChecker, scopeGroupId, ActionKeys.PERMISSIONS);
				}
				%>

				<c:if test="<%= MBCategoryPermission.contains(permissionChecker, scopeGroupId, categoryId, ActionKeys.ADD_CATEGORY) %>">
					<portlet:renderURL var="editCategoryURL">
						<portlet:param name="struts_action" value="/message_boards/edit_category" />
						<portlet:param name="redirect" value="<%= currentURL %>" />
						<portlet:param name="parentCategoryId" value="<%= String.valueOf(categoryId) %>" />
					</portlet:renderURL>

					<input type="button" onClick="location.href = '<%= editCategoryURL %>';" value="<liferay-ui:message key='<%= (category == null) ? "add-category" : "add-subcategory" %>' />" />
				</c:if>

				<c:if test="<%= showPermissionsButton %>">
					<liferay-security:permissionsURL
						modelResource="<%= modelResource %>"
						modelResourceDescription="<%= modelResourceDescription %>"
						resourcePrimKey="<%= resourcePrimKey %>"
						var="permissionsURL"
					/>

					<input type="button" onClick="location.href = '<%= permissionsURL %>';" value="<liferay-ui:message key="permissions" />" />
				</c:if>
			</c:otherwise>
		</c:choose>
	</p>
</c:if>