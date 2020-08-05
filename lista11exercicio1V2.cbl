      $set sourceformat"free"

      *>divisão de identificação do programa
       identification division.
      *>---program-id é uma informação obrigatória---
       program-id. "lista11exercicio1V2".
       author. "Evelyn Yasmin Pereira".
       installation. "PC".
       date-written. 28/07/2020.
       date-compiled. 28/07/2020.

      *>divisão para configuração de ambiente
       environment division.
       configuration section.
           special-names. decimal-point is comma.

      *>declaração de recursos externos
       input-output section.
       file-control.

           select arqTemperatura assign to 'arqTemperatura.txt'
           organization is line sequential
           access mode is sequential
           lock mode is automatic
           file status is ws-fs-arqTemperatura.
       *>______________________________________________________________________________
       *>select adiona nome ao arquivo> assing vai estar assossiando o arquivo fisico.
       *> forma de como sao organizados os dados.
       *> o access vc acessa o aquivo/dados.
       *> o lock mode serve para travar o arquivo.
       *> file status é utilizado uma variavel da working-storage para retorno correto do aqruivo.
       *>_______________________________________________________________________________


       i-o-control.

      *>declaração de variáveis
       data division.
      *>___________________data division, tem 4 sessões possíveis-
      *>________variáveis de arquivos________
       file section.

       fd arqTemperatura.
       01 fd-relatorioTemp.
          05 fd-temperatura                        pic s9(02)v99.

      *>_____variáveis de trabalho______
       working-storage section.

       77 ws-fs-arqTemperatura                     pic  9(02).

       01 ws-temperaturas occurs 30.
          05 ws-temp                               pic s9(02)v99.

       77 ws-media-temp                            pic s9(04)v99.
       77 ws-temp-total                            pic s9(03)v99.

       77 ws-dia                                   pic  9(02).
       77 ws-ind-temp                              pic  9(02).

       77 ws-sair                                  pic  x(01).
       01 ws-msn-erro.
           05 ws-msn-erro-offset                   pic  x(04).
           05 filler                               pic  x(01) value '-'.
           05 ws-msn-erro-cod                      pic  x(1).
           05 filler                               pic  x(02) value '-'.
           05 ws-msn-erro-text                     pic  x(42).

      *>_____variáveis para comunicação entre programas_____
       linkage section.
      *>_____declaração de tela_____
       screen section.

      *>declaração do corpo do programa
       procedure division.

           perform inicializa.
           perform processamento.
           perform finaliza.
      *>_____________________________________________________________________
      *> procedimentos de inicialização
      *>_____________________________________________________________________
       inicializa section.

           open input arqTemperatura.
           if ws-fs-arqTemperatura <> 0 then
               move 1 to ws-msn-erro-offset
               move ws-fs-arqTemperatura to ws-msn-erro-cod
               move 'Erro ao Abrir Arquivo arqTemperatura' to ws-msn-erro-text
               perform finaliza-anormal
           end-if

           perform varying ws-ind-temp from 1 by 1 until ws-fs-arqTemperatura = 10
                                                               or ws-ind-temp > 30

      *> _______________  inicializando a variável da temperatura
           read arqTemperatura into ws-temperaturas(ws-ind-temp)

               if ws-fs-arqTemperatura <> 0
               and ws-fs-arqTemperatura <> 10  then
                   move 2 to ws-msn-erro-offset
                   move ws-fs-arqTemperatura to ws-msn-erro-cod
                   move 'Erro ao Ler Arquivo arqTemperatura' to ws-msn-erro-text
                   perform finaliza-anormal
               end-if

           end-perform

           close arqTemperatura.
           if ws-fs-arqTemperatura <> 0 then
               move 3 to ws-msn-erro-offset
               move ws-fs-arqTemperatura to ws-msn-erro-cod
               move 'Erro ao Fechar Arquivo arqTemperatura' to ws-msn-erro-text
               perform finaliza-anormal
           end-if

           .
       inicializa-exit.
           exit.
      *>________________________________________________________________________
      *>  processamento principal
      *>________________________________________________________________________
       processamento section.
      *> ___________chamando rotina de calculo da média de temp.
           perform calc-media-temp

      *>    menu do sistema
           perform until ws-sair = "S"
                      or ws-sair = "s"
               display erase

               display "Dia a ser testado: "
               accept ws-dia

               if  ws-dia >= 1
               and ws-dia <= 30 then
                   if ws-temp(ws-dia) > ws-media-temp then
                       display "A temperatura do dia " ws-dia " esta acima da media"
                   else
                   if ws-temp(ws-dia) < ws-media-temp then
                           display "A temperatura do dia " ws-dia " esta abaixo da media"
                   else
                           display "A temperatura esta na media"
                   end-if
                   end-if
               else
                   display "Dia fora do intervalo valido (1 -30)"
               end-if

               display "'T'estar outra temperatura"
               display "'S'air"
               accept ws-sair
           end-perform
           .
       processamento-exit.
           exit.
      *>________________________________________________________________________
      *>  calculo da média de temperatura
      *>_______________________________________________________________________
       calc-media-temp section.

           move 0 to ws-temp-total
           perform varying ws-ind-temp from 1 by 1 until ws-ind-temp > 30
               compute ws-temp-total = ws-temp-total + ws-temp(ws-ind-temp)
           end-perform

           compute ws-media-temp = ws-temp-total/30

           .
       calc-media-temp-exit.
           exit.

      *>________________________________________________________________________
      *>   finalização anormal - erro
      *>________________________________________________________________________
       finaliza-anormal section.

           display erase
           display ws-msn-erro

           stop run
           .
       finaliza-anormal-exit.
           exit.
      *>________________________________________________________________________
      *>   finalização normal
      *>________________________________________________________________________
       finaliza section.
           stop run
           .
       finaliza-exit.
           exit.


