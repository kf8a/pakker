# // signature algorithm.
# // Standard signature is initialized with a seed of
# // 0xaaaa. Returns signature.  If the function is called
# // on a partial data set, the return value should be
# // used as the seed for the remainder
# typedef unsigned short uint2;
# typedef unsigned long uint4;
# typedef unsigned char byte;
# uint2 calcSigFor(void const *buff, uint4 len, uint2 seed=0xAAAA)
# {
#   uint2 j, n;
#   uint2 rtn = seed;
#   byte const *str = (byte const *)buff;
#   // calculate a representative number for the byte
#   // block using the CSI signature algorithm.
#   for (n = 0; n < len; n++)
#   {
#     j = rtn;
#     rtn = (rtn << 1) & (uint2)0x01FF;
#     if (rtn >= 0x100)
#     rtn++;
#     rtn = (((rtn + (j >> 8) + str[n]) & (uint2)0xFF) | (j << 8));
#   }
#   return rtn;
# } // calcSigFor

defmodule Pakker.Signature do
  use Bitwise

  def sig(_message) do
  end

  def calc_sig(message, seed \\ 0xAAAA) do
    Enum.map(message, fn x -> csi_alg(x,seed) end)
  end

  def csi_alg(byte, seed) do
    old_seed = seed
    seed 
    |> shift_and_add_1ff
    |> increment_seed 
    |> compute_seed(byte, old_seed)
  end

  def increment_seed(seed) when seed >= 0x100 do
    band(seed + 1, 0xffff)
  end

  def increment_seed(seed) do
    seed
  end

  def shift_and_add_1ff(seed) do
    band(band(seed <<< 1, 0x01ff), 0xffff)
  end

  def compute_seed(seed, c, j) do
    bor(band(seed + (j >>> 8) + :binary.decode_unsigned(c), 0xff), band(j <<< 8, 0xffff))
  end
end

defmodule Signaturetest do
  use ExUnit.Case

  test 'compute seed' do
    assert 0xaaf5 == Pakker.Signature.compute_seed(0xaaa , "A", 0xaaa)
  end

  test 'compute signature bytes' do
    message = << 0x90, 0x01, 0x0f, 0x71 >>
    correct_signature = <<0x71, 0xd2 >>
    signature = Pakker.Signature.calc_sig(message)
    assert signature == correct_signature
  end
end
