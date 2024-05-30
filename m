Return-Path: <live-patching+bounces-299-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CD748D52D4
	for <lists+live-patching@lfdr.de>; Thu, 30 May 2024 22:07:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FEB7281D83
	for <lists+live-patching@lfdr.de>; Thu, 30 May 2024 20:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA033558A0;
	Thu, 30 May 2024 20:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T1JDopag"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48374D8BF
	for <live-patching@vger.kernel.org>; Thu, 30 May 2024 20:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717099647; cv=none; b=Xq/jjIyGQkE7E6uNkA2MMpcxvbS1MU1cOkBjLxoVUMwfkU4Ms8j7OCLhpEoV8Y45ruqvLhchTS+kNg5FBcVuJbUVXT8KYjpuyLRZuMjfGehur8TbQqPW0gfT/vDr2x7kX9HeVBgnoG/jnB79VVJSKaGiEou90cg/hfp93oAOVGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717099647; c=relaxed/simple;
	bh=j0mupzJ7SJA/gB5AC1ETZ8aVBo376zWYvLF4BFA3yWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XcaJUly02k5qWURhDI7Wy9bs2z52lliRC4W9fPM90I/A5hSSyT/qBDMHjKycUymnl0e3JoUZ10bHNOXqxMAHlsNX2NM3+SEZH0kaHR8mARSkv0M8DTmAK2wgkKi2rRW79NkFBWN+DOHsBHNqoVs13W4IzKsCNwVQIFrAHYwOOfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T1JDopag; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717099644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TdFoCn2lWRpn3xKkWMph23Gop2pS2Oc37cOeGoVqsmM=;
	b=T1JDopagbYN8lYzgBViQSH+u2sXT0m3izkqSa75ar67rflqN43ICpNT8UnZpqfLGP/lAsA
	FyDRqAALe2b/0OnBfa3s+qnHqfS7hicVFUNT0UJyRe/tfAsYqmBbrFm3etSMTEMJoBvW8G
	MkG8MuZh1X/LmS1D/UlEUuRHbHEmqVA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-568-zXVFLNxTMXKcvxbo3i23dw-1; Thu,
 30 May 2024 16:07:23 -0400
X-MC-Unique: zXVFLNxTMXKcvxbo3i23dw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 988491C05122;
	Thu, 30 May 2024 20:07:22 +0000 (UTC)
Received: from redhat.com (unknown [10.22.18.140])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 194BF40004D;
	Thu, 30 May 2024 20:07:22 +0000 (UTC)
Date: Thu, 30 May 2024 16:07:20 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Lukas Hruska <lhruska@suse.cz>
Cc: pmladek@suse.com, mbenes@suse.cz, jpoimboe@kernel.org,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, mpdesouza@suse.com,
	Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 2/6] livepatch: Add klp-convert tool
Message-ID: <ZljceDZ7eqEJtYhQ@redhat.com>
References: <20240516133009.20224-1-lhruska@suse.cz>
 <20240516133009.20224-3-lhruska@suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240516133009.20224-3-lhruska@suse.cz>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Thu, May 16, 2024 at 03:30:05PM +0200, Lukas Hruska wrote:
> Livepatches need to access external symbols which can't be handled
> by the normal relocation mechanism. It is needed for two types
> of symbols:
> 
>   + Symbols which can be local for the original livepatched function.
>     The alternative implementation in the livepatch sees them
>     as external symbols.
> 
>   + Symbols in modules which are exported via EXPORT_SYMBOL*(). They
>     must be handled special way otherwise the livepatch module would
>     depend on the livepatched one. Loading such livepatch would cause
>     loading the other module as well.
> 
> The address of these symbols can be found via kallsyms. Or they can
> be relocated using livepatch specific relocation sections as specified
> in Documentation/livepatch/module-elf-format.txt.
> 
> Currently, there is no trivial way to embed the required information as
> requested in the final livepatch elf object. klp-convert solves this
> problem by using annotations in the elf object to convert the relocation
> accordingly to the specification, enabling it to be handled by the
> livepatch loader.
> 
> Given the above, create scripts/livepatch to hold tools developed for
> livepatches and add source files for klp-convert there.
> 
> Allow to annotate such external symbols in the livepatch by a macro
> KLP_RELOC_SYMBOL(). It will create symbol with all needed
> metadata. For example:
> 
>   extern char *saved_command_line \
>                  KLP_RELOC_SYMBOL(vmlinux, vmlinux, saved_command_line, 0);
> 
> would create symbol
> 
> $>readelf -r -W <compiled livepatch module>:
> Relocation section '.rela.text' at offset 0x32e60 contains 10 entries:
>     Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
> [...]
> 0000000000000068  0000003c00000002 R_X86_64_PC32          0000000000000000 .klp.sym.rela.vmlinux.vmlinux.saved_command_line,0 - 4
> [...]
> 
> Also add scripts/livepatch/klp-convert. The tool transforms symbols
> created by KLP_RELOC_SYMBOL() to object specific rela sections
> and rela entries which would later be proceed when the livepatch
> or the livepatched object is loaded.
> 
> For example, klp-convert would replace the above symbol with:
> 
> $> readelf -r -W <livepatch_module_proceed_by_klp_convert>
> Relocation section '.klp.rela.vmlinux.text' at offset 0x5cb60 contains 1 entry:
>     Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
> 0000000000000068  0000003c00000002 R_X86_64_PC32          0000000000000000 .klp.sym.vmlinux.saved_command_line,0 - 4
> 
> klp-convert relies on libelf and on a list implementation. Add files
> scripts/livepatch/elf.c and scripts/livepatch/elf.h, which are a libelf
> interfacing layer and scripts/livepatch/list.h, which is a list
> implementation.
> 
> Update Makefiles to correctly support the compilation of the new tool,
> update MAINTAINERS file and add a .gitignore file.
> 
> [jpoimboe@redhat.com: initial version]
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> [joe.lawrence@redhat.com: clean-up and fixes]
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> [lhruska@suse.cz: klp-convert code, minimal approach]
> Signed-off-by: Lukas Hruska <lhruska@suse.cz>
> Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> ---
>  MAINTAINERS                     |   1 +
>  include/linux/livepatch.h       |  19 +
>  scripts/Makefile                |   1 +
>  scripts/livepatch/.gitignore    |   1 +
>  scripts/livepatch/Makefile      |   5 +
>  scripts/livepatch/elf.c         | 817 ++++++++++++++++++++++++++++++++
>  scripts/livepatch/elf.h         |  73 +++
>  scripts/livepatch/klp-convert.c | 284 +++++++++++
>  scripts/livepatch/klp-convert.h |  23 +
>  scripts/livepatch/list.h        | 391 +++++++++++++++
>  10 files changed, 1615 insertions(+)
>  create mode 100644 scripts/livepatch/.gitignore
>  create mode 100644 scripts/livepatch/Makefile
>  create mode 100644 scripts/livepatch/elf.c
>  create mode 100644 scripts/livepatch/elf.h
>  create mode 100644 scripts/livepatch/klp-convert.c
>  create mode 100644 scripts/livepatch/klp-convert.h
>  create mode 100644 scripts/livepatch/list.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 130b8b0bd4f7..d2facc1f4e15 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12618,6 +12618,7 @@ F:	include/uapi/linux/livepatch.h
>  F:	kernel/livepatch/
>  F:	kernel/module/livepatch.c
>  F:	samples/livepatch/
> +F:	scripts/livepatch/
>  F:	tools/testing/selftests/livepatch/
>  
>  LLC (802.2)
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 9b9b38e89563..83bbcd1c43fd 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -235,6 +235,25 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
>  			     unsigned int symindex, unsigned int secindex,
>  			     const char *objname);
>  
> +/**
> + * KLP_RELOC_SYMBOL_POS - define relocation for external symbols
> + *
> + * @LP_OBJ_NAME: name of the livepatched object where the symbol is needed
> + * @SYM_OBJ_NAME: name of the object where the symbol exists
> + * @SYM_NAME: symbol name
> + * @SYM_POS: position of the symbol in SYM_OBJ when there are more
> + *       symbols of the same name.
> + *
> + * Use for annotating external symbols used in livepatches which are
> + * not exported in vmlinux or are in livepatched modules, see
> + * Documentation/livepatch/module-elf-format.rst
> + */
> +#define KLP_RELOC_SYMBOL_POS(LP_OBJ_NAME, SYM_OBJ_NAME, SYM_NAME, SYM_POS)	\
> +	asm("\".klp.sym.rela." #LP_OBJ_NAME "." #SYM_OBJ_NAME "." #SYM_NAME "," #SYM_POS "\"")
                                                                            ^^^
I think I found a potential bug, or at least compatiblity problem with
including a comma "," character in this symbol format and older versions
of the GNU assembler.  The good news is that other delimiter characters
like "." or "#" seem to work out fine.

If you want to reproduce, you'll need a version of `as` like binutils
2.36.1 and try building the samples/livepatch/livepatch-extern-symbol.ko
and you should get an error like:

  Assembler messages:
  Warning: missing closing '"'
  Warning: missing closing '"'
  Error: too many memory references for `movq'


If you want to retrace my adventure, here are my steps:

  1) Clone klp-convert-tree repo branch containing this patchset +
  Petr's review comments + a few helpful things for klp-convert
  development:
  
    $ git clone \
        --single-branch --branch=klp-convert-minimal-v1-review --depth=9 \
        https://github.com/joe-lawrence/klp-convert-tree.git
    [ ... snip ... ]
    $ cd klp-convert-tree
  
  2) Override .cross-dev defaults:
  
    $ export BUILD_ARCHES=x86_64
    $ export COMPILER=gcc-11.1.0
    $ export URL=https://cdn.kernel.org/pub/tools/crosstool/files/bin/x86_64/
    $ export OUTDIR_PREFIX=$(pwd)/build
    $ export COMPILER_INSTALL_PATH=$(pwd)/cross-compiler
  
  3) Setup x86_64 default .config (this will download and install the
  gcc-11.1.0 compiler from cdn.kernel.org):
  
    $ ./cross-dev make defconfig
    
    x86_64 : make defconfig ...
    Compiler will be installed in /root/klp-convert-tree/cross-compiler
    [ ... snip ... ]
  
  4) Add kernel livepatching configuration options:
  
    $ ./cross-dev klp-config
    
    Configuring x86_64 ...
    [ ... snip ... ]
    
    $ grep LIVEPATCH "$OUTDIR_PREFIX"-x86_64/.config
    CONFIG_HAVE_LIVEPATCH=y
    CONFIG_LIVEPATCH=y
    CONFIG_SAMPLE_LIVEPATCH=m
  
  5) Run the cross-compiler build until it hits a build error on
  livepatch-extern-symbol.ko:
  
    $ ./cross-dev make -j$(nproc)
    [ ... snip ... ]
    make: Target '__all' not remade because of errors.
    [ x86_64 : make -j48 = FAIL ]
  
  6) With pre-requisites already built, retry the external symbol sample
  and add -save-temps to the KCFLAGS to keep the generated assembly file:
  
    $ KCFLAGS="-save-temps=obj" ./cross-dev make samples/livepatch/livepatch-extern-symbol.ko
    [ ... snip ... ]
    samples/livepatch/livepatch-extern-symbol.s: Assembler messages:
    samples/livepatch/livepatch-extern-symbol.s:103: Warning: missing closing '"'
    samples/livepatch/livepatch-extern-symbol.s:103: Warning: missing closing '"'
    samples/livepatch/livepatch-extern-symbol.s:103: Error: too many memory references for `movq'
    [ ... snip ... ]
  
  7) Which line is that?
  
    $ awk 'NR==103' "$OUTDIR_PREFIX"-x86_64/samples/livepatch/livepatch-extern-symbol.s
            movq    ".klp.sym.rela.vmlinux.vmlinux.saved_command_line,0"(%rip), %rdx


You could alternatively poke at it through the compiler explorer service
and toggle the source and binutils versions:

  (error)   binutils 2.36.1 : https://godbolt.org/z/cGGs6rfWe
  (success) binutils 2.38   : https://godbolt.org/z/ffzza3vYd

--
Joe


