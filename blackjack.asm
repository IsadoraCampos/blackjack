# --- Maria Eduarda Rampanelli (20230003255) e Isadora Sbeghen de Campos (20230002890) ---

.data
   msgInicio: .string "Bem-vindo ao BlackJack!\n"
   msgDesejaJogar: .string "\nDeseja jogar? (1 - Sim, 2 - Não): "
   msgTotalCartas: .string "\nTotal de cartas: "
   msgPontuacao: .string "\nPontuação: "
   msgPontuacaoJ: .string "\nJogador: "
   msgPontuacaoD: .string "\nDealer: "
   msgHitStand: .string "\nO que deseja fazer? (1- Hit, 2 - Stand): "
   msgJRecebe: .string "\nO jogador recebe: "
   msgDRecebe: .string "\nO dealer recebe: "
   msgJTem: .string "\nSua mão: "
   msgDTem: .string "\nO dealer tem: "
   msgVenceu: .string "\nVocê venceu!"
   msgPerdeu: .string "\nO dealer venceu!"
   msgEmpate: .string "\nEmpate!"
   valor_sorteado:  .word 57
   cartasDistribuidas: .space 52
   totalDistribuidas: .word 0
   totalCartas: .word 52
   pontuacaoJ: .word 0
   pontuacaoD: .word 0
   pontuacaoJRodada: .word 0
   pontuacaoDRodada: .word 0

.text
   la a0, msgInicio
   li a7, 4
   ecall

main_loop:
   call mostraPontuacao
   call verificaDesejo
   li t0, 2
   beq a0, t0, encerrar_jogo

   call jogar_rodada
   j main_loop

# --- Função: verificaDesejo ---
verificaDesejo:
   la a0, msgDesejaJogar
   li a7, 4
   ecall
   li a7, 5
   ecall
   ret

# --- Função mostraPontuacao ---
mostraPontuacao:
   la a0, msgTotalCartas
   li a7, 4
   ecall

   la t0, totalCartas
   lw a0, 0(t0)
   li a7, 1
   ecall

   la a0, msgPontuacao
   li a7, 4
   ecall

   la a0, msgPontuacaoJ
   li a7, 4
   ecall

   la t0, pontuacaoJRodada
   lw a0, 0(t0)
   li a7, 1
   ecall

   la a0, msgPontuacaoD
   li a7, 4
   ecall

   la t0, pontuacaoDRodada
   lw a0, 0(t0)
   li a7, 1
   ecall

   ret

# --- Função: dealerDistribution ---
dealerDistribution:
   la t0, totalDistribuidas
   lw t1, 0(t0)

   addi t2, zero, 40
   bgt t1, t2, reiniciaDistribuicao

continuaDistribuicao:
   li a0, 0
   li a1, 12
   li a7, 42
   ecall

   addi a0, a0, 1
   addi t3, a0, 0

   la t4, cartasDistribuidas
   slli t5, t3, 2
   add t6, t4, t5
   lw t1, 0(t6)

   addi t2, zero, 4
   bge t1, t2, dealerDistribution  # se a carta já foi distribuída 4 vezes, ele sorteia outra

   addi t1, t1, 1  # adiciona mais um para a carta que foi dstribuída 
   sw t1, 0(t6)

   lw t2, 0(t0)  # carrega totalDistribuidas
   addi t2, t2, 1
   sw t2, 0(t0)
   
   la t4, totalCartas  # diminui o total de cartas
   li t6, 1
   lw t5, 0(t4)
   sub t5, t5, t6
   sw t5, 0(t4) 

   addi a0, t3, 0
   ret

reiniciaDistribuicao:
   la t3, cartasDistribuidas
   addi t4, zero, 0
   
reiniciaLoop:
   addi t5, zero, 13
   beq t4, t5, fimReinicia
   sw zero, 0(t3)
   addi t3, t3, 4
   addi t4, t4, 1
   j reiniciaLoop

fimReinicia:
   sw zero, 0(t0)
   j dealerDistribution

# --- Função jogar_rodada ---
jogar_rodada:
   la t0, pontuacaoJ
   sw zero, 0(t0)
   la t1, pontuacaoD
   sw zero, 0(t1)

   call dealerDistribution
   addi t2, a0, 0
   call soma_pontuacao_jogador

   call dealerDistribution
   addi t2, a0, 0
   call soma_pontuacao_jogador

   call dealerDistribution
   addi t2, a0, 0
   call soma_pontuacao_dealer

   call dealerDistribution
   addi t2, a0, 0
   call soma_pontuacao_dealer

   call mostra_maos

jogador_turno:
   la a0, msgHitStand
   li a7, 4
   ecall

   li a7, 5
   ecall
   addi t3, a0, 0

   addi t4, zero, 1
   beq t3, t4, jogador_hit
   addi t5, zero, 2
   beq t3, t5, dealer_turno
   j jogador_turno

jogador_hit:
   call dealerDistribution
   addi t2, a0, 0
   call soma_pontuacao_jogador
   call mostra_maos

   la t0, pontuacaoJ
   lw t6, 0(t0)
   addi t4, zero, 21
   bgt t6, t4, jogador_estourou
   j jogador_turno

jogador_estourou:
   la a0, msgPerdeu
   li a7, 4
   ecall
   la t2, pontuacaoDRodada
   lw t3, 0(t2)
   addi t3, t3, 1   # adiciona mais um na pontuação da rodada do dealer
   sw t3, 0(t2)
   
   call mostraPontuacao
   call verificaDesejo

dealer_turno:
dealer_loop:
   la t1, pontuacaoD
   lw t5, 0(t1)
   li t6, 17
   bge t5, t6, verifica_vencedor  # Se dealer >= 17, para

   call dealerDistribution
   mv t2, a0
   call soma_pontuacao_dealer
   call mostra_maos

   la t1, pontuacaoD
   lw t5, 0(t1)
   li t6, 21
   bgt t5, t6, dealer_estourou

   j dealer_loop

dealer_estourou:
   la a0, msgVenceu
   li a7, 4
   ecall
   
   la t2, pontuacaoJRodada
   lw t3, 0(t2)
   addi t3, t3, 1   # adiciona mais um na pontuação da rodada do jogador
   sw t3, 0(t2)
   
   call mostraPontuacao
   call verificaDesejo
   j main_loop

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
   
   call mostraPontuacao
   call verificaDesejo
   j main_loop

dealer_ganha:
   la a0, msgPerdeu
   li a7, 4
   ecall
   
   la t2, pontuacaoDRodada
   lw t3, 0(t2)
   addi t3, t3, 1   # adiciona mais um na pontuação da rodada do dealer
   sw t3, 0(t2)
   
   call mostraPontuacao
   call verificaDesejo
   j main_loop

empate:
   # se empatou não soma na pontuação de ninguém
   la a0, msgEmpate
   li a7, 4
   ecall
   call mostraPontuacao
   call verificaDesejo
   j main_loop

# Mostrar mãos atuais 
mostra_maos:
   la a0, msgJTem
   li a7, 4
   ecall

   la t0, pontuacaoJ
   lw a0, 0(t0)
   li a7, 1
   ecall

   la a0, msgDTem
   li a7, 4
   ecall

   la t0, pontuacaoD
   lw a0, 0(t0)
   li a7, 1
   ecall
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
    ret

encerrar_jogo:
   li a7, 10
   ecall
