
defmodule Pakker.Signature do
  use Bitwise

  def calc_sig_nullifier(sig) do
    new_seed = band(sig <<< 1, 0x1ff)
    new_seed =increment_seed(new_seed)
    null1 = compute_null(sig, new_seed)
    new_sig = calc_sig([null1], sig)

    new_seed = band(new_sig <<< 1, 0x1ff)
    new_seed =increment_seed(new_seed)
    null2 = compute_null(sig, new_seed)
    <<null1, null2>>
  end

  def calc_sig([byte | tail], sig) do
    x = ord(byte)
    j = sig
    sig = band((sig <<< 1), 0x1ff)
    sig = increment_seed(sig)
    sig = compute_next_sig(sig, j, x)
    calc_sig(tail, sig)
  end

  def calc_sig([], sig) do
    sig
  end

  def ord(byte) when is_binary(byte) do
    :binary.decode_unsigned(byte)
  end

  def ord(byte) do
    byte
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
    assert 86 == Pakker.Signature.compute_null(0xdd, 0xaaa)
  end

  test 'compute signature for "message" ' do
		# {"message", 0x1a17},
    assert 0x1a17 == Pakker.Signature.calc_sig('message', 0xAAAA)
  end

  test 'compute signature for "testing"' do
		# {"testing", 0x1ef5},
    assert 0x1ef5 == Pakker.Signature.calc_sig('testing', 0xAAAA)
    # message = << 0x90, 0x01, 0x0f, 0x71 >>
    # signature = Pakker.Signature.calc_sig(:erlang.binary_to_list(message), 0xAAAA)
    # assert signature == << 0 >>
  end

  test 'compute signature nullifer bytes' do
    assert << 0xb8, 0xe9>> == Pakker.Signature.calc_sig_nullifier(0x1a17)
		# {0x23a7, 0x8e59},
    # message = << 0x90, 0x01, 0x0f, 0x71 >>
    # signature = Pakker.Signature.calc_sig(:erlang.binary_to_list(message), 0xAAAA)
    # nullifier = Pakker.Signature.calc_sig_nullifier(signature)
    # correct_nullifer = <<0x71, 0xd2 >>
    # assert nullifier == correct_nullifer
  end
end
