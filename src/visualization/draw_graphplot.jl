using Colors
using Printf
using GraphPlot

"""
    draw_graphplot(g, vid=false)

Draws 2D view of graph using `GraphPlot.jl`.

Not recommended for large graphs.

If `vid` (vertex id) is set to true each vertex is labeled after it's id. If not
label represents vertex type ('V', 'H', or 'I')
"""
function draw_graphplot(g, vid=false)
    function position_layout(g)
        x:: Array{Float64} = []
        y:: Array{Float64} = []
        for v in vertices(g)
            if get_prop(g, v, :type) == "interior"
                neigh = interior_vertices(g, v)
                center = center_point([coords(g, neigh[1]), coords(g, neigh[2]), coords(g, neigh[3])])
                push!(x, center[1])
                push!(y, center[2])
            else
                push!(x, get_prop(g, v, :x))
                push!(y, get_prop(g, v, :y))
            end
        end
        return x, y
    end
    # position_layout(g) = map((v) -> get_prop(g, v, :x), vertices(g)), map((v) -> get_prop(g, v, :y), vertices(g))

    if vid
        labels = 1:nv(g)
    else
        labels = map((vertex) -> uppercase(get_prop(g, vertex, :type)[1]), 1:nv(g))
    end

    edge_labels = []
    for edge in edges(g)
        if has_prop(g, edge, :length)
            push!(edge_labels, @sprintf("%.2f", get_prop(g, edge, :length)))
        else
            push!(edge_labels, "")
        end
    end

    edge_colors = []
    edge_width = []
    for edge in edges(g)
        if !has_prop(g, edge, :boundary)
            push!(edge_colors, colorant"yellow")
            push!(edge_width, 1.0)
        elseif get_prop(g, edge, :boundary)
            push!(edge_colors, colorant"lightgray")
            push!(edge_width, 3.0)
        else
            push!(edge_colors, colorant"lightgray")
            push!(edge_width, 1.0)
        end
    end

    vertex_size = []
    vertex_colors = []
    for vertex in 1:nv(g)
        if get_prop(g, vertex, :type) == "interior"
            push!(vertex_size, 1.0)
            if get_prop(g, vertex, :refine)
                push!(vertex_colors, colorant"orange")
            else
                push!(vertex_colors, colorant"yellow")
            end
        elseif get_prop(g, vertex, :type) == "vertex"
            push!(vertex_size, 1.0)
            push!(vertex_colors, colorant"lightgray")
        else
            push!(vertex_size, 1.0)
            push!(vertex_colors, colorant"gray")
        end
    end

    gplot(g,
        layout=position_layout,
        nodelabel=labels,
        nodefillc=vertex_colors,
        edgelabel=edge_labels,
        edgestrokec=edge_colors,
        edgelinewidth=edge_width,
        nodesize=vertex_size)
end
