import ceylon.interop.java {
    javaClass
}

import com.intellij.codeInspection {
    ProblemHighlightType
}
import com.intellij.lang.annotation {
    AnnotationHolder,
    ExternalAnnotator,
    Annotation,
    HighlightSeverity
}
import com.intellij.openapi.application {
    ApplicationManager
}
import com.intellij.openapi.editor {
    Editor
}
import com.intellij.openapi.\imodule {
    ModuleUtil
}
import com.intellij.openapi.project {
    DumbAware,
    Project
}
import com.intellij.openapi.util {
    TextRange
}
import com.intellij.problems {
    WolfTheProblemSolver,
    Problem
}
import com.intellij.psi {
    PsiFile
}
import com.redhat.ceylon.compiler.typechecker.analyzer {
    Warning,
    AnalysisError,
    UsageWarning
}
import com.redhat.ceylon.compiler.typechecker.parser {
    RecognitionError
}
import com.redhat.ceylon.compiler.typechecker.tree {
    Message,
    UnexpectedError
}
import com.redhat.ceylon.ide.common.correct {
    ideQuickFixManager
}
import com.redhat.ceylon.ide.common.typechecker {
    ExternalPhasedUnit
}
import com.redhat.ceylon.ide.common.util {
    nodes
}

import java.util {
    ArrayList
}

import org.intellij.plugins.ceylon.ide.ceylonCode.correct {
    IdeaQuickFixData
}
import org.intellij.plugins.ceylon.ide.ceylonCode.highlighting {
    highlighter
}
import org.intellij.plugins.ceylon.ide.ceylonCode.model {
    IdeaCeylonProjects,
    concurrencyManager,
    CeylonModelManager
}
import org.intellij.plugins.ceylon.ide.ceylonCode.psi {
    CeylonFile
}

shared class CeylonTypeCheckerAnnotator() 
        extends ExternalAnnotator<CeylonFile?, {[Message, TextRange?]*}?>()
        satisfies DumbAware {

    shared actual CeylonFile? collectInformation(PsiFile file) {
        if (is CeylonFile file,
            !file.phasedUnit is ExternalPhasedUnit) {

            return file;
        }

        return null;
    }
    
    shared actual CeylonFile? collectInformation(PsiFile file, Editor editor, Boolean hasErrors)
            => collectInformation(file);
    
    shared actual {[Message, TextRange?]*}? doAnnotate(CeylonFile ceylonFile)
            => concurrencyManager.withAlternateResolution(() 
                => if (exists pu = ceylonFile.ensureTypechecked(),
                        exists cu = pu.compilationUnit)
                then ErrorsVisitor(cu, ceylonFile).extractMessages()
                else null);
    
    shared actual void apply(PsiFile file, {[Message, TextRange?]*} ceylonMessages, AnnotationHolder holder) {
        variable value hasErrors = false;
        concurrencyManager.withAlternateResolution(
            () => ceylonMessages.each(
                ([message,range]) => hasErrors ||= addAnnotation(message, range, holder, file.project)
            )
        );
        if (is CeylonFile file,
            exists cu = file.compilationUnit) {

            if (cu.errors.empty) {
                value modelManager = file.project.getComponent(javaClass<CeylonModelManager>());
                if (modelManager.modelUpdateWasCannceledBecauseOfSyntaxErrors) {
                    modelManager.scheduleModelUpdate();
                }
            }

            if (hasErrors) {
                value problems = object extends ArrayList<Problem>() {
                    empty => false;
                };

                WolfTheProblemSolver.getInstance(file.project).reportProblems(file.virtualFile, problems);
            } else {
                WolfTheProblemSolver.getInstance(file.project).clearProblems(file.virtualFile);
            }
        }
    }

    Boolean addAnnotation(Message message, TextRange? range, AnnotationHolder annotationHolder, Project project) {
        value unresolvedReferenceCodes = [ 100, 102 ];
        value unusedCodes = [ Warning.unusedDeclaration.string, Warning.unusedImport.string ];
        
        Annotation annotation;
        Boolean isError;
        if (message is AnalysisError|RecognitionError|UnexpectedError) {
            annotation = annotationHolder.createAnnotation(
                HighlightSeverity.error,
                range,
                message.message,
                highlighter.highlightQuotedMessage(message.message, project)
            );
            isError = true;
            if (unresolvedReferenceCodes.contains(message.code)) {
                annotation.highlightType = ProblemHighlightType.likeUnknownSymbol;
            }
        } else if (is UsageWarning message) {
            annotation = annotationHolder.createAnnotation(
                HighlightSeverity.warning,
                range,
                message.message,
                highlighter.highlightQuotedMessage(message.message, project)
            );
            isError = false;
            if (unusedCodes.contains(message.warningName)) {
                annotation.highlightType = ProblemHighlightType.likeUnusedSymbol;
            } else {
                annotation.highlightType = ProblemHighlightType.genericErrorOrWarning;
            }
        } else {
            annotation = annotationHolder.createAnnotation(
                HighlightSeverity.information,
                range,
                message.message,
                highlighter.highlightQuotedMessage(message.message, project)
            );
            isError = false;
        }
        if (exists r = range,
            !ApplicationManager.application.unitTestMode) {
            addQuickFixes(r, message, annotation, annotationHolder);
        }
        return isError;
    }

    void addQuickFixes(TextRange range, Message error, Annotation annotation, AnnotationHolder annotationHolder) {
        assert (is CeylonFile file = annotationHolder.currentAnnotationSession.file);
        value mod = ModuleUtil.findModuleForFile(file.virtualFile, file.project);
        value pu = file.phasedUnit;
        
        if (is IdeaCeylonProjects projects = file.project.getComponent(javaClass<IdeaCeylonProjects>()),
            exists project = projects.getProject(mod),
            exists tc = project.typechecker,
            exists node = nodes.findNode(pu.compilationUnit, null, range.startOffset, range.endOffset)) {
            
            value data = IdeaQuickFixData(error, file.viewProvider.document, pu.compilationUnit,
                pu, node, mod, annotation, project);
            
            try {
                ideQuickFixManager.addQuickFixes(data, tc);
            } catch (Exception|AssertionError e) {
                e.printStackTrace();
            }
        }
    }
}



