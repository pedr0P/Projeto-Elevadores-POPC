#!/bin/sh
# Script para compilar, executar e visualizar a simulação do 'Nivel 2 - Elevador'

# --- Configuração ---
set -e

# O nome da sua entidade de testbench
TB_ENTITY="tb_nivel_2"

# O nome do arquivo .vcd de saída
VCD_FILE="simulacao_nivel_2.vcd"

# O diretório onde os arquivos do Nível 1 estão
DIR_NIVEL_1="Nivel_2-Escalonador"

# --- Execução ---

echo "Iniciando script de simulação VHDL..."

# 1. Navega para o diretório de compilação
echo "Navegando para $DIR_NIVEL_1/..."
cd "$DIR_NIVEL_1"

echo "Compilando componentes (peças) do 'src'..."

# 2. Compila TODOS os componentes do diretório 'src'
ghdl -a src/legacy_components/comparador_custo.vhd ;
ghdl -a src/legacy_components/cost_calculator.vhd ;
ghdl -a src/legacy_components/custo_distancia.vhdl ;

ghdl -a src/clear_dec.vhd ;
ghdl -a src/out_gen.vhd ;
ghdl -a src/reg_cham_ext.vhd ;
ghdl -a src/sweeper.vhd ;
ghdl -a src/target_register.vhd ;

ghdl -a POPC/po.vhd ;
ghdl -a POPC/pc.vhd ;

echo "Compilando 'nivel_2_elevador' (Top-Level)..."
# 3. Compila o arquivo "top-level" que junta todas as peças
ghdl -a POPC/nivel_2.vhd ;

echo "Compilando testbench '$TB_ENTITY'..."
# 4. Compila o testbench para o "top-level"
ghdl -a POPC/tb_nivel_2.vhd

echo "Elaborando testbench '$TB_ENTITY'..."
# 5. Elabora o testbench
ghdl -e $TB_ENTITY

echo "Executando simulação e gerando '$VCD_FILE'..."
# 6. Executa e cria o arquivo VCD
ghdl -r $TB_ENTITY --vcd=$VCD_FILE

echo "Abrindo GTKWave..."
# 7. Abre o resultado no GTKWave
gtkwave $VCD_FILE

echo "Script concluído com sucesso."
