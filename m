Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCE58EF06
	for <lists+live-patching@lfdr.de>; Thu, 15 Aug 2019 17:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732253AbfHOPFw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 15 Aug 2019 11:05:52 -0400
Received: from conssluserg-04.nifty.com ([210.131.2.83]:60595 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732079AbfHOPFv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 15 Aug 2019 11:05:51 -0400
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id x7FF5gTB012177;
        Fri, 16 Aug 2019 00:05:43 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com x7FF5gTB012177
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1565881544;
        bh=7YId5/KWcEONCewuALVN+Idh0R3qavrmJPNyYwf46/Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PddXaK/L/QdtFzPAH//J/ybhDue6w2n+ac/5PIKrsqoZt/6nrKM2KK2+MLCVaTSyU
         9bBLN/n6c1qw2OGVlCOGWT2ddQcaVuafrA1ovt2NlT+CTUo6e5EoepRTTrMNHAGDFC
         CKYbKARFieMOJDo0WNk9gooh57IT9XgDWPYXIe2FXR1OfdUtxNnmfSLLpONKK4KWuj
         iuDGp1Z1/YgBcN2YdDhxQHbE6qaRHdK8oR80EgcO2FaNTTigYJa3SDXTrN2eunL+YX
         Ewb46veLnyQ6Dis1Oe2cFosXe/1Mwb/ZhuH+ZfNOqK/O5qplzGcvA1yec1f3t6AMcr
         IZY811H+Qb5Hw==
X-Nifty-SrcIP: [209.85.222.48]
Received: by mail-ua1-f48.google.com with SMTP id y19so893930ual.13;
        Thu, 15 Aug 2019 08:05:43 -0700 (PDT)
X-Gm-Message-State: APjAAAVFleIUDHp30kI0m5XKEQCQb2p8uPT8MI3EWgreidklYODPXl7D
        HgCdvnuKT5lQPh9tHQ0VLGKzwpvCPrtBM1LTOgE=
X-Google-Smtp-Source: APXvYqx5rf35qySXOMhP7i9TefP8EmiWH4AmP1VxeOoQodDNmBhqC1I9+jiBOLUQEGg6kSCah3ecJLxX+Yp7Mc7Tn8Q=
X-Received: by 2002:ab0:70d9:: with SMTP id r25mr3166754ual.109.1565881542095;
 Thu, 15 Aug 2019 08:05:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
 <20190509143859.9050-7-joe.lawrence@redhat.com> <CAK7LNAQuS-YcXecfJ21BGzc0CimzWxQcYST5-1xRgnCQGtcL4A@mail.gmail.com>
 <20190812155626.GA19845@redhat.com>
In-Reply-To: <20190812155626.GA19845@redhat.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Fri, 16 Aug 2019 00:05:06 +0900
X-Gmail-Original-Message-ID: <CAK7LNATRLTBqA9c=b+Y38T-zWc9o5JMq18r9auA=enPC=p10pA@mail.gmail.com>
Message-ID: <CAK7LNATRLTBqA9c=b+Y38T-zWc9o5JMq18r9auA=enPC=p10pA@mail.gmail.com>
Subject: Re: [PATCH v4 06/10] modpost: Add modinfo flag to livepatch modules
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Joe,

On Tue, Aug 13, 2019 at 12:56 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>
> On Wed, Jul 31, 2019 at 02:58:27PM +0900, Masahiro Yamada wrote:
> > Hi Joe,
> >
> >
> > On Thu, May 9, 2019 at 11:39 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> > >
> > > From: Miroslav Benes <mbenes@suse.cz>
> > >
> > > Currently, livepatch infrastructure in the kernel relies on
> > > MODULE_INFO(livepatch, "Y") statement in a livepatch module. Then the
> > > kernel module loader knows a module is indeed livepatch module and can
> > > behave accordingly.
> > >
> > > klp-convert, on the other hand relies on LIVEPATCH_* statement in the
> > > module's Makefile for exactly the same reason.
> > >
> > > Remove dependency on modinfo and generate MODULE_INFO flag
> > > automatically in modpost when LIVEPATCH_* is defined in the module's
> > > Makefile. Generate a list of all built livepatch modules based on
> > > the .livepatch file and store it in (MODVERDIR)/livepatchmods. Give
> > > this list as an argument for modpost which will use it to identify
> > > livepatch modules.
> > >
> > > As MODULE_INFO is no longer needed, remove it.
> >
> >
> > I do not understand this patch.
> > This makes the implementation so complicated.
> >
> > I think MODULE_INFO(livepatch, "Y") is cleaner than
> > LIVEPATCH_* in Makefile.
> >
> >
> > How about this approach?
> >
> >
> > [1] Make modpost generate the list of livepatch modules.
> >     (livepatch-modules)
> >
> > [2] Generate Symbols.list in scripts/Makefile.modpost
> >     (vmlinux + modules excluding livepatch-modules)
> >
> > [3] Run klp-convert for modules in livepatch-modules.
> >
> >
> > If you do this, you can remove most of the build system hacks
> > can't you?
> >
> >
> > I attached an example implementation for [1].
> >
> > Please check whether this works.
> >
>
> Hi Masahiro,
>
> I tested and step [1] that you attached did create the livepatch-modules
> as expected.  Thanks for that example, it does look cleaner that what
> we had in the patchset.
>
> I'm admittedly out of my element with kbuild changes, but here are my
> naive attempts at steps [2] and [3]...
>
>
> [step 2] generate Symbols.list - I tacked this on as a dependency of the
> $(modules:.ko=.mod.o), but there is probably a better more logical place
> to put it.  Also used grep -Fxv to exclude the livepatch-modules list
> from the modules.order list of modules to process.
>
> -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--
>
> diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
> index 3eca7fccadd4..5409bbc212bb 100644
> --- a/scripts/Makefile.modpost
> +++ b/scripts/Makefile.modpost
> @@ -111,7 +111,23 @@ quiet_cmd_cc_o_c = CC      $@
>        cmd_cc_o_c = $(CC) $(c_flags) $(KBUILD_CFLAGS_MODULE) $(CFLAGS_MODULE) \
>                    -c -o $@ $<
>
> -$(modules:.ko=.mod.o): %.mod.o: %.mod.c FORCE
> +quiet_cmd_klp_map = KLP     Symbols.list
> +SLIST = $(objtree)/Symbols.list
> +
> +define cmd_symbols_list
> +       $(shell echo "klp-convert-symbol-data.0.1" > $(objtree)/Symbols.list)                   \
> +       $(shell echo "*vmlinux" >> $(objtree)/Symbols.list)                                     \
> +       $(shell nm -f posix $(objtree)/vmlinux | cut -d\  -f1 >> $(objtree)/Symbols.list)       \
> +       $(foreach ko, $(sort $(shell grep -Fxv -f livepatch-modules modules.order)),            \
> +               $(shell echo "*$(shell basename -s .ko $(ko))" >> $(objtree)/Symbols.list)      \
> +               $(shell nm -f posix $(patsubst %.ko,%.o,$(ko)) | cut -d\  -f1 >> $(objtree)/Symbols.list))
> +endef


All the $(shell ...) calls are pointless.


     $(shell echo "hello" > Symbols.list)

is equivalent to

     echo "hello" > Symbols.list


> +
> +Symbols.list: __modpost
> +       $(if $(CONFIG_LIVEPATCH), $(call cmd,symbols_list))
> +
> +
> +$(modules:.ko=.mod.o): %.mod.o: %.mod.c Symbols.list FORCE
>         $(call if_changed_dep,cc_o_c)
>
>  targets += $(modules:.ko=.mod.o)
> --
> 2.18.1
>
> -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--
>
>
>
> [step 3] klp-convert the livepatch-modules - more or less what existed
> in the patchset already, however used the grep -Fx trick to process only
> modules found in livepatch-modules file:
>
> -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--
>
> diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
> index 73e80b917f12..f085644c2b97 100644
> --- a/scripts/Kbuild.include
> +++ b/scripts/Kbuild.include
> @@ -223,6 +223,8 @@ endif
>  # (needed for the shell)
>  make-cmd = $(call escsq,$(subst $(pound),$$(pound),$(subst $$,$$$$,$(cmd_$(1)))))
>
> +save-cmd = printf '%s\n' 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd
> +
>  # Find any prerequisites that is newer than target or that does not exist.
>  # PHONY targets skipped in both cases.
>  any-prereq = $(filter-out $(PHONY),$?)$(filter-out $(PHONY) $(wildcard $^),$^)
> @@ -230,7 +232,7 @@ any-prereq = $(filter-out $(PHONY),$?)$(filter-out $(PHONY) $(wildcard $^),$^)
>  # Execute command if command has changed or prerequisite(s) are updated.
>  if_changed = $(if $(any-prereq)$(cmd-check),                                 \
>         $(cmd);                                                              \
> -       printf '%s\n' 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd, @:)
> +       $(save-cmd), @:)
>
>  # Execute the command and also postprocess generated .d dependencies file.
>  if_changed_dep = $(if $(any-prereq)$(cmd-check),$(cmd_and_fixdep),@:)
> diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
> index 5409bbc212bb..bc3b7b9dd8fa 100644
> --- a/scripts/Makefile.modpost
> +++ b/scripts/Makefile.modpost
> @@ -142,8 +142,22 @@ quiet_cmd_ld_ko_o = LD [M]  $@
>                   -o $@ $(real-prereqs) ;                                \
>         $(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) $@, true)
>
> +SLIST = $(objtree)/Symbols.list
> +KLP_CONVERT = scripts/livepatch/klp-convert
> +quiet_cmd_klp_convert = KLP     $@
> +      cmd_klp_convert = mv $@ $(@:.ko=.klp.o);                         \
> +                       $(KLP_CONVERT) $(SLIST) $(@:.ko=.klp.o) $@
> +
> +define rule_ld_ko_o
> +       $(Q)$(call echo-cmd,ld_ko_o) $(cmd_ld_ko_o) ;                           \
> +       $(call save-cmd,ld_ko_o) ;                                              \
> +       $(if $(CONFIG_LIVEPATCH),                                               \
> +               $(if $(shell grep -Fx "$@" livepatch-modules),                  \
> +                       $(call echo-cmd,klp_convert) $(cmd_klp_convert)))
> +endef

This does not correctly detect the command change of cmd_klp_convert.


I cleaned up the build system, and pushed it based on my
kbuild tree.

Please see:

git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git
klp-cleanup


Thanks.


> +
>  $(modules): %.ko :%.o %.mod.o FORCE
> -       +$(call if_changed,ld_ko_o)
> +       +$(call if_changed_rule,ld_ko_o)
>
>  targets += $(modules)
>
> --
> 2.18.1
>
> -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--
>
>
> Thanks,
>
> -- Joe
--
Best Regards
Masahiro Yamada
