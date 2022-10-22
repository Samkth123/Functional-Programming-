defmodule Train do
#----FRÅGOR-----
#1.HUR KOMMER TRÄD IN I BILDEN????
#2."Please put all together in one file list.erl" SIDA 4/8 
#3.INDEXERING FRÅN 1!!!
#4.Split på sida 5/8  "split([:a,:b,:c],a)" ska de funka med a eller är :a ok??
#5. 
#------------List operations-----------
#1
def take(_,0) do [] end
def take([h|t],n) do 
[h|take(t,n-1)]
end
#2
def drop(xs,0) do xs end
def drop([_|t],n) do drop(t,n-1) end
#3
def append([],ys) do ys end
def append([h|t],ys) do [h|append(t,ys)] end
#4
def member([],_) do false end
def member([h|t],y) do 
    case h do
        ^y-> true
        _->member(t,y)
    end
end
#5 (tydligen indexerat från 1 :/ fixa på slutet)
def pos([h|t],y) do
case h do
     ^y-> 1
     _->1+pos(t,y)
end 
end
#-------------------Single Move----------------    

def single(move,input) do
{track,nr} = move
{main,one,two} = input
cond do
    track == :one and nr > 0 -> {take(main,length(main)-nr),append(drop(main,length(main)-nr),one),two}
    track ==:one and nr < 0 -> {append(main,take(one,nr*-1)),drop(one,nr*-1),two} 

   track == :two and nr > 0 -> {take(main,length(main)-nr),one,append(drop(main,length(main)-nr),two)}
   track == :two and nr < 0 -> {append(main,take(two,nr*-1)),one,drop(two,nr*-1)}

    nr == 0 -> {main,one,two}
end
end

def move([],state) do [state] end
def move([h|t],state) do 
new = single(h,state)
[ state | move(t,new)]
end

def find(_,[]) do [] end
def find(xs,[y|yt]) do
{hs,ts}=split(xs,y)
[_|t] = append(ts,hs)
move = [{:one,length(ts)},{:two,length(hs)},{:one,length(ts) * -1},{:two,length(hs)*-1}]                   #[n|t] = append(one,two)
append(move,find(t,yt))
end

def few(_,[]) do [] end
def few(xs,[y|yt]) do
[head|t] = xs
if head == y do 
        few(t,yt)
    else
{hs,ts}=split(xs,y)
[_|t] = append(ts,hs)
move = [{:one,length(ts)},{:two,length(hs)},{:one,length(ts) * -1},{:two,length(hs)*-1}]                   #[n|t] = append(one,two)
append(move,few(t,yt))
    end
end

def split(train,e) do
    pos = pos(train,e)
    {take(train,pos-1),drop(train,pos-1)}
end

def rules([]) do [] end
def rules([h|[]]) do
{_,nr} = h
    if nr == 0 do
    []
    else
    [h]
    end 
end
def rules([{_,0}|t]) do rules(t) end
def rules([h|[h2|t]]) do 
{track,nr} = h
{track2,nr2} = h2
        case track do
             ^track2 when nr != 0 -> [{track,nr+nr2}|rules(t)]
             _->[h|rules([h2|t])]
        end
end

def compress(ms) do
ns = rules(ms)
    case ns do
        ^ms-> ms
        _->compress(ns) 
    end
end






end

