/********************************************************************************
 * Copyright (c) {date} Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import org.eclipse.ceylon.ide.common.correct {
    convertToClassQuickFix
}
import org.eclipse.ceylon.ide.common.util {
    nodes
}

import org.eclipse.ceylon.ide.intellij.psi {
    CeylonFile
}

shared class ConvertToClassIntention() extends AbstractIntention() {
    
    familyName => "Convert object to class";
    shared actual void checkAvailable(IdeaQuickFixData data, CeylonFile file, Integer offset) {
        value decl = nodes.findDeclaration(data.rootNode, data.node);

        convertToClassQuickFix.addConvertToClassProposal(data, decl);
    }
}
