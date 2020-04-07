Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFD51A1713
	for <lists+live-patching@lfdr.de>; Tue,  7 Apr 2020 22:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgDGU5u (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 Apr 2020 16:57:50 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54412 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726386AbgDGU5u (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 Apr 2020 16:57:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586293068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H8B5NoGqu8tQRGAEZ9OE3JoK+IEkffevD1+IZAtw1Lc=;
        b=hE/GJQCNmFsvbHj/gxsp2bZbRFX6/dHHs+O3ML8woLsyYEn5joWRpRW6IOZnJsKNaQWWrQ
        tahKntUP5FVGaQGvMiUAxwBZimff9PgEOSVsT/KA7xi2Mdvlf9e08FRCexcbzm2rn3FYqy
        76mjeK32BfFLWGVJwknBQ0AZGjFQtHQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-0LaS2oQhNFicRqHdRPCGQw-1; Tue, 07 Apr 2020 16:57:44 -0400
X-MC-Unique: 0LaS2oQhNFicRqHdRPCGQw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DD73107ACC4;
        Tue,  7 Apr 2020 20:57:43 +0000 (UTC)
Received: from redhat.com (ovpn-112-68.phx2.redhat.com [10.3.112.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7505C119589;
        Tue,  7 Apr 2020 20:57:42 +0000 (UTC)
Date:   Tue, 7 Apr 2020 16:57:40 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [POC 19/23] module/livepatch: Allow to use exported symbols from
 livepatch module for "vmlinux"
Message-ID: <20200407205740.GA17061@redhat.com>
References: <20200117150323.21801-1-pmladek@suse.com>
 <20200117150323.21801-20-pmladek@suse.com>
 <20200406184833.GA6023@redhat.com>
 <alpine.LSU.2.21.2004070915040.1817@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2004070915040.1817@pobox.suse.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 07, 2020 at 09:33:08AM +0200, Miroslav Benes wrote:
> On Mon, 6 Apr 2020, Joe Lawrence wrote:
> 
> > On Fri, Jan 17, 2020 at 04:03:19PM +0100, Petr Mladek wrote:
> > > HINT: Get some coffee before reading this commit message.
> > > 
> > > [ ... snip ... ]
> > > 
> > > B. Livepatch module using an exported symbol from the patched module.
> > > 
> > >    It should be avoided even with the non-split livepatch module. The module
> > >    loader automatically takes reference to make sure the modules are
> > >    unloaded in the right order. This would basically prevent the livepatched
> > >    module from unloading.
> > > 
> > >    Note that it would be perfectly safe to remove this automatic
> > >    dependency. The livepatch framework makes sure that the livepatch
> > >    module is loaded only when the patched one is loaded. But it cannot
> > >    be implemented easily, see below.
> > 
> > Do you envision klp-convert providing this functionality?
> > 
> > [ ... snip ... ]
> 
> That is one way to get around the dependency problem. And I think it 
> should work even with the PoC. It should (and I don't remember all details 
> now unfortunately) guarantee that the patched module is always available 
> for the livepatch and since there is no explicit dependency, the recursion 
> issue is gone.
> 
> However, I think the goal was to follow the most natural road and leverage 
> the existing dependency system. Meaning, since the presence of a patched 
> module in the system before its patching is guaranteed now, there is no 
> reason not to use its exported symbols directly like anywhere else. But it 
> introduces the recursion problem, so we may drop it.
> 
> > FWIW, I have been working an updated klp-convert for v5.6 that includes
> > a bunch of fixes and such... modifying it to convert module-export
> > references like this was quite easy.
> 
> *THUMBS UP* :)

Hi Miroslav,

Perhaps the following bug report is premature, but it was far easier to
start playing with the PoC code than audit all the individual race
conditions :) This came out of the mentioned klp-convert rebase that I
later put on-top of Petr's PoC, and then started writing up some more
selftests to see how the new livepatching world might look.

Forgive me if I'm violating some obvious assumption that the PoC makes,
but I think the experiment may still be useful in pointing out a
problematic use-case / potential pitfall a livepatch author might
encounter.

tl;dr: prepare_coming_module() calls jump_label_add_module() *after* it
       calls klp_module_coming().  In the PoC, the latter function now
       searches for any livepatches that may apply to the loading
       module and tries to load them before proceeding.  If one of
       those livepatch modules references any static key defined by the
       originally loading module, the static key entry structures may
       not be setup correctly.


The test case:

- A kernel module defines a static key called test_klp_true_key and on
  __init, calls static_branch_disable().  I don't think the __init part
  is required for this case, however it was just the easiest way to
  write the test that I was working on at the time.  AFAIK we could
  change the key any where else with the same problem.

- A livepatch module that references test_klp_true_key.  The overarching
  test case was for the key's module owner (target) and 
  livepatch (livepatch__target) to toggle the key and for both target
  and livepatch__target modules to be patched accordingly.

- klp-convert was enhanced to modify relocations to test_klp_true_key in
  both .text and __jump_table sections.  It previously could not handle
  this scenario.


Pseudocode
==========

target.c
--------
static DEFINE_STATIC_KEY_TRUE(test_klp_true_key);
...
__init function() {
	static_branch_disable(&test_klp_true_key);
}

livepatch__target.c
-------------------
extern struct static_key_true test_klp_true_key;
...
pr_info("static_branch_likely(&test_klp_true_key) is %s\n",
	static_branch_likely(&test_klp_true_key) ? "true" : "false");


Test
====

% modprobe livepatch    # livepatch__target only loads when target loads
% modprobe target

(crash in jump_label_update)


Callchain and notes
===================

(livepatch is already loaded)

target
------
load_module
  apply_relocations
  post_relocations
    module_finalize
      jump_label_apply_nops
  complete_formation
    mod->state = MODULE_STATE_COMING
  prepare_coming_module
    klp_module_coming
      klp_try_load_object
        patch_name = livepatch, obj_name = target

    livepatch__target
    -----------------
    load_module
      apply_relocations
      post_relocations
        module_finalize
          jump_label_apply_nops
      complete_formation
        mod->state = MODULE_STATE_COMING
      prepare_coming_module
        blocking_notifier_call_chain(MODULE_STATE_COMING)
          jump_label_module_notify (MODULE_STATE_COMING)
            jump_label_add_module

              first time processing test_klp_true_key, within_module()
              returns false (the key is defined in the other module),
              and we treat it as !static_key_linked() so the code goes
              ahead and makes it linked

              static_key_set_linked
                key->type |= JUMP_TYPE_LINKED

      do_init_module
        mod->state = MODULE_STATE_LIVE;
        blocking_notifier_call_chain(MODULE_STATE_LIVE)
          jump_label_module_notify (MODULE_STATE_LIVE)

target
------
  (prepare_coming_module cont...)
    blocking_notifier_call_chain(MODULE_STATE_COMING)
     jump_label_module_notify(MODULE_STATE_COMING)
       jump_label_add_module

         second time processing test_klp_true_key, within_module()
	 returns true this time and we go straight to
	 static_key_set_entries(), which is careful enough to verify the
         that the entries aren't already linked, but not the key itself

         static_key_set_entries
           WARN_ON_ONCE((unsigned long)entries & JUMP_TYPE_MASK)


  do_init_module
    mod->state = MODULE_STATE_LIVE;
    blocking_notifier_call_chain(MODULE_STATE_LIVE)
      jump_label_module_notify (MODULE_STATE_LIVE)


Ok, so it seems that jump_label_add_module() assumes that any given key
that isn't present in said module, is assumed to have already been
initialized and therefore it enters that convoluted JUMP_TYPE_LINKED
code.

When we later try call jump_label_add_module() for the target module,
the same function assumes that the key is not linked and we're left with
a weird static_key_mod entry that later crashes the box.

tl;dr2: Could we safely reorder klp_module_{coming,going}() with respect
        to the module_notifier callbacks?  i.e.

        blocking_notifier_call_chain(&module_notify_list, MODULE_STATE_COMING, mod);
        klp_module_coming(mod);
          ... and ...
        klp_module_going(mod);
        blocking_notifier_call_chain(&module_notify_list, MODULE_STATE_GOING, mod);

This fixes the above test case, but I wasn't sure if it now violates
some other part of the PoC or consistency model.

-- Joe

