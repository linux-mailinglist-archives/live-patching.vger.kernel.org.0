Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B864566AB
	for <lists+live-patching@lfdr.de>; Wed, 26 Jun 2019 12:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfFZK1O (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 26 Jun 2019 06:27:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:58260 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726131AbfFZK1O (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 26 Jun 2019 06:27:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3FC69AEEE;
        Wed, 26 Jun 2019 10:27:12 +0000 (UTC)
Date:   Wed, 26 Jun 2019 12:27:11 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Joe Lawrence <joe.lawrence@redhat.com>
cc:     Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v4 00/10] klp-convert livepatch build tooling
In-Reply-To: <20190625190836.GL20356@redhat.com>
Message-ID: <alpine.LSU.2.21.1906261222510.22069@pobox.suse.cz>
References: <20190509143859.9050-1-joe.lawrence@redhat.com> <alpine.LSU.2.21.1906131451560.22698@pobox.suse.cz> <b1a627a4-3702-9689-6c03-0c2123c06a2d@redhat.com> <c9021573-11c6-b576-0aa6-97754c98a06e@redhat.com> <20190614083435.uq3mk6mprbatysol@pathway.suse.cz>
 <alpine.LSU.2.21.1906251324450.12085@pobox.suse.cz> <20190625190836.GL20356@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 25 Jun 2019, Joe Lawrence wrote:

> On Tue, Jun 25, 2019 at 01:36:37PM +0200, Miroslav Benes wrote:
> >
> > [ ... snip ... ]
> >
> > If I revert commit d59cadc0a8f8 ("[squash] klp-convert: make
> > convert_rela() list-safe") (from Joe's expanded github tree), the problem
> > disappears.
> >
> > I haven't spotted any problem in the code and I cannot explain a
> > dependency on GCC version. Any ideas?
> >
> 
> I can confirm that test_klp_convert1.ko crashes with RHEL-7 and its
> older gcc.  I added some debugging printf's to klp-convert and see:
> 
>   % ./scripts/livepatch/klp-convert \
>           ./Symbols.list \
>           lib/livepatch/test_klp_convert1.klp.o \
>           lib/livepatch/test_klp_convert1.ko | \
>           grep saved_command_line
> 
>   convert_rela: oldsec: .rela.text rela @ 0x1279670 rela->sym @ 0x12791f0 (.klp.sym.vmlinux.saved_command_line,0) offset: 0x3
>   convert_rela: oldsec: .rela.text rela @ 0x1279cd0 rela->sym @ 0x12791f0 (.klp.sym.vmlinux.saved_command_line,0) offset: 0x9a
>   move_rela: rela @ 0x1279670 rela->sym @ 0x12791f0 (.klp.sym.vmlinux.saved_command_line,0) offset: 0x3
>   main: skipping rela @ 0x1279cd0 rela->sym @ 0x12791f0 (.klp.sym.vmlinux.saved_command_line,0) (!must_convert)
> 
> I think the problem is:
> 
> - Relas at different offsets, but for the same symbol may share symbol
>   storage.  Note the same rela->sym value above.
> 
> - Before d59cadc0a8f8 ("[squash] klp-convert: make convert_rela()
>   list-safe"), convert_rela() iterated through the entire section's
>   relas, moving any of the same name.  This was determined not to be
>   list safe when moving consecutive relas in the linked list.
> 
> - After d59cadc0a8f8 ("[squash] klp-convert: make convert_rela()
>   list-safe"), convert_rela() still iterates through the section relas,
>   but only updates r1->sym->klp_rela_sec instead of moving them.
>   move_rela() was added to be called by the for-each-rela loop in
>   main().
> 
>   - Bug 1: klp_rela_sec probably belongs in struct rela and not struct
>     symbol
> 
>   - Bug 2: the main loop skips over second, third, etc. matching relas
>     anyway as the shared symbol name will have already been converted

Yes, it explains the issue.
 
> The following fix might not be elegant, but I can't think of a clever
> way to handle the original issue d59cadc0a8f8 ("[squash] klp-convert:
> make convert_rela() list-safe") as well as these resulting regressions.
> So I broke out the moving of relas to a seperate loop.

It works. Thanks Joe.

> That is probably
> worth a comment and at the same time we might be able to drop some of
> these other "safe" loop traversals for ordinary list_for_each_entry.

I think _safe from list_for_each_entry_safe(rela, tmprela, &sec->relas, 
list) in the main loop could be dropped, because convert_rela() only marks 
relas and does not move them anywhere. 
Similarly, list_for_each_entry_safe(r1, r2, &oldsec->relas, list) in 
convert_rela() itself.

Miroslav
