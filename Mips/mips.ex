
    #add
    #sub
    #addi
    #lw
    #sw

     #klar
defmodule Out do 
    def new() do [0] end
    def put(out,s) do [s|out]  end 
    def close(out) do Enum.to_list(out) end
end

#klar
defmodule Register do
    def new() do
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} end 
    def read(reg,index) do
    elem(reg,index) end
    def write(reg,index,val) do put_elem(reg,index,val) end
 end
defmodule Program do
    def load(prgm) do  {:code, List.to_tuple(prgm)} end
    def read_instruction({:code,inst},pc) do elem(inst,pc) end
    def getdata([],_,data) do data end #data ska va tom lista då den kallas getdata{code,0,[]}
    def getdata([{:label,name}|t],pc,data) do  getdata(t,pc+1,[{name,pc}|data]) end 
    def getdata([_|t],pc,data) do getdata(t,pc+1,data) end
 end


 defmodule Mem do 
    def new() do [] end
    def input do  end
    def save(mem,index,val) do put_elem(mem,index,val) end
    def lookup([],_) do "no jump :(" end
    def lookup([{label,pc}|_],label) do pc+1 end
    def lookup([_|t],label) do lookup(t,label) end
 end

#[{:addi, 1, 0, 5}, # $1 <- 5
#{:lw, 2, 0, :arg}, # $2 <- data[:arg]
#{:add, 4, 2, 1}, # $4 <- $2 + $1
#{:addi, 5, 0, 1}, # $5 <- 1
#{:label, :loop},
#{:sub, 4, 4, 5}, # $4 <- $4 - $5
#{:out, 4}, # out $4
#{:bne, 4, 0, :loop}, # branch if not equal
#:halt]


defmodule Emulator do

    def run() do
        #{code, data} = Program.load(prgm)
        prgm = [{:addi,1,0,50},{:addi,2,1,25},{:label, :hopp},{:sub,3,2,1},{:addi,5,0,10},{:label, :loop},{:addi,6,6,1},{:bne,5,6,6},{:halt}]
        code = Program.load(prgm)
        data = Program.getdata(prgm,0,[])
        IO.inspect(data) #1
        out = Out.new()
        IO.inspect(out) #2
        reg = Register.new()
       
        run(0, code, reg, data, out)
    end

    def run(pc, code, reg, mem, out) do
        next = Program.read_instruction(code, pc)
        IO.inspect({pc,out})
        case next do
            {:halt}->Out.close(out)

            {:label,_sum}-> run(pc+1, code, reg, mem, out)

            {:out, rs}->
            pc = pc + 1
            s = Register.read(reg, rs)
            out = Out.put(out, s)
            run(pc, code, reg, mem, out)

            {:add, rd,rs,rt}->
            pc = pc + 1
            reg = Register.write(reg,rd, Register.read(reg,rs) + Register.read(reg,rt))
            out = Out.put(out,Register.read(reg,rd) ) 
            run(pc, code, reg, mem, out)

            {:addi, rd,rs,imm}->
            pc = pc + 1
            reg = Register.write(reg,rd, Register.read(reg,rs) + imm)
            out = Out.put(out,Register.read(reg,rd) )  
            run(pc, code, reg, mem, out)

@type inst() :: 
| {:add, rd,rs,rt}
| {:addi, rd,rs,imm}
| {:sub, rd,rs,rt}
| {:bne,rd,rs,label}
| {:sw,rt,imm,rs}
| {:lw,rt,imm,rs}
| {:halt}
| {:out, rs}

            {:sub, rd,rs,rt}->
            pc = pc + 1
            reg = Register.write(reg,rd, Register.read(reg,rs) - Register.read(reg,rt))
            out = Out.put(out,Register.read(reg,rd))  
            run(pc, code, reg, mem, out)

            {:bne,rd,rs,label}->  #ett mer dynamiskt system för att hitta pc måste fixas
            pc = pc + 1
            val = Mem.lookup(mem,label)
            IO.inspect(Mem.lookup(mem,label))

            IO.inspect(Register.read(reg,rd))
            IO.inspect(Register.read(reg,rs))
            if  Register.read(reg,rd) != Register.read(reg,rs) do  run(val, code, reg, mem, out)
            else
            run(pc, code, reg, mem, out)end
    end

 #implement tree
  end


end
