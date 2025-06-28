# --- Maria Eduarda Rampanelli (20230003566) e Isadora Sbeghen de Campos (20230002890) ---

.data
   totalDistribuidas: .word 0
   totalCartas: .word 52
   pontuacaoJ: .word 0
   pontuacaoD: .word 0
   tamMaoJ: .word 0
   tamMaoD: .word 0
   quantAsJ: .word 0
   quantAsD: .word 0
   pontuacaoJRodada: .word 0
   pontuacaoDRodada: .word 0
   maoJ: .space 52
   maoD: .space 52
   cartasDistribuidas: .space 52
   
   # strings
   msgInicio: .string "Bem-vindo ao BlackJack!\n"
   msgDesejaJogar: .string "\nDeseja jogar? (1 - Sim, 2 - Não): "
   msgTotalCartas: .string "\nTotal de cartas: "
   msgPontuacao: .string "\nPontuação: "
   msgPontuacaoJ: .string "\nJogador: "
   msgPontuacaoD: .string "\nDealer: "
   msgHitStand: .string "\nO que deseja fazer? (1- Hit, 2 - Stand): "
   msgE: .string " e "
   msgMais: .string " + "
   msgIgual: .string " = "
   msgJRecebe: .string "\nO jogador recebe: "
   msgDRecebe: .string "\nO dealer recebe: "
   msgDCartaOculta: .string "uma carta oculta"
   msgDealerContinua: .string "\nO dealer deve continuar pedindo cartas..."
   msgJTem: .string "\nSua mão: "
   msgDTem: .string "\nO dealer tem: "
   msgVenceu: .string "\nVocê venceu!"
   msgPerdeu: .string "\nO dealer venceu!"
   msgEmpate: .string "\nEmpate!"
   
.text
   la a0, msgInicio # salva a mensagem no a0
   li a7, 4 # função ecall para imprimir
   ecall #executa

main_loop:
   call mostraPontuacao # chama a pontuação
   call verificaDesejo # verifica se deseja joga ou não
   call jogar_rodada # chama jogo
   j main_loop # retorna

# --- Função: verificaDesejo ---
verificaDesejo:
   la a0, msgDesejaJogar  #salva a mensagem no a0
   li a7, 4 # função ecall para imprimir
   ecall #executa
   li a7, 5 # função que avisa o ecall salvar a escolha
   ecall # executa
   li t0, 2 # carrega no registrador t0 a opção 2
   beq a0, t0, encerrar_jogo #verifica se a resposta do usuário é igual a 2, se sim, pula para encerrar o jogo
   ret #retorna para a últa função, qe seria a main

# --- Função: mostraPontuacao ---
mostraPontuacao:
   la a0, msgTotalCartas 
   li a7, 4			#mostra a mensagem de total de cartas
   ecall

   la t0, totalCartas
   lw a0, 0(t0)			#mostra o total de cartas
   li a7, 1
   ecall

   la a0, msgPontuacao		#mostra a mensagem Pontuação
   li a7, 4
   ecall

   la a0, msgPontuacaoJ
   li a7, 4			
   ecall

   la t0, pontuacaoJRodada
   lw a0, 0(t0)			#mostra a pontuação do jogador
   li a7, 1
   ecall

   la a0, msgPontuacaoD		
   li a7, 4
   ecall

   la t0, pontuacaoDRodada
   lw a0, 0(t0)			#mostra a a pontuação do dealer
   li a7, 1
   ecall

   ret

# --- Função: distribuiCartas ---
distribuiCartas:
   la t0, totalDistribuidas # salva o total em t0
   lw t1, 0(t0) #carrega o valor do total

   addi t2, zero, 40 #limita o t2 em 40, para reninciar a distribuição
   bgt t1, t2, reiniciaDistribuicao # se t2 for igual a 40 pula para reninciar 

continuaDistribuicao:
   li a0, 0  # gera um número de 0
   li a1, 13 # até 13, ou seja [0,12]
   li a7, 42 # faz um ramdom desses números
   ecall # executa

   addi a0, a0, 1 #transforma [0,12] em [1,13]
   addi t3, a0, 0 # salva a carta sorteada e t3

   la t4, cartasDistribuidas # salva em t4 a quantidade de cartas distribuidas
   slli t5, t3, 2 # multiplica o valor que saiu por 2, para adicionar no local da memória que ele vai
   add t6, t4, t5 # soma o valor de t4 com o vaor de t5, resultando no endereço que a carta foi distribuida 
   lw t1, 0(t6) # carrega em t1 o endereço que esta em t6

   addi t2, zero, 4 # adiciona o valor 4 no t2
   bge t1, t2, distribuiCartas  # se a carta já foi distribuída 4 vezes, ele sorteia outra

   addi t1, t1, 1 
   sw t1, 0(t6)   # adiciona mais um para a carta que foi dstribuída 

   lw t2, 0(t0)  # lê o totalDistribuidas
   addi t2, t2, 1
   sw t2, 0(t0) #atualiza a quantidade de cartas distribuidas
   
   la t4, totalCartas  
   lw t5, 0(t4)
   addi t5, t5, -1
   sw t5, 0(t4) 	# diminui o total de cartas

   addi a0, t3, 0
   ret

reiniciaDistribuicao:
   la t3, cartasDistribuidas # adiciona em t3 a quantidade de cartas distribuidas
   addi t4, zero, 0 # zera o t4, que guarda a quantidades tiradas
   
   la t5, totalCartas # Reinicia o valor do total de cartas
   li t6, 52 # carrega 52 cartas em t6
   sw t6, 0(t5) # salva na memoria o total de cartas
   
reiniciaLoop:
   addi t5, zero, 13  
   beq t4, t5, fimReinicia # se t4 = t5 ele zerou o toral de cartas e vai para o fim renincia
   sw zero, 0(t3) # zera a posição atual de cartasDistribuidas
   addi t3, t3, 4  #avança 4bytes 
   addi t4, t4, 1 #incrementa 1 no contador
   j reiniciaLoop #repete o looping

fimReinicia:
   sw zero, 0(t0) #zera o total distribuidas
   j distribuiCartas #volta para a distribuição

# --- Função: jogar_rodada ---
jogar_rodada:
   la t0, pontuacaoJ # salva no registrador t0 a pontuação do jogador
   sw zero, 0(t0) 
   sw zero, 4(t0)
   sw zero, 8(t0)    # zera as posições da memória que salvam as cartas que o uusuário pegou
   sw zero, 12(t0)
   sw zero, 16(t0)
   sw zero, 20(t0)
   
   call jogador_jogada # pula para o jogador jogada
   call jogador_jogada # pula para jogador jogada
   
   call dealer_jogada
   call dealer_jogada

   call mostra_cartas_recebidas
   call mostra_maoJ

# --- Função: jogador_turno ---
jogador_turno:
   la a0, msgHitStand
   li a7, 4		#identifica se deseja jogar ou não
   ecall

   li a7, 5
   ecall		#lê a escolha
   addi t3, a0, 0

   addi t4, zero, 1
   beq t3, t4, jogador_hit	#se escolheu 1 pula para jogador_hit
   addi t5, zero, 2
   beq t3, t5, dealer_turno	#se hogador escolheu 2 pula para dealer_turno
   j jogador_turno		# repete a pergunta

jogador_hit:
   call jogador_jogada
   call mostra_carta_recebidaJ
   call mostra_maoJ
   call mostra_maoD

   la t0, pontuacaoJ
   lw t6, 0(t0)
   addi t4, zero, 21
   bgt t6, t4, jogador_estourou	# se o jogador passou de 21, pula para jogador_estorou
   j jogador_turno	# retorna para o jogador_turno

jogador_estourou:
   la a0, msgPerdeu
   li a7, 4		#imprime você perdeu
   ecall
   la t2, pontuacaoDRodada
   lw t3, 0(t2)
   addi t3, t3, 1   # adiciona mais um na pontuação da rodada do dealer
   sw t3, 0(t2)
   
   j main_loop

# --- Função: dealer_turno ---
dealer_turno:
dealer_loop:
   la t1, pontuacaoD
   lw t5, 0(t1)
   li t6, 17
   bge t5, t6, verifica_vencedor  # Se dealer >= 17, para

   la a0, msgDealerContinua
   li a7, 4
   ecall
  
   call dealer_jogada
   call mostra_carta_recebidaD
   call mostra_maoD

   la t1, pontuacaoD
   lw t5, 0(t1)
   li t6, 21
   bgt t5, t6, dealer_estourou # se o dealer passar de 21

   j dealer_loop #continua pegando carta

dealer_estourou:
   la a0, msgVenceu
   li a7, 4
   ecall
   
   la t2, pontuacaoJRodada
   lw t3, 0(t2)
   addi t3, t3, 1   # adiciona mais um na pontuação da rodada do jogador
   sw t3, 0(t2)
   
   j main_loop

# Função que adiciona o valor da carta na mão do jogador - Recebe em t2 a carta sorteada
adiciona_maoJ:
   la t0, tamMaoJ
   lw t1, 0(t0) # t1 = tamanho do vetor (índice)
   
   la t4, maoJ # t4 = endereço base do vetor
   slli t3, t1, 2 # t3 = índice * 4 (para pegar o próximo endereço de memória livre)
   add t5, t4, t3 # t5 = endereço para a carta nova
   sw t2, 0(t5)
   
   addi t1, t1, 1
   sw t1, 0(t0)
   ret
    
# Função que adiciona o valor da carta na mão do dealer - Recebe em t2 a carta sorteada
adiciona_maoD:
   la t0, tamMaoD
   lw t1, 0(t0)
   
   la t4, maoD
   slli t3, t1, 2
   add t5, t4, t3
   sw t2, 0(t5)
   
   addi t1, t1, 1
   sw t1, 0(t0)
   ret
      
# Função que mostra as cartas recebidas
mostra_cartas_recebidas:
   la a0, msgJRecebe
   li a7, 4
   ecall
   
   la t0, maoJ
   lw t1, 0(t0) # Primeira carta tirada
   mv a0, t1
   li a7, 1
   ecall
   
   la a0, msgE
   li a7, 4
   ecall
   
   lw t2, 4(t0)
   mv a0, t2
   li a7, 1
   ecall
   
   la a0, msgDRecebe
   li a7, 4
   ecall
   
   la t0, maoD
   lw t1, 0(t0)
   mv a0, t1
   li a7, 1
   ecall
   
   la a0, msgE
   li a7, 4
   ecall
   
   la a0, msgDCartaOculta
   li a7, 4
   ecall
   ret

# Função que mostra a última carta recebida do jogador     
mostra_carta_recebidaJ:
  la a0, msgJRecebe
  li a7, 4
  ecall

  la t0, tamMaoJ
  lw t1, 0(t0)
  
  li t2, 1
  sub t1, t1, t2 # pegar o último índice do vetor
  slli t1, t1, 2
  
  la t3, maoJ
  add t4, t3, t1 # t4 = endereço da última carta
  lw t2, 0(t4)
  
  mv a0, t2
  li a7, 1
  ecall 
  ret
  
# Função que mostra a última carta recebida do dealer   
mostra_carta_recebidaD:
  la a0, msgDRecebe
  li a7, 4
  ecall

  la t0, tamMaoD
  lw t1, 0(t0)
  
  li t2, 1
  sub t1, t1, t2
  slli t1, t1, 2
  
  la t3, maoD
  add t4, t3, t1
  lw t2, 0(t4)
  
  mv a0, t2
  li a7, 1
  ecall 
  ret 
  
# Função que mostra a mão completa do jogador (Exemplo: 4 + 6 = 10)
mostra_maoJ:
  la a0, msgJTem
  li a7, 4
  ecall

  la t0, tamMaoJ
  lw t1, 0(t0)
  la t2, maoJ
  li t3, 0 # contador loop

loop_mostra_maoJ:
  beq t3, t1, fim_loop_mostraMaoJ
  slli t4, t3, 2
  add t5, t2, t4 # t5 = endereço da carta
  lw t6, 0(t5)
  
  mv a0, t6
  li a7, 1
  ecall
  
  addi a3, t1, -1     # t7 = última posição do vetor
  beq t3, a3, pula_mais_maoJ

  la a0, msgMais
  li a7, 4
  ecall

pula_mais_maoJ:
  addi t3, t3, 1
  j loop_mostra_maoJ

fim_loop_mostraMaoJ:
  la a0, msgIgual
  li a7, 4
  ecall

  la t0, pontuacaoJ
  lw a0, 0(t0)
  li a7, 1
  ecall

  ret
  
# Função que mostra a mão completa do dealer  
mostra_maoD:
  la a0, msgDTem
  li a7, 4
  ecall

  la t0, tamMaoD
  lw t1, 0(t0)
  la t2, maoD
  li t3, 0 # contador loop
  
loop_mostra_maoD:
  beq t3, t1, fim_loop_mostraMaoD
  slli t4, t3, 2
  add t5, t2, t4 # t5 = endereço da carta
  lw t6, 0(t5)
  
  mv a0, t6
  li a7, 1
  ecall
  
  addi a3, t1, -1     # t7 = última posição do vetor
  beq t3, a3, pula_mais_maoD

  la a0, msgMais
  li a7, 4
  ecall

pula_mais_maoD:
  addi t3, t3, 1
  j loop_mostra_maoD

fim_loop_mostraMaoD:
  la a0, msgIgual
  li a7, 4
  ecall

  la t0, pontuacaoD
  lw a0, 0(t0)
  li a7, 1
  ecall

  ret  

# Função que verifica quem ganhou a partida
verifica_vencedor:
   la t0, pontuacaoJ
   lw t6, 0(t0)
   la t1, pontuacaoD
   lw t5, 0(t1)

   beq t6, t5, empate
   blt t6, t5, dealer_ganha

   la a0, msgVenceu
   li a7, 4
   ecall
   
   # se chegar aqui é porque o jogador ganhou
   la t2, pontuacaoJRodada
   lw t3, 0(t2)
   addi t3, t3, 1   # adiciona mais um na pontuação da rodada do jogador
   sw t3, 0(t2)
   
   j main_loop

dealer_ganha:
   la a0, msgPerdeu
   li a7, 4
   ecall
   
   la t2, pontuacaoDRodada
   lw t3, 0(t2)
   addi t3, t3, 1   # adiciona mais um na pontuação da rodada do dealer
   sw t3, 0(t2)
   
   j main_loop

empate:
   # se empatou não soma na pontuação de ninguém
   la a0, msgEmpate
   li a7, 4
   ecall
   j main_loop
   
# Função que verifica se o jogador tirou o Ás   
verifica_se_tirouAsJ:
   # t2 = carta sorteada
   li t0, 1
   beq t0, t2, adiciona_asJ
   ret
   
adiciona_asJ:
   la t3, quantAsJ
   lw t4, 0(t3)
   addi t4, t4, 1
   sw t4, 0(t3)
   ret         
   
# Função que verifica se o dealer tirou o Ás      
verifica_se_tirouAsD:
   # t2 = carta sorteada
   li t0, 1
   beq t0, t2, adiciona_asD
   ret
   
adiciona_asD:
   la t3, quantAsD
   lw t4, 0(t3)
   addi t4, t4, 1
   sw t4, 0(t3)
   ret    
   
soma_pontuacao_jogador:
    la t0, pontuacaoJ
    lw t1, 0(t0)
    mv t3, t2
  
    li t4, 10
    ble t3, t4, soma_valor  # se a carta tirada for menor que 10, ele soma normalmente
    li t3, 10

soma_valor:
    add t1, t1, t3
    sw t1, 0(t0)
    
    li t4, 1
    beq t2, t4, verifica_asJ
    ret
    
verifica_asJ:
   # t1 = pontuacaoJ
    la t0, pontuacaoJ
    lw t1, 0(t0)
    
    li t5, 21
    addi t1, t1, 10 # adiciona 10 na pontuação do jogador e verifica se passou de 21
    sw t1, 0(t0)
    
    bgt t1, t5, tira10SeTiverAsJ
    ret

tira10SeTiverAsJ:
   la a3, quantAsJ
   lw a4, 0(a3)
   li t4, 1
   
   bge a4, t4, tira10J
   ret
  
tira10J:
  li a5, 10
  sub t1, t1, a5
  sw t1, 0(t0)
  
  sub a4, a4, t4
  sw a4, 0(a3)
  ret
  
soma_pontuacao_dealer:
    la t0, pontuacaoD
    lw t1, 0(t0)
    mv t3, t2

    li t4, 10
    ble t3, t4, soma_valor_d
    li t3, 10

soma_valor_d:   
    add t1, t1, t3
    sw t1, 0(t0)
    
    li t4, 1
    beq t2, t4, verifica_asD
    ret
    
verifica_asD:
    # t1 = pontuacaoD
    la t0, pontuacaoD
    lw t1, 0(t0)
    
    li t5, 21
    addi t1, t1, 10 # adiciona 10 na pontuação do dealer e verifica se passou de 21
    sw t1, 0(t0)
    
    bgt t1, t5, tira10SeTiverAsD
    ret

tira10SeTiverAsD:
   la a3, quantAsD
   lw a4, 0(a3)
   li t4, 1
   
   bge a4, t4, tira10D
   ret
  
tira10D:
  addi t1, t1, -10
  sw t1, 0(t0)
  
  addi a4, a4, -1
  sw a4, 0(a3)
  ret    
  
 jogador_jogada:
   mv s8, ra # salva o endereço de ra em s8, para poder retornar para ese endereço depois
   call distribuiCartas # perdeu a referência do retorno da função
   addi t2, a0, 0 # copia o valor de a0 em t2
   call verifica_se_tirouAsJ  #chama a função que identifica o as
   call soma_pontuacao_jogador # chama a função que soma a pontuação
   call adiciona_maoJ #  chama a função que adiciona o valor da mão do jogador
   mv ra, s8 # resere o ra, para retornar corretamente
   ret #volta para quem chamou o jogador jogada
   
dealer_jogada:
   mv s8, ra
   call distribuiCartas
   addi t2, a0, 0
   call verifica_se_tirouAsD
   call soma_pontuacao_dealer
   call adiciona_maoD
   mv ra, s8
   ret 
  
encerrar_jogo:
   li a7, 10   #cahama o encerramento do programa
   ecall
