/********************************************************************************
 * Copyright (c) {date} Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import com.intellij.ide.actions {
    QualifiedNameProvider
}
import com.intellij.openapi.editor {
    Editor
}
import com.intellij.openapi.project {
    Project
}
import com.intellij.psi {
    PsiElement
}
import org.eclipse.ceylon.compiler.typechecker.tree {
    Tree
}

import org.eclipse.ceylon.ide.intellij.psi {
    CeylonCompositeElement,
    CeylonPsi
}

shared class CeylonQualifiedNameProvider() satisfies QualifiedNameProvider {

    shared actual PsiElement? adjustElementToCopy(PsiElement element) {
        if (is CeylonCompositeElement element) {
            return if (is CeylonPsi.IdentifierPsi element)
            then element.parent
            else element;
        }
        return null;
    }

    shared actual String? getQualifiedName(PsiElement element) {
        if (is CeylonCompositeElement element,
            is Tree.Declaration declaration = element.ceylonNode,
            exists model = declaration.declarationModel) {

            return model.qualifiedNameString;
        }
        return null;
    }

    qualifiedNameToElement(String fqn, Project project) => null;

    shared actual void insertQualifiedName(String fqn, PsiElement element, Editor editor, Project project) {}
}
