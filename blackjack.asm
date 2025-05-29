.data
   asJogador: .word 0
   asCarteador: .word 0
   msgInicio: .string "Bem-vindo ao BlackJack!\n"
   msgDesejaJogar: .string "Deseja jogar? (1 - Sim, 2 - Não): "
   msgTotalCartas: .string "Total de cartas: "
   msgPontuacao: .string "Pontuação: "
   msgPontuacaoJ: .string "Jogador: "
   msgPontuacaoD: .string "Dealer: "
   msgHitStand: .string "O que deseja fazer? (1- Hit, 2 - Stand)"
   msgJRecebe: .string "O jogador recebe: "
   msgJTem: .string "Sua mão: "
   msgDTem: .string "O dealer tem: "
   msgVenceu: .string "O dealer estourou! Você venceu!\n"
   msgPerdeu: .string "Sua mão estourou! O dealer venceu!\n"
   totalCartas: .word 52
   
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
   
jogar:
   la a0, msgInicio
   li a7, 4
   ecall
