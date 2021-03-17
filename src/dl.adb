with C_Strings;

with Dlx.Dlfcn_H;

with Interfaces.C.Strings;

package body DL is

   package Bind renames Dlx.Dlfcn_H;
   package CS   renames Interfaces.C.Strings;

   use Interfaces;

   ----------
   -- Open --
   ----------

   function Open (File  : String   := "";
                  Mode  : Modes    := Now;
                  Flags : Or_Flags := 0) return Handle is
   begin
      return Result : constant Handle :=
        Handle'
          (Addr => Bind.Dlopen
             (Uu_File => (if File /= ""
                          then C_Strings.To_C (File).To_Ptr
                          else CS.Null_Ptr),
              Uu_Mode => C.Int ((if Mode = Lazy
                then Defs.RTLD_LAZY
                else Defs.RTLD_NOW) + Flags)),
           Length => File'Length,
           File   => File)
      do
         if File /= "" and then Result.Addr in System.Null_Address
         then
            raise Symbol_Error with "[DL.Open] Failed to open: " & File;
         end if;
      end return;
   end Open;

   ---------
   -- Sym --
   ---------

   function Sym (H    : Handle;
                 Name : String) return System.Address is
   begin
      return Result : constant System.Address :=
        Bind.Dlsym (Uu_Handle => H.Addr,
                    Uu_Name   => C_Strings.To_C (Name).To_Ptr)
      do
         if Result in System.Null_Address then
            if H.Addr in System.Null_Address then
               raise Symbol_Error
                 with "[DL.Sym] Symbol not found in main program: " & Name;
            else
               raise Symbol_Error
                 with "[DL.Sym] Symbol '" & Name & "' not found in handle for: " & H.file;
            end if;
         end if;
      end return;
   end Sym;

   -----------
   -- Error --
   -----------

   function Error return String is
      use CS;
      Ret : constant Chars_Ptr := Bind.Dlerror;
   begin
      if Ret = Null_Ptr then
         return "";
      else
         return Value (Ret);
      end if;
   end Error;

end DL;
