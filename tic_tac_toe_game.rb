class TicTacToe
  attr_reader :gameboard, :current_player
  # Définition des lignes gagnantes au Tic_tac_toe
  WINNING_LINES = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

  ##### Initialisation des joueurs et de la gameboard #####
  #########################################################
  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @gameboard = Gameboard.new
    @current_player = @player1
  end
              ##### Lancement de la partie ####
  #########################################################
  def start_game
    puts "Une petite partie de morpion ? C'est moi qui offre ;)"
    puts "  "
    gameboard.draw_board
    while 1
      puts "C'est au tour de #{current_player.player_id}"
      puts " "
      puts "Ecrit un nombre compris entre 1 (case en haut à gauche) et 9 (case en bas à droite)"
      puts " "
      puts "Ecrit exit pour fuir comme un lâche"
      input = gets.chomp
      input = input_validation(input)
      break if input == "exit"
      place_token(input)
      gameboard.draw_board
      look_for_winner
      board_full?
      next_turn
    end
  end

  private #Mis de la méthode en privée car elle ne doit pas pouvoir être appellée ailleurs

  #### Est-ce que tous les slots sont remplis ? ####
  ##################################################
  def board_full?
    if gameboard.slots.all? {|slot| slot.class == Token }
      puts "Egalité !"
      gameboard.reset_board
    end
  end

  #### Pour défini un vainqueur ####
  ##################################
  def look_for_winner
    winner = WINNING_LINES.any? do |line| #Appel des lignes gagnates définies plus haut
               line.all? do |index|
               if gameboard.slots[index].class == Token
                 gameboard.slots[index].token_owner == current_player.player_id
               end
             end
           end
    if winner
      print_winner(current_player.player_id)
    end
  end

  #### Affichage du gagnat ####
  #############################
  def print_winner(winner)
    puts "#{winner} à gagné !"
    gameboard.reset_board
  end

  #### Tour suivant ###
  #####################
  def next_turn
    @current_player == @player1 ? @current_player = @player2 : @current_player = @player1
  end
  #### Ajout d'un token selon le nom du current player ####
  #########################################################
  def place_token(location)
    gameboard.slots[location] = Token.new(current_player.player_id)
  end


  #### Récupération des inputs + méthode d'exit ####
  ###################################################
  def input_validation(input)
    return "exit" if input.downcase == "exit"
    input = input.to_i
    while 1
      while !(input.between?(1,9))
        puts "Entrez un nombre entre 1 et 9"
        input = gets.chomp.to_i
        puts " "
      end

      #### Si la case est pleine on affiche un message d'erreur ####
      ##############################################################
      if gameboard.slots[input - 1].class == Token
        puts "Case pleine, il faut en trouver une autre :/"
        input = gets.chomp.to_i
        puts " "
        next
      end
      return input - 1
    end
  end

      ############# DEFINITION D'UN PLAYER #############
      #########################################################
  class Player
    attr_accessor :player_id

  	@@player_count = 0

  	def initialize
      @@player_count += 1
      @player_id = "player#{@@player_count}"
  	end
  end

    ############# DEFINITION D'UNE GAMEBOARD ##############
    #########################################################
  class Gameboard
    attr_accessor :slots
    # Slots de 1 à 9 , vides
  	def initialize
  	  @slots = (1..9).to_a
      @slots.map! { |slot| slot = "empty slot" }
  	end

    #### Affichage de la board vide ####
    ####################################
    def draw_board
      slots.each_with_index do |slot, index|
        if index == 2 || index == 5 || index == 8
          if slot.class == Token
            puts "| #{slot.token_model} |"

          else
            puts "|   |"


          end
        else
          if slot.class == Token
            print "| #{slot.token_model} |"

          else
            print "|   |"

          end
        end

      end
    end

    #### Remise à 0 de la board ####
    ################################
    def reset_board
      @slots.map! { |slot| slot = "empty slot" }
    end
  end

  #### Création d'un token (ou une couleur) pour le joueur ####
  #############################################################
  class Token
    attr_reader :token_model, :token_owner
    def initialize(player_id)
      @token_owner = player_id
      @token_owner == "player1" ? @token_model = "X" : @token_model = "O"
    end
  end

end
  #### Lancement de la partie, ouiiiiiiii c'est rigolo le morpion ####
  ####################################################################
my_game = TicTacToe.new
my_game.start_game
