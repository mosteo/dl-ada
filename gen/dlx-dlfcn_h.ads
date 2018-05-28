pragma Ada_2005;
pragma Style_Checks (Off);

with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings;
with System;
with dlx.stddef_h;

package dlx.dlfcn_h is

   --  unsupported macro: RTLD_NEXT ((void *) -1l)
   --  unsupported macro: RTLD_DEFAULT ((void *) 0)
   LM_ID_BASE : constant := 0;  --  /usr/include/dlfcn.h:47
   LM_ID_NEWLM : constant := -1;  --  /usr/include/dlfcn.h:48

  -- User functions for run-time dynamic loading.
  --   Copyright (C) 1995-2018 Free Software Foundation, Inc.
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

  -- Collect various system dependent definitions and declarations.   
  -- If the first argument of `dlsym' or `dlvsym' is set to RTLD_NEXT
  --   the run-time address of the symbol called NAME in the next shared
  --   object is returned.  The "next" relation is defined by the order
  --   the shared objects were loaded.   

  -- If the first argument to `dlsym' or `dlvsym' is set to RTLD_DEFAULT
  --   the run-time address of the symbol called NAME in the global scope
  --   is returned.   

  -- Type for namespace indeces.   
   subtype Lmid_t is long;  -- /usr/include/dlfcn.h:44

  -- Special namespace ID values.   
  -- Open the shared object FILE and map it in; return a handle that can be
  --   passed to `dlsym' to get symbol values from it.   

   function dlopen (uu_file : Interfaces.C.Strings.chars_ptr; uu_mode : int) return System.Address;  -- /usr/include/dlfcn.h:56
   pragma Import (C, dlopen, "dlopen");

  -- Unmap and close a shared object opened by `dlopen'.
  --   The handle cannot be used again after calling `dlclose'.   

   function dlclose (uu_handle : System.Address) return int;  -- /usr/include/dlfcn.h:60
   pragma Import (C, dlclose, "dlclose");

  -- Find the run-time address in the shared object HANDLE refers to
  --   of the symbol called NAME.   

   function dlsym (uu_handle : System.Address; uu_name : Interfaces.C.Strings.chars_ptr) return System.Address;  -- /usr/include/dlfcn.h:64
   pragma Import (C, dlsym, "dlsym");

  -- Like `dlopen', but request object to be allocated in a new namespace.   
   function dlmopen
     (uu_nsid : Lmid_t;
      uu_file : Interfaces.C.Strings.chars_ptr;
      uu_mode : int) return System.Address;  -- /usr/include/dlfcn.h:69
   pragma Import (C, dlmopen, "dlmopen");

  -- Find the run-time address in the shared object HANDLE refers to
  --   of the symbol called NAME with VERSION.   

   function dlvsym
     (uu_handle : System.Address;
      uu_name : Interfaces.C.Strings.chars_ptr;
      uu_version : Interfaces.C.Strings.chars_ptr) return System.Address;  -- /usr/include/dlfcn.h:73
   pragma Import (C, dlvsym, "dlvsym");

  -- When any of the above functions fails, call this function
  --   to return a string describing the error.  Each call resets
  --   the error string so that a following call returns null.   

   function dlerror return Interfaces.C.Strings.chars_ptr;  -- /usr/include/dlfcn.h:82
   pragma Import (C, dlerror, "dlerror");

  -- Structure containing information about object searched using
  --   `dladdr'.   

  -- File name of defining object.   
   type Dl_info is record
      dli_fname : Interfaces.C.Strings.chars_ptr;  -- /usr/include/dlfcn.h:90
      dli_fbase : System.Address;  -- /usr/include/dlfcn.h:91
      dli_sname : Interfaces.C.Strings.chars_ptr;  -- /usr/include/dlfcn.h:92
      dli_saddr : System.Address;  -- /usr/include/dlfcn.h:93
   end record;
   pragma Convention (C_Pass_By_Copy, Dl_info);  -- /usr/include/dlfcn.h:94

   --  skipped anonymous struct anon_0

  -- Load address of that object.   
  -- Name of nearest symbol.   
  -- Exact value of nearest symbol.   
  -- Fill in *INFO with the following information about ADDRESS.
  --   Returns 0 iff no shared object's segments contain that address.   

   function dladdr (uu_address : System.Address; uu_info : access Dl_info) return int;  -- /usr/include/dlfcn.h:98
   pragma Import (C, dladdr, "dladdr");

  -- Same as `dladdr', but additionally sets *EXTRA_INFO according to FLAGS.   
   function dladdr1
     (uu_address : System.Address;
      uu_info : access Dl_info;
      uu_extra_info : System.Address;
      uu_flags : int) return int;  -- /usr/include/dlfcn.h:102
   pragma Import (C, dladdr1, "dladdr1");

  -- These are the possible values for the FLAGS argument to `dladdr1'.
  --   This indicates what extra information is stored at *EXTRA_INFO.
  --   It may also be zero, in which case the EXTRA_INFO argument is not used.   

  -- Matching symbol table entry (const ElfNN_Sym *).   
  -- The object containing the address (struct link_map *).   
  -- Get information about the shared object HANDLE refers to.
  --   REQUEST is from among the values below, and determines the use of ARG.
  --   On success, returns zero.  On failure, returns -1 and records an error
  --   message to be fetched with `dlerror'.   

   function dlinfo
     (uu_handle : System.Address;
      uu_request : int;
      uu_arg : System.Address) return int;  -- /usr/include/dlfcn.h:123
   pragma Import (C, dlinfo, "dlinfo");

  -- These are the possible values for the REQUEST argument to `dlinfo'.   
  -- Treat ARG as `lmid_t *'; store namespace ID for HANDLE there.   
  -- Treat ARG as `struct link_map **';
  --       store the `struct link_map *' for HANDLE there.   

  -- Unsupported, defined by Solaris.   
  -- Treat ARG as `Dl_serinfo *' (see below), and fill in to describe the
  --       directories that will be searched for dependencies of this object.
  --       RTLD_DI_SERINFOSIZE fills in just the `dls_cnt' and `dls_size'
  --       entries to indicate the size of the buffer that must be passed to
  --       RTLD_DI_SERINFO to fill in the full information.   

  -- Treat ARG as `char *', and store there the directory name used to
  --       expand $ORIGIN in this shared object's dependency file names.   

  -- Unsupported, defined by Solaris.   
  -- Unsupported, defined by Solaris.   
  -- Treat ARG as `size_t *', and store there the TLS module ID
  --       of this object's PT_TLS segment, as used in TLS relocations;
  --       store zero if this object does not define a PT_TLS segment.   

  -- Treat ARG as `void **', and store there a pointer to the calling
  --       thread's TLS block corresponding to this object's PT_TLS segment.
  --       Store a null pointer if this object does not define a PT_TLS
  --       segment, or if the calling thread has not allocated a block for it.   

  -- This is the type of elements in `Dl_serinfo', below.
  --   The `dls_name' member points to space in the buffer passed to `dlinfo'.   

  -- Name of library search path directory.   
   type Dl_serpath is record
      dls_name : Interfaces.C.Strings.chars_ptr;  -- /usr/include/dlfcn.h:173
      dls_flags : aliased unsigned;  -- /usr/include/dlfcn.h:174
   end record;
   pragma Convention (C_Pass_By_Copy, Dl_serpath);  -- /usr/include/dlfcn.h:175

   --  skipped anonymous struct anon_3

  -- Indicates where this directory came from.  
  -- This is the structure that must be passed (by reference) to `dlinfo' for
  --   the RTLD_DI_SERINFO and RTLD_DI_SERINFOSIZE requests.   

  -- Size in bytes of the whole buffer.   
   type Dl_serinfo_dls_serpath_array is array (0 .. 0) of aliased Dl_serpath;
   type Dl_serinfo is record
      dls_size : aliased dlx.stddef_h.size_t;  -- /usr/include/dlfcn.h:181
      dls_cnt : aliased unsigned;  -- /usr/include/dlfcn.h:182
      dls_serpath : aliased Dl_serinfo_dls_serpath_array;  -- /usr/include/dlfcn.h:183
   end record;
   pragma Convention (C_Pass_By_Copy, Dl_serinfo);  -- /usr/include/dlfcn.h:184

   --  skipped anonymous struct anon_4

  -- Number of elements in `dls_serpath'.   
  -- Actually longer, dls_cnt elements.   
end dlx.dlfcn_h;
