namespace Grovers {
    import Std.Arrays.ForEach;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Unstable.Arithmetic;
    open Microsoft.Quantum.ResourceEstimation;

     
     @EntryPoint()
   operation RunProgram() : Result[] {
       return SixGroverRun(6, [true,false,true,false,true,false]);
        
   }

    operation GateSwitch(target: Qubit[], pattern: Bool[]) : Unit {
        for i in 0..5 {
            if pattern[i] {
                X(target[i]); 
            }
        }     
    }

    operation SelectorSix(target: Qubit[], pattern: Bool[]) : Unit {
        GateSwitch(target, pattern); 
        Controlled Z(target[0..4],target[5]); 
        GateSwitch(target, pattern); 
    }

    operation AmplifySix(target: Qubit[]) : Unit {
        ApplyToEach(H, target); 
        ApplyToEach(X, target); 
        Controlled Z(target[0..4],target[5]);
        ApplyToEach(X, target); 
        ApplyToEach(H, target); 
    }

    operation SixQGroverIteration(target: Qubit[], pattern: Bool[]) : Unit {
        SelectorSix(target, pattern); 
        AmplifySix(target); 
    }

    operation SixQGrovers(target: Qubit[], pattern: Bool[], repeats: Int) : Unit {
        for i in 1..repeats {
            SixQGroverIteration(target, pattern); 
        }
    }

    operation RandomiseSix(target: Qubit[]) : Unit {
        ApplyToEach(H, target);    
    }
   
    operation SixGroverRun(repeats: Int, pattern: Bool[]) : Result[] {
        use q = Qubit[6];
        RandomiseSix(q);
        SixQGrovers(q, pattern, repeats);
        //DumpMachine();
        //ResetAll(q);
        return MResetEachZ(q); 
    }
}