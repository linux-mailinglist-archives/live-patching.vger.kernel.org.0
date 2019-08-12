Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B5B8A2B9
	for <lists+live-patching@lfdr.de>; Mon, 12 Aug 2019 17:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfHLP43 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 12 Aug 2019 11:56:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53306 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbfHLP43 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 12 Aug 2019 11:56:29 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B32A17BDA9;
        Mon, 12 Aug 2019 15:56:28 +0000 (UTC)
Received: from redhat.com (dhcp-17-153.bos.redhat.com [10.18.17.153])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 350F562671;
        Mon, 12 Aug 2019 15:56:28 +0000 (UTC)
Date:   Mon, 12 Aug 2019 11:56:26 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] modpost: Add modinfo flag to livepatch modules
Message-ID: <20190812155626.GA19845@redhat.com>
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
 <20190509143859.9050-7-joe.lawrence@redhat.com>
 <CAK7LNAQuS-YcXecfJ21BGzc0CimzWxQcYST5-1xRgnCQGtcL4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNAQuS-YcXecfJ21BGzc0CimzWxQcYST5-1xRgnCQGtcL4A@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 12 Aug 2019 15:56:28 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jul 31, 2019 at 02:58:27PM +0900, Masahiro Yamada wrote:
> Hi Joe,
> 
> 
> On Thu, May 9, 2019 at 11:39 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> >
> > From: Miroslav Benes <mbenes@suse.cz>
> >
> > Currently, livepatch infrastructure in the kernel relies on
> > MODULE_INFO(livepatch, "Y") statement in a livepatch module. Then the
> > kernel module loader knows a module is indeed livepatch module and can
> > behave accordingly.
> >
> > klp-convert, on the other hand relies on LIVEPATCH_* statement in the
> > module's Makefile for exactly the same reason.
> >
> > Remove dependency on modinfo and generate MODULE_INFO flag
> > automatically in modpost when LIVEPATCH_* is defined in the module's
> > Makefile. Generate a list of all built livepatch modules based on
> > the .livepatch file and store it in (MODVERDIR)/livepatchmods. Give
> > this list as an argument for modpost which will use it to identify
> > livepatch modules.
> >
> > As MODULE_INFO is no longer needed, remove it.
> 
> 
> I do not understand this patch.
> This makes the implementation so complicated.
> 
> I think MODULE_INFO(livepatch, "Y") is cleaner than
> LIVEPATCH_* in Makefile.
> 
> 
> How about this approach?
> 
> 
> [1] Make modpost generate the list of livepatch modules.
>     (livepatch-modules)
> 
> [2] Generate Symbols.list in scripts/Makefile.modpost
>     (vmlinux + modules excluding livepatch-modules)
> 
> [3] Run klp-convert for modules in livepatch-modules.
> 
> 
> If you do this, you can remove most of the build system hacks
> can't you?
> 
> 
> I attached an example implementation for [1].
> 
> Please check whether this works.
> 

Hi Masahiro, 

I tested and step [1] that you attached did create the livepatch-modules
as expected.  Thanks for that example, it does look cleaner that what
we had in the patchset.

I'm admittedly out of my element with kbuild changes, but here are my
naive attempts at steps [2] and [3]...


[step 2] generate Symbols.list - I tacked this on as a dependency of the
$(modules:.ko=.mod.o), but there is probably a better more logical place
to put it.  Also used grep -Fxv to exclude the livepatch-modules list
from the modules.order list of modules to process.

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--

diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 3eca7fccadd4..5409bbc212bb 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -111,7 +111,23 @@ quiet_cmd_cc_o_c = CC      $@
       cmd_cc_o_c = $(CC) $(c_flags) $(KBUILD_CFLAGS_MODULE) $(CFLAGS_MODULE) \
 		   -c -o $@ $<
 
-$(modules:.ko=.mod.o): %.mod.o: %.mod.c FORCE
+quiet_cmd_klp_map = KLP     Symbols.list
+SLIST = $(objtree)/Symbols.list
+
+define cmd_symbols_list
+	$(shell echo "klp-convert-symbol-data.0.1" > $(objtree)/Symbols.list)			\
+	$(shell echo "*vmlinux" >> $(objtree)/Symbols.list)					\
+	$(shell nm -f posix $(objtree)/vmlinux | cut -d\  -f1 >> $(objtree)/Symbols.list)	\
+	$(foreach ko, $(sort $(shell grep -Fxv -f livepatch-modules modules.order)),		\
+		$(shell echo "*$(shell basename -s .ko $(ko))" >> $(objtree)/Symbols.list)	\
+		$(shell nm -f posix $(patsubst %.ko,%.o,$(ko)) | cut -d\  -f1 >> $(objtree)/Symbols.list))
+endef
+
+Symbols.list: __modpost
+	$(if $(CONFIG_LIVEPATCH), $(call cmd,symbols_list))
+
+
+$(modules:.ko=.mod.o): %.mod.o: %.mod.c Symbols.list FORCE
 	$(call if_changed_dep,cc_o_c)
 
 targets += $(modules:.ko=.mod.o)
-- 
2.18.1

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--



[step 3] klp-convert the livepatch-modules - more or less what existed
in the patchset already, however used the grep -Fx trick to process only
modules found in livepatch-modules file:

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 73e80b917f12..f085644c2b97 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -223,6 +223,8 @@ endif
 # (needed for the shell)
 make-cmd = $(call escsq,$(subst $(pound),$$(pound),$(subst $$,$$$$,$(cmd_$(1)))))
 
+save-cmd = printf '%s\n' 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd
+
 # Find any prerequisites that is newer than target or that does not exist.
 # PHONY targets skipped in both cases.
 any-prereq = $(filter-out $(PHONY),$?)$(filter-out $(PHONY) $(wildcard $^),$^)
@@ -230,7 +232,7 @@ any-prereq = $(filter-out $(PHONY),$?)$(filter-out $(PHONY) $(wildcard $^),$^)
 # Execute command if command has changed or prerequisite(s) are updated.
 if_changed = $(if $(any-prereq)$(cmd-check),                                 \
 	$(cmd);                                                              \
-	printf '%s\n' 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd, @:)
+	$(save-cmd), @:)
 
 # Execute the command and also postprocess generated .d dependencies file.
 if_changed_dep = $(if $(any-prereq)$(cmd-check),$(cmd_and_fixdep),@:)
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 5409bbc212bb..bc3b7b9dd8fa 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -142,8 +142,22 @@ quiet_cmd_ld_ko_o = LD [M]  $@
                  -o $@ $(real-prereqs) ;                                \
 	$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) $@, true)
 
+SLIST = $(objtree)/Symbols.list
+KLP_CONVERT = scripts/livepatch/klp-convert
+quiet_cmd_klp_convert = KLP     $@
+      cmd_klp_convert = mv $@ $(@:.ko=.klp.o);				\
+			$(KLP_CONVERT) $(SLIST) $(@:.ko=.klp.o) $@
+
+define rule_ld_ko_o
+	$(Q)$(call echo-cmd,ld_ko_o) $(cmd_ld_ko_o) ;				\
+	$(call save-cmd,ld_ko_o) ;						\
+	$(if $(CONFIG_LIVEPATCH),						\
+		$(if $(shell grep -Fx "$@" livepatch-modules),			\
+			$(call echo-cmd,klp_convert) $(cmd_klp_convert)))
+endef
+
 $(modules): %.ko :%.o %.mod.o FORCE
-	+$(call if_changed,ld_ko_o)
+	+$(call if_changed_rule,ld_ko_o)
 
 targets += $(modules)
 
-- 
2.18.1

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--


Thanks,

-- Joe
