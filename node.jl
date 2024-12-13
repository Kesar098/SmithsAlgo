
struct node{T1<:Integer}
    parent::Union{Nothing,node{T1}}
    level::T1
    edgeSplit::T1
    #terminalInserted::T1

    node{T1}() where T1 = new{T1}(nothing,0,0)#,3)

    node{T1}(e::Integer, n::node{T1}) where T1 = new{T1}(n, n.level+1, e) #n.terminalInserted+1)
end



function test()
    n = node{Int64}()

    for i in 1:100
        n = node{Int64}(i,n)
    end
end


#@time test()
#=
struct node
    parent::Union{Nothing,node}
    level::Int64
    edgeSplit::Int64
    terminalInserted::Int64
end

function MakeNode(edge::Int64, currentNode::node)
    L = currentNode.level+1
    t = currentNode.terminalInserted+1
    return node{Int64}(currentNode, L, edge, t)
end
=#
