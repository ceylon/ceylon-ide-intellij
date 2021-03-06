/********************************************************************************
 * Copyright (c) {date} Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import java.util {
    Objects
}
shared class CompilerConfigurable()
        extends AbstractCompilerConfigurable() {

    id => "preferences.Ceylon.compiler";

    displayName => "Ceylon compiler";

    createComponent() => mainPanel;

    modified => outProcessMode.selected != ceylonSettings.useOutProcessBuild
             || verboseCheckbox.selected != ceylonSettings.compilerVerbose
             || !Objects.equals(verbosityLevel, ceylonSettings.verbosityLevel);

    shared actual void apply() {
        ceylonSettings.useOutProcessBuild = outProcessMode.selected;
        ceylonSettings.compilerVerbose = verboseCheckbox.selected;
        ceylonSettings.verbosityLevel = verbosityLevel;
    }

    shared actual void reset() {
        outProcessMode.selected = ceylonSettings.useOutProcessBuild;
        inProcessMode.selected = !ceylonSettings.useOutProcessBuild;
        verboseCheckbox.selected = ceylonSettings.compilerVerbose;
        setVerbosityLevel(ceylonSettings.verbosityLevel);
    }

    String verbosityLevel {
        if (allCheckBox.selected) {
            return "all";
        } else {
            value builder = StringBuilder();
            for (cb in verbosities) {
                if (cb.selected) {
                    if (!builder.empty) {
                        builder.append(",");
                    }
                    builder.append(cb.text);
                }
            }
            return builder.string;
        }
    }

    void setVerbosityLevel(String level) {
        for (cb in verbosities) {
            cb.selected = false;
        }
        value parts = level.split(','.equals);
        for (part in parts) {
            for (cb in verbosities) {
                if (cb.text == part) {
                    cb.selected = true;
                }
            }
        }
    }


}