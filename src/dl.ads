with Ada.Unchecked_Conversion;

with C_Strings;

with Interfaces.C.Strings;

with System;

with DLx.Dlfcn_H;
with DLx.X86_64_Linux_Gnu_Bits_Dlfcn_H;

package DL is

   type Handle is private;

   type Modes is (Lazy, Now);

   type Or_Flags is mod 2 ** Integer'Size;

   --  See man for following flags
   RTLD_BINDING_MASK : constant Or_Flags;
   RTLD_NOLOAD       : constant Or_Flags;
   RTLD_DEEPBIND     : constant Or_Flags;
   RTLD_GLOBAL       : constant Or_Flags;
   RTLD_LOCAL        : constant Or_Flags;
   RTLD_NODELETE     : constant Or_Flags;

   function Open (File  : String   := "";
                  Mode  : Modes    := Now;
                  Flags : Or_Flags := 0) return Handle;

   function Sym (H    : Handle;
                 Name : String) return System.Address;

   function Error return String;
   --  Returns last error or empty string

private

   pragma Linker_Options ("-ldl");

   package Bind renames DLx.Dlfcn_H;
   package Defs renames DLx.X86_64_Linux_Gnu_Bits_Dlfcn_H;

   package C  renames Interfaces.C;
   package CS renames Interfaces.C.Strings;

   type Handle is new System.Address;

   function To_Address (H : Handle) return System.Address is
      (System.Address (H));

   RTLD_BINDING_MASK : constant Or_Flags := Defs.RTLD_BINDING_MASK;
   RTLD_NOLOAD       : constant Or_Flags := Defs.RTLD_NOLOAD;
   RTLD_DEEPBIND     : constant Or_Flags := Defs.RTLD_DEEPBIND;
   RTLD_GLOBAL       : constant Or_Flags := Defs.RTLD_GLOBAL;
   RTLD_LOCAL        : constant Or_Flags := Defs.RTLD_LOCAL;
   RTLD_NODELETE     : constant Or_Flags := Defs.RTLD_NODELETE;



   ----------
   -- Open --
   ----------

   function Open (File  : String   := "";
                  Mode  : Modes    := Now;
                  Flags : Or_Flags := 0) return Handle is
     (Handle
        (Bind.Dlopen
             ((if File /= "" then C_Strings.To_C (File).To_Ptr else CS.Null_Ptr),
              C.Int((if Mode = Lazy then Defs.RTLD_LAZY else Defs.RTLD_NOW) + Flags))));

   ---------
   -- Sym --
   ---------

   function Sym (H    : Handle;
                 Name : String) return System.Address is
     (Bind.Dlsym (System.Address (H),
                  C_Strings.To_C (Name).To_Ptr));

end DL;
