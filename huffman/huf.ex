defmodule Huf do
def sample do
'the quick brown fox jumps over the lazy dog
this is a sample text that we will use when we build
up a table we will only handle lower case letters and
no punctuation symbols the frequency will of course not
represent english but it is probably not that far off'
end
def text() do
'this is something that we should encode'
end
def bench(func) do
:timer.tc(fn() -> func.() end)
end
def time do 
{time,ans} = bench(fn()-> read("cain.txt") end)
#IO.inspect(ans)
{time2,ans2} = bench(fn()-> tree(ans) end)
#IO.inspect(ans2)
{time3,ans3} = bench(fn()-> encode_table(ans2) end)
#IO.inspect(ans3)
{time4,ans4} = bench(fn()-> encode(read("cain.txt"),ans3) end)
#IO.inspect(ans4)

{time5,ans5} = bench(fn()-> decode(ans4,ans3) end)
#IO.inspect(List.to_string(ans5))
{{"READ: " ,time},{"HUFFMAN TREE: ",time2},{"ENCODE TABLE: ",time3},{"ENCODE: ",time4},{"DECODE: ",time5} , {"ENODED BITS: ", length(ans4) }, {"NORMAL BITS: ", length(ans)*8 }}
end



def tester(text) do 
{time,ans} = bench(fn()-> read(text) end)
#IO.inspect(ans)
{time2,ans2} = bench(fn()-> tree(ans) end)
#IO.inspect(ans2)
{time3,ans3} = bench(fn()-> encode_table(ans2) end)
#IO.inspect(ans3)
{time4,ans4} = bench(fn()-> encode(read(text),ans3) end)
#IO.inspect(ans4)

{time5,ans5} = bench(fn()-> decode(ans4,ans3) end)
#IO.inspect(List.to_string(ans5))
{{"READ: " ,time},{"HUFFMAN TREE: ",time2},{"ENCODE TABLE: ",time3},{"ENCODE: ",time4},{"DECODE: ",time5} , {"ENODED BITS: ", length(ans4) }, {"NORMAL BITS: ", length(ans)*8 }}
end

def test do
sample = text()

tree = tree(sample)
IO.inspect(tree)
encode = encode_table(tree)
IO.inspect(encode)
s = encode('something',encode)
IO.inspect(s)
#decode = decode_table(tree)
#text = text()
#seq = encode(text, encode)
decode(s, encode)
end
def cain do 
    text =read("cain.txt")
     et =tree(text)
     tv =encode_table(et)
     IO.inspect(tv)
     tr =encode(text,tv)
     #_fy =decode(tr, tv)
end
def timetable do 
    text =read("cain.txt")
     et =tree(text)
     t1 = :os.system_time(:microsecond)
     tv =encode_table(et)
     t2 = :os.system_time(:microsecond)
     IO.inspect(t1)
    t2-t1
end

#----------------------------------TREE---------------------------------
def tree(sample) do
freq = freq(sample)
huffman(Enum.sort(Map.to_list(freq),&(sec(&1) <= sec(&2))))
end
def sec({_,x}) do x end
#----------------------------------ENCODE(FREQ -> TABLE)---------------------------------
def encode_table({left,_}) do encode_table(left,[]) end
def encode_table({left,right},ack) do
encode_table(left,[1|ack]) ++ encode_table(right,[0|ack])
end
def encode_table(s,ack) do [{s,Enum.reverse(ack)}] end


#----------------------------------ENCODE(TEXT -> BITS)---------------------------------

def encode([], _) do [] end
def encode([char|rest], table) do
code=lookup(char,table)
code ++ encode(rest,table)
end
def lookup(_,[]) do :error end
def lookup(char,[let|rest]) do
#IO.inspect(char)
case let do
    {^char,code} -> code
    _->lookup(char,rest)
end
end

#----------------------------------DECODE---------------------------------

def decode([], _) do [] end
def decode(seq, table) do
{char, rest} = decode_char(seq, 1, table)
[char | decode(rest, table)]
end
def decode_char(seq, n, table) do
{code, rest} = Enum.split(seq, n)
case List.keyfind(table, code, 1) do

{let,_} -> {let,rest}
nil -> decode_char(seq, n+1, table)
end
end


#----------------------------------ENCODE---------------------------------


def huffman([s]) do s end 
def huffman([{let,f}|[{let2,f2}|t]]) do 
 huffman( insert({{let,let2},f2+f},t) )
end
def insert(h,[]) do [h] end 
def insert({_,f} = h,[{_,c}=hs|t] = tail) do 
    cond  do
    c > f -> [h|tail]
    true -> [hs|insert(h,t)]
    end
end

def freq(sample) do freq(sample, %{} ) end
def freq([], freq) do freq end
def freq([char | rest], freq) do
    freq(rest, add(char,freq))
    end

def add(char,map) do 
    case Map.has_key?(map, char) do
        true -> Map.update!(map, char, &(&1 + 1))
        false ->  Map.put(map, char, 1)
    end       
end
#----------------------------------READFILE---------------------------------

def read(file) do
{:ok, file} = File.open(file, [:read, :utf8])
binary = IO.read(file, :all)
File.close(file)
case :unicode.characters_to_list(binary, :utf8) do
{:incomplete, list, _} ->
list
list ->
list
end
end


end




