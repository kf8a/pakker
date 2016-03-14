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
  # Pythonish version
  # def calcSigFor(buff, seed = 0xAAAA) do
  #   sig = seed
  #   for x in buff:
  #     x = ord(x)
  #     j = sig
  #     sig = (sig <<1) & 0x1FF
  #     if sig >= 0x100: sig += 1
  #     sig = ((((sig + (j >>8) + x) & 0xFF) | (j <<8))) & 0xFFFF
  #   sig
  # end


defmodule Pakker.Signature do
  use Bitwise

  def calc_sig_nullifier(sig) do
    new_seed = band(sig <<< 1, 0x1ff)
    new_seed =increment_seed(new_seed)
    null1 = compute_null(sig, new_seed)
    new_sig = calc_sig([null1], sig)

    new_seed = band(new_sig <<< 1, 0x01ff)
    new_seed =increment_seed(new_seed)
    null2 = compute_null(sig, new_seed)
    <<null1, null2>>
  end

  def calc_sig([byte | tail], sig) do
    x = case is_binary(byte) do
      true -> :binary.decode_unsigned(byte)
      false -> byte
    end

    j = sig
    sig = band((sig <<< 1), 0x1ff)
    sig = increment_seed(sig)
    sig = compute_next_sig(sig, j, x)
    calc_sig(tail, sig)
  end

  def calc_sig([], sig) do
    sig 
  end

  def compute_null(sig, seed) do
    band(0x0100 - (seed + (sig >>> 8 )), 0xff)
  end

  def increment_seed(seed) when seed >= 0x100 do
    band(seed + 1, 0xffff)
  end

  def increment_seed(seed) do
    seed
  end

  def compute_next_sig(sig, x, j) do
    band(bor(band(sig + (j >>> 8) + x, 0xff), (j <<<8)), 0xffff)
  end

end

defmodule Signaturetest do
  use ExUnit.Case

  test 'compute seed' do
    assert 43765 == Pakker.Signature.compute_next_sig(0xaaa , 65, 0xaaa)
  end

  test 'compute null' do
    assert 0 == Pakker.Signature.compute_null(0xdd, 0xaaa)
  end

  test 'compute signature nullifer bytes' do
    message = << 0x90, 0x01, 0x0f, 0x71 >>
    signature = Pakker.Signature.calc_sig(:erlang.binary_to_list(message), 0xAAAA)
    nullifier = Pakker.Signature.calc_sig_nullifier(signature)
    correct_nullifer = <<0x71, 0xd2 >>
    assert nullifier == correct_nullifer
  end
end
