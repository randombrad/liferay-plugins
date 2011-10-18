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

<%@ include file="/html/portlet/css_init.jsp" %>

.portlet-message-boards .btn:hover {
	background-color: #F08000;
}

.portlet-message-boards .code {
	background: #fff;
	border: 1px solid #777;
	font-family: monospace;
	overflow-x: auto;
	white-space: pre;
}

.ie6 .portlet-message-boards .code {
	width: 100%;
}

.portlet-message-boards .entry-body {
	margin: 0.75em 0;
}

.portlet-message-boards .entry-header .answer {
	margin-left: 55px;
}

.portlet-message-boards .header-back-to {
	float: right;
	font-weight: bold;
	text-decoration: none;
}

.portlet-message-boards .lfr-panel-container {
	background: none;
	border-style: none;
}

.portlet-message-boards .lfr-panel-titlebar {
	display: none;
}

.portlet-message-boards .lfr-textarea.message-edit {
	height: 100%;
	width: 100%;
}

.portlet-message-boards .lfr-textarea.message-edit textarea {
	height: 378px;
	min-height: 100%;
	width: 99.5%;
}

.portlet-message-boards .mb-commands .subscription {
	float: right;
}

.portlet-message-boards .quote {
	background: #fff url(<%= themeImagesPath %>/message_boards/quoteleft.png) left top no-repeat;
	border: 1px solid #777;
	padding: 5px 0px 0px 5px;
}

.portlet-message-boards .quote-content {
	background: transparent url(<%= themeImagesPath %>/message_boards/quoteright.png) right bottom no-repeat;
	padding: 5px 30px 10px 30px;
}

.portlet-message-boards .quote-title {
	font-weight: bold;
	padding: 5px 0px 5px 0px;
}

.portlet-message-boards .results-header {
	background: none;
}

.portlet-message-boards .results-row.hover td {
	background: none;
}

.portlet-message-boards .taglib-ratings.thumbs .aui-thumbrating .aui-rating-label-element {
	padding: 0 5px 10px 0;
}

.portlet-message-boards .taglib-search-iterator th {
	color: #444;
	font: 12px Arial,Helvetica,sans-serif;
	font-weight: bold;
}

.portlet-message-boards .taglib-search-iterator td {
	padding: 8px 10px 9px;
}

.portlet-message-boards .taglib-search-iterator thead th {
	text-align: left;
}

.portlet-message-boards .taglib-search-iterator td.only {
	padding-left: 0;
	padding-right: 0;
}

.portlet-message-boards .taglib-search-iterator td.first {
	padding-left: 0;
}

.portlet-message-boards .taglib-search-iterator td.last {
	padding-right: 0;
}

.portlet-message-boards .taglib-search-iterator td,
.portlet-message-boards .taglib-search-iterator th {
	border-bottom: 1px solid #CCC;
}

.portlet-message-boards .taglib-search-iterator .col-2,
.portlet-message-boards .taglib-search-iterator .col-3,
.portlet-message-boards .taglib-search-iterator .col-4,
.portlet-message-boards .taglib-search-iterator .col-5 {
	text-align: center;
	width: 15%;
}

.portlet-message-boards .taglib-search-iterator tr.last td,
.portlet-message-boards .taglib-search-iterator tr.last th,
.portlet-message-boards .taglib-search-iterator tr.only td,
.portlet-message-boards .taglib-search-iterator tr.only th {
	border-bottom: 0;
	padding-bottom: 10px;
}

.portlet-message-boards .thread-controls {
	display: none;
}

.portlet-message-boards .thread-view-controls {
	margin-bottom: 0;
}

.portlet-message-boards .toggle_id_message_boards_view_message_thread a {
	text-decoration: none;
}

.portlet-message-boards .toggle_id_message_boards_view_message_thread td {
	padding: 0 5px;
}

.portlet-message-boards #toggle_id_message_boards_view_message_thread_image {
	display: none;
}