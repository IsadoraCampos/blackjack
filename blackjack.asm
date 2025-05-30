.data
   asJogador: .word 0
   asDealer: .word 0
   msgInicio: .string "Bem-vindo ao BlackJack!\n"
   msgDesejaJogar: .string "Deseja jogar? (1 - Sim, 2 - Não): "
   msgTotalCartas: .string "\nTotal de cartas: "
   msgPontuacao: .string "\nPontuação: \n"
   msgPontuacaoJ: .string "\nJogador: "
   msgPontuacaoD: .string "\nDealer: "
   msgHitStand: .string "O que deseja fazer? (1- Hit, 2 - Stand)"
   msgJRecebe: .string "O jogador recebe: "
   msgJTem: .string "Sua mão: "
   msgDTem: .string "O dealer tem: "
   msgVenceu: .string "O dealer estourou! Você venceu!\n"
   msgPerdeu: .string "Sua mão estourou! O dealer venceu!\n"
   totalCartas: .word 52
   pontuacaoJ: .word 0
   pontuacaoD: .word 0
   
.text
   la a0, msgInicio
   li a7, 4
   ecall
   call verificaDesejo
   
# --- Função: verificaDesejo ---
#Saída: a0 = 1 (sim) ou 2 (não)
verificaDesejo:
   la a0, msgDesejaJogar
   li a7, 4
   ecall
   li a7, 5
   ecall
   li t1, 1 # Para comparar com a resposta do jogador
   beq a0, t1, jogar
   li a7, 10 # Se não for 1 encerra o programa
   ecall
   
 # --- Função mostraPontuacao ---
 mostraPontuacao:
   la a0, msgTotalCartas
   li a7, 4
   ecall
   
   la t0, totalCartas # Carrega o endereço de totalCartas para t0
   lw a0, 0(t0) # Carrega o valor de totalCartas
   li a7, 1
   ecall
   
   la a0, msgPontuacao
   li a7, 4
   ecall
   
   la a0, msgPontuacaoJ
   li a7, 4
   ecall
   
   la t0, pontuacaoJ # Endereço da pontuação do jogador
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
   
jogar:
   call mostraPontuacao
