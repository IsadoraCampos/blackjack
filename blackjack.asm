.data
   asJogador: .word 0
   asCarteador: .word 0
   msgInicio: .string "Bem-vindo ao BlackJack!"
   msgDesejaJogar: .string "Deseja jogar? (1 - Sim, 2 - Não): "
   msgTotalCartas: .string "Total de cartas: "
   msgPontuacao: .string "Pontuação: "
   msgPontuacaoJ: .string "Jogador: "
   msgPontuacaoD: .string "Dealer: "
   msgHitStand: .string "O que deseja fazer? (1- Hit, 2 - Stand)"
   msgJRecebe: .string "O jogador recebe: "
   msgJTem: .string "Sua mão: "
   msgDTem: .string "O dealer tem: "
   msgVenceu: .string "O dealer estourou! Você venceu!"
   msgPerdeu: .string "Sua mão estourou! O dealer venceu!"
   
.text
   la a0, msgInicio
   li a7, 4
   ecall
   
