using Pkg

Pkg.add("ChainRulesCore")

Pkg.add("ChainRules")

Pkg.add("ChainRulesTestUtils")

using ChainRulesCore
using ChainRules
using ChainRulesTestUtils

using Zygote

y, back = Zygote.pullback(sin, 0.5);

y

sin(0.5)

dsin(x) = (sin(x), ȳ -> (ȳ * cos(x),))

dsin(0.5)

# Additionally, for signalling semantics, we distinguish between two tangent types representing a zero tangent. 
# NoTangent type represent situtations in which the tangent space does not exist, e.g. an index into an array can not be perturbed. 
# ZeroTangent is used for cases where the tangent happens to be zero, e.g. because the primal argument is not used in the computation.

using ChainRulesCore

function foo(x)
    a = sin(x)
    b = 0.2 + a
    c = asin(b)
    return c
end

# Define rules (alternatively get them for free via `using ChainRules`)
@scalar_rule(sin(x), cos(x))
@scalar_rule(+(x, y), (1.0, 1.0))
@scalar_rule(asin(x), inv(sqrt(1 - x^2)))

#### Find dfoo/dx via rrules
#### First the forward pass, gathering up the pullbacks
x = 3;
a, a_pullback = rrule(sin, x);
b, b_pullback = rrule(+, 0.2, a);
c, c_pullback = rrule(asin, b)

#### Then the backward pass calculating gradients
c̄ = 1;                    # ∂c/∂c
_, b̄ = c_pullback(c̄);     # ∂c/∂b = ∂c/∂b ⋅ ∂c/∂c
_, _, ā = b_pullback(b̄);  # ∂c/∂a = ∂c/∂b ⋅ ∂b/∂a
_, x̄ = a_pullback(ā);     # ∂c/∂x = ∂c/∂a ⋅ ∂a/∂x
x̄

#### Find dfoo/dx via frules
x = 3;
ẋ = 1;              # ∂x/∂x
nofields = ZeroTangent();  # ∂self/∂self

a, ȧ = frule((nofields, ẋ), sin, x);                    # ∂a/∂x = ∂a/∂x ⋅ ∂x/∂x 
b, ḃ = frule((nofields, ZeroTangent(), ȧ), +, 0.2, a);  # ∂b/∂x = ∂b/∂a ⋅ ∂a/∂x
c, ċ = frule((nofields, ḃ), asin, b);                   # ∂c/∂x = ∂c/∂b ⋅ ∂b/∂x
ċ 

Pkg.add("FiniteDifferences")

Pkg.add("ForwardDiff")

#### Find dfoo/dx via FiniteDifferences.jl
using FiniteDifferences
central_fdm(5, 1)(foo, x)
# output
# -1.0531613736418257

#### Find dfoo/dx via ForwardDiff.jl
using ForwardDiff
ForwardDiff.derivative(foo, x)
# output
# -1.0531613736418153

#### Find dfoo/dx via Zygote.jl
using Zygote
Zygote.gradient(foo, x)

Pkg.add("ImageTransformations")

import Pkg

Pkg.develop("DiffImages")

using DiffImages, ImageTransformations, CoordinateTransformations, ImageCore, FileIO, StaticArrays










