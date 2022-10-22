defmodule Cmplx do
    #{real,img}
    def new(re,im) do {re,im} end
    def add({ra,ia},{rb,ib}) do {ra+rb,ia+ib} end
    def sqr({re,im}) do {(re*re) - (im*im),  2*re*im } end
    def abs({re,im}) do :math.sqrt(((re*re) + (im*im)))
  end
end

defmodule Brot do 

def mandelbrot(c, m) do
z0 = Cmplx.new(0, 0)
i = 0
test(i, z0, c, m)
end

def test(m, _, _, m)do 0 end
def test(i, zi, c, m)do
ans =  Cmplx.add(Cmplx.sqr(zi), c)
#IO.inspect(Cmplx.abs(ans))
#IO.inspect("-------------------")
cond do
    Cmplx.abs(ans) >= 2 -> i
    Cmplx.abs(ans) < 2 -> test(i+1,ans,c,m)
end

end

end


defmodule PPM do 

 def write(name, image) do
    height = length(image)
    width = length(List.first(image))
    {:ok, fd} = File.open(name, [:write])
    IO.puts(fd, "P6")
    IO.puts(fd, "#generated by ppm.ex")
    IO.puts(fd, "#{width} #{height}")
    IO.puts(fd, "255")
    rows(image, fd)
    File.close(fd)
  end

  defp rows(rows, fd) do
    Enum.each(rows, fn(r) ->
      colors = row(r)
      IO.write(fd, colors)
    end)
  end

  defp row(row) do
    List.foldr(row, [], fn({:rgb, r, g, b}, a) ->
      [r, g, b | a]
    end)
  end

end

defmodule Color do 

def convert(depth, max) do 
a = ((depth/max) * 4)
x=trunc(a)
y = trunc(255*(a-x))

#red
case x do
   0 ->
      #black to darkblue
      {:rgb, trunc(y/2), 0,  y }
     
      #white to blue
    1 ->
      {:rgb, 255-y, 255-y,  255 }
      
      #black
    2 ->
     {:rgb, y, 0, 255}
      #black
    3 ->
      {:rgb, 0, 255 - y, 255}
      #{:rgb, 255, y, 0}
      #black
    4 ->
      {:rgb, 0, 255 - y, 255}
     #{:rgb, 255-y, y, 0}
    end

end

end

defmodule Mandel do ## fixa till O(N)
def mandelbrot(width, height, x, y, k, depth) do
trans = fn(w, h) ->
Cmplx.new(x + k * (w - 1), y - k * (h - 1))
end
rows(width, height, trans, depth, [])
end
def rows(_,0, _, _, list) do list end
def rows(width, height, trans, depth, list) do 
single = single(width, height, trans, depth,[])
list = [single | list] 
rows(width, height-1, trans, depth, list)
end

def single(0, _, _, _, list) do list end
def single(width, height, trans, depth, list) do
comp=trans.(width,height)
val=Brot.mandelbrot(comp,depth)
single(width-1, height, trans, depth, [Color.convert(val,depth)|list])
end


end
#-1.6, 0.2, 0.2 cords report
defmodule Test do 
def demo() do
small(-3.5, 1.2, 1.2)
end
def small(x0, y0, xn) do
width = 1280
height = 640
depth = 50
k = (xn - x0) / width
image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
PPM.write("git.ppm", image)
end
end



  #0 ->
        #black to blue
 #       {:rgb, 0, 0, y}
        #blue to purple
  #    1 ->
 #      {:rgb, 255-y, 0,  255-y }
        
        #purple to 
 #     2 ->
  #     {:rgb, 255-y, 0, y}

  #    3 ->
  #      {:rgb, 0, 255, y}
  #    4 ->
  #      {:rgb, 0, 255 - y, 255}
#    end



#0 ->
#       #black to darkblue
#       {:rgb, trunc(y/2), 0,  y }
#      
#       #white to blue
#     1 ->
#       {:rgb, 255-y, 255-y,  255 }
#       
#       #black
#     2 ->
#      {:rgb, 0, 0, 0}
#       #black
#     3 ->
#       {:rgb, 0, 0, 0}
#       #black
#     4 ->
#       {:rgb, 0, 0, 0}





#0 ->
#       #black to darkblue
#       {:rgb, trunc(y/2), 0,  y }
#      
#       #white to blue
#     1 ->
#       {:rgb, 255-y, 255-y,  255 }
#       
#       #black
#     2 ->
#      {:rgb, y, 0, 255}
#       #black
#     3 ->
#       {:rgb, 0, 255 - y, 255}
#       #{:rgb, 255, y, 0}
#       #black
#     4 ->
#       {:rgb, 0, 255 - y, 255}
#      #{:rgb, 255-y, y, 0}