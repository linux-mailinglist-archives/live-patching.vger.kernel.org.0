Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFED1E3CC5
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2020 10:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgE0I54 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 27 May 2020 04:57:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:60922 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728152AbgE0I54 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 27 May 2020 04:57:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AEECFAEA6;
        Wed, 27 May 2020 08:57:56 +0000 (UTC)
From:   Martin Jambor <mjambor@suse.cz>
To:     Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, mliska@suse.cz,
        pmladek@suse.cz, live-patching@vger.kernel.org,
        Jan Hubicka <hubicka@ucw.cz>
Subject: Re: linux-next: Tree for May 21 (objtool warnings)
In-Reply-To: <alpine.LSU.2.21.2005261809480.22611@pobox.suse.cz>
References: <20200522001209.07c19400@canb.auug.org.au> <22332d9b-5e9f-5474-adac-9b3e39861aee@infradead.org> <alpine.LSU.2.21.2005251101030.24984@pobox.suse.cz> <alpine.LSU.2.21.2005251303430.24984@pobox.suse.cz> <20200526140113.ppjywpx7uir3vrlj@treble> <alpine.LSU.2.21.2005261809480.22611@pobox.suse.cz>
User-Agent: Notmuch/0.29.3 (https://notmuchmail.org) Emacs/26.3 (x86_64-suse-linux-gnu)
Date:   Wed, 27 May 2020 10:57:53 +0200
Message-ID: <ri65zch21ri.fsf@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

On Tue, May 26 2020, Miroslav Benes wrote:
> On Tue, 26 May 2020, Josh Poimboeuf wrote:
>
>> On Mon, May 25, 2020 at 01:07:27PM +0200, Miroslav Benes wrote:
>> > > I'll try to find out which optimization does this, because it is a 
>> > > slightly different scenario than hiding __noreturn from the callees. 
>> > > Probably -fno-ipa-pure-const again.
>> > 
>> > And it is indeed -fno-ipa-pure-const again.
>> 
>> It still seems odd to me that GCC's dead end detection seems to break
>> with -fno-ipa-pure-const.  Do you know if these issues can be fixed on
>> the GCC side?
>
> It is odd. I asked Martin and Martin about that yesterday (CCed). It could 
> be possible to enable just noreturn propagation for -flive-patching if I 
> understood correctly. The attribute would need to be preserved in a 
> patched function then, but that should be manageable.
>
> Marking functions as __noreturn is one thing (I think it is useful on its 
> own as mentioned in the older thread about -flive-patching), but 
> __always_inline solution in this case is really arbitrary.

Noreturn functions generally tend to be very cold ones and so you do not
really want to inline them.

> I don't like 
> this neverending "battle" with compilers much, so it would be nice to have 
> some kind of generic solution (and I currently have no idea about that). 
> Of course, declaring -flive-patching a failed experiment is an option if 
> there is not a better way to deal with a dead end detection either in GCC 
> or in objtool. I would not like it, but you're right that if there are 
> more and more problems like this appearing, we'll have to deal with 
> maintainers all over the place and ask them to maintain odd fixes just for 
> the sake of -flive-patching. I don't know what the current numbers are 
> though. We'd have to approach the problem of GCC optimizations from a 
> different angle. Petr CCed (we talked about it yesterday as well).
>
> But first, let's try to find a way with -flive-patching.
>
> Reduced test case follows (courtesty of Martin Liska):
>
> $ cat open.i
> int global;
>
> void
> break_deleg_wait()
> {
>   asm(".byte 15, 0x0b");
>   __builtin_unreachable();
> }
>
> void chmod_common_delegated_inode(int arg)
> {
> retry_deleg:
>   if (arg)
>     break_deleg_wait(global);
>   else
>     return;
>   goto retry_deleg;
> }
>
> $ gcc open.i -c -Os -fno-omit-frame-pointer -fno-ipa-pure-const && ./tools/objtool/objtool check open.o
> open.o: warning: objtool: chmod_common_delegated_inode()+0x18: unreachable instruction
>
> $ gcc open.i -c -Os -fno-omit-frame-pointer && ./tools/objtool/objtool check open.o
> [OK]
> ---
>
> So it is a similar problem. There is no noreturn attribute anywhere 
> (nothing to propagate from a caller to a callee). Here, the information 
> about an unreachable code is not propagated to the caller 
> (chmod_common_delegated_inode()).
>
> Martins, would it be possible to extend -flive-patching to deal with
> this?

I think we could allow -fipa-pure-const with -flive-patching but make it
dump all the attributes it has assigned to all functions in some format
similar to what it does for all the internal clones GCC creates.  You
would then need to explicitely annotate functions in live patches with
these attributes - and of course make sure you do not violate them.

If this is too difficult for the full set of attributes, we can restrict
the pass to just propagate the noreturn attribute, but I think it's not
going to be necessary.

Martin
