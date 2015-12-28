import com.redhat.ceylon.model.loader.mirror {
    AnnotationMirror
}
import com.intellij.psi {
    PsiAnnotation,
    PsiLiteralExpression,
    PsiAnnotationMemberValue,
    PsiArrayInitializerMemberValue,
    PsiReferenceExpression,
    PsiClassObjectAccessExpression
}
import com.intellij.openapi.application {
    ApplicationManager
}
import ceylon.collection {
    HashMap
}
import java.util {
    ArrayList
}
import com.redhat.ceylon.ide.common.util {
    platformUtils,
    Status
}
import ceylon.interop.java {
    javaString
}
import java.lang {
    JShort=Short
}

class PSIAnnotation(shared PsiAnnotation psi)
    satisfies AnnotationMirror {

    value values = HashMap<String, Object>();

    Object convert(PsiAnnotationMemberValue v, String paramName) {
        if (is PsiArrayInitializerMemberValue v) {
            value inits = v.initializers.array.coalesced;
            value values = ArrayList<Object>(inits.size);
            inits.each((_) => values.add(convert(_, paramName)));
            
            return values;
        } else if (is PsiAnnotation v) {
            return PSIAnnotation(v);
        } else if (is PsiReferenceExpression v) {
            return javaString(v.referenceName);
        } else if (is PsiClassObjectAccessExpression v) {
            return PSIType(v.type);
        } else if (is PsiLiteralExpression v) {
            // TODO this is super ultra ugly, but we can't get the type associated
            // to a PsiArrayInitializerMemberValue, and IJ parses shorts as ints :(
            if (psi.qualifiedName == "com.redhat.ceylon.compiler.java.metadata.AnnotationInstantiation",
                paramName == "arguments") {

                return JShort(v.text);
            }
            return v.\ivalue;
        } else {
            platformUtils.log(Status._WARNING,
                "unsupported PsiAnnotationMemberValue ``className(v)``");
            return v;
        }
    }
    
    doWithLock(() {
        // TODO return values according to contract!!
        psi.parameterList.attributes.array.coalesced.each((pair) {
            value name = pair.name else "value";
            value val = convert(pair.\ivalue, name);
            
            values.put(name, val);
        });
    });
    
    shared actual Object? getValue(String name) => values.get(name);
    
    shared actual Object? \ivalue => getValue("value");
}

Return doWithLock<Return>(Callable<Return, []> callback) {
    value lock = ApplicationManager.application.acquireReadActionLock();
    try {
        return callback();
    } finally {
        lock.finish();
    }
}