Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FF41AD87E
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2020 10:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbgDQI1H (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Apr 2020 04:27:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:47780 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729166AbgDQI1H (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Apr 2020 04:27:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D2ABFACCA;
        Fri, 17 Apr 2020 08:27:04 +0000 (UTC)
Date:   Fri, 17 Apr 2020 10:27:04 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Jessica Yu <jeyu@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] livepatch,module: Remove .klp.arch and
 module_disable_ro()
In-Reply-To: <20200416154514.xqqyvdtm6hjynbx2@treble>
Message-ID: <alpine.LSU.2.21.2004171025090.31054@pobox.suse.cz>
References: <cover.1586881704.git.jpoimboe@redhat.com> <20200414182726.GF2483@worktop.programming.kicks-ass.net> <20200414190814.glra2gceqgy34iyx@treble> <20200415142415.GH20730@hirez.programming.kicks-ass.net> <20200415161706.3tw5o4se2cakxmql@treble>
 <20200416153131.GC6164@linux-8ccs.fritz.box> <20200416154514.xqqyvdtm6hjynbx2@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 16 Apr 2020, Josh Poimboeuf wrote:

> On Thu, Apr 16, 2020 at 05:31:31PM +0200, Jessica Yu wrote:
> > > But I still not a fan of the fact that COMING has two different
> > > "states".  For example, after your patch, when apply_relocate_add() is
> > > called from klp_module_coming(), it can use memcpy(), but when called
> > > from klp module init() it has to use text poke.  But both are COMING so
> > > there's no way to look at the module state to know which can be used.
> > 
> > This is a good observation, thanks for bringing it up. I agree that we
> > should strive to be consistent with what the module states mean. In my
> > head, I think it is easiest to assume/establish the following meanings
> > for each module state:
> > 
> > MODULE_STATE_UNFORMED - no protections. relocations, alternatives,
> > ftrace module initialization, etc. any other text modifications are
> > in the process of being applied. Direct writes are permissible.
> > 
> > MODULE_STATE_COMING - module fully formed, text modifications are
> > done, protections applied, module is ready to execute init or is
> > executing init.
> > 
> > I wonder if we could enforce the meaning of these two states more
> > consistently without needing to add another module state.
> > 
> > Regarding Peter's patches, with the set_all_modules_text_*() api gone,
> > and ftrace reliance on MODULE_STATE_COMING gone (I think?), is there
> > anything preventing ftrace_module_init+enable from being called
> > earlier (i.e., before complete_formation()) while the module is
> > unformed? Then you don't have to move module_enable_ro/nx later and we
> > keep the MODULE_STATE_COMING semantics. And if we're enforcing the
> > above module state meanings, I would also be OK with moving jump_label
> > and static_call out of the coming notifier chain and making them
> > explicit calls while the module is still writable.
> > 
> > Sorry in advance if I missed anything above, I'm still trying to wrap
> > my head around which callers need what module state and what module
> > permissions :/
> 
> Sounds reasonable to me...
> 
> BTW, instead of hard-coding the jump-label/static-call/ftrace calls, we
> could instead call notifiers with MODULE_STATE_UNFORMED.

That was exactly what I was thinking about too while reading Jessica's 
email. Since (hopefully all if I remember correctly. I checked only 
random subset now) existing module notifiers check module state, 
it should not be a problem.

Miroslav
