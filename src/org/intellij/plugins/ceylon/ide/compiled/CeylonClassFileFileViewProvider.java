package org.intellij.plugins.ceylon.ide.compiled;

import com.intellij.openapi.components.ServiceManager;
import com.intellij.openapi.fileTypes.FileType;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.roots.FileIndexFacade;
import com.intellij.openapi.vfs.VirtualFile;
import com.intellij.psi.PsiFile;
import com.intellij.psi.PsiManager;
import com.intellij.psi.SingleRootFileViewProvider;
import com.intellij.psi.impl.PsiManagerImpl;
import com.intellij.psi.impl.compiled.ClsFileImpl;
import com.intellij.psi.impl.file.PsiBinaryFileImpl;
import org.intellij.plugins.ceylon.ide.ceylonCode.compiled.CeylonBinaryData;
import org.intellij.plugins.ceylon.ide.ceylonCode.compiled.classFileDecompilerUtil_;
import org.intellij.plugins.ceylon.ide.ceylonCode.lang.CeylonLanguage;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

class CeylonClassFileFileViewProvider extends SingleRootFileViewProvider {
    CeylonClassFileFileViewProvider(@NotNull PsiManager manager, @NotNull VirtualFile virtualFile,
                           boolean eventSystemEnabled) {
        super(manager, virtualFile, eventSystemEnabled, CeylonLanguage.INSTANCE);
    }

    @NotNull
    @Override
    public CharSequence getContents() {
        return ClsFileImpl.decompile(getVirtualFile());
    }

    @Nullable
    @Override
    protected PsiFile createFile(@NotNull Project project, @NotNull VirtualFile file,
                                 @NotNull FileType fileType) {
        FileIndexFacade fileIndex = ServiceManager.getService(project, FileIndexFacade.class);
        if (!fileIndex.isInLibraryClasses(file) && fileIndex.isInSource(file)) {
            return new PsiBinaryFileImpl((PsiManagerImpl)getManager(), this);
        }

        CeylonBinaryData data = classFileDecompilerUtil_.get_().getCeylonBinaryData(file);
        if (!data.getInner()) {
            return new ClsFileImpl(this);
        }

        return null;
    }
}
