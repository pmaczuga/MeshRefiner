"Module that contains all transformations responsible for breaking marked
traingles and removing hanging nodes."
module Transformations

export
    transform_p1!,
    transform_p2!,
    transform_p3!,
    transform_p4!,
    transform_p5!,
    transform_p6!,
    run_transformations!

include("p1.jl")
include("p2.jl")
include("p3.jl")
include("p4.jl")
include("p5.jl")
include("p6.jl")

"""
    run_for_all_triangles!(g, fun, log=false)

Run function `fun(g, i)` on all interiors `i` of graph `g`
"""
function run_for_all_triangles!(g, fun, log=false)
    get_interiors(graph) = filter_vertices(g, (g, v) -> (if get_prop(g, v, :type) == "interior" true else false end))

    ran = false
    for v in get_interiors(g)
        ex = fun(g, v)
        if ex && log
            println("Executed: ", String(Symbol(fun)), " on ", v)
        end
        ran |= ex
    end
    return ran
end

"""
    run_transformations!(g, log=false)

Execute all transformations (P1-P6) on all interiors of graph `g`. Stop when no
more transformations can be executed.

`log` flag tells wheter to log what transformation was executed on which vertex
"""
function run_transformations!(g, log=false)
    while true
        ran = false
        ran |= run_for_all_triangles!(g, transform_p1!, log)
        ran |= run_for_all_triangles!(g, transform_p2!, log)
        ran |= run_for_all_triangles!(g, transform_p3!, log)
        ran |= run_for_all_triangles!(g, transform_p4!, log)
        ran |= run_for_all_triangles!(g, transform_p5!, log)
        ran |= run_for_all_triangles!(g, transform_p6!, log)
        if !ran
            return false
        end
    end
end

end
