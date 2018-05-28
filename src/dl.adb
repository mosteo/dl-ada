package body DL is

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
