using Pkg

Pkg.add("Zygote")

using Zygote

gradient(x -> 3x^2 + 2x + 1, 5)

gradient((a, b) -> a*b, 2, 3)

W = rand(2, 3); x = rand(3);

W

x

W

x

gradient(W -> sum(W*x), W)[1]

gradient(x -> 3x^2 + 2x + 1, 1//4)

# 6x + 2 = > 2 + 3//2 => 7//2

function pow(x, n)
         r = 1
         for i = 1:n
           r *= x
         end
         return r
       end

gradient(x -> pow(x,3), 5)[1]

pow2(x,n) = n<=0 ? 0 : pow2(x,n-1)

gradient(x -> pow2(x,3), 5)[1]

d = Dict()

gradient(5) do x
         d[:x] = x
         d[:x] * d[:x]
       end

d

import Base: +,-

struct Point
    x::Float64
    y::Float64
end

a::Point + b::Point = Point(a.x + b.x, a.y + b.y)
a::Point - b::Point = Point(a.x - b.x, a.y - b.y)

dist(p::Point) = sqrt(p.x^2 + p.y^2)

a = Point(1,2)
b = Point(3,4)

dist(a+b)

gradient(a -> dist(a+b), a)[1]

gradient(b -> dist(a+b), b)[1]

Pkg.update("Zygote")

Pkg.add("Colors")

using Colors

colordiff(RGB(1, 0, 0), RGB(0, 1, 0))

gradient(colordiff, RGB(1, 0, 0), RGB(0, 1, 0))

function pow_global(x, n)
  global r=1
  while n > 0
    r *= x
    n -= 1
  end
  return r
end

gradient(pow_global, 2, 3)

function pow_mut(x, n)
  r = Ref(one(x))
  while n > 0
    n -= 1
    r[] = r[] * x
  end
  return r[]
end

gradient(pow_mut, 2, 3)

mul(a,b) = a*b

using Zygote: @adjoint

@adjoint mul(a,b) = mul(a,b) , c̄ -> (c̄*b,c̄*a)

gradient(mul,2,3)

struct Point
    x::Float64
    y::Float64
end

width(p::Point) = p.x
height(p::Point) = p.y

a::Point + b::Point = Point(width(a)+width(b),height(a)+height(b))

a::Point - b::Point = Point(width(a)-width(b),height(a)-height(b))

dist(p::Point) = sqrt(width(p)^2 + height(p)^2)

gradient(a -> dist(a),Point(1,2))[1]

gradient(a -> a.x, Point(1, 2))

@adjoint width(p::Point) = p.x, x̄ -> (Point(x̄,0),)

@adjoint height(p::Point) = p.y, ȳ -> (Point(0,ȳ),)

gradient(a -> height(a),Point(1,2))

gradient(b -> width(b),Point(1,2))

gradient(a -> dist(a), Point(1, 2))[1]

# If you do this you should also overload the Point constructor, 
# so that it can handle a Point gradient (otherwise this function will error).

@adjoint Point(a,b) = Point(a,b), p̄ -> (p̄.x,p̄.y)

gradient(x -> dist(x), Point(1,2))[1]

# We usually use custom adjoints to add gradients that Zygote can't derive itself (for example, because they ccall to BLAS). 
# But there are some more advanced and fun things we can to with @adjoint.

hook(f, x) = x

@adjoint hook(f, x) = x, x̄ -> (nothing, f(x̄))

gradient((a, b) -> hook(-, a)*b, 2, 3)

gradient((a, b) -> hook(ā -> @show(ā), a)*b, 2, 3)

checkpoint(f, x) = f(x)

@adjoint checkpoint(f, x) = f(x), ȳ -> Zygote._pullback(f, x)[2](ȳ)

gradient(x -> checkpoint(sin, x), 1)

foo(x) = (println(x); sin(x))

gradient(x -> checkpoint(foo, x), 1)

isderiving() = false

@adjoint isderiving() = true, _ -> nothing

nestlevel() = 0

@adjoint nestlevel() = nestlevel()+1, _ -> nothing

function f(x)
         println(nestlevel(), " levels of nesting")
         return x
       end

grad(f, x) = gradient(f, x)[1]

f(1);

grad(f, 1);

grad(x -> x*grad(f, x), 1);


