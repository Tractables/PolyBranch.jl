using IRTools
using IRTools: IR, @dynamo

"Generate a version of the method that has polymorphic control flow"
function gen_polybr_f(funtype, args...)
    ir = IR(funtype, args...)
    fir, helpers = transform(ir)
    gen_helpers(helpers)
    polybr = @eval @generated function $(gensym("polybr"))($([Symbol(:arg, i) for i = 1:length(arguments(fir))]...))
        return IRTools.Inner.build_codeinfo($fir)
    end
    # hide first argument
    return (args...) -> polybr(nothing, args...)
end

function gen_helpers(helpers)
    for (helpername, helperir) in helpers
        # cf https://github.com/FluxML/IRTools.jl/blob/master/src/eval.jl
        @eval @generated function $(helpername)($([Symbol(:arg, i) for i = 1:length(arguments(helperir))]...))
            return IRTools.Inner.build_codeinfo($helperir)
        end
    end
end

@dynamo function polybranch(a...)
    ir = IR(a...)
    fir, helpers = transform(ir)
    gen_helpers(helpers)
    fir
end
