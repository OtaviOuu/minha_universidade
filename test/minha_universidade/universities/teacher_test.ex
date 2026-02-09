defmodule MinhaUniversidade.Universities.TeacherTest do
  use MinhaUniversidade.DataCase, async: true

  describe "Tunez.Music.read_artists!/0-2" do
    test "when there is no data, nothing is returned" do
      assert Tunez.Music.read_artists!() == []
    end
  end
end
