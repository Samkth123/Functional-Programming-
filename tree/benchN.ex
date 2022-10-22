defmodule Bench do
  
  def bench() do bench(100) end

  def bench(l) do

    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]

    time = fn (i, f) ->
      seq = Enum.map(1..i, fn(_) -> :rand.uniform(100000) end)
      elem(:timer.tc(fn () -> loop(l, fn -> f.(seq) end) end),0)
    end

    bench = fn (i) ->

      list = fn (seq) ->
        List.foldr(seq, list_new(), fn (e, acc) -> list_insert(e, acc) end)
      end

      tree = fn (seq) ->
        List.foldr(seq, tree_new(), fn (e, acc) -> tree_insert(e, acc) end)
      end      

      tl = time.(i, list)
      tt = time.(i, tree)

      IO.write("  #{tl}\t\t\t#{tt}\n")
    end

    IO.write("# benchmark of lists and tree (loop: #{l}) \n")
    Enum.map(ls, bench)

    :ok
  end
  
  def loop(0,_) do :ok end
  def loop(n, f) do 
    f.()
    loop(n-1, f)
  end
  
def list_new() do [] end
def list_insert(e, []) do [e] end
def list_insert(e, [h|t]) do 
        cond do
            e<=h-> [e|[h|t]]
            e>h-> [h|list_insert(e,t)]
        end
 end


#frågor till föreläsning:
#1. ska man kolla om det nya värdet är member i trädet sen skriva över det eller ska man vara stoppa in saker
#2.
  
def tree_new do :nil end

def tree_insert(e, :nil)  do  {:leaf,e}  end
def tree_insert(e, {:leaf, v}) when e < v  do  {:node,v,{:leaf,e},:nil}   end
def tree_insert(e, {:leaf, v}) do  {:node,v,:nil,{:leaf,e}}   end

def tree_insert(e, {:node, v, left, right }) when e < v do
    {:node, v, tree_insert(e,left), right }
end
def tree_insert(e, {:node, v, left, right })  do
    {:node, v,left, tree_insert(e,right)}
end

end



# benchmark of lists and tree rimliga värden?
#0                       0
#0                       0
#0                       0
#102                     0
#102                     0
#819                     102
#3686                    307
#17100                   1536
#62259                   1843
#258969                  4403