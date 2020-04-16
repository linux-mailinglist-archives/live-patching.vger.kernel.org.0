Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A781ABCC9
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2020 11:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392206AbgDPJ2b (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Apr 2020 05:28:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:59948 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392188AbgDPJ22 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Apr 2020 05:28:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E9FEBAD0E;
        Thu, 16 Apr 2020 09:28:25 +0000 (UTC)
Date:   Thu, 16 Apr 2020 11:28:25 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Jessica Yu <jeyu@kernel.org>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 6/7] livepatch: Remove module_disable_ro() usage
In-Reply-To: <20200415163303.ubdnza6okg4h3e5a@treble>
Message-ID: <alpine.LSU.2.21.2004161126540.10475@pobox.suse.cz>
References: <cover.1586881704.git.jpoimboe@redhat.com> <9f0d8229bbe79d8c13c091ed70c41d49caf598f2.1586881704.git.jpoimboe@redhat.com> <20200415150216.GA6164@linux-8ccs.fritz.box> <20200415163303.ubdnza6okg4h3e5a@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 15 Apr 2020, Josh Poimboeuf wrote:

> On Wed, Apr 15, 2020 at 05:02:16PM +0200, Jessica Yu wrote:
> > +++ Josh Poimboeuf [14/04/20 11:28 -0500]:
> > > With arch_klp_init_object_loaded() gone, and apply_relocate_add() now
> > > using text_poke(), livepatch no longer needs to use module_disable_ro().
> > > 
> > > The text_mutex usage can also be removed -- its purpose was to protect
> > > against module permission change races.
> > > 
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > > ---
> > > kernel/livepatch/core.c | 8 --------
> > > 1 file changed, 8 deletions(-)
> > > 
> > > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > > index 817676caddee..3a88639b3326 100644
> > > --- a/kernel/livepatch/core.c
> > > +++ b/kernel/livepatch/core.c
> > > @@ -767,10 +767,6 @@ static int klp_init_object_loaded(struct klp_patch *patch,
> > > 	struct klp_modinfo *info = patch->mod->klp_info;
> > > 
> > > 	if (klp_is_module(obj)) {
> > > -
> > > -		mutex_lock(&text_mutex);
> > > -		module_disable_ro(patch->mod);
> > > -
> > 
> > Don't you still need the text_mutex to use text_poke() though?
> > (Through klp_write_relocations -> apply_relocate_add -> text_poke)
> > At least, I see this assertion there:
> > 
> > void *text_poke(void *addr, const void *opcode, size_t len)
> > {
> > 	lockdep_assert_held(&text_mutex);
> > 
> > 	return __text_poke(addr, opcode, len);
> > }
> 
> Hm, guess I should have tested with lockdep ;-)

:)

If I remember correctly, text_mutex must be held whenever text is modified 
to prevent race due to the modification. It is not only about permission 
changes even though it was how it manifested itself in our case.

Miroslav
