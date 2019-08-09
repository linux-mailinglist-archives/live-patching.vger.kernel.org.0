Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23CF9882CB
	for <lists+live-patching@lfdr.de>; Fri,  9 Aug 2019 20:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfHISm5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Aug 2019 14:42:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38748 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbfHISm5 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Aug 2019 14:42:57 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 06A773069609;
        Fri,  9 Aug 2019 18:42:56 +0000 (UTC)
Received: from redhat.com (ovpn-125-104.rdu2.redhat.com [10.10.125.104])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 25B23F6E9;
        Fri,  9 Aug 2019 18:42:55 +0000 (UTC)
Date:   Fri, 9 Aug 2019 14:42:53 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH v4 03/10] livepatch: Add klp-convert tool
Message-ID: <20190809184253.GA31811@redhat.com>
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
 <20190509143859.9050-4-joe.lawrence@redhat.com>
 <CAK7LNAT3qZ8EESs0eEtaezjgjzRa1XqoAAxpKh_sLi_JPJie2A@mail.gmail.com>
 <CAK7LNAToLyKSk9C0hwuMRxDK8yjJtghi_y6fH1p0+wK7N1wKow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNAToLyKSk9C0hwuMRxDK8yjJtghi_y6fH1p0+wK7N1wKow@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 09 Aug 2019 18:42:56 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jul 31, 2019 at 12:36:05PM +0900, Masahiro Yamada wrote:
> On Wed, Jul 31, 2019 at 11:50 AM Masahiro Yamada
> <yamada.masahiro@socionext.com> wrote:
> >
> > On Thu, May 9, 2019 at 11:39 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> > >
> > > From: Josh Poimboeuf <jpoimboe@redhat.com>
> > >
> > > Livepatches may use symbols which are not contained in its own scope,
> > > and, because of that, may end up compiled with relocations that will
> > > only be resolved during module load. Yet, when the referenced symbols
> > > are not exported, solving this relocation requires information on the
> > > object that holds the symbol (either vmlinux or modules) and its
> > > position inside the object, as an object may contain multiple symbols
> > > with the same name. Providing such information must be done
> > > accordingly to what is specified in
> > > Documentation/livepatch/module-elf-format.txt.
> > >
> > > Currently, there is no trivial way to embed the required information
> > > as requested in the final livepatch elf object. klp-convert solves
> > > this problem in two different forms: (i) by relying on Symbols.list,
> > > which is built during kernel compilation, to automatically infer the
> > > relocation targeted symbol, and, when such inference is not possible
> > > (ii) by using annotations in the elf object to convert the relocation
> > > accordingly to the specification, enabling it to be handled by the
> > > livepatch loader.
> > >
> > > Given the above, create scripts/livepatch to hold tools developed for
> > > livepatches and add source files for klp-convert there.
> > >
> > > The core file of klp-convert is scripts/livepatch/klp-convert.c, which
> > > implements the heuristics used to solve the relocations and the
> > > conversion of unresolved symbols into the expected format, as defined
> > > in [1].
> > >
> > > klp-convert receives as arguments the Symbols.list file, an input
> > > livepatch module to be converted and the output name for the converted
> > > livepatch. When it starts running, klp-convert parses Symbols.list and
> > > builds two internal lists of symbols, one containing the exported and
> > > another containing the non-exported symbols. Then, by parsing the rela
> > > sections in the elf object, klp-convert identifies which symbols must
> > > be converted, which are those unresolved and that do not have a
> > > corresponding exported symbol, and attempts to convert them
> > > accordingly to the specification.
> > >
> > > By using Symbols.list, klp-convert identifies which symbols have names
> > > that only appear in a single kernel object, thus being capable of
> > > resolving these cases without the intervention of the developer. When
> > > various homonymous symbols exist through kernel objects, it is not
> > > possible to infer the right one, thus klp-convert falls back into
> > > using developer annotations. If these were not provided, then the tool
> > > will print a list with all acceptable targets for the symbol being
> > > processed.
> > >
> > > Annotations in the context of klp-convert are accessible as struct
> > > klp_module_reloc entries in sections named
> > > .klp.module_relocs.<objname>. These entries are pairs of symbol
> > > references and positions which are to be resolved against definitions
> > > in <objname>.
> > >
> > > Define the structure klp_module_reloc in
> > > include/linux/uapi/livepatch.h allowing developers to annotate the
> > > livepatch source code with it.
> > >
> > > klp-convert relies on libelf and on a list implementation. Add files
> > > scripts/livepatch/elf.c and scripts/livepatch/elf.h, which are a
> > > libelf interfacing layer and scripts/livepatch/list.h, which is a
> > > list implementation.
> > >
> > > Update Makefiles to correctly support the compilation of the new tool,
> > > update MAINTAINERS file and add a .gitignore file.
> > >
> > > [1] - Documentation/livepatch/module-elf-format.txt
> > >
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > > Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> > > Signed-off-by: Joao Moreira <jmoreira@suse.de>
> > > Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> > > ---
> > >  MAINTAINERS                     |   1 +
> > >  include/uapi/linux/livepatch.h  |   5 +
> > >  scripts/Makefile                |   1 +
> > >  scripts/livepatch/.gitignore    |   1 +
> > >  scripts/livepatch/Makefile      |   7 +
> > >  scripts/livepatch/elf.c         | 753 ++++++++++++++++++++++++++++++++
> > >  scripts/livepatch/elf.h         |  73 ++++
> > >  scripts/livepatch/klp-convert.c | 713 ++++++++++++++++++++++++++++++
> > >  scripts/livepatch/klp-convert.h |  39 ++
> > >  scripts/livepatch/list.h        | 391 +++++++++++++++++
> > >  10 files changed, 1984 insertions(+)
> > >  create mode 100644 scripts/livepatch/.gitignore
> > >  create mode 100644 scripts/livepatch/Makefile
> > >  create mode 100644 scripts/livepatch/elf.c
> > >  create mode 100644 scripts/livepatch/elf.h
> > >  create mode 100644 scripts/livepatch/klp-convert.c
> > >  create mode 100644 scripts/livepatch/klp-convert.h
> > >  create mode 100644 scripts/livepatch/list.h
> > >
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 52842fa37261..c1587e1cc385 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -9022,6 +9022,7 @@ F:        arch/x86/kernel/livepatch.c
> > >  F:     Documentation/livepatch/
> > >  F:     Documentation/ABI/testing/sysfs-kernel-livepatch
> > >  F:     samples/livepatch/
> > > +F:     scripts/livepatch/
> > >  F:     tools/testing/selftests/livepatch/
> > >  L:     live-patching@vger.kernel.org
> > >  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git
> > > diff --git a/include/uapi/linux/livepatch.h b/include/uapi/linux/livepatch.h
> > > index e19430918a07..1c364d42d38e 100644
> > > --- a/include/uapi/linux/livepatch.h
> > > +++ b/include/uapi/linux/livepatch.h
> > > @@ -12,4 +12,9 @@
> > >  #define KLP_RELA_PREFIX                ".klp.rela."
> > >  #define KLP_SYM_PREFIX         ".klp.sym."
> > >
> > > +struct klp_module_reloc {
> > > +       void *sym;
> > > +       unsigned int sympos;
> > > +} __attribute__((packed));
> > > +
> > >  #endif /* _UAPI_LIVEPATCH_H */
> > > diff --git a/scripts/Makefile b/scripts/Makefile
> > > index 9d442ee050bd..bf9ce74b70b0 100644
> > > --- a/scripts/Makefile
> > > +++ b/scripts/Makefile
> > > @@ -39,6 +39,7 @@ build_unifdef: $(obj)/unifdef
> > >  subdir-$(CONFIG_GCC_PLUGINS) += gcc-plugins
> > >  subdir-$(CONFIG_MODVERSIONS) += genksyms
> > >  subdir-$(CONFIG_SECURITY_SELINUX) += selinux
> > > +subdir-$(CONFIG_LIVEPATCH)   += livepatch
> > >
> > >  # Let clean descend into subdirs
> > >  subdir-        += basic dtc gdb kconfig mod package
> > > diff --git a/scripts/livepatch/.gitignore b/scripts/livepatch/.gitignore
> > > new file mode 100644
> > > index 000000000000..dc22fe4b6a5b
> > > --- /dev/null
> > > +++ b/scripts/livepatch/.gitignore
> > > @@ -0,0 +1 @@
> > > +klp-convert
> > > diff --git a/scripts/livepatch/Makefile b/scripts/livepatch/Makefile
> > > new file mode 100644
> > > index 000000000000..2842ecdba3fd
> > > --- /dev/null
> > > +++ b/scripts/livepatch/Makefile
> > > @@ -0,0 +1,7 @@
> > > +hostprogs-y                    := klp-convert
> > > +always                         := $(hostprogs-y)
> > > +
> > > +klp-convert-objs               := klp-convert.o elf.o
> > > +
> > > +HOST_EXTRACFLAGS               := -g -I$(INSTALL_HDR_PATH)/include -Wall
> >
> > This looks strange.
> >
> > Theoretically, you cannot include headers in $(INSTALL_HDR_PATH)/include
> > from host programs.
> >
> > headers_install works for the target architecture, not host architecture.
> > This may cause a strange result when you are cross-compiling the kernel.
> >
> > BTW, which header in $(INSTALL_HDR_PATH)/include do you need to include ?
> >
> >
> > Also, -Wall is redundant because it is set by the top-level Makefile.
> 
> 
> I deleted HOST_EXTRACFLAGS entirely,
> and I was still able to build klp-convert.
> 
> 
> What is the purpose of '-g' ?
> If it is only needed for local debugging,
> it should be removed from the upstream code, in my opinion.
> 

HOST_EXTRACFLAGS looks like it was present in the patchset from the
early RFC days and inherited through each revision.

These are the files that the klp-convert code includes, mostly typical C
usercode headers like stdio.h and a few local headers like elf.h:

  % grep -h '^#include' scripts/livepatch/*.{c,h} | sort -u
  #include "elf.h"
  #include <fcntl.h>
  #include <gelf.h>
  #include "klp-convert.h"
  #include "list.h"
  #include <stdbool.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <sys/stat.h>
  #include <sys/types.h>
  #include <unistd.h>

If HOST_EXTRACFLAGS is really unneeded, we can easily drop it in the
next patchset version.

I haven't tried cross-compiling yet, but that is a good thing to note
for future testing.

Thanks,

-- Joe
