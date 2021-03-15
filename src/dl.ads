with Ada.Unchecked_Conversion;

with DLx.X86_64_Linux_Gnu_Bits_Dlfcn_H;

with System;

package DL is

   Symbol_Error : exception;

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
   --  If File /= "" and Open'Result would be null, Symbol_Error is raised

   function Sym (H    : Handle;
                 Name : String) return System.Address;
   --  Raises Symbol_Error when symbol not found (so it never returns null)

   function Error return String;
   --  Returns last error or empty string

private

   pragma Linker_Options ("-ldl");

   package Defs renames DLx.X86_64_Linux_Gnu_Bits_Dlfcn_H;

   type Handle is new System.Address;

   function To_Address (H : Handle) return System.Address is
      (System.Address (H));

   RTLD_BINDING_MASK : constant Or_Flags := Defs.RTLD_BINDING_MASK;
   RTLD_NOLOAD       : constant Or_Flags := Defs.RTLD_NOLOAD;
   RTLD_DEEPBIND     : constant Or_Flags := Defs.RTLD_DEEPBIND;
   RTLD_GLOBAL       : constant Or_Flags := Defs.RTLD_GLOBAL;
   RTLD_LOCAL        : constant Or_Flags := Defs.RTLD_LOCAL;
   RTLD_NODELETE     : constant Or_Flags := Defs.RTLD_NODELETE;

end DL;
