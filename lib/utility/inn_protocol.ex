defimpl InnProtocol, for: Integer do
  def validate(number) do
    d = Integer.digits(number, 10)
    cnt = length(d)

    base_coefficients = [2, 4, 10, 3, 5, 9, 4, 6, 8, 0]

    coefficients = [
      c10: base_coefficients,
      c11: [7] ++ base_coefficients ++ [0],
      c12: [3, 7] ++ base_coefficients
    ]

    case cnt do
      10 ->
        cs = control_sum(d, coefficients[:c10])
        cn = control_number(cs)
        diff = (cs - cn) |> IO.inspect(label: "diffrent")
        control_diff(diff, Enum.at(d, 9))

      12 ->
        cs11 = control_sum(d, coefficients[:c11])
        cn11 = control_number(cs11)
        diff11 = (cs11 - cn11) |> IO.inspect(label: "diffrent")
        cd11 = control_diff(diff11, Enum.at(d, 10))

        cs12 = control_sum(d, coefficients[:c12])
        cn12 = control_number(cs12)
        diff12 = (cs12 - cn12) |> IO.inspect(label: "diffrent")
        cd12 = control_diff(diff12, Enum.at(d, 11))

        cd11 && cd12
      _ ->
        false
    end
  end

  defp control_sum(digits, coefficient) do
    digits
    |> Enum.zip(coefficient)
    |> IO.inspect(label: "control_sum zip")
    |> Enum.map(fn {k, v} -> k * v end)
    |> IO.inspect(label: "control_sum map")
    |> Enum.reduce(0, fn x, amount -> x + amount end)
  end

  defp control_number(sum) do
    (div(sum, 11) * 11) |> IO.inspect(label: "control_number")
  end

  defp control_diff(10, control) do
    0 === control
  end

  defp control_diff(diff, control) do
    diff === control
  end
end
