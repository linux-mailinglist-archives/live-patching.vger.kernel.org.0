Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0832AA34F
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2019 14:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387471AbfIEMgE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Sep 2019 08:36:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46922 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387436AbfIEMgE (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Sep 2019 08:36:04 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EFE333090FDA;
        Thu,  5 Sep 2019 12:36:03 +0000 (UTC)
Received: from treble (ovpn-120-170.rdu2.redhat.com [10.10.120.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D21A5C22C;
        Thu,  5 Sep 2019 12:35:59 +0000 (UTC)
Date:   Thu, 5 Sep 2019 07:35:58 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, jikos@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20190905123558.d4zh4h5pnej6pcuk@treble>
References: <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz>
 <20190822223649.ptg6e7qyvosrljqx@treble>
 <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz>
 <20190826145449.wyo7avwpqyriem46@treble>
 <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz>
 <5c649320-a9bf-ae7f-5102-483bc34d219f@redhat.com>
 <alpine.LSU.2.21.1909031447140.3872@pobox.suse.cz>
 <20190904084932.gndrtewubqiaxmzy@pathway.suse.cz>
 <20190905025055.36loaatxtkhdo4q5@treble>
 <alpine.LSU.2.21.1909051355240.25712@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1909051355240.25712@pobox.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 05 Sep 2019 12:36:04 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Sep 05, 2019 at 02:03:34PM +0200, Miroslav Benes wrote:
> > >   + I would like to better understand the scope of the current
> > >     problems. It is about modifying code in the livepatch that
> > >     depends on position of the related code:
> > > 
> > >       + relocations are rather clear; we will need them anyway
> > > 	to access non-public (static) API from the original code.
> > > 
> > >       + What are the other changes?
> > 
> > I think the .klp.arch sections are the big ones:
> > 
> >   .klp.arch.altinstructions
> >   .klp.arch.parainstructions
> >   .klp.arch.jump_labels (doesn't exist yet)
> > 
> > And that's just x86...
> 
> I may misunderstand, but we have .klp.arch sections because para and 
> alternatives have to be processed after relocations. And if we cannot get 
> rid of relocations completely, because of static symbols, then we cannot 
> get rid of .klp.arch sections either.

With late module patching gone, the module code can just process the klp
relocations at the same time it processes normal relocations.

Then the normal module alt/para/jump_label processing code can be used
instead of arch_klp_init_object_loaded().

Note this also means that Joe's patches can remove copy_module_elf() and
free_module_elf().  And module_arch_freeing_init() in s390.

> > And then of course there's the klp coming/going notifiers which have
> > also been an additional source of complexity.
> 
> True, but I think we (me and Petr) do not consider it as much of a problem 
> as you.

It's less of an issue than .klp.arch and all the related code which can
be removed.

-- 
Josh
