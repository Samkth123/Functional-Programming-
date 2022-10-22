defmodule Li do 

  
def list_new() do [] end
def list_insert(e, []) do [e] end
def list_insert(e, [h|t]) do 
        cond do
            e<=h-> [e|[h|t]]
            e>h-> [h|list_insert(e,t)]
        end
 end
end