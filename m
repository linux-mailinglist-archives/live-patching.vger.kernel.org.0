Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8D02514A
	for <lists+live-patching@lfdr.de>; Tue, 21 May 2019 15:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbfEUN6j (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 May 2019 09:58:39 -0400
Received: from condef-06.nifty.com ([202.248.20.71]:37995 "EHLO
        condef-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbfEUN6j (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 May 2019 09:58:39 -0400
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 May 2019 09:58:37 EDT
Received: from conssluserg-02.nifty.com ([10.126.8.81])by condef-06.nifty.com with ESMTP id x4LDo1N1007867
        for <live-patching@vger.kernel.org>; Tue, 21 May 2019 22:50:01 +0900
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id x4LDnYw6027273;
        Tue, 21 May 2019 22:49:35 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com x4LDnYw6027273
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1558446575;
        bh=wki7JwvrZ9RUz00+Did3BCvqytR4NxGLs+2dqfiy3MM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BvauOK+GHa1bl3WAMTDGrf7ni6j8z++/+NkQJOt845euJszQ/Sp+a9udFYjFe7KMM
         bkrkjmwK99j1jnZuq2JNNyodpy/ts4ayIF9cQo8mnx6gBfzmXONS04r+rSFaHTQZkm
         tkPn1csNMK5bdlUt7kUl9REGEKhigSKiJeN6wWFWYxV3iIbAD+bS2LcFeMaIRwvw8X
         7H4g6lO5nBxNd1fx/O+FPdZTFlHpZgssF598bHBc9LP8HR3kisfeGcktMuTULcPF0B
         2vZaaMpeFLANDC2Eh4J6OEy7UZ4SlH+gsCECPDTSkYRGCIWn+9agLNVwKv7uwvBdDN
         e1RlT3lwtupag==
X-Nifty-SrcIP: [209.85.217.54]
Received: by mail-vs1-f54.google.com with SMTP id c24so11169656vsp.7;
        Tue, 21 May 2019 06:49:35 -0700 (PDT)
X-Gm-Message-State: APjAAAVDqDGsFTxDXJfmsdYQdmbBJTbsWEI/E49SIDe/Y4ICww8OIdMC
        Vqfs9z7tFu+TJ0b1+2uOX5yqb6FkHPPwnv1sakc=
X-Google-Smtp-Source: APXvYqxcDjZDHiMUpn9cnaLGkfZA35KnjvEwSlFRKKz1fP5fktkPYJE8WDRbS6BEAwZ7dss7nXcKto+7mKSV9eENPpM=
X-Received: by 2002:a67:ad0f:: with SMTP id t15mr21995936vsl.179.1558446573967;
 Tue, 21 May 2019 06:49:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190509143859.9050-1-joe.lawrence@redhat.com> <20190509143859.9050-3-joe.lawrence@redhat.com>
In-Reply-To: <20190509143859.9050-3-joe.lawrence@redhat.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Tue, 21 May 2019 22:48:57 +0900
X-Gmail-Original-Message-ID: <CAK7LNAT_2Tgt+3C1RVYGn47uhQ0L94uY4CFRjjooJz2m0nZnXw@mail.gmail.com>
Message-ID: <CAK7LNAT_2Tgt+3C1RVYGn47uhQ0L94uY4CFRjjooJz2m0nZnXw@mail.gmail.com>
Subject: Re: [PATCH v4 02/10] kbuild: Support for Symbols.list creation
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, May 9, 2019 at 11:40 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>
> From: Joao Moreira <jmoreira@suse.de>
>
> For automatic resolution of livepatch relocations, a file called
> Symbols.list is used. This file maps symbols within every compiled
> kernel object allowing the identification of symbols whose name is
> unique, thus relocation can be automatically inferred, or providing
> information that helps developers when code annotation is required for
> solving the matter.
>
> Add support for creating Symbols.list in the main Makefile. First,
> ensure that built-in is compiled when CONFIG_LIVEPATCH is enabled (as
> required to achieve a complete Symbols.list file). Define the command to
> build Symbols.list (cmd_klp_map) and hook it in the modules rule.
>
> As it is undesirable to have symbols from livepatch objects inside
> Symbols.list, make livepatches discernible by modifying
> scripts/Makefile.build to create a .livepatch file for each livepatch
> in $(MODVERDIR). This file then used by cmd_klp_map to identify and
> bypass livepatches.
>
> For identifying livepatches during the build process, a flag variable
> LIVEPATCH_$(basetarget).o is considered in scripts/Makefile.build. This
> way, set this flag for the livepatch sample Makefile in
> samples/livepatch/Makefile.
>
> Finally, Add a clean rule to ensure that Symbols.list is removed during
> clean.
>
> Notes:
>
> To achieve a correct Symbols.list file, all kernel objects must be
> considered, thus, its construction require these objects to be priorly
> built. On the other hand, invoking scripts/Makefile.modpost without
> having a complete Symbols.list in place would occasionally lead to
> in-tree livepatches being post-processed incorrectly. To prevent this
> from becoming a circular dependency, the construction of Symbols.list
> uses non-post-processed kernel objects and such does not cause harm as
> the symbols normally referenced from within livepatches are visible at
> this stage. Also due to these requirements, the spot in-between modules
> compilation and the invocation of scripts/Makefile.modpost was picked
> for hooking cmd_klp_map.
>
> The approach based on .livepatch files was proposed as an alternative
> to using MODULE_INFO statements. This approach was originally
> proposed by Miroslav Benes as a workaround for identifying livepathes
> without depending on modinfo during the modpost stage. It was moved to
> this patch as the approach also shown to be useful while building
> Symbols.list.
>
> Signed-off-by: Joao Moreira <jmoreira@suse.de>
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> ---
>  .gitignore                 |  1 +
>  Makefile                   | 30 ++++++++++++++++++++++++++----
>  lib/livepatch/Makefile     |  5 +++++
>  samples/livepatch/Makefile |  4 ++++
>  scripts/Makefile.build     |  7 +++++++
>  5 files changed, 43 insertions(+), 4 deletions(-)
>
> diff --git a/.gitignore b/.gitignore
> index a20ac26aa2f5..5cd5758f5ffe 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -45,6 +45,7 @@
>  *.xz
>  Module.symvers
>  modules.builtin
> +Symbols.list


Symbols.list is created only in the top directory.

Please move this to

# Top-level generic files

section with a leading slash.



Also, you need to add it to
Documentation/dontdiff




>  #
>  # Top-level generic files
> diff --git a/Makefile b/Makefile
> index abe13538a8c0..98089f9d44fe 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -574,10 +574,13 @@ KBUILD_BUILTIN := 1
>  # If we have only "make modules", don't compile built-in objects.
>  # When we're building modules with modversions, we need to consider
>  # the built-in objects during the descend as well, in order to
> -# make sure the checksums are up to date before we record them.
> +# make sure the checksums are up to date before we record them. The
> +# same applies for building livepatches, as built-in objects may hold
> +# symbols which are referenced from livepatches and are required by
> +# klp-convert post-processing tool for resolving these cases.
>
>  ifeq ($(MAKECMDGOALS),modules)
> -  KBUILD_BUILTIN := $(if $(CONFIG_MODVERSIONS),1)
> +  KBUILD_BUILTIN := $(if $(or $(CONFIG_MODVERSIONS), $(CONFIG_LIVEPATCH)),1)
>  endif
>
>  # If we have "make <whatever> modules", compile modules
> @@ -1261,9 +1264,25 @@ all: modules
>  # duplicate lines in modules.order files.  Those are removed
>  # using awk while concatenating to the final file.
>
> +quiet_cmd_klp_map = KLP     Symbols.list
> +SLIST = $(objtree)/Symbols.list


Please do not define SLIST.

Use Symbols.list directly.




> +
> +define cmd_klp_map
> +       $(shell echo "klp-convert-symbol-data.0.1" > $(SLIST))                          \
> +       $(shell echo "*vmlinux" >> $(SLIST))                                            \
> +       $(shell nm -f posix $(objtree)/vmlinux | cut -d\  -f1 >> $(SLIST))              \
> +       $(foreach m, $(wildcard $(MODVERDIR)/*.mod),                                    \
> +               $(eval mod = $(patsubst %.ko,%.o,$(shell head -n1 $(m))))               \
> +               $(if $(wildcard $(MODVERDIR)/$(shell basename -s .o $(mod)).livepatch),,\
> +                       $(eval fmod = $(subst $(quote),_,$(subst -,_,$(mod))))          \
> +                       $(shell echo "*$(shell basename -s .o $(fmod))" >> $(SLIST))    \
> +                       $(shell nm -f posix $(mod) | cut -d\  -f1 >> $(SLIST))))
> +endef
> +
>  PHONY += modules
>  modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux) modules.builtin
>         $(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.order) > $(objtree)/modules.order
> +       $(if $(CONFIG_LIVEPATCH), $(call cmd,klp_map))
>         @$(kecho) '  Building modules, stage 2.';
>         $(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
>
> @@ -1350,7 +1369,7 @@ clean: rm-dirs  := $(CLEAN_DIRS)
>  clean: rm-files := $(CLEAN_FILES)
>  clean-dirs      := $(addprefix _clean_, . $(vmlinux-alldirs) Documentation samples)
>
> -PHONY += $(clean-dirs) clean archclean vmlinuxclean
> +PHONY += $(clean-dirs) clean archclean vmlinuxclean klpclean
>  $(clean-dirs):
>         $(Q)$(MAKE) $(clean)=$(patsubst _clean_%,%,$@)
>
> @@ -1358,7 +1377,10 @@ vmlinuxclean:
>         $(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
>         $(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
>
> -clean: archclean vmlinuxclean
> +klpclean:
> +       $(Q) rm -f $(SLIST)


klpclean is unneeded.

Add it to CLEAN_FILES

CLEAN_FILES += modules.builtin.modinfo Systems.list




-- 
Best Regards
Masahiro Yamada
