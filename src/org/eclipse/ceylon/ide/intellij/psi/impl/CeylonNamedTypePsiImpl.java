/********************************************************************************
 * Copyright (c) {date} Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
package org.eclipse.ceylon.ide.intellij.psi.impl;

import com.intellij.lang.ASTNode;
import com.intellij.psi.PsiNamedElement;
import org.eclipse.ceylon.ide.intellij.psi.CeylonPsiImpl;

/**
 * Resolves inheritance ambiguities:
 *
 * - may not inherit two declarations with the same name unless redefined in subclass: 'name' is defined by supertypes 'PsiElementBase' and 'PsiNamedElement'
 * - may not inherit two declarations with the same name that do not share a common supertype: 'name' is defined by supertypes 'PsiNamedElement' and 'NavigationItem'
 */
public abstract class CeylonNamedTypePsiImpl extends CeylonPsiImpl.TypePsiImpl
    implements PsiNamedElement {

    public CeylonNamedTypePsiImpl(ASTNode astNode) {
        super(astNode);
    }
}
