with Ada.Unchecked_Conversion;

with Interfaces.C.Strings;

with System;

with DLx.Dlfcn_H;
with DLx.X86_64_Linux_Gnu_Bits_Dlfcn_H;

package DL is

   type Handle is private;

   function To_Address (H : Handle) return System.Address;

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

   -------------
   -- Strings --
   -------------

   package Strings is

      --  To more conveniently manage C strings

      use all type C.Size_T;

      type C_String (Len : C.Size_T) is tagged record
         Cstr : aliased C.Char_Array (1 .. Len);
      end record;
      --  Convenience type for the many conversions

      ----------
      -- To_C --
      ----------

      function To_C (S : String) return C_String is
        (Len => S'Length + 1,
         Cstr => C.To_C (S));

      type Char_Access is access constant C.Char;

      ------------------------------
      -- Char_Access_To_Chars_Ptr --
      ------------------------------

      function Char_Access_To_Chars_Ptr is new
        Ada.Unchecked_Conversion (Char_Access, CS.Chars_Ptr);

      ------------
      -- To_Ptr --
      ------------

      function To_Ptr (Str                   : C_String;
                       Null_Instead_Of_Empty : Boolean := True)
                    return CS.Chars_Ptr is
        (if Null_Instead_Of_Empty and then Str.Len = 0
         then CS.Null_Ptr
         else Char_Access_To_Chars_Ptr (Str.Cstr (Str.Cstr'First)'Unchecked_Access));
      --  This obviously presumes the pointer won't be kept elsewhere.
      --  We shall see if this blows up in our face or what.

   end Strings;

   ----------
   -- Open --
   ----------

   function Open (File  : String   := "";
                  Mode  : Modes    := Now;
                  Flags : Or_Flags := 0) return Handle is
     (Handle
        (Bind.Dlopen
             ((if File /= "" then Strings.To_C (File).To_Ptr else CS.Null_Ptr),
              C.Int((if Mode = Lazy then Defs.RTLD_LAZY else Defs.RTLD_NOW) + Flags))));

   ---------
   -- Sym --
   ---------

   function Sym (H    : Handle;
                 Name : String) return System.Address is
     (Bind.Dlsym (System.Address (H),
                  Strings.To_C (Name).To_Ptr));

end DL;
