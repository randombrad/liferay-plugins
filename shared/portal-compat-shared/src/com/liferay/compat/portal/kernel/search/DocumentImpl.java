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

package com.liferay.compat.portal.kernel.search;

import com.liferay.portal.kernel.util.PropsKeys;
import com.liferay.portal.kernel.util.PropsUtil;
import com.liferay.portal.kernel.util.SetUtil;

import java.util.Set;

/**
 * @author Brian Wing Shun Chan
 * @author Bruno Farache
 */
public class DocumentImpl
	extends com.liferay.portal.kernel.search.DocumentImpl implements Cloneable {

	@Override
	public Object clone() {
		DocumentImpl documentImpl = new DocumentImpl();

		documentImpl.setSortableTextFields(_sortableTextFields);

		return documentImpl;
	}

	public boolean isDocumentSortableTextField(String name) {
		return _sortableTextFields.contains(name);
	}

	public void setSortableTextFields(String[] sortableTextFields) {
		_sortableTextFields = SetUtil.fromArray(sortableTextFields);
	}

	protected void setSortableTextFields(Set<String> sortableTextFields) {
		_sortableTextFields = sortableTextFields;
	}

	private static Set<String> _defaultSortableTextFields = SetUtil.fromArray(
		PropsUtil.getArray(PropsKeys.INDEX_SORTABLE_TEXT_FIELDS));

	private Set<String> _sortableTextFields = _defaultSortableTextFields;

}