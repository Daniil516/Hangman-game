class ConsoleInterface
  # В константе FIGURES будут лежать все текстовые файлы из папки figures,
  # помещённые в массив. Один элемент массива — одна строка с содержимым целого
  # файла.
  FIGURES =
      Dir["#{__dir__}/../data/figures/*.txt"].
      sort.
      map { |file_name| File.read(file_name) }

  # На вход конструктор класса ConsoleInterface принимает экземпляр класса Game.
  #
  # Экземпляр ConsoleInterface выводит информацию юзеру. При выводе использует
  # статические строки типа "У вас осталось ошибок:" и информацию из экземпляра
  # класса Game, дёргая у него методы, которые мы придумали.
  def initialize(game)
    @game = game
  end

  # Выводит в консоль текущее состояние игры, используя данные из экземпляра
  # класса Game (количество ошибок, сколько осталось попыток и т.д.)
  def print_out
    puts <<~END
      #{("Word:" + word_to_show).colorize(:light_blue)} 
      #{figure.colorize(:yellow)}
      #{ ("Mistakes" + "(" + @game.errors_made.to_s + "):" + errors_to_show).colorize(:red) } 
      
      #{("You have attempts: " + @game.errors_allowed.to_s).colorize(:red)}

    END
    if @game.won?
      puts "Congratulations, you win!"
    elsif @game.lost?
      puts "You failed, the hidden word: #{@game.word}"
    end
  end

  # Возвращает ту фигуру из массива FIGURES, которая соответствует количеству
  # ошибок, сделанных пользователем на данный момент (число ошибок берем у
  # экземпляра класса Game)
  def figure
    FIGURES[@game.errors_made]
  end

  # Метод, который готовит слово для вывода "на игровом табло".
  #
  # Получает на вход массив: каждый элемент массива соответствует одной букве в
  # загаданном слове. Но на позиции отгаданной буквы — сама эта буква (строка из
  # одного символа), а на позиции неотгаданной буквы — nil.
  #
  # Метод трансформирует массив (записывает вместо nil два подчеркивания),
  # и склеивает в строку, разделяя элементы пробелами. Получается как-то так:
  #
  # На вход передали: ["К", "О", nil, "О", nil, nil],
  # на выходе будет: "К О __ О __ __"
  def word_to_show
    result =
      @game.letters_to_guess.map do |letter|
        if letter == nil
          "__"
        else
          letter
        end
      end

    result.join(" ")
  end

  # Получает массив ошибочных букв и склеивает их в строку вида "Х, У"
  def errors_to_show
    @game.errors.join(", ")
  end

  # Получает букву из пользовательского ввода, приводит её к верхнему регистру
  # и возвращает её
  def get_input
    print "Enter the next letter: ".colorize(:green)
    letter = gets[0].upcase
    letter
  end
end
