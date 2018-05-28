pragma Ada_2005;
pragma Style_Checks (Off);

with Interfaces.C; use Interfaces.C;

package x86_64_linux_gnu_bits_dlfcn_h is

   RTLD_LAZY : constant := 16#00001#;  --  /usr/include/x86_64-linux-gnu/bits/dlfcn.h:24
   RTLD_NOW : constant := 16#00002#;  --  /usr/include/x86_64-linux-gnu/bits/dlfcn.h:25
   RTLD_BINDING_MASK : constant := 16#3#;  --  /usr/include/x86_64-linux-gnu/bits/dlfcn.h:26
   RTLD_NOLOAD : constant := 16#00004#;  --  /usr/include/x86_64-linux-gnu/bits/dlfcn.h:27
   RTLD_DEEPBIND : constant := 16#00008#;  --  /usr/include/x86_64-linux-gnu/bits/dlfcn.h:28

   RTLD_GLOBAL : constant := 16#00100#;  --  /usr/include/x86_64-linux-gnu/bits/dlfcn.h:33

   RTLD_LOCAL : constant := 0;  --  /usr/include/x86_64-linux-gnu/bits/dlfcn.h:38

   RTLD_NODELETE : constant := 16#01000#;  --  /usr/include/x86_64-linux-gnu/bits/dlfcn.h:41
   --  arg-macro: function DL_CALL_FCT (fctp, args)
   --    return _dl_mcount_wrapper_check ((void *) (fctp)), (*(fctp)) args;

  -- System dependent definitions for run-time dynamic loading.
  --   Copyright (C) 1996-2018 Free Software Foundation, Inc.
  --   This file is part of the GNU C Library.
  --   The GNU C Library is free software; you can redistribute it and/or
  --   modify it under the terms of the GNU Lesser General Public
  --   License as published by the Free Software Foundation; either
  --   version 2.1 of the License, or (at your option) any later version.
  --   The GNU C Library is distributed in the hope that it will be useful,
  --   but WITHOUT ANY WARRANTY; without even the implied warranty of
  --   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  --   Lesser General Public License for more details.
  --   You should have received a copy of the GNU Lesser General Public
  --   License along with the GNU C Library; if not, see
  --   <http://www.gnu.org/licenses/>.   

  -- The MODE argument to `dlopen' contains one of the following:  
  -- If the following bit is set in the MODE argument to `dlopen',
  --   the symbols of the loaded object and its dependencies are made
  --   visible as if the object were linked directly into the program.   

  -- Unix98 demands the following flag which is the inverse to RTLD_GLOBAL.
  --   The implementation does this by default and so we can define the
  --   value to zero.   

  -- Do not delete object when closed.   
  -- To support profiling of shared objects it is a good idea to call
  --   the function found using `dlsym' using the following macro since
  --   these calls do not use the PLT.  But this would mean the dynamic
  --   loader has no chance to find out when the function is called.  The
  --   macro applies the necessary magic so that profiling is possible.
  --   Rewrite
  --	foo = (*fctp) (arg1, arg2);
  --   into
  --        foo = DL_CALL_FCT (fctp, (arg1, arg2));
  -- 

  -- This function calls the profiling functions.   
   --  skipped func _dl_mcount_wrapper_check

end x86_64_linux_gnu_bits_dlfcn_h;
