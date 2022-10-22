defmodule Brot do

  # This is the client version.
  def start(mandel) do
    {:ok, spawn(fn -> init(mandel) end)}
  end

  defp init(mandel) do
    self = self()
    brot(mandel, self)
  end

  defp brot(mandel, self) do
    send(mandel, {:req, self})

    receive do
      {:pos, pr, pos, c, m} ->
        i = mandelbrot(c, m)
        send(pr, {:res, pos, i})
        brot(mandel, self)

      :done ->
        :ok
    end
  end

  # mandelbrot(c, m): calculate the mandelbrot value of
  # complex value c with a maximum iteration of m. Returns
  # 0..(m - 1).

  def mandelbrot(c, m) do
    mandelbrot_vanilla(c, m)
  end
  
  # This is the vanilla version
  def mandelbrot_vanilla(c, m) do
    z0 = Cmplx.new(0, 0)
    test(0, z0, c, m)
  end

  def test(m, _z, _c, m), do: 0
  def test(i, z, c, m) do
    a = Cmplx.abs(z)

    if a <= 2.0 do
      z1 = Cmplx.add(Cmplx.sqr(z), c)
      test(i + 1, z1, c, m)
    else
      i
    end
  end

  # This is using the Cmplx version of the calculation.
  def mandelbrot_cmplx(c, m) do
    Cmplx.mandelbrot(c, m)
  end

  # This is if we want to use the native code version.
  def mandelbrot_nif(c, m) do
    Cmplx.mandelbrot_nif(c, m)
  end
end

defmodule Mandel do

  def mandelbrot(width, height, x, y, k, depth) do
    trans = fn(w, h) ->
      Cmplx.new(x + k * (w - 1), y - k * (h - 1))
    end

    rows(width, height, trans, depth, [])
  end

  defp rows(_, 0, _, _, rows), do: rows
  defp rows(w, h, tr, depth, rows) do
    row = row(w, h, tr, depth, [])
    rows(w, h - 1, tr, depth, [row | rows])
  end

  defp row(0, _, _, _, row), do: row
  defp row(w, h, tr, depth, row) do
    c = tr.(w, h)
    res = Brot.mandelbrot(c, depth)
    color = Color.convert(res, depth)
    row(w - 1, h, tr, depth, [color | row])
  end

end