-- This file is part of the Nanda Devi project.
-- Nanda Devi is a simple CPU architecture which emerged from learning
-- VHDL.
--
-- Copyright (c) 2017 Jonas Deitmerg
--
-- For licensing information, please refer to the LICENSE file.

-- file common.vhdl
--
-- Includes generic defines as well as the constants of the instruction
-- set.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package common is
    -- General stuff: Width of architectures words
    constant WORDWIDTH : positive := 32;
    subtype word_t is std_logic_vector(WORDWIDTH-1 downto 0);

    -- Possible ALU operations. Enum is not an option, as these have to
    -- be known to the assembler.
    subtype alu_op_t is unsigned(4 downto 0);
    constant alu_add    : alu_op_t := "00000"; -- addition
    constant alu_sub    : alu_op_t := "00001"; -- substractionl
    constant alu_addc   : alu_op_t := "00010"; -- addition with carry
    constant alu_subc   : alu_op_t := "00011"; -- substraction with carry
    constant alu_or     : alu_op_t := "00100"; -- bitwise logical or
    constant alu_xor    : alu_op_t := "00101"; -- bitwise logical xor
    constant alu_and    : alu_op_t := "00110"; -- bitwise logical and
    constant alu_not    : alu_op_t := "00111"; -- bitwise logical not
    constant alu_sll    : alu_op_t := "01000"; -- shift logical left
    constant alu_slr    : alu_op_t := "01001"; -- shift logical right
    constant alu_tst    : alu_op_t := "01010"; -- test (only set flags)

    -- Indices of special registers in regfile
    subtype regnum_t is natural range 0 to 31;
    constant reg_pc      : regnum_t := 16;
    constant reg_sp      : regnum_t := 17;
    constant reg_flags   : regnum_t := 18;
    constant reg_max     : regnum_t := 18;

    -- Flow control defines and constants
    subtype fc_op_t is std_logic_vector(2 downto 0);
    constant flowc_normal : fc_op_t := "000";
    constant flowc_skipc  : fc_op_t := "001";
    constant flowc_skipz  : fc_op_t := "010";
    constant flowc_skipn  : fc_op_t := "100";
    type flow_control_t is record
        command: fc_op_t;
        -- If bit 3 is set, skip if flag is cleared. If it's cleared, skip
        -- if flag is set.
        inv: std_logic;
    end record;

    -- There are four possible sources for the data bus (which feeds the
    -- registers and memory write port): ALU output, first ALU argument,
    -- the immediate from the instruction decoder and memory.
    subtype dsrc_t is natural range 0 to 3;
    constant dsrc_ALU       : dsrc_t := 0;
    constant dsrc_arg0      : dsrc_t := 1;
    constant dsrc_immediate : dsrc_t := 2;
    constant dsrc_mem       : dsrc_t := 3;

    -- Groups of instructions:
    subtype instrg_t is std_logic_vector(4 downto 0);
    constant instrg_ldi   : instrg_t := "00000"; -- load immediate
    constant instrg_ALU   : instrg_t := "00001";
    constant instrg_cpy   : instrg_t := "00010"; -- copy and move
    constant instrg_cond  : instrg_t := "00011"; -- conditional jumps/skips

    -- Actual command in a move/copy instruction:
    subtype mvcp_t is std_logic_vector(1 downto 0);
    constant mvcp_mv  : mvcp_t := "00";
    constant mvcp_ldm : mvcp_t := "01";
    constant mvcp_stm : mvcp_t := "10";

    -- For reducing the width of the flags "busses":
    constant flagpos_c : natural := 0;
    constant flagpos_z : natural := 1;
    constant flagpos_n : natural := 2;
    constant flagpos_o : natural := 3;
    constant numflags  : natural := 4;
    subtype flags_t is std_logic_vector(numflags-1 downto 0);

end common;

