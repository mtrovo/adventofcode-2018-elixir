defmodule Mix.Tasks.Day.Create do
  def run([name, fun_name]) do
    IO.puts("Creating day " <> name)
    module_name = Macro.camelize(name)

    create_input_file(name)
    create_lib_file(name, module_name, fun_name)
    create_spec_file(name, module_name, fun_name)
  end

  defp create_input_file(name) do
    File.write("input/#{name}.txt", IO.read(:stdio, :all))
  end

  defp create_lib_file(name, module_name, fun_name) do
    contents = generate_lib_file(module_name, fun_name)
    File.write("lib/#{name}.ex", contents)
  end

  defp create_spec_file(name, module_name, fun_name) do
    contents = generate_spec_file(module_name, fun_name)
    File.write("test/#{name}_test.exs", contents)
  end

  defp generate_lib_file(module_name, fun_name) do
    """
    defmodule Adventofcode2018.#{module_name} do
      use Adventofcode2018
      def #{fun_name}(input) do
        input
      end
    end
    """
  end

  defp generate_spec_file(module_name, fun_name) do
    """
    defmodule Adventofcode2018.#{module_name}Test do
      use Adventofcode2018.AdventCase
      import Adventofcode2018.#{module_name}
      describe "#{fun_name}/1" do
        test "" do
          assert 1337 = input |> #{fun_name}()
        end
        test_with_puzzle_input do
          assert 1337 = puzzle_input() |> #{fun_name}()
        end
      end
    end
    """
  end
end
