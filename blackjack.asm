# --- Maria Eduarda Rampanelli (20230003255) e Isadora Sbeghen de Campos (20230002890) ---

.data
   asJogador: .word 0
   asDealer: .word 0
   msgInicio: .string "Bem-vindo ao BlackJack!\n"
   msgDesejaJogar: .string "\nDeseja jogar? (1 - Sim, 2 - Não): "
   msgTotalCartas: .string "\nTotal de cartas: "
   msgPontuacao: .string "\nPontuação: "
   msgPontuacaoJ: .string "\nJogador: "
   msgPontuacaoD: .string "\nDealer: "
   msgHitStand: .string "\nO que deseja fazer? (1- Hit, 2 - Stand): "
   msgJRecebe: .string "O jogador recebe: "
   msgDRecebe: .string "O dealer recebe: "
   msgJTem: .string "Sua mão: "
   msgDTem: .string "O dealer tem: "
   msgVenceu: .string "Você venceu!\n"
   msgPerdeu: .string "O dealer venceu!\n"
   msgEmpate: .string "Empate!\n"
   valor_sorteado:  .word 57
   cartasDistribuidas: .space 52
   totalDistribuidas: .word 0
   totalCartas: .word 52
   pontuacaoJ: .word 0
   pontuacaoD: .word 0

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

   la t0, pontuacaoJ
   lw a0, 0(t0)
   li a7, 1
   ecall

   la a0, msgPontuacaoD
   li a7, 4
   ecall

   la t0, pontuacaoD
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
   ret

dealer_turno:
   la t1, pontuacaoD
   lw t5, 0(t1)
   addi t6, zero, 17
   bge t5, t6, verifica_vencedor

   call dealerDistribution
   addi t2, a0, 0
   call soma_pontuacao_dealer
   call mostra_maos

   la t1, pontuacaoD
   lw t5, 0(t1)
   addi t6, zero, 21
   bgt t5, t6, dealer_estourou

   j dealer_turno

dealer_estourou:
   la a0, msgVenceu
   li a7, 4
   ecall
   ret

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
   ret

dealer_ganha:
   la a0, msgPerdeu
   li a7, 4
   ecall
   ret

empate:
   la a0, msgEmpate
   li a7, 4
   ecall
   ret

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

# imprime o valor de t2 (que é a carta)
    mv a0, t2      # move o valor da carta para a0 (argumento para impressão)
    li a7, 1       # código da syscall para imprimir inteiro
    ecall          # faz a chamada do sistema para imprimir

    li t6, 1
    beq t6, t2, verificaAsJogador

    li t4, 10
    ble t3, t4, soma_valor
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
    
verficaAsJogador:
   la s0, asJogador
   li s1, 1
   sw s1, 0(s0)
   ret

encerrar_jogo:
   li a7, 10
   ecall
