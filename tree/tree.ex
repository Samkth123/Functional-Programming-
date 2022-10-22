defmodule Tre do 

def tree_new do :nil end

def insert(e, :nil)  do  {:leaf,e}  end
def insert(e, {:leaf, v}) when e < v  do  {:node,v,{:leaf,e},nil}   end
def insert(e, {:leaf, v}) do  {:node,v,nil,{:leaf,e}}   end
def insert(e, {:node, v, left, right }) when e < v do
   {:node, v, insert(e,left), right }
end
def insert(e, {:node, v, left, right })  do
   {:node, v,left, insert(e,right) }
end
end

@type inst() ::  :nil |
 {:leaf,e}
 {:node, v, left, right }
 