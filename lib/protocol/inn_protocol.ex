defprotocol InnProtocol do
  @doc "Проверка контрольной суммы ИНН согласно алгоритму"
  @spec validate(integer()) :: boolean()
  def validate(number)
end
