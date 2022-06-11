module PolyBranch

export polybranch

using IRTools
using IRTools: @dynamo, IR, recurse!
using IfElse

# pirate `IRTools.cond`` but keep default behavior on Bool guards
IRTools.cond(guard::Bool, then, elze) = guard ? then() : elze()
IRTools.cond(guard, then, elze) = IfElse.ifelse(guard, then(), elze())

"Transform IR to support polymorphic control flow"
function polybranch_transform(ir)
    # reuse `IRTools.functional`
    IRTools.functional(ir)
end

@dynamo function polybranch(a...)
    ir = IR(a...)
    (ir == nothing) && return
    recurse!(ir, polybranch)
    return polybranch_transform(ir)
end

# avoid transformation when it is known to trigger a bug

polybranch(::typeof(unsafe_copyto!), args...) = unsafe_copyto!(args...)

end # module
